terraform {
  backend "remote" {
    organization = "fabyang-terraform-learning"

    workspaces {
      name = "cli-workspace"
    }
  }
}