# API Specification

## Base URL

```
https://api.selfi.bot/v1
```

## Authentication

All API requests must include:
- `x-user-id`: Telegram user ID
- `x-auth-token`: JWT token from bot

## Endpoints

### Image Generation

#### Generate Image
```http
POST /generate

Request:
{
  "prompt": string,
  "negativePrompt"?: string,
  "loraId"?: string,
  "seed"?: number,
  "baseModelId": string
}

Response:
{
  "id": string,
  "imageUrl": string,
  "starsUsed": number,
  "seed": number
}

Error Responses:
402 - Insufficient stars
404 - Model not found
500 - Generation failed
```

### LoRA Management

#### Get My LoRAs
```http
GET /loras/me

Response:
{
  "loras": [
    {
      "id": string,
      "name": string,
      "triggerWord": string,
      "status": "PENDING" | "TRAINING" | "COMPLETED" | "FAILED",
      "previewImageUrl": string?,
      "isPublic": boolean,
      "createdAt": string
    }
  ]
}
```

#### Get Public LoRAs
```http
GET /loras/public

Query Parameters:
- page?: number (default: 1)
- limit?: number (default: 20)
- sort?: "newest" | "popular" (default: "newest")

Response:
{
  "loras": [
    {
      "id": string,
      "name": string,
      "triggerWord": string,
      "previewImageUrl": string?,
      "isPublic": boolean,
      "createdAt": string,
      "user": {
        "username": string?
      }
    }
  ],
  "pagination": {
    "total": number,
    "pages": number,
    "current": number
  }
}
```

### Training

#### Start Training
```http
POST /training/start

Request:
{
  "name": string,
  "triggerWord": string,
  "imageUrls": string[],
  "instancePrompt": string,
  "classPrompt"?: string,
  "steps"?: number,
  "learningRate"?: number
}

Response:
{
  "modelId": string,
  "starsDeducted": number,
  "remainingStars": number
}

Error Responses:
402 - Insufficient stars
400 - Invalid parameters
500 - Training failed to start
```

#### Get Training Status
```http
GET /training/{modelId}/status

Response:
{
  "status": "PENDING" | "PROCESSING" | "COMPLETED" | "FAILED",
  "progress"?: number,
  "error"?: string,
  "previewImageUrl"?: string
}
```

### Star Management

#### Get Star Balance
```http
GET /stars/balance

Response:
{
  "balance": number,
  "totalSpent": number,
  "totalBought": number
}
```

#### Get Transaction History
```http
GET /stars/transactions

Query Parameters:
- page?: number (default: 1)
- limit?: number (default: 20)
- type?: "PURCHASE" | "GENERATION" | "TRAINING" | "REFUND"

Response:
{
  "transactions": [
    {
      "id": string,
      "amount": number,
      "type": "PURCHASE" | "GENERATION" | "TRAINING" | "REFUND",
      "status": "PENDING" | "COMPLETED" | "FAILED" | "REFUNDED",
      "createdAt": string
    }
  ],
  "pagination": {
    "total": number,
    "pages": number,
    "current": number
  }
}
```

### File Upload

#### Upload Training Image
```http
POST /upload

Request:
- Content-Type: multipart/form-data
- Body: FormData with "file" field

Response:
{
  "url": string
}

Error Responses:
400 - Invalid file type
413 - File too large
500 - Upload failed
```

## WebSocket Events

### Training Updates
```typescript
// Connect to
ws://api.selfi.bot/v1/training/{modelId}/ws

// Incoming Events
interface TrainingUpdate {
  type: "progress" | "completed" | "failed";
  data: {
    progress?: number;
    error?: string;
    previewImageUrl?: string;
  }
}
```

## Error Responses

All error responses follow this format:
```json
{
  "error": {
    "code": string,
    "message": string,
    "details"?: any
  }
}
```

Common error codes:
- `insufficient_stars`: Not enough stars for operation
- `invalid_parameters`: Request validation failed
- `not_found`: Resource not found
- `generation_failed`: Image generation failed
- `training_failed`: Model training failed
- `upload_failed`: File upload failed