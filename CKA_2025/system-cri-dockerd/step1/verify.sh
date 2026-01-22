#!/bin/bash

systemctl is-enabled cri-docker.service >/dev/null 2>&1 && \
systemctl is-active cri-docker.service >/dev/null 2>&1
