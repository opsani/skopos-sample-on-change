# skopos-sample-on-change
Sample app that demos the use of an on_change lifecycle event


To load in Skopos:

```
skopos load -project skopos-sample-on-change -env github://opsani/skopos-sample-on-change/env.yaml github://opsani/skopos-sample-on-change/model.yaml
```

Check the vote component in the `model.yaml` - it has an `on_change` lifecycle event that calls a plugin (containerized) that notifies an external service of the created and destroyed IPs. The plugin in this example is a container in the `probe-sample-on-change/` directory - it gets the list of created and destroyed components, as well as some user defined arguments (external service API URL, etc.) and calls the external service.
