# FAL AI Models Documentation

This directory contains documentation for the FAL AI models used in the Selfi project:

1. [Flux LoRA](./flux-lora.md) - Main image generation model
   - Used for generating images from text prompts
   - Supports custom LoRA weights
   - Configurable generation parameters

2. [Flux LoRA Fast Training](./flux-lora-fast-training.md) - Training model
   - Used for training custom LoRA models
   - Supports both subject and style training
   - Includes auto-captioning and segmentation

## Integration Points

| Model | Component | Usage |
|-------|-----------|-------|
| flux-lora | Bot `/gen` command | Image generation from prompts |
| flux-lora | API `/generate` endpoint | Generation requests via API |
| flux-lora-fast-training | Bot `/train` command | Training custom LoRAs |
| flux-lora-fast-training | API `/train` endpoint | Training requests via API |

## Common Usage

1. Image Generation:
   ```typescript
   fal.subscribe("fal-ai/flux-lora", {
     input: {
       prompt: "your prompt",
       image_size: "landscape_4_3"
     }
   });
   ```

2. Training:
   ```typescript
   fal.subscribe("fal-ai/flux-lora-fast-training", {
     input: {
       images_data_url: "url_to_zip",
       steps: 1000,
       trigger_word: "TOK"
     }
   });
   ```

For detailed parameters and best practices, see each model's dedicated documentation.