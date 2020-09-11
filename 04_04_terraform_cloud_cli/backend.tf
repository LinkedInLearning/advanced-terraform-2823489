terraform {
  backend "remote" {
    organization = "red30"

    workspaces {
      name = "cli-workspace"
    }
  }
}
