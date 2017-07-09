datadog_monitor2terraform
==========

Import DataDog monitor rule and generate Terraform resource configuration

## Setup

```bash
$ git clone https://github.com/kurochan/datadog_monitor2terraform
$ bundle install
```

## Usage
```
$ ruby ./monitor-import.rb [monitor_name] [monitor_id]
```

* `monitor_name` is terraform resource id
* `monitor_id` is written in datadog monitor page url
  * https://app.datadoghq.com/monitors#112233
  * `112233` is `monitor_id`

## example

```bash
$ export DATADOG_API_KEY='datadogapikeydatadogapikey'
$ export DATADOG_APP_KEY='datadogappkeydatadogappkeydatadogappkey'

$ ruby ./monitor-import.rb dynamodb_user_error_count 112233

resource "datadog_monitor" "dynamodb_user_error_count" {
  name               = "DynamoDB UserError count is above the Threshold !!"
  type               = "metric alert"
  message            = <<EOF
@slack-metric-alert DynamoDB UserError count is above the Threshold !!
EOF
  query = "sum(last_5m):sum:aws.dynamodb.user_errors{*} > 10"
  thresholds {
    warning = 5.0
    critical = 10.0
  }
  notify_no_data = false
  no_data_timeframe = 2
  renotify_interval = 0
  timeout_h = 0
  require_full_window = true
  notify_audit = false
  tags = []
}
```
