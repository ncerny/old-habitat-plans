pkg_name=kube-master
pkg_origin=ncerny
pkg_version="0.1.0"
pkg_type="composite"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")

pkg_services=(
  ncerny/cfssl
  ncerny/containerd
  ncerny/kube-etcd
  ncerny/kube-apiserver
  ncerny/kube-controller-manager
  ncerny/kube-scheduler
  ncerny/kubelet
)

pkg_bind_map=(
  [ncerny/kube-apiserver]="kvstore:ncerny/kube-etcd"
  [ncerny/kubelet]="apiserver:ncerny/kube-apiserver"
)
