FROM python:3.14-slim AS builder

WORKDIR /app
COPY ./pyproject.toml ./uv.lock ./

RUN pip install uv && uv sync --frozen --no-dev


FROM python:3.14-slim

WORKDIR /app
COPY --from=builder /app/.venv ./.venv

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

COPY ./app ./app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]