variable "db_credentials" {
  type = map(string)
  default = {
    username = "postgres"
    password = "postgrespass"
    db_name  = "techchallengefastfood"
  }
}

resource "aws_secretsmanager_secret" "db_credentials_secret" {
  name        = "fast-food-db-credentials"
  description = "Database credentials for PostgreSQL"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_credentials_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials_secret.id
  secret_string = jsonencode(var.db_credentials)
}
