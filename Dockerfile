
FROM python:3.9-alpine3.20 as builder

WORKDIR /app

COPY code/requirements.txt requirements.txt

RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r requirements.txt && pip install flask

COPY code/app.py .
RUN rm requirements.txt

FROM builder

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

COPY --from=builder /app/* .

EXPOSE 5001


CMD ["python", "app.py"]