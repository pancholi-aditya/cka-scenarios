#!/bin/bash
set -e

# File must exist
[ -f /opt/course/1/contexts ]
[ -f /opt/course/1/context_default_kubectl.sh ]
[ -f /opt/course/1/context_default_no_kubectl.sh ]

# contexts file must not be empty
[ -s /opt/course/1/contexts ]

# kubectl command must be correct
grep -qx "kubectl config current-context" \
  /opt/course/1/context_default_kubectl.sh

# non-kubectl command must not contain kubectl
! grep -q kubectl /opt/course/1/context_default_no_kubectl.sh

# non-kubectl command must reference kubeconfig
grep -q kube/config /opt/course/1/context_default_no_kubectl.sh