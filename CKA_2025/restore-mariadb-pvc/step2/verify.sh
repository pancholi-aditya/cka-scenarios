#!/bin/bash

grep -q "persistentVolumeClaim" /mariadb-deployment.yaml && \
grep -q "claimName: mariadb" /mariadb-deployment.yaml
