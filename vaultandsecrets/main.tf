provider "vault" {
  address = "http://35.173.183.179:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "1b8ed27a-ca92-19b6-475d-4b0e9a4d1c80"
      secret_id = "206b5f57-7b4a-7158-790c-b18eadccad53"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "qasimname" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id = "subnet-059058ec54f2444ea"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}