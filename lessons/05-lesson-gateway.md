# Basic obervability

#### Add file log plugin
```
http POST :30001/services/mockbin/plugins \
name=file-log \
config:='{"path": "/dev/stdout"}'
```