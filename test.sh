sudo docker run -it \
--env AZURE_OPENAI_ENDPOINT=https://<resource-name>.openai.azure.com/ \
--env AZURE_OPENAI_API_KEY=your-azure-api-key \
--env AZURE_OPENAI_API_VERSION=2024-02-15-preview \
openai-agents:local bash