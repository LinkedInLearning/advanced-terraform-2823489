terraform {
  backend "remote" {
    organization = "red30www-dev221"

    workspaces {
      name = "cli-workspace"
    }
  }
}
