# Saída de um prompt genérico:
#   "crie um bucket S3 em Terraform para os comprovantes da iJanta"
# Este arquivo tem pelo menos três problemas. Não copie para a raiz do repositório.

resource "aws_s3_bucket" "comprovantes" {
  bucket       = "ijanta-comprovantes"
  acl          = "public-read"
  auto_encrypt = true
  versioning {
    enabled = true
  }
}
