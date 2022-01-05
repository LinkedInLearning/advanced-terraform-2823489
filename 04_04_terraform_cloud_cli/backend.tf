terraform {
  backend "remote" {
    organization = "red30-aydy84"

    workspaces {
      name = "cli-workspace"
    }
  }
}
