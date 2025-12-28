from pydantic import BaseModel

class AudioBase(BaseModel):
    text: str

class AudioCreate(AudioBase):
    pass

class Audio(AudioBase):
    id: int
    file_path: str

    class Config:
        orm_mode = True