# Secure kube-apiserver Access

For testing purposes, the kubeadm-provisioned cluster API server was configured
to allow unauthenticated and unauthorized access.

You must secure the kube-apiserver by updating its static Pod manifest and
allowing the control plane to restart with the new settings.
