# Update RKE cluster
Update Rancher Kubernetes Engine (RKE) clusters built with Rancher.

![Upadte RKE cluster visualization ](https://github.com/onzack/update-rke-cluster/blob/main/update-rke-cluster-blueprint.png)

## Comments
The playbooks handles etcd and control plane nodes the same way.  

## WARNING
The playbook uses an aggressive drain command for the nodes and the playbook will contunue even if the drain command was not successful. Updates are prioritized higher then pod availability.  
This early version of the playbook supports only Ubuntu or Debian as operating system.

## Quick start
### Prerequesites
- Rancher Server and an RKE Cluster
- Rancher information to update a downstream Kubernetes cluster
  - Via Rancher API
    - Kubernetes Cluster URL in Rancher is known, e. g. "https://rancher.example.com/v3/clusters/c-asdf"
    - Cluster Name is known, e. g. "apps-dev"
    - A Rancher API user, e. g. "token-asdf"
    - The API user password/token
  - Via `kubectl patch` command
    - Cluster name is known, e. g. "c-xdabc"
    - Kubeconfig file for the Rancher local cluster
- Kubernets CLI (kubectl)
- The kubeconfig file for the downstream cluster to drain and uncordon nodes

### Run the playbooks
Update all nodes and the kubernetes version (via API):  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e kubernetes_cluster_url="https://rancher.example.com/v3/clusters/c-asdf" \
  -e cluster_display_name="apps-dev" \
  -e rancher_api_username="token-asdf" \
  -e rancher_api_password="asdf321asdf321asdf321asdf321asdf321asdf321asdf321asdf3" \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e kubeconfig_downstream="/home/ansible/kubeconfig_downstream" \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  -e docker_package_name="docker.io" \
  -e docker_version="20.10.12*" \
  -e pause_seconds_between_workers=300
```

Update all nodes and the kubernetes version (via kubectl patch):  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e cluster_name="c-xdabc" \
  -e kubeconfig_local="/home/ansible/kubeconfig_local" \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e kubeconfig_downstream="/home/ansible/kubeconfig_downstream" \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  -e docker_package_name="docker.io" \
  -e docker_version="20.10.12*" \s
  -e pause_seconds_between_workers=300
```

Update only the worker nodes:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e kubeconfig_downstream="/home/ansible/kubeconfig_downstream" \
  -e pause_seconds_between_workers=300 \
  -e docker_package_name="docker.io" \
  -e docker_version="20.10.12*" \
  --tags "worker"
```

Update only the controlplane (master, etcd) nodes:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e kubeconfig_downstream="/home/ansible/kubeconfig_downstream" \
  -e docker_package_name="docker.io" \
  -e docker_version="20.10.12*" \
  --tags "controlplane"
```

Update only the kubernetes version (via API):  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e kubernetes_cluster_url="https://rancher.example.com/v3/clusters/c-asdf" \
  -e cluster_name="apps-dev" \
  -e rancher_api_username="token-asdf" \
  -e rancher_api_password="asdf321asdf321asdf321asdf321asdf321asdf321asdf321asdf3" \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  --tags "kubernetes"
```
Update only the kubernetes version (via kubectl patch):  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e cluster_name="c-xdabc" \
  -e kubeconfig_local="/home/ansible/kubeconfig_local" \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  --tags "kubernetes"
```

## How to get some of the needed information for the Ansible playbook
### Ansible inventory file
Create a file with the following content and replace the hostnames and IPs with the values from your environment:
```
localhost ansible_connection=local

[controlplane_nodes]
master1 ansible_host=10.0.0.13
master2 ansible_host=10.0.0.14
etcd1 ansible_host=10.0.0.10
etcd2 ansible_host=10.0.0.11
etcd3 ansible_host=10.0.0.12

[worker_nodes]
worker1 ansible_host=10.0.0.15
worker2 ansible_host=10.0.0.16
worker3 ansible_host=10.0.0.17
```

### The kubernetes_cluster_url
If you choose to update the Kubernetes cluster version via Rancher API, you need the corresponding URL for your cluster, e. g. "https://rancher.example.com/v3/clusters/c-asdf".  
Replace "rancher.example.com" with the URL of your Rancher server and replace "c-asdf" with the "metadata.name" value of your cluster, as found in: Rancher Cluster Management menu -> Cluster hamburger menu -> "View YAML".

### The rancher_api_username and rancher_api_password
Create a new personal API Key with scope "No Scope" and use the "Access Key" as the rancher_api_user and the "Secret Key" as the rancher_api_password.

### The cluster_name
Get the cluster name from the "metadata.name" value of your cluster, as found in: Rancher Cluster Management menu -> Cluster hamburger menu -> "View YAML".
