# Update RKE cluster
Update Rancher Kubernetes Engine clusters built with Rancher.

# Comments
The Ansible playbook pauses for about 10 Minutes between each worker node to give Longhorn or any other cloud native storage the change to rebalance.  

The playbooks handles etcd and control plane nodes the same way.  

# WARNING
The playbook uses an affressive drain command for the nodes and the playbook will contunue even if the drain command was not successful. Updates are prioritized higher then pod availability.  

This early version of the playbook supports only Ubunt oder Debian as operating system.
# Quick start
Update all nodes and the kubernetes version:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  -e kubernetes_cluster_url="https://rancher.example.com/v3/clusters/c-asdf" \
  -e cluster_name="apps-dev" \
  -e rancher_api_username="token-asdf" \
  -e rancher_api_password="asdf321asdf321asdf321asdf321asdf321asdf321asdf321asdf3" \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e path_to_kubeconfig="/home/ansible/kubeconfig"
  -e pause_seconds_between_workers=300
```

Update only the worker nodes:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e path_to_kubeconfig="/home/ansible/kubeconfig"
  -e pause_seconds_between_workers=300
  --tags "worker"
```

Update only the controlplane (master, etcd) nodes:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e path_to_kubectl=$PATH_TO_KUBECTL \
  -e path_to_kubeconfig="/home/ansible/kubeconfig"
  --tags "controlplane"
```

Update only the kubernetes version:  
```
export PATH_TO_KUBECTL=$(which kubectl)
git clone https://github.com/onzack/update-rke-cluster.git
ansible-playbook -i hosts update-rke-cluster/ansible/update-rke-cluster.yml \
  -e rancher_kubernetes_version="v1.20.4-rancher1-1" \
  -e kubernetes_cluster_url="https://rancher.example.com/v3/clusters/c-asdf" \
  -e cluster_name="apps-dev" \
  -e rancher_api_username="token-asdf" \
  -e rancher_api_password="asdf321asdf321asdf321asdf321asdf321asdf321asdf321asdf3" \
  --tags "kubernetes"
```