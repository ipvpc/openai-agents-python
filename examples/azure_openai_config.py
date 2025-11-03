"""Example configuration for using Azure OpenAI with the Agents SDK.

This example shows how to configure the SDK to use Azure OpenAI instead of the standard OpenAI API.

Azure OpenAI typically requires:
1. Endpoint: https://<resource-name>.openai.azure.com/
2. API Key: Your Azure OpenAI API key
3. API Version: e.g., 2024-02-15-preview
4. Deployment name: Used as the model name when creating agents

Usage:
    export AZURE_OPENAI_ENDPOINT="https://<resource-name>.openai.azure.com/"
    export AZURE_OPENAI_API_KEY="your-azure-api-key"
    export AZURE_OPENAI_API_VERSION="2024-02-15-preview"  # Optional
    python azure_openai_config.py
"""

import os
from openai import AsyncOpenAI
from agents import set_default_openai_client, set_default_openai_api

# Azure OpenAI configuration from environment variables
AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_API_KEY = os.getenv("AZURE_OPENAI_API_KEY")
AZURE_OPENAI_API_VERSION = os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview")

if not AZURE_OPENAI_ENDPOINT or not AZURE_OPENAI_API_KEY:
    raise ValueError(
        "Please set AZURE_OPENAI_ENDPOINT and AZURE_OPENAI_API_KEY environment variables.\n"
        "Example:\n"
        "  export AZURE_OPENAI_ENDPOINT='https://<resource-name>.openai.azure.com/'\n"
        "  export AZURE_OPENAI_API_KEY='your-azure-api-key'"
    )

# Ensure endpoint doesn't have trailing slash
endpoint = AZURE_OPENAI_ENDPOINT.rstrip("/")

# Configure the Azure OpenAI client
# Note: Azure OpenAI typically uses Chat Completions API, not Responses API
azure_client = AsyncOpenAI(
    base_url=f"{endpoint}/openai/deployments",
    api_key=AZURE_OPENAI_API_KEY,
    api_version=AZURE_OPENAI_API_VERSION,
)

# Set the Azure OpenAI client as the default client for the SDK
# Azure OpenAI typically uses Chat Completions, so we set that as default
set_default_openai_client(azure_client, use_for_tracing=False)
set_default_openai_api("chat_completions")

# Now you can use agents normally - they will use Azure OpenAI
# Example:
# from agents import Agent, Runner
#
# async def main():
#     agent = Agent(
#         name="Azure Agent",
#         instructions="You are a helpful assistant.",
#         model="gpt-4",  # Use your Azure deployment name here (e.g., "gpt-4", "gpt-35-turbo")
#     )
#
#     result = await Runner.run(agent, "Hello!")
#     print(result.final_output)
#
# if __name__ == "__main__":
#     import asyncio
#     asyncio.run(main())
