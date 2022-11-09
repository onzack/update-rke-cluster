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
  -e cluster_name="apps-dev" \
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
