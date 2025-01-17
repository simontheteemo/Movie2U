variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "upload_bucket_arn" {
  description = "ARN of the S3 upload bucket"
  type        = string
}

variable "upload_bucket_name" {
  description = "Name of the S3 upload bucket"
  type        = string
}

variable "analysis_table_arn" {
  description = "ARN of the DynamoDB analysis table"
  type        = string
}

variable "analysis_table_name" {
  description = "Name of the DynamoDB analysis table"
  type        = string
}

variable "mediaconvert_endpoint" {
  description = "MediaConvert endpoint URL"
  type        = string
}

variable "mediaconvert_queue_arn" {
  description = "MediaConvert queue ARN"
  type        = string
}

variable "media_output_bucket_arn" {
  description = "ARN of the S3 bucket for MediaConvert output"
  type        = string
}

variable "media_output_bucket_name" {
  description = "Name of the S3 bucket for MediaConvert output"
  type        = string
}

variable "mediaconvert_role_arn" {
  description = "ARN of the IAM role for MediaConvert"
  type        = string
}