terraform {
  backend "remote" {
    organization = "hilmaja"

    workspaces {
      name = "cli-workspace"
    }
  }
}
