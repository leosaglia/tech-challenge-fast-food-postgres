resource "aws_ssm_parameter" "postgres_endpoint" {
  name  = "/tech-challenge/fast-food-postgres-endpoint"
  type  = "String"
  value = "jdbc:postgresql://${aws_db_instance.postgres.endpoint}/${local.db_credentials["db_name"]}"
}