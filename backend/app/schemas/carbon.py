from pydantic import BaseModel

class FarmActivityRequest(BaseModel):
    farmer_address: str
    trees_planted: int
    fertilizer_usage: str
    tillage_method: str
    irrigation_type: str
