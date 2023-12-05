resource "null_resource" "provisioner" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    always_run = timestamp()
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  provisioner "local-exec" {
    command = "scp -o StrictHostkeyChecking=no -i /Users/chaitanyanathreddynandireddy/Downloads/myuckeypair.pem /Users/chaitanyanathreddynandireddy/Downloads/myuckeypair.pem ec2-user@${aws_instance.web-bastion-host.public_ip}:~"
}

  depends_on = [aws_instance.web-bastion-host]
  connection {
    type = "ssh"
    user = "ec2-user"
    # password = var.root_password
    host = aws_instance.web-bastion-host.public_ip
    #private_key = file("${path.module}/../../../Download/myuckeypair.pem")
    private_key = file("/Users/chaitanyanathreddynandireddy/Downloads/myuckeypair.pem")

  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 myuckeypair.pem"
    ]
  }
}
