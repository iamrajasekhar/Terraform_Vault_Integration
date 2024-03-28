provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://localhost:8200/"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "f00d10cb-ba0f-c06f-ed33-128feeade238"
      secret_id = "dee238d1-7ea4-706a-5c13-860d0c87331d"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "new_secret" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}