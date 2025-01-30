# Flux LoRA Model

Model ID: `fal-ai/flux-lora`

## Description
Next generation text-to-image model for high-quality image generation.

## Purpose
Used for regular image generation requests.

## Input Parameters

### Required Parameters
- `prompt` (string): The text prompt to generate an image from

### Optional Parameters
- `image_size`: Size of the generated image
  - Default: `landscape_4_3`
  - Options: 
    - `square_hd`
    - `square`
    - `portrait_4_3`
    - `portrait_16_9`
    - `landscape_4_3`
    - `landscape_16_9`
  - Custom sizes: `{ width: number, height: number }`
- `num_inference_steps` (integer): Number of inference steps (default: 28)
- `guidance_scale` (float): CFG scale for prompt adherence (default: 3.5)
- `num_images` (integer): Number of images to generate (default: 1)
- `seed` (integer): Seed for reproducible results
- `loras` (array): List of LoRA weights to apply
  ```typescript
  interface LoraWeight {
    path: string;     // URL or path to LoRA weights
    scale: number;    // Scale factor (default: 1)
  }
  ```

## Response Structure

```typescript
interface GenerationResponse {
  images: Array<{
    url: string;
    content_type: string;  // e.g., "image/jpeg"
    width?: number;
    height?: number;
  }>;
  seed: number;            // Used or generated seed
  has_nsfw_concepts: boolean[];
  prompt: string;          // Original prompt
}
```

## API Usage Example

```typescript
const result = await fal.subscribe("fal-ai/flux-lora", {
  input: {
    prompt: "A detailed landscape photo with mountains",
    image_size: "landscape_4_3",
    num_inference_steps: 28,
    guidance_scale: 3.5
  },
  logs: true,
  onQueueUpdate: (update) => {
    console.log('Generation status:', update.status);
  },
});
```

## Safety Features
- Built-in NSFW content detection
- Safety checker enabled by default
- Content filtering options available

## Best Practices
1. Keep prompts clear and detailed
2. Use guidance scale between 3.0-7.0 for best results
3. Default inference steps (28) work well for most cases
4. Use consistent image size for batch generations
5. Store seeds for reproducible results