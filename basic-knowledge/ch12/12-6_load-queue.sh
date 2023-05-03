#!/bin/sh
curl -X PUT localhost:8080/memq/server/queues/keygen
for i in work-item-{0..99}
do
    curl -X POST localhost:8080/memq/server/queues/keygen/enqueue -d "$i"
done
