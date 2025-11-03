FROM python:3.12-slim

# Basic env for reliable non-interactive Python
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install curl to fetch uv (fast Python package manager)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    git \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    libreadline-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:${PATH}"

# Copy only project definition files first for better layer caching
COPY pyproject.toml uv.lock ./

# Sync dependencies (prod + dev) according to repository guidance
RUN uv sync --all-extras --all-packages --group dev
ENV PATH="/root/.local/bin:${PATH}"

# Now copy the rest of the source tree
COPY . .

# Default command runs the repo checks (format-check, lint, mypy, tests)
CMD ["make", "check"]


