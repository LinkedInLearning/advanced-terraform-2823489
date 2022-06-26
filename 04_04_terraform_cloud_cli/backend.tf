terraform {
  backend "remote" {
    organization = "testorg1234www"

    workspaces {
      name = "cli-workspace"
    }
  }
}
