/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "lock_table_name" {
  value = aws_dynamodb_table.tf_lock.id
}

output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.id
}
