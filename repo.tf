resource "github_repository" "this" {
  name               = var.name
  visibility         = "private"
  archive_on_destroy = true
}
