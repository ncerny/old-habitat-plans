pkg_name=certmgr
pkg_origin=ncerny
pkg_version="1.6.0"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_scaffolding=core/scaffolding-go
pkg_source="https://github.com/cloudflare/certmgr"
pkg_license=("BSD 2-Clause")
pkg_bin_dirs=(bin)
pkg_svc_run="certmgr -f $pkg_svc_config_path/certmgr.yaml"

pkg_binds=(
  [ca]="port"
)
