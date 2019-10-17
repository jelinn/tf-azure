module "app_build" {
  source  = "app.terraform.io/jlinn/appBuild/azurerm"
  version = "0.0.1"

  prefix = "jlinn-demo-test"
}
