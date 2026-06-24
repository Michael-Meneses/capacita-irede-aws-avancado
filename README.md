# Projeto E-commerce - Capacita iRede (Módulo Avançado)

Este projeto apresenta uma arquitetura moderna de microsserviços baseada em comunicação assíncrona na AWS, provisionada inteiramente via Terraform.

## Arquitetura do Projeto
Usuário → EC2 (API Flask) → SQS (Fila) → Lambda → CloudWatch Logs

## Como Executar o Terraform
1. Certifique-se de ter o Terraform e o AWS CLI instalados.
2. Configure suas credenciais comerciais da AWS usando `aws configure`.
3. Inicialize o diretório:
   ```bash
   terraform init

#  Aplique a infraestrutura:
1. terraform apply -auto-approve

# Como Acessar a Aplicação e Testar:
Listar Produtos: Execute um GET para http://<IP_DA_EC2>:5000/produtos
Criar Pedido (Envio SQS): Execute um POST para http://<IP_DA_EC2>:5000/pedidos
enviando um JSON com os dados do pedido.


