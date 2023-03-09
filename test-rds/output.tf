output rds_creds {
    value = aws_db_instance.db_test
    sensitive = true
}