import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.kotoba.kakurenbo"
            resValue(type = "string", name = "app_name", value = "ことばかくれんぼ")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.kotoba.kakurenbo.stg"
            resValue(type = "string", name = "app_name", value = "ことばかくれんぼ (Stg)")
        }
        create("development") {
            dimension = "flavor-type"
            applicationId = "com.kotoba.kakurenbo.dev"
            resValue(type = "string", name = "app_name", value = "ことばかくれんぼ (Dev)")
        }
    }
}