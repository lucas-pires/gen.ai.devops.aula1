# Lab 0 · Um S3 que parece certo

O arquivo [`s3_generico.tf`](s3_generico.tf) foi gerado por um pedido curto, sem restrições:

```text
crie um bucket S3 em Terraform para os comprovantes da iJanta
```

O bucket vai guardar comprovantes de pagamento de clientes. O código tem pelo menos três problemas.

## Passos

1. Leia o arquivo e anote os três problemas antes de rodar qualquer ferramenta.
2. Nesta pasta, rode o sensor de sintaxe:

   ```bash
   cd labs/lab0-s3-generico
   terraform init -backend=false
   terraform validate
   ```

3. Remova a linha que o `validate` apontou e rode o `validate` de novo.
4. Compare o resultado com a sua lista. Quais problemas continuam no arquivo?
5. Desfaça a alteração: `git checkout -- s3_generico.tf`.

Não copie este arquivo para a raiz do repositório: ele é só para este exercício.

As respostas são discutidas em aula e ficam em [clc16/m1/lab0.md](https://github.com/genai4devops/clc16/blob/main/m1/lab0.md),
disponível **só depois da aula**. Compare depois de fazer a sua lista.
