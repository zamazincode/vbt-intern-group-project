# Temel Python imajı
FROM python:3.10-slim-buster
WORKDIR /app

# Bağımlılıkları kopyalama ve yükleme
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Uygulama kodunu kopyalama
COPY . .

# FastAPI için Uvicorn'u başlatma
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]