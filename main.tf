provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e449927258d45bc4"  
  instance_type = "t2.micro"
  security_groups = ["web_sg"]

  tags = {
    Name = "WebServerInstance"
  }
}


resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP access to EC2 instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-static-website-26apr"
  website {
    index_document = "index.html"
     }
}

resource "aws_lambda_function" "s3_event_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "LogS3Events"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}