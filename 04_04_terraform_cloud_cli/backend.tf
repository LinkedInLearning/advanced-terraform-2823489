terraform {
  backend "remote" {
    organization = "kasunn25"

    workspaces {
      name = "cli-workspace"
    }
  }
}
