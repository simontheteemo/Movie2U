---
layout: default
title: Deployment
description: Movie2U Deployment Guide
---

[Home](./README.md) | 
[Architecture](./architecture.md) | 
[Technical Stack](./technical-stack.md) | 
[Deployment](./deployment.md) | 
[Demo](./demo.md)

# Deployment Guide

## Prerequisites
1. AWS Account
2. GitHub Account
3. Installed Tools:
   - Node.js 24
   - Terraform
   - AWS CLI

## AWS Configuration
1. Create S3 bucket for Terraform state
2. Configure AWS credentials
3. Enable required AWS services:
   - Rekognition
   - MediaConvert
   - Transcribe
   - Bedrock
   - Polly

## GitHub Setup
1. Create repository
2. Add AWS credentials as secrets:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY

## Local Development Setup
```bash
# Clone repository
git clone <repository-url>

# Install dependencies
cd src/video-processor
npm install

# Build TypeScript
npm run build
```

## Infrastructure Deployment
```bash
# Initialize Terraform
cd terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## GitHub Actions Deployment
1. Push changes to main branch
2. GitHub Actions will:
   - Build TypeScript
   - Run Terraform
   - Deploy to AWS

## Verification
1. Upload test video to S3
2. Check CloudWatch logs
3. Verify DynamoDB entries
4. Test generated audio
