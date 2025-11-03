sudo docker run -it \
--env OPENAI_API_KEY=sk-proj-1234567890 \
--env OPENAI_WEBHOOK_SECRET=whsec_1234567890 \
--env OPENAI_WEBHOOK_URL=https://example.com/openai/webhook \
openai-agents:local bash