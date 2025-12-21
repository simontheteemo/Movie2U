---
layout: default
title: Architecture
description: Movie2U System Architecture
---

[Home]({{ site.baseurl }}/) |
[Architecture]({{ site.baseurl }}/architecture) |
[Technical Stack]({{ site.baseurl }}/technical-stack) |
[Deployment]({{ site.baseurl }}/deployment) |
[Demo]({{ site.baseurl }}/demo)

# Movie2U Architecture

## Component Flow Diagram

<div class="mermaid">
flowchart TD
    subgraph Input
        Video[Video Upload] --> S3upload[S3 Upload Bucket]
    end

    subgraph Processing
        S3upload --> Lambda[Lambda Processor]
        
        Lambda --> |Visual Analysis| Rekognition
        Lambda --> |Audio Extraction| MediaConvert
        
        Rekognition --> |Labels| Bedrock1[Bedrock - Visual Narrative]
        
        MediaConvert --> |Audio| Transcribe
        Transcribe --> |Text| CombineData[Combine Visual + Audio]
        
        CombineData --> |Combined Data| Bedrock2[Bedrock - Comprehensive Narrative]
        
        Bedrock2 --> Polly[Polly - Text to Speech]
    end

    subgraph Storage
        MediaConvert --> |Extracted Audio| S3media[S3 Media Bucket]
        Transcribe --> |Transcription| S3media
        Polly --> |Narration Audio| S3media
        
        Bedrock1 --> |Visual Narrative| DynamoDB
        Bedrock2 --> |Comprehensive Narrative| DynamoDB
        S3media --> |File Paths| DynamoDB
    end

    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:white;
    classDef storage fill:#3F8624,stroke:#232F3E,stroke-width:2px,color:white;
    
    class S3upload,S3media,DynamoDB storage;
    class Lambda,Rekognition,MediaConvert,Transcribe,Bedrock1,Bedrock2,Polly aws;
</div>

## Process Sequence

<div class="mermaid">
sequenceDiagram
    participant User
    participant S3
    participant Lambda
    participant Rekognition
    participant MediaConvert
    participant Transcribe
    participant Bedrock
    participant Polly
    participant DynamoDB

    User->>S3: Upload Video
    S3->>Lambda: Trigger
    
    par Parallel Processing
        Lambda->>Rekognition: Start Label Detection
        Lambda->>MediaConvert: Extract Audio
    end
    
    MediaConvert-->>S3: Save Audio File
    Lambda->>Transcribe: Start Transcription
    
    Rekognition-->>Lambda: Labels Complete
    Lambda->>Bedrock: Generate Visual Narrative
    
    Transcribe-->>S3: Save Transcription
    Lambda->>Bedrock: Generate Comprehensive Narrative
    
    Bedrock-->>Lambda: Return Narrative
    Lambda->>Polly: Generate Speech
    
    Polly-->>S3: Save Narration Audio
    Lambda->>DynamoDB: Save Complete Analysis
</div>

## Infrastructure Components

### Storage
- S3 Buckets for file storage
- DynamoDB for metadata and analysis results

### Compute
- Lambda for serverless processing
- AWS Services for specialized tasks

### IAM and Security
- Service roles and policies
- S3 bucket policies
- Lambda execution roles