# Consumer groups

#### Create consumer groups
```
http POST :30001/consumer_groups name=gold
http POST :30001/consumer_groups name=silver
```
#### Create consumers
```
http POST :30001/consumers username=gold_customer
http POST :30001/consumers username=silver_customer
```

#### Create consumer credentials
```
http POST :30001/consumers/gold_customer/key-auth-enc key=gold
http POST :30001/consumers/silver_customer/key-auth-enc key=silver
```

#### Add consumers to groups
```
http POST :30001/consumers/gold_customer/consumer_groups group=gold
http POST :30001/consumers/silver_customer/consumer_groups group=silver
```

#### Override rate limits for consumer groups
```
http PUT :30001/consumer_groups/gold/overrides/plugins/rate-limiting-advanced config:='{"limit": [10], "window_size": [60]}'
http PUT :30001/consumer_groups/silver/overrides/plugins/rate-limiting-advanced config:='{"limit": [7], "window_size": [60]}'
```

####  Add rate limiting advanced plugin for groups
```
http POST :30001/services/mockbin/plugins \
    name=rate-limiting-advanced \
    config:='{"limit": [5], "window_size": [60], "identifier": "consumer", "sync_rate": -1, "namespace": "myns", "strategy": "local", "enforce_consumer_groups": true, "consumer_groups":["gold", "silver"]}'
```