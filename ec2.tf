resource "aws_instance" "web1" {
  ami                         = "ami-09040d770ffe2224f"
  instance_type               = "t2.micro"
  key_name                    = "two-tier-public-key"
  depends_on                  = [aws_key_pair.two-tier-public-key, aws_db_instance.project_db]
  availability_zone           = "us-east-2a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  
  tags = {
    Name = "web1_instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2 php php-mysql
    systemctl start apache2
    systemctl enable apache2
    
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    
    chown -R www-data:www-data /var/www/html/
    
    # Configure WordPress with RDS details
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    DB_NAME="project_db"
    DB_USER="admin"
    DB_PASSWORD="password"
    DB_HOST="${aws_db_instance.project_db.endpoint}"
    
    sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$DB_HOST/" /var/www/html/wp-config.php
    sudo rm -rf /var/www/html/index.html
  EOF
}

resource "aws_instance" "web2" {
  ami                         = "ami-09040d770ffe2224f"
  instance_type               = "t2.micro"
  key_name                    = "two-tier-public-key"
  depends_on                  = [aws_key_pair.two-tier-public-key, aws_db_instance.project_db]
  availability_zone           = "us-east-2b"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_2.id
  associate_public_ip_address = true
  tags = {
    Name = "web2_instance"
  }

  

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2 php php-mysql
    systemctl start apache2
    systemctl enable apache2
    
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    
    chown -R www-data:www-data /var/www/html/
    
    # Configure WordPress with RDS details
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    DB_NAME="project_db"
    DB_USER="admin"
    DB_PASSWORD="password"
    DB_HOST="${aws_db_instance.project_db.endpoint}"
    
    sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$DB_HOST/" /var/www/html/wp-config.php
    sudo rm -rf /var/www/html/index.html
  EOF
}

output "web1_public_ip" {
  value = aws_instance.web1.public_ip
}

output "web2_public_ip" {
  value = aws_instance.web2.public_ip
}
