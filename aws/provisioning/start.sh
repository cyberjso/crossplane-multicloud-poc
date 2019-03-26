#!/bin/bash

cd "$(dirname "$0")"

aws cloudformation create-stack \
--stack-name crossplane-stack \
--template-body file://crossplane-stack.yaml \
--capabilities CAPABILITY_NAMED_IAM