# Automatic Failover and Redundancy

* Note: Make sure mTLS is enabled in mesh

```
CONTEXT=kind-kong
kubectl apply -f demo.yaml --context $CONTEXT
kubectl get po -n main-application --context $CONTEXT -w
```

# Add service in gateway
```
http POST :30001/services name=counter url=http://counter-app_main-application_svc_5000.mesh:80

# change host
http POST :30001/services/counter/routes \
hosts:='["<change-me>"]' \
paths:='["/"]' \
name='counter_route'
```
http://<change-me>:30080

```
CONTEXT=<change-me>
kubectl apply -f default-mesh-locale.yaml --context $CONTEXT
```

#### Scale down your own redis
```
CONTEXT=kind-kong
kubectl scale --replicas=0 -n main-application deployment/redis --context $CONTEXT
```

#### In browser you should see it failover to other redis services

#### Scale back up
```
kubectl scale --replicas=1 -n main-application deployment/redis --context $CONTEXT
```
