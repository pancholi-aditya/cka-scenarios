#!/bin/bash

kubectl rollout status deployment mariadb -n mariadb >/dev/null 2>&1