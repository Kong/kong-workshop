# Kong Gateway installation and initialization

1.

```
CONTEXT=kind-kong
MAIN_APP_NS=kong

echo "apiVersion: v1
kind: Namespace
metadata:
  name: $MAIN_APP_NS
  labels:
    kuma.io/sidecar-injection: enabled" | kubectl apply -f - --context $CONTEXT
```

2.

```
kubectl create secret generic kong-config-secret -n $MAIN_APP_NS \
    --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_samesite":"off","cookie_secure":false}' \
    --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
    --from-literal=kong_admin_password=kong \
    --from-literal=password=kong \
    --context=$CONTEXT
```

3.

```
kubectl create secret generic kong-enterprise-license --from-file=license=license.json \
-n $MAIN_APP_NS --dry-run=client -o yaml | kubectl apply -f - --context $CONTEXT
```

4.

```
helm repo add kong https://charts.konghq.com ; helm repo update
```

5.

```
helm upgrade --install union-pacific-workshop kong/kong --namespace $MAIN_APP_NS --values values-kong.yaml --kube-context $CONTEXT --set ingressController.installCRDs=false
kubectl get po -n kong --context $CONTEXT -w
```

6.

#### Examine Kong Admin API
```
sudo apt  install httpie
http :30001/
```

#### Workloads

1.

```
echo "apiVersion: v1
kind: Namespace
metadata:
  name: my-applications
  labels:
    kuma.io/sidecar-injection: enabled" | kubectl apply -f - --context $CONTEXT
```
2.

```
kubectl apply -f mockbin.yaml -n my-applications --context $CONTEXT
```

#### Services and Routing
1.
```
http POST :30001/services name=mockbin url=http://mockbin_my-applications_svc_3000.mesh:80/requests
```

2.

```
# change host before you run command
http POST :30001/services/mockbin/routes \
hosts:='["up-workshop-X.centralus.cloudapp.azure.com"]' \
paths:='["/mockbin"]' \
strip_path:='true'
```

3.
From your browser, open http://up-workshop-X.centralus.cloudapp.azure.com:30080/mockbin

#### Plugins and policy
1.
```
http POST :30001/services/mockbin/plugins \
name=key-auth-enc \
config:='{"key_names":["apikey"]}'
```

Now try and call the above URL.

2.
```
http POST :30001/consumers username=app1
```
3.
```
http POST :30001/consumers/app1/key-auth-enc key=myapikey
```
