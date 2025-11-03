FROM ghcr.io/astral-sh/uv:python3.12-bookworm

# Basic env for reliable non-interactive Python
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Azure OpenAI configuration (can be overridden via environment variables)
# Set AZURE_OPENAI_ENDPOINT and AZURE_OPENAI_API_KEY to use Azure OpenAI
ENV AZURE_OPENAI_ENDPOINT="" \
    AZURE_OPENAI_API_KEY="" \
    AZURE_OPENAI_API_VERSION="2024-02-15-preview"

WORKDIR /app

# Copy only project definition files first for better layer caching
COPY pyproject.toml uv.lock ./

# Copy README.md (needed by pyproject.toml for build) and source files
COPY README.md ./
COPY src/agents ./src/agents

# Sync dependencies and build workspace project
RUN uv sync --all-extras --all-packages --group dev

# Now copy the rest of the source tree
COPY . .

# Default command runs the repo checks (format-check, lint, mypy, tests)
CMD ["make", "check"]