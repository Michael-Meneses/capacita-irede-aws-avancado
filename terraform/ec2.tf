# ec2.tf
resource "aws_iam_role" "ec2_role" {
  name = "ec2-sqs-publisher-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "ec2_sqs_policy" {
  name = "ec2-sqs-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sqs:SendMessage"]
      Resource = "${aws_sqs_queue.pedidos_queue.arn}"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "api_server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS na us-east-1 (verifique se atualizou)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Passa a URL da fila como variavel de ambiente interna na criacao
  user_data = <<-EOF
              #!/bin/bash
              echo "SQS_QUEUE_URL='${aws_sqs_queue.pedidos_queue.id}'" >> /etc/environment
              EOF

  tags = { Name = "api-produtos-pedidos" }
}

output "ec2_public_ip" {
  value = aws_instance.api_server.public_ip
}