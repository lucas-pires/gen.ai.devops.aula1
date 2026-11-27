# Desafio do M1 · opcional

Dois desafios abertos, sem hints e sem solução. Faça um, os dois ou nenhum: não valem nota.

## A. A/B com e sem AGENTS.md

**Requisito.** Rode o mesmo prompt de reescrita do [Lab 2](../lab2-iam/README.md#reescrita) duas vezes,
uma com o `AGENTS.md` carregado e outra sem, partindo do mesmo `iam_policy.tf` legado.

**Como desligar o AGENTS.md.** Renomeie o arquivo durante a rodada B e volte no fim:

```bash
cp iam_policy.tf /tmp/iam_policy.meu.tf   # guarde a sua versão do Lab 2
LEGADO=$(git rev-list --max-parents=0 HEAD | tail -1)
git show "$LEGADO":iam_policy.tf > iam_policy.tf   # volta ao legado (primeiro commit)

# Rodada A: com guide
opencode                                  # rode o prompt de reescrita, aprove, saia
git diff "$LEGADO" -- iam_policy.tf > /tmp/diff-com-agents.txt
git show "$LEGADO":iam_policy.tf > iam_policy.tf

# Rodada B: sem guide (abra uma sessão nova do opencode)
mv AGENTS.md AGENTS.md.off
opencode                                  # mesmo prompt, aprove, saia
git diff "$LEGADO" -- iam_policy.tf > /tmp/diff-sem-agents.txt
mv AGENTS.md.off AGENTS.md                # não esqueça de voltar

cp /tmp/iam_policy.meu.tf iam_policy.tf   # restaura a sua versão
```

> Não use `OPENCODE_DISABLE_PROJECT_CONFIG=1` para isso. Além do AGENTS.md, a variável pode deixar de
> carregar o `opencode.json` do projeto, e com ele as permissões `ask`/`deny`. Renomear o arquivo
> desliga só o guide.

**Critério de aceite.** Dois diffs salvos (`/tmp/diff-com-agents.txt` e `/tmp/diff-sem-agents.txt`) e
respostas para:

1. Uma diferença concreta entre os diffs (linha, recurso ou ação).
2. Qual regra do AGENTS.md explica essa diferença, ou por que nenhuma explica.
3. O resultado do Checkov nas duas versões.

Rode cada versão duas vezes se puder: com uma rodada só, a diferença pode ser ruído do modelo.

## B. plan, apply e destroy no MiniStack

Precisa de Docker (o Codespace já tem). [MiniStack](https://github.com/ministackorg/ministack)
é um emulador local de AWS com licença MIT: nenhuma conta, nenhum custo.

**Requisito.** Aplicar o bucket de comprovantes do Lab 1 no emulador e conferir os atributos no bucket criado.

```bash
docker run -d --name ministack -p 4566:4566 ministackorg/ministack
cp labs/desafio-m1/ministack/provider_override.tf.exemplo provider_override.tf
terraform init
terraform plan -out=plan.out    # leia o plan inteiro antes do apply
terraform apply plan.out
```

**Critério de aceite.** Com a AWS CLI apontada para o emulador (`--endpoint-url http://localhost:4566`,
credenciais `test`), mostre:

- `s3api get-bucket-versioning` com `"Status": "Enabled"`
- `s3api get-public-access-block` com as 4 flags em `true`

**Limpeza (obrigatória).**

```bash
terraform destroy
rm provider_override.tf plan.out
docker rm -f ministack
```

Aplique só o bucket: a VPC do Lab 3 e a policy do Lab 2 podem não ser suportadas pelo emulador.
Use `terraform plan -target=aws_s3_bucket.comprovantes -target=aws_s3_bucket_versioning.comprovantes ...`
se precisar isolar. O `terraform.tfstate` gerado fica fora do Git pelo `.gitignore`. Nunca faça commit dele.
