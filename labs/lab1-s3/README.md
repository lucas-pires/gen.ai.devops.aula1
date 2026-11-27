# Lab 1 · Esqueleto iJanta + bucket de comprovantes seguro

Objetivo: criar um bucket S3 seguro para os comprovantes de pagamento da iJanta **sem digitar uma linha de HCL**.
Quem escreve é o OpenCode; quem lê, aprova e valida é você.

> **Antes do primeiro prompt.** Só o código deste repositório da iJanta entra no agente. Nada de código ou dado da sua
> empresa, IPs, nomes de clientes ou saída de `plan` real. A chave do AI Studio fica só na variável de
> ambiente: nunca no prompt, num chat ou num print.

## Passos

1. No terminal do Codespace ou no seu terminal local, na raiz do repositório, rode:

   ```bash
   opencode
   ```

2. **Etapa 1:** cole o prompt da etapa 1 (abaixo). Ele é o exemplo das cinco partes de um prompt restrito.
   O agente cria `provider.tf` e `variables.tf`.
3. **Etapa 2:** escreva o seu prompt a partir dos requisitos da etapa 2 e cole no OpenCode.
   Com o seu prompt, o agente cria `s3_comprovantes.tf`.
4. **Leia cada mudança antes de aprovar.** O OpenCode pede aprovação (`ask`) antes de editar arquivo ou
   rodar comando. Confira o diff contra o checklist. Se algo estiver fora, recuse e peça a correção.
5. Valide no terminal (fora do OpenCode, ou aprovando o comando nele):

   ```bash
   terraform init -backend=false
   terraform validate
   ```

   Ninguém precisa de conta AWS: `-backend=false` e o `validate` não acessam a nuvem.

## Prompts

### Etapa 1 · provider e variáveis

```text
Papel: engenheiro de IaC sênior.
Tarefa: crie provider.tf e variables.tf para a iJanta.
Restrições:
- terraform required_version >= 1.10 e provider hashicorp/aws com version "~> 6.0"
- provider "aws" com region = var.region e default_tags com Project = "ijanta" e Env = var.environment
- variables.tf: region (string, default "us-east-1") e environment (string, default "dev"),
  ambas com description e type
- nenhum backend, nenhuma credencial, nenhum profile
Formato: só HCL, sem explicação. Antes de editar, liste os arquivos que vai criar.
```

### Etapa 2 · bucket de comprovantes (o seu prompt)

Agora o prompt é seu. Use o da etapa 1 como modelo e escreva um prompt com as cinco partes que cubra
**todos** os requisitos abaixo:

- o arquivo gerado é `s3_comprovantes.tf`
- contexto: o bucket guarda comprovantes de pagamento da iJanta
- o recurso principal se chama `aws_s3_bucket.comprovantes` e o nome do bucket usa `var.environment`
- versioning, Block Public Access e encryption, cada um como recurso `aws_s3_bucket_*` separado
- nenhuma ACL pública
- nenhuma credencial no código
- só argumentos documentados do provider
- saída só em HCL, sem explicação

<details>
<summary>Plano B: travou para escrever o prompt?</summary>

Responda a estas perguntas e cada resposta vira uma linha do seu prompt:

1. Que papel o agente deve assumir para que segurança seja prioridade, e não só "fazer funcionar"?
2. Qual arquivo ele deve criar e para qual projeto?
3. O que o bucket guarda? Por que isso muda o nível de cuidado?
4. Qual nome de recurso o checklist espera? De qual variável sai o nome do bucket?
5. Quais são os três controles do checklist? Eles vão como bloco dentro do bucket ou como recursos separados?
6. O que nunca pode aparecer no código (pense em acesso público e em segredos)?
7. Como impedir que o modelo invente argumentos que o provider não tem?
8. Em que formato você quer a resposta?

Esqueleto com lacunas (preencha cada `____`; não cole como está):

```text
Papel: ____.
Tarefa: ____ para a iJanta.
Contexto: ____. O recurso principal se chama ____ e ____.
Restrições:
- ____, ____ e ____ como ____
- ____; ____
- ____
Formato: ____.
```

</details>

As cinco partes do prompt: papel, tarefa, contexto, restrições e formato.
Cada restrição vira um item que você confere no diff.

## Checklist

| # | Atributo | Recurso separado | O que conferir |
|---|----------|------------------|----------------|
| 1 | Versioning | `aws_s3_bucket_versioning` | `status = "Enabled"` |
| 2 | Block Public Access | `aws_s3_bucket_public_access_block` | `block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`, todos `true` |
| 3 | Encryption | `aws_s3_bucket_server_side_encryption_configuration` | regra com `apply_server_side_encryption_by_default` |

Os três apontam para `aws_s3_bucket.comprovantes.id`. Nenhum deles fica como bloco dentro do `aws_s3_bucket`.

## Pronto quando

- [ ] `terraform validate` retorna `Success! The configuration is valid.`
- [ ] Os 3 atributos do checklist aparecem como recursos separados
- [ ] O print **não** mostra a chave do AI Studio nem nenhum tfstate

### Entrega do M1

O formulário da avaliação do M1 pede um print com o `Success` do validate **e** o código de `s3_comprovantes.tf` mostrando os 3 recursos
(ou a saída do Checkov com os checks de versioning, Block Public Access e encryption em `PASSED`).
Antes de capturar, confira: terminal sem `echo $GOOGLE_GENERATIVE_AI_API_KEY`, sem `env`, sem arquivo `.tfstate` aberto.

## Sensor extra (opcional)

```bash
checkov -f s3_comprovantes.tf --compact
```

Espere alguns `FAILED` que **não** fazem parte do checklist: access logging (CKV_AWS_18), replicação entre
regiões (CKV_AWS_144), KMS em vez de AES256 (CKV_AWS_145), lifecycle (CKV2_AWS_61) e event notifications
(CKV2_AWS_62). São decisões de custo e operação que o time precisa tomar: o sensor aponta, você decide.
O que precisa passar é o Block Public Access (CKV2_AWS_6) e a ausência de ACL pública (CKV_AWS_20).

## Travou?

Durante a aula, siga o que o instrutor mostra. Dicas (hint 1 → hint 2) e solução de referência ficam em
[clc16/m1/lab1.md](https://github.com/genai4devops/clc16/blob/main/m1/lab1.md), disponível **só depois da aula**.
Elas ficam fora deste repositório para o OpenCode não encontrar a resposta enquanto trabalha.

## Terminou antes?

- Rode o seu prompt da etapa 2 de novo, num arquivo temporário, e compare as duas saídas com `diff`.
  O mesmo prompt gera código diferente: a saída do modelo é probabilística.
- Faça o [desafio do MiniStack](../desafio/README.md#b-plan-apply-e-destroy-no-ministack):
  plan, apply e destroy deste bucket num emulador local de AWS.
