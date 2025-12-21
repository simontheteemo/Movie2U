---
layout: default
title: Movie2U Documentation
---

[Home](./) |
[Architecture](./architecture) |
[Technical Stack](./technical-stack) |
[Deployment](./deployment) |
[Demo](./demo)

# Movie2U Documentation
## Overview
Movie2U is a serverless application that enhances video accessibility by providing comprehensive visual and audio descriptions, specifically designed to help blind or visually impaired users understand video content.

## Features

### 1. Visual Analysis
- Detects objects, scenes, and actions in videos
- Provides temporal information about what happens when
- Generates natural language descriptions of visual content

### 2. Audio Processing
- Extracts audio from video files
- Transcribes speech to text
- Preserves original audio content

### 3. Comprehensive Narrative Generation
- Combines visual analysis with speech transcription
- Creates flowing, natural descriptions
- Maintains temporal alignment between visual and spoken content

### 4. Audio Narration
- Converts comprehensive narratives to speech
- Uses natural-sounding voices (Amazon Polly)
- Creates accessible audio descriptions

## Output Files
1. Original video in S3
2. Extracted audio in S3
3. Transcription JSON in S3
4. Generated narration audio in S3
5. Analysis data in DynamoDB

## Data Structure
```typescript
interface VideoAnalysis {
    videoId: string;
    timestamp: string;
    labels: Array<{
        label: string;
        confidence: number;
        timestamp: number;
    }>;
    audioPath: string;
    visualNarrative: string;
    transcriptionPath: string;
    transcript: string;
    comprehensiveNarrative: string;
    narrationAudioPath: string;
    status: string;
}
```

## Additional Resources
- [Architecture Diagrams](architecture.md)
- [Technical Stack Details](technical-stack.md)
- [Deployment Guide](deployment.md)