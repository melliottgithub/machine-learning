# app.py
from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

model = joblib.load("rf_pipeline.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        text = data.get("text", "")

        if not text or not isinstance(text, str):
            return jsonify({"error": "Invalid input"}), 400

        prediction = model.predict([text])
        return jsonify({"prediction": prediction[0]})
    except Exception as e:
        return jsonify({"error": "Model prediction failed"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
