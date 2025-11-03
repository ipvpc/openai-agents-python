FROM ghcr.io/astral-sh/uv:python3.12-bookworm

# Basic env for reliable non-interactive Python
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1ok

WORKDIR /app

# Copy only project definition files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies only (without building workspace project)
RUN uv sync --no-install-project --all-extras --all-packages --group dev

# Now copy the rest of the source tree (including source files needed for build)
COPY . .

# Sync again to build and install the workspace project
RUN uv sync --all-extras --all-packages --group dev

# Default command runs the repo checks (format-check, lint, mypy, tests)
CMD ["make", "check"]

