# web-app1

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env.secret | string | `"mysecret"` |  |
| env.valueMessage | string | `"App 1 "` |  |
| env.valuePort | string | `"80"` |  |
| image.containerPort | int | `80` |  |
| image.name | string | `"app1"` |  |
| image.repository | string | `"devopsorient.azurecr.io/webpage8001"` |  |
| image.tag | string | `"latest"` |  |
| namespace | string | `"devops"` |  |
| replicasCount | int | `1` |  |
| resources.cpu | string | `"0.1"` |  |
| resources.memory | string | `"256Mi"` |  |
| service.portExpose | int | `80` |  |
| service.portTarget | int | `80` |  |
| service.protocol | string | `"TCP"` |  |
| serviceAccountName | string | `"service-account-1"` |  |

