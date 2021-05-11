module "db" {
    source = "terraform-aws-modules/rds/aws"

    identifier = "gatmauel"

    engine = "mysql"
    engine_version = "8.0.21"
    instance_class = "db.t2.micro"
    allocated_storage= 20

    name = "gatmauel_prod"
    username = "root"
    password = var.mysql_root_password
    port = "3306"

    vpc_security_group_ids = [aws_security_group.allow_mysql.id]
    subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]

    backup_window = "17:00-17:30"
    backup_retention_period = 7
    maintenance_window = "mon:20:00-mon:20:30"

    family = "mysql8.0"
    major_engine_version = "8.0"
    parameters = [
    {
        name = "character_set_client"
        value = "utf8mb4"
    },
    {
        name = "character_set_connection"
        value = "utf8mb4"
    },
    {
        name = "character_set_database"
        value = "utf8mb4"
    },
    {
        name = "character_set_filesystem"
        value = "utf8mb4"
    },
    {
        name = "character_set_results"
        value = "utf8mb4"
    },
    {
        name = "character_set_server"
        value = "utf8mb4"
    },
    {
        name = "collation_connection"
        value = "utf8mb4_general_ci"
    },
    {
        name = "collation_server"
        value = "utf8mb4_general_ci"
    },
    {
        name = "time_zone"
        value = "Asia/Seoul"
    }
  ]

  skip_final_snapshot = true
}