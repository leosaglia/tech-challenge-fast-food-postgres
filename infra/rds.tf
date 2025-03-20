resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "techchallenge_rds_subnet_group"
  subnet_ids = [for id in data.aws_subnets.private_subnets.ids : id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13"
  instance_class         = "db.t3.micro"
  identifier             = "tech-challenge-fast-food-postgres"
  db_name                = local.db_credentials["db_name"]
  username               = local.db_credentials["username"]
  password               = local.db_credentials["password"]
  parameter_group_name   = "default.postgres13"
  publicly_accessible    = false
  vpc_security_group_ids = [data.aws_security_group.sg_rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = true

  depends_on = [
    aws_db_subnet_group.rds_subnet_group,
    aws_secretsmanager_secret_version.db_credentials_secret_version
  ]
}