# Lab 3 · VPC da API de pedidos com harness

Objetivo: construir a rede da API de pedidos com o OpenCode, usando o [`AGENTS.md`](../../AGENTS.md) como
guide fixo e o `terraform validate` como sensor **ao fim de cada etapa**.

Arquitetura alvo:

```text
VPC (var.vpc_cidr)
├── subnet pública  us-east-1a ──┐
├── subnet pública  us-east-1b   ├── route table pública → Internet Gateway
│        └── NAT Gateway + Elastic IP (na pública da 1a)
├── subnet privada  us-east-1a ──┐
└── subnet privada  us-east-1b   └── route table privada → NAT Gateway
```

> ⚠️ **Este lab não usa AWS.** Se você rodar `apply` na sua própria conta, o NAT Gateway é cobrado por hora:
> faça `destroy` no fim.

## Passos

1. **Confirme que o OpenCode carregou o AGENTS.md.** Na raiz do repositório, abra o `opencode` e pergunte:

   ```text
   Quais regras do projeto você está seguindo? Liste-as sem editar nada.
   ```

   A resposta precisa citar as AZs fixas, as tags obrigatórias e a proibição de IAM. Se não citar, você
   provavelmente abriu o agente fora da raiz do repositório.

2. **Siga os 4 prompts, na ordem.** Aprove cada mudança só depois de ler o diff.
3. **No NAT, confira o `allocation_id`**: ele aponta para o Elastic IP (`aws_eip.<nome>.id`). É a
   referência que o modelo mais erra neste recurso.
4. **`terraform validate` verde ao fim de cada etapa.** O erro aparece perto de onde nasceu.

## Chain of prompts

Um prompt por camada. Pedir tudo de uma vez gera um diff grande demais para revisar.

### Etapa 1 · VPC e variáveis

```text
Crie vpc.tf com uma aws_vpc chamada "pedidos" para a API de pedidos da iJanta.
- CIDR em var.vpc_cidr (default "10.20.0.0/16"), declarada em variables.tf com description e type
- enable_dns_support e enable_dns_hostnames = true
- siga o AGENTS.md (tags, convenções)
Antes de editar, liste os arquivos que vai mudar. Só HCL.
```

### Etapa 2 · subnets

```text
Em vpc.tf, adicione 2 subnets públicas e 2 privadas na aws_vpc.pedidos.
- AZs fixas do AGENTS.md (uma pública e uma privada em cada AZ), sem data source
- CIDRs derivados de var.vpc_cidr com cidrsubnet
- tag Tier = "publica" ou "privada"
Só HCL.
```

### Etapa 3 · Internet Gateway, NAT com Elastic IP e rotas

```text
Em vpc.tf, adicione:
- aws_internet_gateway na aws_vpc.pedidos
- aws_eip para o NAT (domain = "vpc")
- aws_nat_gateway numa subnet pública, com allocation_id apontando para o EIP
- route table pública com 0.0.0.0/0 → Internet Gateway, associada às 2 públicas
- route table privada com 0.0.0.0/0 → NAT Gateway, associada às 2 privadas
Nenhum recurso IAM. Só HCL.
```

### Etapa 4 · outputs

```text
Crie outputs.tf com: vpc_id, public_subnet_ids, private_subnet_ids e nat_gateway_id.
Cada output com description. Não mude outros arquivos. Só HCL.
```

## Pronto quando

- [ ] `terraform validate` verde em todas as etapas
- [ ] `aws_nat_gateway` com `allocation_id` apontando para o Elastic IP
- [ ] Outputs em `outputs.tf` (nenhum `output` em outro arquivo)
- [ ] Nenhum recurso IAM novo; AZs `us-east-1a` e `us-east-1b` escritas no código

## Travou?

Durante a aula, siga o que o instrutor mostra. Dicas (hint 1 → hint 2) e solução de referência ficam em
[clc16/m1/lab3.md](https://github.com/genai4devops/clc16/blob/main/m1/lab3.md), disponível **só depois da aula**.
Elas ficam fora deste repositório para o OpenCode não encontrar a resposta enquanto trabalha.

## Terminou?

Veja o [desafio do M1](../desafio/README.md): A/B com e sem AGENTS.md, ou o MiniStack do Lab 1.
