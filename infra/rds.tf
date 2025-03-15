resource "aws_security_group" "rds_sg" {
  name        = "tech-challenge-rds-sg"
  description = "RDS PostgreSQL"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = true

  depends_on = [
    aws_security_group.rds_sg,
    aws_db_subnet_group.rds_subnet_group,
    aws_secretsmanager_secret_version.db_credentials_secret_version
  ]
}