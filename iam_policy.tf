# Legado: policy do worker de pagamentos da iJanta.
# Funciona, passa no terraform validate e está em produção há anos.
# Lab 2: auditar e restringir esta policy ao bucket de comprovantes do Lab 1.

resource "aws_iam_policy" "pagamentos" {
  name = "ijanta-pagamentos-worker"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}
