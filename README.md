# KubeInfra

Infrastructure code for our Kubernetes cluster on AWS.

Terraform state lives in the `kubeinfra-tfstate-452630323308` S3 bucket.

- Masters are configured (We are using the stacked configuration for control plane)
- Workers are deployed but not configured.
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes running the following command on each as root:

  kubeadm join control-plane.kube.internal:6443 --token 1a96uo.crebd39416pz36ur \
	--discovery-token-ca-cert-hash sha256:2e367f91608bc797dba718d7def553689e5947274ca284b7da110e02897f2d7a \
	--control-plane --certificate-key b2b054ed9637790bac9f4e8a207dd6d1946801d5ecfe003c0663467620111c6d

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join control-plane.kube.internal:6443 --token 1a96uo.crebd39416pz36ur \
	--discovery-token-ca-cert-hash sha256:2e367f91608bc797dba718d7def553689e5947274ca284b7da110e02897f2d7a

```