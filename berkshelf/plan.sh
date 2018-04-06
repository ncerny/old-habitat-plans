pkg_name=berkshelf
pkg_origin=ncerny
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_description="Manage a Cookbook or an Application's Cookbook dependencies"
pkg_version="6.3.1"
pkg_source="https://github.com/berkshelf/berkshelf.git"
# pkg_shasum="3340c18bfc3409eba2c40955aa93f5b372a57a6554f19d7c5249658387349b5e"
pkg_dirname="${pkg_name}-${pkg_version}"
pkg_license=('Apache-2.0')
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_deps=(core/glibc core/ruby24 core/libxml2 core/libxslt core/zlib core/gecode) #  core/libiconv core/xz  core/openssl core/cacerts core/libffi core/tar
pkg_build_deps=(core/make core/gcc core/git core/graphviz) # core/coreutils
pkg_svc_user=root
pkg_svc_group=root

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  cd $HAB_CACHE_SRC_PATH
  git clone --branch v${pkg_version} https://github.com/berkshelf/${pkg_name}.git ${pkg_dirname}
}

do_build() {
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"
  local _bundler_dir=$(pkg_path_for "core/ruby24")/lib/ruby/gems/2.4.0
  local _libxml2_dir=$(pkg_path_for "core/libxml2")
  local _libxslt_dir=$(pkg_path_for "core/libxslt")
  local _zlib_dir=$(pkg_path_for "core/zlib")
  local _gecode_dir=$(pkg_path_for core/gecode)

  export GEM_HOME=${pkg_prefix}/lib/ruby/2.4.0
  export GEM_PATH=${_bundler_dir}:${GEM_HOME}

  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  bundle config --local build.nokogiri '${NOKOGIRI_CONFIG}'
  bundle config --local silence_root_warning 1

  # We need to add tzinfo-data to the Gemfile since we're not in an
  # environment that has this from the OS
  if [[ -z "`grep 'gem .*tzinfo-data.*' Gemfile`" ]]; then
    echo 'gem "tzinfo-data"' >> Gemfile
  fi

  export USE_SYSTEM_GECODE=1
  gem install bundler
  gem install rake
  gem install dep_selector --install-dir $pkg_prefix/lib/ruby/2.4.0 -- --with-opt-dir=${_gecode_dir}
  bundle update
  bundle install --no-deployment --jobs 2 --retry 5 --path $pkg_prefix/lib --without development,build,changelog
  bundle exec rake build
  bundle exec gem install pkg/${pkg_name}-${pkg_version}.gem --install-dir $pkg_prefix/lib/ruby/2.4.0
}

do_install() {
  mkdir -p $pkg_prefix/bin
  install -v -D "$HAB_CACHE_SRC_PATH/$pkg_dirname/bin/berks" "$pkg_prefix/bin/berks"

  for binstub in ${pkg_prefix}/bin/*; do
    build_line "Setting shebang for ${binstub} to 'ruby'"
    [[ -f $binstub ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for core/ruby24)/bin/ruby#" -i $binstub
  done
}

# Stubs
do_strip() {
  return 0
}
