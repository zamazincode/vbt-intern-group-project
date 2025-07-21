import os
from flask import Flask, request, jsonify
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)

genai.configure(api_key=os.environ.get("GEMINI_API_KEY"))
model_name = "gemini-2.5-pro"

@app.route('/generate-description', methods=['POST'])
def generate_description():
    data = request.get_json()
    required_fields = ["type", "age", "breed"]
    if not data or not all(field in data for field in required_fields):
        return jsonify({"error": "Missing fields: 'type', 'age', 'breed' are required."}), 400

    prompt = (
        f"Bir evcil hayvan için sıcak ve ilgi çekici bir tanıtım yazısı oluştur. "
        f"Tür: {data['type']}, Yaş: {data['age']}, Cins: {data['breed']}."
    )
    try:
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(prompt)
        return jsonify({"description": response.text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/recommend-pet', methods=['POST'])
def recommend_pet():
    data = request.get_json()
    if not data or "preferences" not in data:
        return jsonify({"error": "Missing field: 'preferences' is required."}), 400

    prompt = (
        f"Kullanıcının yaşam tarzı ve tercihleri: {data['preferences']}. "
        f"Bu bilgilere göre en uygun evcil hayvan türlerini öner ve nedenlerini açıkla."
    )
    try:
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(prompt)
        return jsonify({"recommendation": response.text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="localhost", port=5000)