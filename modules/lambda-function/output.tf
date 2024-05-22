output "coachx-auth-out" {
  value = aws_lambda_function.coachx-auth
}

output "auth-invoke-arn" {
  value = aws_lambda_function.coachx-auth.invoke_arn
}