import { serve } from "https://deno.land/std@0.223.0/http/server.ts";
import {
  create,
  getNumericDate,
} from "https://deno.land/x/djwt@v3.0.2/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type VerifyRequest = {
  platform: "ios" | "android";
  productId: string;
  verificationData?: string;
  packageName?: string;
  transactionId?: string;
  transactionDate?: string;
};

type VerifyResponse = {
  success: boolean;
  isValid: boolean;
  isActive: boolean;
  expiryTimeMillis?: number;
  message?: string;
  details?: unknown;
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const payload = (await req.json()) as VerifyRequest;

    if (!payload?.platform || !payload.productId) {
      return jsonResponse(
        {
          success: false,
          isValid: false,
          isActive: false,
          message: "platform and productId are required",
        },
        400,
      );
    }

    if (payload.platform === "android") {
      const result = await verifyAndroidPurchase(payload);
      return jsonResponse(result);
    }

    if (payload.platform === "ios") {
      // TODO: Implement App Store Server API verification when credentials are ready.
      return jsonResponse({
        success: true,
        isValid: true,
        isActive: true,
        message: "iOS verification skipped (not yet implemented)",
      });
    }

    return jsonResponse(
      {
        success: false,
        isValid: false,
        isActive: false,
        message: `Unsupported platform: ${payload.platform}`,
      },
      400,
    );
  } catch (error) {
    console.error("verify-subscription error", error);
    return jsonResponse(
      {
        success: false,
        isValid: false,
        isActive: false,
        message: error?.message ?? "Unexpected error",
      },
      500,
    );
  }
});

async function verifyAndroidPurchase(
  payload: VerifyRequest,
): Promise<VerifyResponse> {
  const purchaseToken = payload.verificationData;
  if (!purchaseToken) {
    return {
      success: false,
      isValid: false,
      isActive: false,
      message: "verificationData (purchase token) is required for Android",
    };
  }

  const packageName = payload.packageName;
  if (!packageName) {
    return {
      success: false,
      isValid: false,
      isActive: false,
      message: "packageName is required for Android verification",
    };
  }

  const accessToken = await getGoogleAccessToken();
  if (!accessToken) {
    return {
      success: false,
      isValid: false,
      isActive: false,
      message: "Google service account credentials are not configured",
    };
  }

  const url =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptions/${payload.productId}/tokens/${purchaseToken}`;

  const googleResponse = await fetch(url, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (!googleResponse.ok) {
    const details = await googleResponse.text();
    console.error("Google verification failed", details);
    return {
      success: false,
      isValid: false,
      isActive: false,
      message: "Google Play verification failed",
      details,
    };
  }

  const data = await googleResponse.json();
  const expiryTimeMillis = Number(data.expiryTimeMillis ?? 0);
  const acknowledgementState = Number(data.acknowledgementState ?? 0);
  const isActive = expiryTimeMillis > Date.now();
  const isAcknowledged = acknowledgementState === 1;

  return {
    success: true,
    isValid: isActive && isAcknowledged,
    isActive,
    expiryTimeMillis,
    details: data,
  };
}

async function getGoogleAccessToken(): Promise<string | null> {
  const clientEmail = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_EMAIL");
  const privateKey = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_KEY");

  if (!clientEmail || !privateKey) {
    return null;
  }

  const key = await importPrivateKey(privateKey);

  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: clientEmail,
      scope: "https://www.googleapis.com/auth/androidpublisher",
      aud: "https://oauth2.googleapis.com/token",
      iat: getNumericDate(0),
      exp: getNumericDate(60 * 10),
    },
    key,
  );

  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!tokenResponse.ok) {
    const details = await tokenResponse.text();
    console.error("Failed to obtain Google access token", details);
    return null;
  }

  const tokenJson = await tokenResponse.json();
  return tokenJson.access_token as string;
}

async function importPrivateKey(pem: string): Promise<CryptoKey> {
  const lines = pem.replace(/\\n/g, "\n")
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s+/g, "");

  const buffer = Uint8Array.from(atob(lines), (c) => c.charCodeAt(0));

  return await crypto.subtle.importKey(
    "pkcs8",
    buffer,
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"],
  );
}

function jsonResponse(body: VerifyResponse, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}
