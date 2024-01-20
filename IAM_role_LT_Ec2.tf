resource "aws_iam_instance_profile" "demo-monish" {
  name = "test_profile"
  role = aws_iam_role.demo-monish.name
}
resource "aws_iam_role" "demo-monish" {
  name = "demo-monish-role-terra"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.demo-monish.name
}
