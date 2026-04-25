# GEMINI.md - n8n-trained-email-ai-agent

## Project Overview
This project implements an AI-powered Email Agent for customer service automation, specifically tailored for "MagicCars.com". It uses **n8n** as the orchestration engine, leveraging its LangChain nodes to create an intelligent agent capable of professional, empathetic, and context-aware email communication.

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
    docker-compose up -d
    ```
    This starts n8n, Postgres, and Qdrant.
3.  **n8n Configuration**:
    - Access n8n at `http://localhost:5678`.
    - Install the `n8n-nodes-mcp` community node as described in the `README.md`.
    - Import the `Main.json` workflow.
    - Configure credentials for Azure OpenAI, Microsoft Outlook, and Postgres within n8n.

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
- `Main.json`: The exported n8n workflow containing the AI Agent logic.
- `docker-compose.yaml`: Defines the local development environment.
- `terraform/`: Azure infrastructure definitions (`main.tf`, `variables.tf`, `output.tf`).
- `shared/`: Mounted volume for shared data between the host and containers.

## Development Conventions
- **Workflow Updates**: When modifying the n8n workflow, ensure you export it back to `Main.json` to keep the repository in sync.
- **AI Agent Logic**: The system prompt and agent behavior are defined within the "AI Agent" node in `Main.json`.
- **RAG Implementation**: Knowledge base retrieval is handled via Qdrant nodes within the workflow.
- **Memory**: Conversation persistence is managed by the "Postgres Chat Memory" node, using `conversationId` as the session key.
- **MCP**: The agent uses Model Context Protocol (MCP) via `mcpClientTool` for extended capabilities.

## Usage Guidelines
- **Triggers**: The workflow is designed to be triggered by incoming Outlook emails.
- **Mocking**: For development, use the "click trigger node" with mock data as provided in the `README.md`.
- **Validation**: Always verify the AI's responses against the "Core Guidelines" and "Rules" defined in the system prompt inside `Main.json`.
