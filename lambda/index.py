import json

def handler(event, context):
    for record in event['Records']:
        print("--- Nova mensagem recebida do SQS ---")
        payload = record['body']
        print(f"Conteúdo do Pedido: {payload}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processado com sucesso!')
    }