output "name" {
  value = "${var.name}"
}

output "cluster_name" {
  value = "${var.env}.${var.name}"
}

output "state_store" {
  value = "s3://${aws_s3_bucket.state_store.id}"
}

