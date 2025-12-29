from pydantic import BaseModel, Field
from typing import Dict, Optional
from datetime import datetime

class CarbonCalculationRequest(BaseModel):
    activity_type: str = Field(..., description="Type of activity")
    value: float = Field(..., description="Activity value", gt=0)
    farmer_id: str = Field(..., description="Farmer ID")

class CarbonCalculationResponse(BaseModel):
    estimated_credits: float = Field(..., description="Estimated carbon credits in tons")
    confidence_score: float = Field(..., description="Confidence score 0-100")
    breakdown: Dict[str, float] = Field(..., description="Carbon breakdown by category")

class CarbonRecordResponse(BaseModel):
    id: str
    farmer_id: str
    total_credits: float
    confidence_score: float
    breakdown: Dict[str, float]
    verified_actions: Dict[str, bool]
    last_updated: datetime
    created_at: datetime

    class Config:
        from_attributes = True
