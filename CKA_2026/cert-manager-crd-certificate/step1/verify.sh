#!/bin/bash
test -s custom-crd.txt && grep -q cert-manager.io custom-crd.txt
