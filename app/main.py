import uvicorn

from .config import Config

uvicorn.run(
    "app.app:app",
    host=Config.HOST,
    port=Config.PORT,
)
