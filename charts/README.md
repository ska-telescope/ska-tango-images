

[![Documentation Status](https://readthedocs.org/projects/ska-tango-imagesges/badge/?version=latest)](https://developer.skatelescope.org/projecska-tango-imagesimages/en/latest/?badge=latest)


SKA TANGO-controls docker images on Kubernetes
==============================================

The following are a set of instructions of running the SKA TANGO-controls docker images made by SKA on Kubernetes, and has been tested on minikube v1.12.3 with k8s v1.18.3 Docker 19.03.8 on Ubuntu 18.04.

Minikube
========

Using [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) enables us to create a single node stand alone Kubernetes cluster for testing purposes.  If you already have a cluster at your disposal, then you can skip forward to the section ['Running the SKA TANGO-controls docker images on Kubernetes'](https://developer.skatelescope.org/projects/ska-tango-images/en/latest/README.html#running-the-ska-tango-controls-docker-images-on-kubernetes).

The generic installation instructions are available at [https://kubernetes.io/docs/tasks/tools/install-minikube/](https://kubernetes.io/docs/tasks/tools/install-minikube/). A deployment of Minikube that will support the standard features required for the SKA is available at [https://gitlab.com/ska-telescope/sdi/deploy-minikube](https://gitlab.com/ska-telescope/sdi/deploy-minikube).

Once you have finished the deployment you may need to fixup your permissions:
```
sudo chown -R ${USER} /home/${USER}/.minikube
sudo chgrp -R ${USER} /home/${USER}/.minikube
sudo chown -R ${USER} /home/${USER}/.kube
sudo chgrp -R ${USER} /home/${USER}/.kube
```

Once completed, minikube will also update your kubectl settings to include the context `current-context: minikube` in `~/.kube/config`.  Test that connectivity works with something like:
```
$ kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-86c58d9df4-5ztg8           1/1     Running   0          3m24s
...
```

Helm Chart
----------

The Helm Chart based install of the SKA TANGO-controls docker images relies on [Helm](https://docs.helm.sh/using_helm/#installing-helm) (surprise!).  If your system does not have a running version of Helm the easiest way to install one is using the install script:
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

Cleaning Up
-----------

Note on cleaning up:
```
minikube stop # stop minikube - this can be restarted with minikube start
minikube delete # destroy minikube - totally gone!
rm -rf ~/.kube # local minikube configuration cache
# remove all other minikube related installation files
sudo rm -rf /var/lib/kubeadm.yaml /data/minikube /var/lib/minikube /var/lib/kubelet /etc/kubernetes
```

Running the SKA TANGO-controls docker images on Kubernetes
----------------------------------------------------------
The basic configuration for each component of the SKA TANGO-controls docker images is held in the `values.yaml` files.

We launch the SKA TANGO-controls docker images with:
```
$ make install-chart
```

To clean up the Helm Chart release:
```
$make uninstall-chart
```