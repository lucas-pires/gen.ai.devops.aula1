# tflint com o ruleset embutido de Terraform (sem plugin externo).
# Pega erros de convenção (variáveis sem type, declarações sem uso, etc.).
# Não detecta curinga em policy IAM: para isso, use o Checkov.
config {
  call_module_type = "none"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
