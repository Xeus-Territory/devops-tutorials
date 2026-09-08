# web-server-nginx

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.name | string | `"nginx-conf"` |  |
| deployment.image.containerPortHTTP | int | `80` |  |
| deployment.image.containerPortHTTPS | int | `443` |  |
| deployment.image.name | string | `"web-server"` |  |
| deployment.image.repository | string | `"devopsorient.azurecr.io/nginx_alb"` |  |
| deployment.image.tag | string | `"k8s"` |  |
| deployment.replicasCount | int | `1` |  |
| deployment.resources.cpu | string | `"0.1"` |  |
| deployment.resources.memory | string | `"256Mi"` |  |
| deployment.volumeMounts.mountPath | string | `"/etc/nginx/site-enables"` |  |
| deployment.volumeMounts.name | string | `"nginx-conf"` |  |
| namespace | string | `"devops"` |  |
| persistentVolumeClaim.name | string | `"nginx-conf"` |  |
| service.name | string | `"web-server"` |  |
| service.portExpose | int | `80` |  |
| service.portTarget | int | `80` |  |
| service.protocol | string | `"TCP"` |  |
| storageClass.name | string | `"nginx-conf"` |  |
| storageClass.parameters.resourceGroup | string | `"DevOpsIntern"` |  |
| storageClass.parameters.shareName | string | `"nginx"` |  |
| storageClass.parameters.storageAccount | string | `"orientdevopsintern"` |  |

