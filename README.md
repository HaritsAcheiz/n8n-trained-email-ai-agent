# n8n-trained-email-ai-agent
Email AI agent with auto model training using N8N

## Pre-Requisites
### 1. Docker Engine with docker compose

## Installation
### 1. Create docker-compose.yaml
	a. n8n container
	b. postgres container
	c. qdrant cntainer
	d. presist data with volume
	e. network
### 2. Create .env file
	a. GENERIC_TIMEZONE=<preferred timezone>
	b. N8N_ENCRYPTION_KEY=<random encryption key>
	c. N8N_USER_MANAGEMENT_JWT_SECRET=<random jwt secret>
	d. POSTGRES_USER=<your postgres user>
	e. POSTGRES_PASSWORD=<your postgres password>
	f. POSTGRES_DB=<your postgress db name>
	g. QDRANT_API_KEY=<random api key>
### 3. Deployment
	docker-compose up -d
### 4. Validation
	open http://localhost:5678 on your browser

## Usage
### 1.Open n8n web app
	open http://localhost:5678 on your browser
### 2. Sign up admin account
	a. email
	b. first name
	c. last name
	d. password
	e. Sign Up
### 3.Install n8n-nodes-mcp
	a.

## Deactivate
### 1. docker-compose down for keep volume data presist
### 2. docker-compose down -v for permanently clean all volume data