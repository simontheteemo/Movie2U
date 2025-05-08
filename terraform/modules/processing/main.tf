# IAM role for Lambda
resource "aws_iam_role" "processor" {
  name = "${var.resource_prefix}-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for Lambda
resource "aws_iam_role_policy" "processor" {
  name = "${var.resource_prefix}-processor-policy"
  role = aws_iam_role.processor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.upload_bucket_arn,
          "${var.upload_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "rekognition:StartLabelDetection",
          "rekognition:GetLabelDetection"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ]
        Resource = [
          var.analysis_table_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "mediaconvert:CreateJob",
          "mediaconvert:GetJob",
          "mediaconvert:ListJobs"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${var.media_output_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "transcribe:StartTranscriptionJob",
          "transcribe:GetTranscriptionJob"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "polly:StartSpeechSynthesisTask",
          "polly:GetSpeechSynthesisTask"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = aws_ssm_parameter.narrative_prompt.arn
      }
    ]
  })
}

# CloudWatch Logs policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.processor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "processor" {
  filename      = "${path.module}/processor.zip"
  function_name = "${var.resource_prefix}-processor"
  role          = aws_iam_role.processor.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  timeout       = 900
  memory_size   = 256

  source_code_hash = filebase64sha256("${path.module}/processor.zip")

  environment {
    variables = {
      UPLOAD_BUCKET         = var.upload_bucket_name
      ANALYSIS_TABLE        = var.analysis_table_name
      MEDIACONVERT_ENDPOINT = var.mediaconvert_endpoint
      MEDIACONVERT_QUEUE    = var.mediaconvert_queue_arn
      MEDIA_OUTPUT_BUCKET   = var.media_output_bucket_name
      MEDIACONVERT_ROLE     = var.mediaconvert_role_arn
    }
  }

  tags = var.tags
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.upload_bucket_arn
}

# Add this policy to the Lambda execution role
resource "aws_iam_role_policy" "mediaconvert_pass_role" {
  name = "${var.resource_prefix}-mediaconvert-pass-role"
  role = aws_iam_role.processor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = var.mediaconvert_role_arn
      }
    ]
  })
}

# Add S3 read permissions for media output bucket
resource "aws_iam_role_policy" "media_output_access" {
  name = "${var.resource_prefix}-media-output-access"
  role = aws_iam_role.processor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.media_output_bucket_arn,
          "${var.media_output_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_ssm_parameter" "narrative_prompt" {
  name  = "/video-analysis/prompts/comprehensive-narrative"
  type  = "SecureString"
  value = <<EOT
You are an assistant helping blind people understand videos. Create a comprehensive narrative combining visual elements and spoken dialogue.

Visual elements by timestamp:
{sceneDescription}

Spoken dialogue: "{transcript}"

Create a flowing narrative that:
1. Describes the visual scenes and actions
2. Integrates the spoken dialogue naturally
3. Maintains temporal alignment between visual elements and speech
4. Provides context that helps visualize the complete scene
EOT
}
