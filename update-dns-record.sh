#!/bin/bash
ZONE_ID="Z0366464237Z7LZLZPKFA"
DOMAIN="learninguser.online"

for server in jenkins sonarqube; do
    PUBLIC_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${server}"  --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
    sed -e "s/IPADDRESS/${PUBLIC_IP}/" -e "s/COMPONENT/${server}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
    aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/jenkins.json | jq .
