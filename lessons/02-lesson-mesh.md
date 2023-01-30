# Traffic Permissions

* Note: make sure mTLS is enabled

# Examine Policy file
```
CONTEXT=<change-me>
cat deny-mockbin.yaml
```

# Apply policy file to mesh
```
kubectl apply -f deny-mockbin.yaml --context $CONTEXT
```

# Try calling mockbin service from browser

# Remove policy
```
kubectl delete -f deny-mockbin.yaml --context $CONTEXT
```
