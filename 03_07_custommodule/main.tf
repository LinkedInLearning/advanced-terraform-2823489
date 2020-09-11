# //////////////////////////////
# PROVIDERS
# //////////////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

module "node_instance" {
    source = "./modules/nodejs-instance"
    instance_count = 2
    environment_tags = {
        "environment_id" = "development"
    }
}