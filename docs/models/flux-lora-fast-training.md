# Flux LoRA Fast Training

Model ID: `fal-ai/flux-lora-fast-training`

## Description
Fine-tuning endpoint optimized for fast LoRA training. Can be used for both subject-specific and style LoRA training.

## Installation

```bash
# Using pnpm (recommended)
pnpm add @fal-ai/client

# Using npm
npm install --save @fal-ai/client
```

Note: The `@fal-ai/serverless-client` package has been deprecated in favor of `@fal-ai/client`.

## Authentication

Set up your FAL AI key in one of two ways:

1. Environment variable (recommended):
```bash
export FAL_KEY="YOUR_API_KEY"
```

2. Client configuration:
```typescript
import { fal } from "@fal-ai/client";

fal.config({
  credentials: "YOUR_FAL_KEY"
});
```

⚠️ **Security Note**: Never expose your FAL_KEY in client-side code. Use a server-side proxy for browser applications.

## Methods

### Direct Subscribe
```typescript
const result = await fal.subscribe("fal-ai/flux-lora-fast-training", {
  input: {
    images_data_url: "your_zip_url",
    steps: 1000,
    trigger_word: "TOK"
  },
  logs: true,
  onQueueUpdate: (update) => {
    if (update.status === "IN_PROGRESS") {
      update.logs.map((log) => log.message).forEach(console.log);
    }
  },
});
```

### Queue Operations

For long-running training jobs:

1. Submit request:
```typescript
const { request_id } = await fal.queue.submit("fal-ai/flux-lora-fast-training", {
  input: {
    images_data_url: "your_zip_url"
  },
  webhookUrl: "https://your-webhook.com/callback"
});
```

2. Check status:
```typescript
const status = await fal.queue.status("fal-ai/flux-lora-fast-training", {
  requestId: request_id,
  logs: true
});
```

3. Get result:
```typescript
const result = await fal.queue.result("fal-ai/flux-lora-fast-training", {
  requestId: request_id
});
```

## Input Schema

### Required Parameters
- `images_data_url` (string): URL to zip archive with training images
  - Minimum 4 images recommended
  - Can include caption files with matching names (e.g., `photo.jpg` and `photo.txt`)

### Optional Parameters
- `trigger_word` (string): Trigger word for captions
  - Used as caption if no captions provided
  - Required for style training
- `steps` (integer, default: 1000): Training steps
  - Range: 1-10000
- `create_masks` (boolean, default: true): Use segmentation masks
  - Uses face masking for people when possible
- `is_style` (boolean, default: false): Style training mode
  - When true, disables segmentation and auto-captioning
- `is_input_format_already_preprocessed` (boolean, default: false)
  - Set true if data is preprocessed
- `data_archive_format` (string, optional)
  - Inferred from URL if not provided

## Response Schema

```typescript
interface TrainingResponse {
  diffusers_lora_file: {
    url: string;          // URL to trained weights
    file_name: string;    // e.g., "pytorch_lora_weights.safetensors"
    file_size: number;    // Size in bytes
    content_type: string; // e.g., "application/octet-stream"
  };
  config_file: {
    url: string;          // URL to configuration
    file_name: string;    // e.g., "config.json"
    file_size: number;
    content_type: string;
  };
  debug_preprocessed_output?: {
    url: string;
    file_name: string;
    file_size: number;
    content_type: string;
  } | null;
}
```

## File Handling

### Base64 Data URI
You can pass images as Base64 data URIs:
```typescript
const base64Image = "data:image/jpeg;base64,/9j/4AAQ...";
```

### URL Upload
For files hosted online:
```typescript
const imageUrl = "https://example.com/image.jpg";
```

### File Upload
Using FAL storage:
```typescript
const file = new File([imageData], "training.zip", { 
  type: "application/zip" 
});
const url = await fal.storage.upload(file);
```

## Best Practices

1. Image Preparation:
   - Use 4+ high-quality images
   - For subjects: clear, well-lit photos
   - For styles: representative style samples

2. Training Configuration:
   - Subjects:
     - Keep `create_masks: true`
     - Use descriptive trigger words
   - Styles:
     - Set `is_style: true`
     - Choose distinctive trigger word

3. Steps Configuration:
   - Start with 1000 steps
   - Increase for complex styles
   - Decrease for simple subjects

4. Data Organization:
   - Consistent image sizes
   - Clear file naming
   - Include captions when needed