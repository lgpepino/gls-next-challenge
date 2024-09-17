
# Use uma imagem base do Python
FROM python:3.9-slim-buster

# Copiar o arquivo da aplicação para o contêiner
COPY code/app.py /app/

# Definir o diretório de trabalho
WORKDIR /app

# Instalar as dependências
COPY code/requirements.txt requirements.txt
RUN pip install flask && pip install -r requirements.txt

# Expor a porta 5000
EXPOSE 5001

# Comando para iniciar a aplicação
CMD ["python", "app.py"]