#!/bin/sh

# fail on any errors
set -e

# read args
action=$1
shift
json="$@"


# Sample value of `json` var. This script only uses "ipaddr", but other fields
# are available
#
# {
#   "diff_created": [
#     {
#       "ipaddr": "10.0.3.3",
#       "image": "opsani/sample-front:1.1",
#       "state": "running",
#       "index": 1,
#       "reason": "started",
#       "id": "97k6dhs5vou41qncifsyy3rto"
#     }
#   ],
#   "exposed_port": "80",
#   "api_base_url": "http://example.com/",
#   "diff_destroyed": [
#     {
#       "ipaddr": "10.0.3.2",
#       "image": "opsani/sample-front:1.1",
#       "state": "running",
#       "index": 1,
#       "reason": "started",
#       "id": "7phshpko9qr8btqvj8uym055k"
#     }
#   ],
#   "project": "test",
#   "inst": [
#     {
#       "reason": "started",
#       "index": 1,
#       "ipaddr": "10.0.3.3",
#       "id": "97k6dhs5vou41qncifsyy3rto",
#       "image": "opsani/sample-front:1.1"
#     }
#   ],
#   "component": "vote"
# }


# Get base api URL
api_base_url=$(echo "${json}"|jq -e -r '.api_base_url')
exposed_port=$(echo "${json}"|jq -e -r '.exposed_port')

# Get list of created and destroyed instances
destroyed=
created=

for i in $(echo "${json}"|jq -r '.diff_created[]?.ipaddr'); do
    [ -n "${created}" ] && created="${created},"
    created="${created}${i}"
done

for i in $(echo "${json}"|jq -r '.diff_destroyed[]?.ipaddr'); do
    [ -n "${destroyed}" ] && destroyed="${destroyed},"
    destroyed="${destroyed}${i}"
done

# Call API endpoint - this does it in a single call, but we can call the API
# once for each created/destroyed component.

# NB: If you have both destroyed and created components (i.e. upgrade/replace),
# Docker may reuse the IP addresses so you may see the same IP as both
# destroyed and created

wget -q -T 3 "${api_base_url}?destroyed=${destroyed}&created=${created}&exposed_port=${exposed_port}"
