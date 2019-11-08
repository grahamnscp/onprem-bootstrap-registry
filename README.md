# Some basic scripts to parse json file of images and load into a local docker registry

If operating in a disconnected environment, a server on the edge with internet access can pull all the images and export to a tar file which can be copied internally and loaded into the server where the registry is to be populated

Once all the images are in the local docker daemon and a basic (or otherwise) docker registry is available and accessible via an FQDN name (not just localhost) the images can be tagged with the FQDN:PORT and pushed into the registry for deployment use later.

For Konvoy kubernetes the cluster.yaml syntax should be modified to specify the local docker registry as the default:
```
kind: ClusterConfiguration
apiVersion: konvoy.mesosphere.io/v1alpha1
spec:
  imageRegistries:
    - server: https://myregistry.fqdn:5000
      username: "myuser"
      password: "mypassword"
      default: true
```

