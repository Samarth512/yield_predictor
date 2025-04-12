from flask import Flask, request, jsonify
import pickle
import os

# Load your trained model (ensure the model file is in the same directory)
model = pickle.load(open('random_forest_model.pkl', 'rb'))

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json

    # Extract features from the request
    features = [
        data['Crop'],            # Encoded crop type (e.g., Wheat -> 1)
        data['Season'],          # Encoded season (e.g., Kharif -> 0)
        data['State'],           # Encoded state (e.g., Maharashtra -> 2)
        float(data['Area']),     # Area in hectares
        float(data['Annual_Rainfall']),  # Annual rainfall in mm
        float(data['Fertilizer']),       # Fertilizer usage in kilograms
        float(data['Pesticide'])         # Pesticide usage in kilograms
    ]

    # Make prediction using the model
    prediction = model.predict([features])[0]

    return jsonify({'predicted_yield': f"{prediction:.2f} tons/ha"})

if __name__ == '__main__':
    # Ensure it listens on the correct port
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
