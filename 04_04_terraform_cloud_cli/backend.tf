terraform {
  backend "remote" {
    organization = "ahmedlotfy700"

    workspaces {
      name = "cli-workspace"
    }
  }
}
