
# Using OPA for fine grained authorization inside the mesh

#### Examine policy
```
cat opa.yaml
```

```
CONTEXT=gke_sales-engineering-282713_us-central1_global-up-workshop-pkanrwjd
kubectl apply -f opa.yaml --context $CONTEXT
```

Try calling service


Create a JWT with "role" claim and make sure it is encoded with secret of "secret"