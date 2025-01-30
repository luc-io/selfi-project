# Flux LoRA Model

Model ID: `fal-ai/flux-lora`

## Description
Next generation text-to-image model for high-quality image generation (FLUX.1 [dev]).

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
const result = await fal.subscribe("fal-ai/flux-lora", {
  input: {
    prompt: "Your detailed prompt here",
    image_size: "landscape_4_3",
    num_inference_steps: 28,
    guidance_scale: 3.5
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

For longer generation requests:

1. Submit request:
```typescript
const { request_id } = await fal.queue.submit("fal-ai/flux-lora", {
  input: {
    prompt: "Your prompt",
    image_size: "landscape_4_3"
  },
  webhookUrl: "https://your-webhook.com/callback"
});
```

2. Check status:
```typescript
const status = await fal.queue.status("fal-ai/flux-lora", {
  requestId: request_id,
  logs: true
});
```

3. Get result:
```typescript
const result = await fal.queue.result("fal-ai/flux-lora", {
  requestId: request_id
});
```

## Input Schema

### Required Parameters
- `prompt` (string): Text prompt to generate image from

### Optional Parameters
- `image_size`: Size of the generated image
  - Default: `landscape_4_3`
  - Options: `square_hd`, `square`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, `landscape_16_9`
  - Custom: `{ width: number, height: number }`
- `num_inference_steps` (integer, default: 28): Number of inference steps
- `guidance_scale` (float, default: 3.5): CFG scale for prompt adherence
- `seed` (integer): Seed for reproducible results
- `num_images` (integer, default: 1): Number of images to generate
- `enable_safety_checker` (boolean, default: true): Enable safety filtering
- `output_format` (string, default: "jpeg"): "jpeg" or "png"
- `loras`: Array of LoRA weights to apply
  ```typescript
  interface LoraWeight {
    path: string;  // LoRA weights URL/path
    scale: number; // Scale factor (default: 1)
  }
  ```
- `sync_mode` (boolean): Wait for direct upload completion

## Response Schema

```typescript
interface GenerationResponse {
  images: Array<{
    url: string;
    content_type: string;  // e.g., "image/jpeg"
    width?: number;
    height?: number;
  }>;
  seed: number;
  has_nsfw_concepts: boolean[];
  prompt: string;
}
```

## Example Response

```json
{
  "images": [
    {
      "url": "https://generated-image-url.com/image.jpg",
      "content_type": "image/jpeg"
    }
  ],
  "prompt": "A detailed landscape photo with mountains",
  "seed": 42,
  "has_nsfw_concepts": [false]
}
```

## Using Custom Image Sizes

```typescript
// Using predefined size
const result = await fal.subscribe("fal-ai/flux-lora", {
  input: {
    prompt: "Mountain landscape",
    image_size: "landscape_4_3"
  }
});

// Using custom dimensions
const result = await fal.subscribe("fal-ai/flux-lora", {
  input: {
    prompt: "Mountain landscape",
    image_size: {
      width: 1280,
      height: 720
    }
  }
});
```

## Using LoRA Models

```typescript
const result = await fal.subscribe("fal-ai/flux-lora", {
  input: {
    prompt: "A photo in style TOK",
    loras: [{
      path: "path/to/lora/weights.safetensors",
      scale: 0.8
    }]
  }
});
```

## Best Practices

1. Prompt Engineering:
   - Be specific and descriptive
   - Include desired artistic style
   - Mention technical details (lighting, angle, etc.)

2. Parameter Tuning:
   - Keep guidance_scale between 3.0-7.0
   - Default inference steps (28) work well
   - Use same seed for reproducibility

3. Image Size Selection:
   - Use predefined sizes when possible
   - Match aspect ratio to content type
   - Consider bandwidth for larger sizes

4. LoRA Integration:
   - Start with scale 0.8 for subtle effect
   - Increase scale for stronger influence
   - Test different combinations

5. Error Handling:
   - Always check for NSFW flags
   - Handle queue timeouts gracefully
   - Validate image URLs in response