terraform {
  backend "remote" {
    organization = "red30ct"

    workspaces {
      name = "cli-workspace"
    }
  }
}
