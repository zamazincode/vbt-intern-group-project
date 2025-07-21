
# 🐾 Pet Store AI - Flask + Gemini

Bu proje, Google Gemini API kullanarak evcil hayvan tanıtımı ve önerisi yapan basit bir Flask servisidir.

---

## 🚀 Kurulum Adımları

### 1. Sanal Ortam Oluşturun

```bash
python3 -m venv venv
source venv/bin/activate  # MacOS/Linux
```

Windows için:
```bash
venv\Scripts\activate
```

---

### 2. Gereken Paketleri Yükleyin

```bash
pip install -r requirements.txt
```

---

### 3. Ortam Değişkenini Tanımlayın

Proje dizinine `.env` adında bir dosya oluşturun ve içine aşağıdaki satırı ekleyin:

```
GEMINI_API_KEY=senin_api_anahtarin
```

> 🔐 Not: `senin_api_anahtarin` kısmını gerçek API anahtarınla değiştir.

---

### 4. Servisi Başlatın

```bash
python app.py
```

---

## 📌 Servisler

### `GET /`

Servisin çalıştığını doğrulamak için kullanılabilir.

---

### `POST /generate-description`

Verilen hayvan bilgilerine göre tanıtım metni üretir.

#### Örnek Request:

```json
{
  "pet_type": "kedi",
  "age": "2",
  "breed": "British Shorthair"
}
```

---

### `POST /recommend-pet`

Kullanıcının yaşam tarzına göre evcil hayvan önerir.

#### Örnek Request:

```json
{
  "lifestyle": "apartmanda yaşayan, çocuklu aile"
}
```

---

## 📦 Gerekli Paketler (`requirements.txt`)

```txt
Flask
python-dotenv
google-generativeai
```

---

## 🧠 Desteklenen AI Platformu

- [Gemini (Google Generative AI)](https://ai.google.dev/)

---

Hazırlayan: `Pet Store AI Ekibi` 🐶🐱🐰
