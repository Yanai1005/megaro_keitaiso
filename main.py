from fastapi import FastAPI, HTTPException
from app.models import JsonRpcRequest, JsonRpcResponse
from app.analyzer import analyzer

app = FastAPI(title="形態素解析API", version="1.0.0")

@app.post("/")
def parse(request: JsonRpcRequest) -> JsonRpcResponse:
    if request.method != "jlp.maservice.parse":
        raise HTTPException(status_code=400, detail="Unsupported method")
    
    text = request.params.get("q", "")
    tokens = analyzer.parse(text)
    
    return JsonRpcResponse(
        id=request.id,
        result={"tokens": tokens}
    )

@app.get("/health")
def health():
    return {"status": "ok"}