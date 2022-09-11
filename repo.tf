resource "github_repository" "this" {
  name               = var.name
  visibility         = "private"
  archive_on_destroy = true
}

data "github_team" "admin_team" {
  slug = var.admin_team
}

resource "github_team_repository" "admin" {
  team_id    = github_team.admin_team.id
  repository = var.name
  permission = "admin"
}

