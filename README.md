## Introduction
Helm chart and Docker image to bootstrap a set of Azure DevOps agents in Kubernetes. This repo was put together as the official repositories and documentation is out of date and not actively maintained. No official documentation exists for hosting images in Kubernetes.

## Prerequisites
 - Kubernetes 1.8+ or newer
 - Helm

## Configure Azure DevOps pipelines

Before starting the chart installation, below configuration is required:

1. Create a personal access token with the authorized scope **Agent Pools(read, manage)**  following these [instructions](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#permissions). You will have to provide later the base64 encoded value of this token to the `azpToken` value of the chart. 

2. By default this chart uses the agent pool "Default". Should you require a custom pool you can find more details [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml%2Cbrowser). 

## Installing the Chart

The chart can be installed with the following command:

```bash
export AZP_TOKEN=$(echo -n '<AZP TOKEN>' | base64)

helm install --namespace <NAMESPACE> --set azpToken=${AZP_TOKEN} --set azpUrl="https://dev.azure.com/replace_with_my_org/" -f values.yaml azp-agent ./chart/azdo-agent
```

## Scale up the number of AZP agents

The number of AZP agents can be easily increased to `10` by using the following command:

```bash
kubectl scale --namespace <NAMESPACE> azp-agent --replicas 10
```

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for azp-agent pods |
| azpAgentName | string | `nil` | Agent name (default value: the container hostname) |
| azpPool | string | `nil` | Agent pool name (default value: Default) |
| azpToken | string | `nil` | Personal Access Token (PAT) granting access to AZP_URL |
| azpUrl | string | `nil` | The URL of the Azure DevOps or Azure DevOps Server instance |
| azpWorkspace | string | `nil` | Work directory (default value: _work) |
| cleanRun | bool | `false` | If `true` run workload on a new agent |
| diskSize | string | `"10Gi"` | Size of peristent volume in the `azpWorkspace` directory |
| extraEnv | object | `{}` | Additional environment variables to be pass to the azp-agent deployment |
| extraLabels | object | `{}` | Additional labels for azp-agent resources |
| fullnameOverride | string | `""` | Override full name |
| image.pullPolicy | string | `"IfNotPresent"` | azp-agent image pull policy  |
| image.repository | string | `"jeffvader/vsts-slim2:latest"` | azp-agent image |
| imagePullSecrets | list | `[]` | Image pull secrets |
| nameOverride | string | `""` | Override name |
| nodeSelector | object | `{}` | Node selection |
| podSecurityContext | object | `{}` | Set security context for pod |
| replicaCount | int | `1` | Amount of agents to start |
| resources | object | `{}` | CPU/memory resource requests/limits |
| securityContext | object | `{}` | Set security context for pod |
| storageClassName | string | `""` | Name of storageclass to use for workspace binding |
| tolerations | list | `[]` | Tolerations |
