resource "aws_db_subnet_group" "db-sub-grp" {
  subnet_ids = [ aws_subnet.private-sub2-1b.id ]
  name = "mydb-subnet-grp"
}

resource "aws_db_instance" "mydb-instance" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  identifier = "three-tier-db"
  username = "admin"
  password = "23vS5TdDW8*o"
  db_subnet_group_name = aws_db_subnet_group.db-sub-grp.name
  vpc_security_group_ids = [ aws_security_group.db-tier-sg.id ]
  multi_az = true
  skip_final_snapshot = true
  publicly_accessible = false
  tags = {
        Name = "three-tier-db"
  }
  lifecycle {
    ignore_changes = all
  }
}