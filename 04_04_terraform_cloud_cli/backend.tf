terraform {
  backend "remote" {
    organization = "yesbkz"

    workspaces {
      name = "cli-workspace"
    }
  }
}
