from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib

app = FastAPI()

model = joblib.load("rf_pipeline.pkl")

class Item(BaseModel):
    text: str

@app.post("/predict/")
async def predict(item: Item):
    try:
        prediction = model.predict([item.text])
        return {"prediction": prediction[0]}
    except:
        raise HTTPException(status_code=500, detail="Model prediction failed")
