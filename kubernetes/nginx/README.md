# web-server-nginx

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.data.app1.name | string | `"web-app1"` |  |
| config.data.app1.port | int | `80` |  |
| config.data.app2.name | string | `"web-app2"` |  |
| config.data.app2.port | int | `80` |  |
| config.data.app3.name | string | `"web-app3"` |  |
| config.data.app3.port | int | `80` |  |
| config.data.app4.name | string | `"web-app4"` |  |
| config.data.app4.port | int | `80` |  |
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
| deployment.volumes.items.key | string | `"default.conf"` |  |
| deployment.volumes.items.path | string | `"default.conf"` |  |
| namespace | string | `"devops"` |  |
| service.name | string | `"web-server"` |  |
| service.portExpose | int | `80` |  |
| service.portTarget | int | `80` |  |
| service.protocol | string | `"TCP"` |  |

