from flask import Flask, jsonify, request
import boto3
import os
import json

app = Flask(__name__)

# Recupera a URL mapeada pelo Terraform
QUEUE_URL = os.environ.get('SQS_QUEUE_URL')
# Configura o cliente SQS apontando para a regiao correta
sqs = boto3.client('sqs', region_name='us-east-1')

@app.route('/produtos', methods=['GET'])
def listar_produtos():
    produtos = [
        {"id": 1, "nome": "Notebook Pro", "preco": 4500.00},
        {"id": 2, "nome": "Mouse Sem Fio", "preco": 120.00},
        {"id": 3, "nome": "Teclado Mecanico", "preco": 350.00}
    ]
    return jsonify(produtos), 200

@app.route('/pedidos', methods=['POST'])
def criar_pedido():
    dados = request.get_json()
    
    if not dados:
        return jsonify({"erro": "Corpo da requisicao invalido"}), 400
        
    try:
        # Envia a mensagem para o SQS de forma assincrona
        response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(dados)
        )
        return jsonify({
            "status": "Pedido recebido com sucesso e enviado para processamento!",
            "message_id": response.get('MessageId')
        }), 202
    except Exception as e:
        return jsonify({"erro": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)