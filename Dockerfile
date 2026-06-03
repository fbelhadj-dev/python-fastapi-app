FROM python:3.14-alpine AS builder

WORKDIR /app
COPY ./pyproject.toml ./uv.lock ./

RUN pip install uv && uv sync --frozen --no-dev

FROM builder AS test

WORKDIR /app
COPY --from=builder /app/.venv ./.venv

RUN uv sync --frozen --group dev

COPY ./app ./app
COPY ./tests ./tests

CMD ["uv", "run", "pytest"]

FROM python:3.14-alpine AS build

WORKDIR /app
COPY --from=builder /app/.venv ./.venv

COPY ./app ./app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

CMD [ "python", "-m", "app.main" ]