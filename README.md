# iJanta · Módulo 1 · Infraestrutura Inteligente

Labs do Módulo 1 do CLC16: Terraform gerado com o OpenCode, conferido com sensors e aprovado por você.

A iJanta é uma plataforma **fictícia** de delivery de comida (pedidos, pagamentos, fotos de pratos).
Errar aqui não vaza nada. Nenhum lab usa AWS nem exige conta na AWS: o trabalho termina no
`terraform validate` e no Checkov.

## Antes de começar

Crie a sua chave em [Google AI Studio → API keys](https://aistudio.google.com/apikey), num projeto próprio.
Depois escolha um dos dois caminhos.

### Codespace (recomendado)

Nada para instalar. O Codespace já traz OpenCode, Terraform, tflint, Checkov e Docker.

1. **Use this template → Create a new repository**, na sua conta.
2. Libere o secret `GOOGLE_GENERATIVE_AI_API_KEY` para o repositório novo (github.com → Settings → Codespaces).
3. **Code → Codespaces → Create codespace.**

### Terminal local

Para o M1, basta clonar: nenhum lab faz push.

```bash
git clone https://github.com/genai4devops/ijanta-m1.git
cd ijanta-m1
```

Instale as ferramentas nas [versões](#versões) abaixo.
Docker só é necessário para o desafio do MiniStack. No Windows, use o WSL: o OpenCode 2 não suporta os
gerenciadores de pacote do Windows. Exporte a chave no terminal sem gravar em arquivo:

```bash
read -rs GOOGLE_GENERATIVE_AI_API_KEY && export GOOGLE_GENERATIVE_AI_API_KEY
```

### Nos dois caminhos

Abra o terminal na raiz do repositório e confira a chave sem imprimir o valor:

```bash
test -n "$GOOGLE_GENERATIVE_AI_API_KEY" && echo "chave ok" || echo "chave ausente"
```

Rode o `opencode` sempre **na raiz**: é ali que ele carrega o `AGENTS.md` e o `opencode.json`.

## Labs

Faça na ordem. Os labs 1 a 3 trabalham **na raiz** do repositório: o Lab 2 usa o bucket do Lab 1, e o Lab 3
usa as variáveis do Lab 1. Cada README tem prompts, checklist e critério de pronto. As dicas e as soluções ficam no
[hub do curso](https://github.com/genai4devops/clc16/tree/main/m1), que fica disponível **só depois da aula**.
Durante a aula, siga o que o instrutor mostra. O hub fica fora deste repositório para o OpenCode não
encontrar a resposta enquanto trabalha.

| Lab | O que você faz |
|-----|----------------|
| [Lab 0 · Um S3 que parece certo](labs/lab0-s3-generico/README.md) | Acha três problemas num Terraform gerado sem restrições |
| [Lab 1 · Bucket de comprovantes seguro](labs/lab1-s3/README.md) | Gera provider, variáveis e um S3 seguro com prompt restrito |
| [Lab 2 · Auditoria IAM](labs/lab2-iam/README.md) | Audita e restringe a policy do worker de pagamentos |
| [Lab 3 · VPC da API de pedidos](labs/lab3-vpc/README.md) | Constrói a rede em 4 prompts, com o `AGENTS.md` como guia |
| [Desafio (opcional)](labs/desafio/README.md) | A/B com e sem `AGENTS.md`; plan, apply e destroy no MiniStack |

## Como os labs se encaixam

| Controle | Neste módulo | Quando age |
|----------|--------------|------------|
| Guides | Prompt restrito e [`AGENTS.md`](AGENTS.md) | Antes de o agente escrever |
| Sensors | `terraform validate`; Checkov; tflint | Depois de cada arquivo gerado |
| Você | Aprovação de cada mudança no OpenCode; leitura do plan antes de qualquer apply | Antes de aceitar a mudança |

## Entrega do M1

O formulário da avaliação pede um **print do Lab 1**: o `Success` do `terraform validate` e o bucket de
comprovantes com versioning, Block Public Access e encryption. Detalhes no
[Lab 1](labs/lab1-s3/README.md#entrega-do-m1).

O print **não pode** mostrar a chave do AI Studio nem nenhum tfstate.

## Regras de segurança

- **Chave do AI Studio:** nunca em prompt, print, chat, peer review ou repositório. No Codespace, só como
  secret; no terminal local, só em variável de ambiente.
- **Só o código deste repositório entra no prompt.** A chave é do plano gratuito: o conteúdo enviado pode
  ser usado e revisado pelo Google. Nada de código, dado, IP ou nome de cliente da sua empresa.
- **tfstate nunca no repositório.** O `.gitignore` já cobre; não force com `git add -f`.
- **A saída do plan** pode expor valores sensíveis: revise antes de colar na IA ou num print.
- **O agente propõe; você aprova.** Leia cada diff antes de aceitar.

## Arquivos

```text
.
├── AGENTS.md              # regras da casa, lidas pelo OpenCode a cada sessão
├── opencode.json          # permissões do agente: edit e shell pedem aprovação; apply e destroy bloqueados
├── iam_policy.tf          # policy legada do worker de pagamentos (Lab 2)
├── .devcontainer/         # ambiente do Codespace
├── .gitignore             # tfstate, .terraform/, *.tfvars, .env, *.pem, crash.log
├── .tflint.hcl
└── labs/
```

## Versões

| Ferramenta | Versão |
|------------|--------|
| Terraform | 1.17.2 |
| Provider hashicorp/aws | `~> 6.0` (fixado no `provider.tf` que você gera no Lab 1) |
| OpenCode | 2.3.2 (`@opencode/cli`) |
| Checkov | 3.4.6 |
| Modelo | `google/gemini-3.5-flash` (em `opencode.json`) |

Se uma tela ou flag estiver diferente do README, confira a versão da ferramenta antes de tudo.
