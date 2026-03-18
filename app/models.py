from pydantic import BaseModel
from typing import Any


class JsonRpcRequest(BaseModel):
    id: str | int | None = None
    method: str
    params: dict[str, Any] = {}

    model_config = {
        "json_schema_extra": {
            "example": {
                "id": 1,
                "method": "jlp.maservice.parse",
                "params": {"q": "日本語の形態素解析をします。"},
            }
        }
    }


class JsonRpcResponse(BaseModel):
    id: str | int | None = None
    result: Any = None

    model_config = {
        "json_schema_extra": {
            "example": {
                "id": 1,
                "result": {
                    "tokens": [
                        ["日本語", "にほんご", "日本語", "名詞", "一般", "*", "*"],
                        ["の", "の", "の", "助詞", "連体化", "*", "*"],
                    ]
                },
            }
        }
    }
