# Lab 2 · Auditoria IAM do worker de pagamentos

Objetivo: auditar a policy legada [`iam_policy.tf`](../../iam_policy.tf), restringir ao bucket de comprovantes
do Lab 1 e **provar a melhora pelo diff e pelo sensor**, não pelo que o agente diz.

Pré-requisito: o `s3_comprovantes.tf` do Lab 1 na raiz, com o recurso `aws_s3_bucket.comprovantes`.
Não terminou o Lab 1? Use a solução mostrada em aula. Depois da aula, ela também fica em
[clc16/m1/lab1.md](https://github.com/genai4devops/clc16/blob/main/m1/lab1.md).

## O problema

```hcl
Action   = "*"
Resource = "*"
```

O worker de pagamentos pode fazer qualquer ação em qualquer recurso da conta, e a policy passa no
`validate`. O worker só precisa **ler e gravar
comprovantes** no bucket do Lab 1 (least privilege).

## Passos

1. **Linha de base do sensor.** Rode o Checkov e guarde a saída:

   ```bash
   checkov -f iam_policy.tf --compact | tee /tmp/checkov-antes.txt
   ```

   Anote os IDs que falharam. Esta linha de base não depende da opinião do agente.

2. **Auditoria.** No OpenCode, use o prompt de auditoria (abaixo). O agente **só lê** nesta etapa.
3. **Reescrita.** Use o prompt de reescrita. Leia o diff antes de aprovar.
4. **Prova.** Rode o sensor de novo e compare:

   ```bash
   terraform validate
   checkov -f iam_policy.tf --compact | tee /tmp/checkov-depois.txt
   git diff iam_policy.tf
   ```

## Prompts

### Auditoria (modo auditora, sem editar)

```text
Papel: auditor de segurança de IAM na AWS.
Tarefa: audite iam_policy.tf. NÃO edite nenhum arquivo nesta etapa.
Contexto: a policy é do worker de pagamentos da iJanta. O worker só lê e grava
comprovantes no bucket definido em s3_comprovantes.tf (aws_s3_bucket.comprovantes).
Regra: least privilege. Cada ação permitida precisa de um uso real do worker.
Formato: uma tabela com colunas risco | linha | por que é um problema | correção proposta.
No fim, a lista mínima de ações S3 que o worker precisa, com uma justificativa por ação.
```

### Reescrita

```text
Tarefa: reescreva iam_policy.tf aplicando a auditoria.
Restrições:
- mantenha o recurso aws_iam_policy.pagamentos e o name atual
- nenhum "*" em Action ou Resource
- Resource por referência a aws_s3_bucket.comprovantes (arn), nunca ARN escrito à mão
- ações de objeto no ARN com "/*"; ação de bucket no ARN do bucket
- não crie nenhum outro recurso IAM
Antes de editar, liste os arquivos que vai mudar. Formato: só HCL.
```

## Pronto quando

- [ ] Nenhum `"*"` em `Action` ou `Resource`
- [ ] `Resource` aponta o ARN do bucket por referência (`aws_s3_bucket.comprovantes.arn`)
- [ ] O Checkov não acusa mais o curinga (CKV_AWS_62, CKV_AWS_63 e CKV_AWS_355 em `PASSED`)
- [ ] `terraform validate` continua em `Success`

## O que o Checkov acusa na policy legada

Saída do Checkov 3.4.6, a versão do devcontainer, contra o `iam_policy.tf` original:

| ID | O que significa |
|----|-----------------|
| CKV_AWS_62 | Policy com privilégio administrativo total `*:*` |
| CKV_AWS_63 | `"*"` como ação de um statement |
| CKV_AWS_355 | `"*"` como recurso para ações que aceitam restrição |
| CKV_AWS_286 | Permite escalada de privilégio |
| CKV_AWS_287 | Permite exposição de credenciais |
| CKV_AWS_288 | Permite exfiltração de dados |
| CKV_AWS_289 | Permite gestão de permissões / exposição de recursos sem restrição |
| CKV_AWS_290 | Permite escrita sem restrição |
| CKV2_AWS_40 | Permite privilégios IAM totais |

São 9 falhas. Depois da reescrita correta, todas passam.

> **E o tflint?** O tflint é um linter de Terraform: pega erro de convenção e de sintaxe, mas o ruleset
> padrão não julga se uma policy é larga demais. Neste lab, o sensor que detecta o curinga é o Checkov.

## Travou?

Durante a aula, siga o que o instrutor mostra. Dicas (hint 1 → hint 2) e solução de referência ficam em
[clc16/m1/lab2.md](https://github.com/genai4devops/clc16/blob/main/m1/lab2.md), disponível **só depois da aula**.
Elas ficam fora deste repositório para o OpenCode não encontrar a resposta enquanto trabalha.

## Terminou antes?

[Desafio do M1](../desafio/README.md#a-ab-com-e-sem-agentsmd): o mesmo prompt de reescrita com e sem
o `AGENTS.md`. A evidência é o diff, não a sua opinião.
