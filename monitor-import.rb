#!/usr/bin/env ruby

require 'dogapi'
require 'erb'

api_key= ENV['DATADOG_API_KEY']
app_key= ENV['DATADOG_APP_KEY']
monitor_name = ARGV[0]
monitor_id = ARGV[1]

dog = Dogapi::Client.new(api_key, app_key)
monitor = dog.get_monitor(monitor_id)[1]

renderer =  ERB.new(DATA.read, nil, "-")
result = renderer.result

puts result

__END__

resource "datadog_monitor" "<%= monitor_name %>" {
  name               = "<%= monitor["name"] %>"
  type               = "<%= monitor["type"] %>"
  message            = <<EOF
<%= monitor["message"] %>
EOF
  query = "<%= monitor["query"].gsub('"', '\\"') %>"
  <%- if monitor["options"]["escalation_message"] != nil -%>
  escalation_message = "<%= monitor["options"]["escalation_message"] %>"
  <%- end -%>
  <%- if monitor["options"]["thresholds"] != nil && monitor["options"]["thresholds"] != {} -%>
  thresholds {
    <%- if monitor["options"]["thresholds"]["ok"] != nil -%>
    ok = <%= monitor["options"]["thresholds"]["ok"] %>
    <%- end -%>
    <%- if monitor["options"]["thresholds"]["warning"] != nil -%>
    warning = <%= monitor["options"]["thresholds"]["warning"] %>
    <%- end -%>
    <%- if monitor["options"]["thresholds"]["critical"] != nil -%>
    critical = <%= monitor["options"]["thresholds"]["critical"] %>
    <%- end -%>
  }
  <%- end -%>
  <%- if monitor["options"]["notify_no_data"] != nil -%>
  notify_no_data = <%= monitor["options"]["notify_no_data"] %>
  <%- end -%>
  <%- if monitor["options"]["no_data_timeframe"] != nil -%>
  no_data_timeframe = <%= monitor["options"]["no_data_timeframe"] %>
  <%- end -%>
  <%- if monitor["options"]["new_host_delay"] != nil -%>
  new_host_delay = <%= monitor["options"]["new_host_delay"] %>
  <%- end -%>
  <%- if monitor["options"]["evaluation_delay"] != nil -%>
  evaluation_delay = <%= monitor["options"]["evaluation_delay"] %>
  <%- end -%>
  <%- if monitor["options"]["renotify_interval"] != nil -%>
  renotify_interval = <%= monitor["options"]["renotify_interval"] %>
  <%- end -%>
  <%- if monitor["options"]["timeout_h"] != nil -%>
  timeout_h = <%= monitor["options"]["timeout_h"] %>
  <%- end -%>
  <%- if monitor["options"]["include_tags"] != nil -%>
  include_tags = <%= monitor["options"]["include_tags"] %>
  <%- end -%>
  <%- if monitor["options"]["require_full_window"] != nil -%>
  require_full_window = <%= monitor["options"]["require_full_window"] %>
  <%- end -%>
  <%- if monitor["options"]["notify_audit"] != nil -%>
  notify_audit = <%= monitor["options"]["notify_audit"] %>
  <%- end -%>
  tags = <%= monitor["tags"] %>
}
