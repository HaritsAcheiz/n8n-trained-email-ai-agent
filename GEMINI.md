# GEMINI.md - n8n-trained-email-ai-agent

## Project Overview
This project implements an AI-powered Email Agent for customer service automation, specifically tailored for "MagicCars.com". It uses **n8n** as the orchestration engine, leveraging its LangChain nodes to create an intelligent agent capable of professional, empathetic, and context-aware email communication.

For a high-level overview of how the system works, see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

### Core Technologies
- **n8n**: Workflow automation and AI agent orchestration.
- **Azure OpenAI**: LLM provider (GPT-4o-mini).
- **Qdrant**: Vector database for Retrieval-Augmented Generation (RAG).
- **Postgres**: Chat memory storage for conversation history.
- **Microsoft Outlook**: Email integration for triggers and responses.
- **Docker Compose**: Local infrastructure orchestration.
- **Terraform**: Infrastructure as Code for Azure deployment.

## Building and Running

### Local Development (Docker)
1.  **Environment Setup**: Create a `.env` file in the root directory based on the requirements in `README.md`.
2.  **Start Services**:
    ```bash
    docker compose up -d
    ```
    This starts n8n, Postgres, and Qdrant.
3.  **n8n Configuration**:
    - Access n8n at `http://localhost:5678`.
    - Install the `n8n-nodes-mcp` community node as described in the `README.md`.
    - **Sync Credentials**: Run `docker exec n8n n8n import:credentials --input=/home/node/workflows/credentials-portable.json` to automatically link n8n to your `.env` variables.
    - **Sync Workflows**: Run `docker exec n8n n8n import:workflow --input=/home/node/workflows/Main.json`.
    - Workflows and credentials are automatically mounted from `./n8n-workflows` to `/home/node/workflows` inside the container.

### Cloud Deployment (Azure)
The `terraform/` directory contains configuration for deploying to Azure.
1.  Navigate to `terraform/`.
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Apply the configuration (requires Azure CLI and proper permissions):
    ```bash
    terraform apply
    ```

## Project Structure
- `n8n-workflows/`: Directory containing exported n8n workflow JSON files and `credentials-portable.json` for environment-driven setup.
- `docker-compose.yaml`: Defines the local development environment and passes `.env` variables to n8n.
- `terraform/`: Azure infrastructure definitions (`main.tf`, `variables.tf`, `output.tf`).
- `shared/`: Mounted volume for shared data between the host and containers.

## Development Conventions
- **Workflow Updates**: 
    - **Edit in VS Code**: Modify JSON in `n8n-workflows/`, then sync to n8n: 
      `docker exec n8n n8n import:workflow --input=/home/node/workflows/<file>.json`
    - **Edit in UI**: Modify in n8n, then export back to local:
      `docker exec n8n n8n export:workflow --all --output=/home/node/workflows/`
- **Credential Portability**: Use **Expression-based Credentials** (e.g., `{{ $env.AI_API_KEY }}`) to ensure the project remains "clone and run" across different environments.
- **AI Agent Logic**: The system prompt and agent behavior are defined within the "AI Agent" node in `Main.json`.
- **RAG Implementation**: Knowledge base retrieval is handled via Qdrant nodes within the workflow.
- **Memory**: Conversation persistence is managed by the "Postgres Chat Memory" node, using `conversationId` as the session key.
- **MCP**: The agent uses Model Context Protocol (MCP) via `mcpClientTool` for extended capabilities.

## Usage Guidelines
- **Triggers**: The workflow is designed to be triggered by incoming Outlook emails.
- **Mocking**: For development, use the "click trigger node" with mock data as provided in the `README.md`.
- **Validation**: Always verify the AI's responses against the "Core Guidelines" and "Rules" defined in the system prompt inside `Main.json`.
