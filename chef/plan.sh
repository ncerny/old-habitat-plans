pkg_name=chef
pkg_origin=ncerny
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_description="Chef Software Inc Infrastructure Automation"
pkg_version="13.7.16"
pkg_source="https://github.com/chef/${pkg_name}/archive/v${pkg_version}.tar.gz"
pkg_shasum="92bc8470909cdcbeff4759d7c7a338c786d62efbf76bd20900ba9b439aff7ef4"
$pkg_dirname="chef-${pkg_version}"
pkg_license=('Apache-2.0')
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_build_deps=(core/make core/gcc core/coreutils core/git)
pkg_deps=(core/glibc core/ruby24 core/libxml2 core/libxslt core/libiconv core/xz core/zlib core/openssl core/cacerts core/libffi core/tar core/jq-static)
pkg_svc_user=root
pkg_svc_group=root

do_prepare() {
  export OPENSSL_LIB_DIR=$(pkg_path_for "core/openssl")/lib
  export OPENSSL_INCLUDE_DIR=$(pkg_path_for "core/openssl")/include
  export SSL_CERT_FILE=$(pkg_path_for "core/cacerts")/ssl/cert.pem

  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s $(pkg_path_for coreutils)/bin/env /usr/bin/env

  return 0
}

do_build() {
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"

  # local _bundler_dir=$(pkg_path_for bundler)
  local _bundler_dir=$(pkg_path_for "core/ruby24")
  local _libxml2_dir=$(pkg_path_for "core/libxml2")
  local _libxslt_dir=$(pkg_path_for "core/libxslt")
  local _zlib_dir=$(pkg_path_for "core/zlib")

  export GEM_HOME=${pkg_prefix}/lib/ruby/2.4.0
  export GEM_PATH=${_bundler_dir}/lib/ruby/2.4.0:${GEM_HOME}

  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  bundle config --local build.nokogiri '${NOKOGIRI_CONFIG}'

  bundle config --local silence_root_warning 1

  # We need to add tzinfo-data to the Gemfile since we're not in an
  # environment that has this from the OS
  if [[ -z "`grep 'gem .*tzinfo-data.*' Gemfile`" ]]; then
    echo 'gem "tzinfo-data"' >> Gemfile
  fi

  gem install bundler
  bundle update
  bundle install --no-deployment --jobs 2 --retry 5 --path $pkg_prefix/lib

  bundle exec 'cd ./chef-config && rake package'
  bundle exec 'rake package'
  mkdir -p gems-suck/gems
  cp pkg/chef-$pkg_version.gem gems-suck/gems
  cp chef-config/pkg/chef-config-$pkg_version.gem gems-suck/gems
  bundle exec gem generate_index -d gems-suck

  sed -e "s#gem \"chef\".*#gem \"chef\", source: \"file://$HAB_CACHE_SRC_PATH/$pkg_dirname/gems-suck\"#" -i Gemfile
  sed -e "s#gem \"chef-config\".*#gem \"chef-config\", source: \"file://$HAB_CACHE_SRC_PATH/$pkg_dirname/gems-suck\"#" -i Gemfile
  #bundle config --local local.chef $HAB_CACHE_SRC_PATH/$pkg_dirname/gems-suck
  #bundle config --local local.chef-config $HAB_CACHE_SRC_PATH/$pkg_dirname/gems-suck

  bundle install --no-deployment --jobs 2 --retry 5 --path $pkg_prefix/lib

}

do_install() {

  mkdir -p $pkg_prefix/bin

  bundle exec appbundler $HAB_CACHE_SRC_PATH/$pkg_dirname $pkg_prefix/bin chef
  bundle exec appbundler $HAB_CACHE_SRC_PATH/$pkg_dirname $pkg_prefix/bin ohai

  for binstub in ${pkg_prefix}/bin/*; do
    build_line "Setting shebang for ${binstub} to 'ruby'"
    [[ -f $binstub ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for ruby)/bin/ruby#" -i $binstub
  done

  cp -r $PLAN_CONTEXT/cookbooks ${pkg_prefix}/lib
  echo "default['pkg_prefix'] = '${pkg_prefix}'" > ${pkg_prefix}/lib/cookbooks/smoke_test/attributes/default.rb
}

# Stubs
do_strip() {
  return 0
}

do_end() {
  if [[ `readlink /usr/bin/env` = "$(pkg_path_for coreutils)/bin/env" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/env'"
    rm /usr/bin/env
  fi
}
