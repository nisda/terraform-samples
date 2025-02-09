variable "env" {
  type        = string
  default     = "poc"
  description = "environment name"
}
variable "log_retension_in_days" {
  type        = number
  default     = 30
  description = "common log retension in days"
}