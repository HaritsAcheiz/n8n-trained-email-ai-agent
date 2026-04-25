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
	h. MS_APP_CLIENT_ID=<get from azure>
	i. MS_APP_SECRET_ID=<get from azure>
	j. MS_APP_SECRET=<get from azure>
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
	a. click three dot button on bottom left side.
	b. open settings
	c. click Comunity nodes
	d. install comunity node n8n-nodes-mcp
	e. enable understand checkbox
	f. click Install
	g. restart docker container
		- docker-compose down
		- docker-compose up -d
### 4. Use Ngrok to publish your local (for development purpose)
	a. Follow instruction from this [link link](https://ngrok.com/downloads/linux) to install ngrok in your local
	b. Run the Ngrok ngrok http 5678
	c. Get the Public Address (Forwarding) Copy to clipboard
### 5. Get microsoft account credential
	a. Open Azure Portal
	b. Login
	c. Click on burger button on top left side.
	d. Click on Microsoft Entra ID
	e. Click on Manage
	f. Click on App Registrations
	g. Click on New registration
		- Fill name
		- Choose Supported account types "Accounts in any organizational directory and personal Microsoft accounts"
		% For Production - Redirect URI ("https://<unique-domain>.ngrok-free.app" concat with "/rest/oauth2-credential/callback")
		- Redirect URI "http://localhost:5678/rest/oauth2-credential/callback"
		- Click on Register
	h. Click Add a certificate or secret
	i. Click on New Client Secret
		- Fill Description and choose Expires
	j. Copy credential to .env file
		- MS_APP_CLIENT_ID
		- MS_APP_SECRET_ID
		- MS_APP_SECRET
### 5. Create Agent Basic Agent AI Workflow
	a. Create workflow
	b. Add click trigger node, mimic input from outlook email (for development purpose)
		% - Find out input get from outlook trigger
		% 	1. Add microsoft outlook trigger
		% 	2. Create new Credential
		% 		- Fill Client ID and Client Secret with value that stored in your .env file
		% 	3. Click on Connect my account
		% 	4. Sign in with your outlook account
		1. Click on Fetch Test Event Button
		2. Copy output to click trigger node
			a. Open click trigger node
			b. Click on set mock data
				[
				    {
				        "id": "AQMkADAwATMwMAItN2E2Yi1iYWZhLTAwAi0wMAoARgAAA5tdwux29LNMloIuv-Y1y2sHAMq4legj1TtEnwzPYP78Mw4AAAIBDAAAAMq4legj1TtEnwzPYP78Mw4AARNiDgcAAAA=",
				        "conversationId": "AQQkADAwATMwMAItN2E2Yi1iYWZhLTAwAi0wMAoAEACcDLV4MKc-SYh8dLh_8CVc",
				        "subject": "Inquiry about the Evergreen 2000 Standing Desk",
				        "bodyPreview": "Hello Sarah,\r\n\r\nI hope you're having a good day.\r\n\r\nI'm writing to request some information about one of your products. I'm interested in the Evergreen 2000 standing desk. Could you please provide me with the following details?\r\n\r\nProduct specifications: I'd like to know more about its technical specs, dimensions, and any key features.\r\nPricing: Could you give me the current price and information on any available package deals or discounts?\r\nAvailability: Is the product currently in stock? What's the estimated shipping time to my location, Jakarta, Indonesia?\r\n\r\nI appreciate your time and help. I look forward to your response.\r\n\r\nBest regards,\r\n\r\nIndra",
				        "from": "indra.s@gmail.com",
				        "to": [
				            "customercare@outlook.com"
				        ],
				        "categories": [],
				        "hasAttachments": false
				    }
				]
	c. Add AI Agent Node
		- Choose "Define Below" for "Source for Prompt (User Message)"
		- Prompt (User Message):
			"{{ $json.bodyPreview }}"
		- Click on Add Option and choose System Message fill it with this system prompt:
			"Generates a professional, empathetic email response"
		- Add Chat "Model Azure OpenAI Chat Model"
			1. Create New Credential
				- Fill API Key
				- Fill Resource Name
				- Fill API Version
				- Fill Endpoint



## Deactivate
### 1. docker-compose down for keep volume data presist
### 2. docker-compose down -v for permanently clean all volume data