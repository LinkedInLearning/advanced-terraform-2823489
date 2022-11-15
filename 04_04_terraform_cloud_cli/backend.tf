terraform {
  backend "remote" {
    organization = "red30systems"

    workspaces {
      name = "cli-workspace"
    }
  }
}
