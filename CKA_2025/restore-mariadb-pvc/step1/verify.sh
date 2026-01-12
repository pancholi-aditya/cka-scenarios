#!/bin/bash

kubectl get pvc mariadb -n mariadb -o jsonpath='{.status.phase}' 2>/dev/null | grep -q Bound
