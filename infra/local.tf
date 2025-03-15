locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_secret_version.secret_string)
}