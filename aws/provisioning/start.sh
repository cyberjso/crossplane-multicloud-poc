#!/bin/bash

cd "$(dirname "$0")"

. ../env.sh

aws cloudformation create-stack \
--stack-name crossplane-stack \
--template-body file://crossplane-stack.yaml \
--tags Key=Owner,Value=jackson.oliveira Key=Tec,Value=Multi-cloud Key=Team,Value=Dev \
--capabilities CAPABILITY_NAMED_IAM


# aws cloudformation describe-stack-resources --stack-name crossplane-stack