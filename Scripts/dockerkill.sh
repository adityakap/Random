#!/bin/bash
id=$1
interval=$2
duration=$3
iterations=$(bc -l <<< "scale=2; $3/$2")
iterations=$(bc -l <<< "scale=0;$iterations/1")
echo $iterations
COUNTER=0
while [ $COUNTER -lt $iterations ]; do
docker kill -s KILL $id
sleep $interval
let COUNTER=COUNTER+1
done