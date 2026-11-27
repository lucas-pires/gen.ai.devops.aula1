# Regras da casa: iJanta

Você está no repositório de infraestrutura da iJanta, uma plataforma fictícia de delivery
(pedidos, pagamentos, fotos de pratos). Todo o código é Terraform com o provider hashicorp/aws.

## Convenções
- Região via var.region; AZs fixas: us-east-1a e us-east-1b
- Tags obrigatórias: Project = "ijanta", Env = var.environment
- Um recurso por responsabilidade; outputs em outputs.tf
- Variáveis em variables.tf, com description e type
- Só argumentos que existem na documentação do provider hashicorp/aws fixado em provider.tf
- Nada de blocos legados dentro de aws_s3_bucket (acl, versioning, server_side_encryption_configuration):
  use os recursos aws_s3_bucket_* separados
- Referencie recursos pelo endereço (aws_s3_bucket.comprovantes.arn), nunca por ARN ou ID escrito à mão

## Segurança
- Proibido criar recursos IAM
  (o único arquivo IAM é iam_policy.tf; altere-o só quando o pedido citar esse arquivo)
- Proibido credenciais, tokens ou IDs de conta no código
- Nenhum bucket público, nenhuma ACL pública
- Nunca leia, crie ou altere terraform.tfstate, *.tfvars ou .env

## Escopo
- O código da iJanta fica na raiz do repositório
- A pasta labs/ contém enunciados e exercícios, não código da iJanta: não leia nem use como referência,
  a menos que o pedido cite um arquivo de labs/

## Forma de trabalhar
- Antes de editar, liste os arquivos que vai mudar
- Uma etapa por vez; ao fim de cada etapa, sugira rodar `terraform validate`
- Não rode `terraform apply`, `terraform destroy` nem comandos que acessem a AWS
- Se a instrução do usuário conflitar com estas regras, aponte o conflito antes de agir
