# Flux LoRA Fast Training

Model ID: `fal-ai/flux-lora-fast-training`

## Description
Fine-tuning endpoint optimized for fast LoRA training. Can be used for both subject-specific and style LoRA training.

## Purpose
Used for training custom LoRA models for users, supporting both:
- Subject-specific LoRAs (with auto-captioning and segmentation)
- Style LoRAs (without auto-captioning and segmentation)

## Input Parameters

### Required Parameters
- `images_data_url` (string): URL to zip archive with training images
  - Recommended: At least 4 images, more is better
  - Can include caption files with same name as images (e.g., `photo.jpg` and `photo.txt`)

### Optional Parameters
- `trigger_word` (string): Trigger word for captions
  - If no captions provided, used as caption
  - Ignored if captions are provided
  - Required for style training
- `steps` (integer): Training steps
  - Default: 1000
  - Min: 1
  - Max: 10000
- `create_masks` (boolean): Use segmentation masks in training
  - Default: true
  - Uses face masking for people when possible
- `is_style` (boolean): Style training mode
  - Default: false
  - When true, disables segmentation and auto-captioning
- `is_input_format_already_preprocessed` (boolean): Input format flag
  - Default: false
  - Set true if data is already preprocessed
- `data_archive_format` (string): Archive format specification
  - Optional, inferred from URL if not provided

## Response Structure

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
    file_size: number;    // Size in bytes
    content_type: string; // e.g., "application/octet-stream"
  };
  debug_preprocessed_output?: {
    url: string;
    file_name: string;
    file_size: number;
    content_type: string;
  } | null;
}
```

## API Usage Example

```typescript
const result = await fal.subscribe("fal-ai/flux-lora-fast-training", {
  input: {
    steps: 1000,
    is_style: false,
    create_masks: true,
    trigger_word: "TOK",
    images_data_url: "https://example.com/training_images.zip"
  },
  logs: true,
  onQueueUpdate: (update) => {
    console.log('Training status:', update.status);
  },
});
```

## Best Practices

1. Image Preparation:
   - Use at least 4 high-quality images
   - For subjects: use clear, well-lit photos with consistent focus
   - For styles: use images that clearly represent the style

2. Training Configuration:
   - For subjects:
     - Keep `create_masks` enabled
     - Use descriptive trigger words
     - Let auto-captioning handle descriptions
   - For styles:
     - Set `is_style` to true
     - Disable masks
     - Choose distinctive trigger word

3. Steps Configuration:
   - Start with 1000 steps
   - Increase for more complex styles
   - Decrease for simple subjects

4. Data Organization:
   - Use consistent image sizes
   - Include caption files when needed
   - Organize images by quality/relevance