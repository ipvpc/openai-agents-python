FROM ghcr.io/astral-sh/uv:python3.12-bookworm

# Basic env for reliable non-interactive Python
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy only project definition files first for better layer caching
COPY pyproject.toml uv.lock ./

# Copy README.md (needed by pyproject.toml for build) and source files
COPY README.md ./
COPY src/agents ./src/agents

# Now copy the rest of the source tree
COPY . .

# Default command runs the repo checks (format-check, lint, mypy, tests)
CMD ["make", "check"]

RUN uv sync --all-extras --all-packages --group dev

RUN python -m venv .venv
RUN source .venv/bin/activate && pip install openai-agents