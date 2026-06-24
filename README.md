# Projeto E-commerce - Comunicação Assíncrona na AWS
### Módulo: AWS Avançado — Capacita iRede
**Estudante:** Michael David Moura de Meneses

Este repositório contém o código de provisionamento de infraestrutura como código (IaC) utilizando Terraform e os códigos de aplicação para uma arquitetura de microsserviços escalável e assíncrona na AWS.

---

## 🛠️ Arquitetura do Projeto

A arquitetura implementada foi desenhada para suportar alta disponibilidade e processamento desacoplado de pedidos de e-commerce:

1. **Cliente:** Envia requisições HTTP para a API.
2. **Instância EC2 (API Flask):** Recebe o payload do pedido e publica uma mensagem na fila.
3. **Fila SQS (`pedidos-a-processar`):** Armazena as mensagens de forma segura e assíncrona.
4. **AWS Lambda:** É disparada automaticamente pela chegada de novas mensagens na fila SQS, realizando o processamento simulado.
5. **Amazon CloudWatch:** Armazena os logs de execução da função Lambda para auditoria.

---

## 🚀 Tecnologias Utilizadas

* **Terraform** (v1.x)
* **AWS Provider** (Provedor HashiCorp)
* **Python 3.x** (Flask para a API e manipulador nativo para a Lambda)
* **Amazon VPC, EC2, SQS, IAM e Lambda**

---

## 📂 Estrutura do Repositório

```text
AwsAvancado/
├── .gitignore          # Arquivos ignorados pelo Git (estados do Terraform e caches)
├── README.md           # Documentação do projeto
├── app/
│   ├── app.py          # API Flask (Publisher SQS)
│   └── requirements.txt
├── lambda/
│   └── index.py        # Código do Worker (Consumer SQS)
└── terraform/          # Arquivos de Infraestrutura como Código
    ├── provider.tf
    ├── vpc.tf
    ├── ec2.tf
    ├── sqs.tf
    ├── lambda.tf
    ├── security.tf
    └── variables.tf
########################################################

📦 Como Executar e Testar o Projeto
1. Provisionamento com Terraform
Dentro da pasta terraform/, inicialize o ambiente e aplique a configuração:
terraform init
terraform apply -auto-approve

2. Validação dos Endpoints da API
A API Flask expõe as seguintes rotas na porta 5000:

GET /produtos: Retorna a lista de produtos disponíveis.

POST /pedidos: Envia um novo pedido para a fila do SQS.

Exemplo de payload enviado via Postman (POST):
JSON
{
  "produto_id": 1,
  "quantidade": 2,
  "cliente": "Michael Meneses"
}


1. Infraestrutura Criada com Sucesso:
(Print do terminal mostrando o final do comando terraform apply com sucesso)

2. Envio de Pedido:
(Print do Postman recebendo status 201 ao enviar um pedido)

3. Processamento da Lambda:
(Print do CloudWatch logs mostrando a Lambda consumindo a mensagem do SQS)

## 🧼 Limpeza de Recursos

Para evitar custos desnecessários na conta AWS após a validação e avaliação do projeto, toda a infraestrutura pode ser completamente removida com um único comando:

```bash
terraform destroy -auto-approve

