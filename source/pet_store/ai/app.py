import os
from flask import Flask, request, jsonify
import google.generativeai as genai


app = Flask(__name__)


api_key = os.getenv("GEMINI_API_KEY")


if not api_key:
    print("HATA: GEMINI_API_KEY ortam değişkeni tanımlı değil. Lütfen PythonAnywhere ayarlarınızda tanımlayın.")

genai.configure(api_key=api_key)
model_name = "gemini-2.5-pro" 

@app.route('/generate-description', methods=['POST'])
def generate_description():
    """
    Verilen hayvan bilgilerine göre tanıtım metni üretir.
    Gerekli alanlar: 'type', 'breed'.
    """
    data = request.get_json()
    required_fields = ["type", "breed"]
    
    
    if not data or not all(field in data for field in required_fields):
        
        return jsonify({"error": "Eksik alanlar: 'type', 'breed' gereklidir."}), 400

    prompt = (
        f"Bir evcil hayvan için sıcak ve ilgi çekici bir tanıtım yazısı oluştur. (maximum 50 kelime) "
        f"Tür: {data['type']}, Cins: {data['breed']}."
    )
    try:
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(prompt)
        return jsonify({"description": response.text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/recommend-pet', methods=['POST'])
def recommend_pet():
    """
    Kullanıcının yaşam tarzına göre evcil hayvan önerir.
    Gerekli alan: 'preferences'.
    """
    data = request.get_json()
  
    if not data or "preferences" not in data:
        return jsonify({"error": "Eksik alan: 'preferences' gereklidir."}), 400

    prompt = (
        f"Kullanıcının yaşam tarzı ve tercihleri: {data['preferences']}. "
        f"Bu bilgilere göre en uygun evcil hayvan türlerini öner ve nedenlerini açıkla (maximum 50 kelime)."
    )
    try:
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(prompt)
        return jsonify({"recommendation": response.text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


application = app
