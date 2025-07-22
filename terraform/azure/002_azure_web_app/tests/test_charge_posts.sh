#!/bin/bash

fqdn=$1
number_of_requests=$2
echo "Request Id, Total Time (s)"
for i in $(seq 1 $number_of_requests); do
	curl -o /dev/null -s -w "$i, %{time_total}\n" \
		-X POST https://$fqdn/api/payments \
		-H "Content-Type: application/json" \
		-d "{\"amount\":$((RANDOM % 1000 + 10)),\"currency\":\"EUR\",\"merchantId\":\"MERCHANT_$i\"}" &
done
wait
