resource "aws_key_pair" "devopsmonks" {
  key_name = "devopsmonks"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example" {
  ami = lookup(var.AMI, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name = aws_key_pair.devopsmonks.key_name

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }
  connection {
    host = self.public_ip
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
  tags = {
  Name = "nginx"
  }
}
output "instance_public_ip" { value = aws_instance.example.public_ip }
