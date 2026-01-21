#!/bin/bash

kubectl get httproute web-route -n web -o json | \
jq -e '
.status.parents[].conditions[] |
select(.type=="Accepted" and .status=="True")
' >/dev/null 2>&1
