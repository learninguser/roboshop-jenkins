#!/bin/bash
ZONE_ID="Z08819113VNU2ISF56217"
IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=jenkins" | jq ".Reservations[].Instances[].PublicIpAddress" |xargs)
sed -e "s/IPADDRESS/${IP}/" route53.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq