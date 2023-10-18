import json
import boto3
import pickle
import os

# Initialize the S3 client
s3 = boto3.client('s3')

# Define the S3 bucket and object key where the model is stored as environment variables
S3_BUCKET = os.environ['S3_BUCKET']
MODEL_KEY = os.environ['MODEL_KEY']

# Load the model from S3
def load_model():
    try:
        print("Loading model from S3...")
        response = s3.get_object(Bucket=S3_BUCKET, Key=MODEL_KEY)
        model_bytes = response['Body'].read()
        print("Model loaded successfully.")
        return pickle.loads(model_bytes)
    except Exception as e:
        print(f"Failed to load model from S3: {str(e)}")
        raise Exception("Failed to load model from S3") from e

model = load_model()

def lambda_handler(event, context):
    try:
        data = json.loads(event['body'])
        text = data.get("text", "")

        if not text or not isinstance(text, str):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid input"})
            }

        prediction = model.predict([text])
        return {
            "statusCode": 200,
            "body": json.dumps({"prediction": prediction[0]})
        }
    except Exception as e:
        print(f"Error in Lambda function: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Model prediction failed"})
        }
