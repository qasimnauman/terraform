resource "aws_instance" "webserver1" {
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id = "subnet-059058ec54f2444ea"
  key_name = "webiode-key"
  vpc_security_group_ids = ["sg-0554f33585825ddcd"]
  tags = {
    Name="Webserver1"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    private_key = file("C:/Users/Qasim Nauman/Downloads/keys/webiode-key.pem")
    user = "ubuntu"
  }

  provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [ 
        "echo 'Hello from the remote instance'",
        "sudo apt update -y",  # Update package lists (for ubuntu)
        "sudo apt install python3-pip -y",  # Example package installation
        "cd /home/ubuntu",
        "sudo pip3 install flask",
        "sudo python3 app.py",
     ]
  }
}

output "public_ip" {
  value = aws_instance.webserver1.public_ip
}