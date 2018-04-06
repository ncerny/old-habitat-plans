pkg_name=btrfs-progs
pkg_origin=ncerny
pkg_version="4.15.1"
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("GPLv2")
pkg_source="https://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git/snapshot/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="9cb985b3466e2e0ca712ef8570d7eb2f94b56592221baf0fc76622f413852445"
pkg_deps=(core/glibc core/util-linux core/lzo core/zlib core/zstd core/attr)
pkg_build_deps=(core/make core/gcc core/autoconf core/automake core/pkg-config)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
pkg_description="Btrfs is a modern copy on write (CoW) filesystem for Linux aimed at implementing advanced features while also focusing on fault tolerance, repair and easy administration."
pkg_upstream_url="https://btrfs.wiki.kernel.org/index.php/Main_Page"

do_build() {
  export AL_OPTS="-I $(pkg_path_for core/pkg-config)/share/aclocal \
    -I$(pkg_path_for core/automake)/share/aclocal-1.15"
  ./autogen.sh
  ./configure --disable-documentation --disable-convert --prefix=$pkg_prefix
  make
}
