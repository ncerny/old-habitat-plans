pkg_name=chef
pkg_origin=ncerny
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_description="Chef Software Inc Infrastructure Automation"
pkg_version="13.8.5" # use "" to build from master
pkg_shasum="7e2f858356469275e4e42a3a43c53c657b53c6a6c88d09a900d9a9f72e12b755"

# TODO: Add support for :stable and :current channels
# See if we're building from a checked out git repo
if [[ -f "../chef.gemspec" ]]; then
  pkg_source=""
  pkg_dirname="$PLAN_CONTEXT/.."
elif [[ -z "$pkg_version" ]]; then
  pkg_source="https://github.com/chef/chef.git"
  pkg_dirname="chef"
else
  pkg_source="https://github.com/chef/${pkg_name}/archive/v${pkg_version}.tar.gz"
  pkg_dirname="chef-${pkg_version}"
fi

ruby_origin=$pkg_origin
ruby_version=""
if [[ -f "../omnibus_overrides.rb" ]]; then
  if [[ -z "$ruby_version" ]]; then ruby_version=$(grep ':ruby' ../omnibus_overrides.rb | cut -d'"' -f2); fi
  if [[ -z "$ruby_version" ]]; then ruby_version=$(grep '"ruby"' ../omnibus_overrides.rb | cut -d'"' -f4); fi
fi
if [[ -z "$ruby_version" ]]; then
  ruby="ruby"
else
  ruby="ruby/$ruby_version"
fi
pkg_license=('Apache-2.0')
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_build_deps=(core/make core/gcc core/coreutils core/git)
pkg_deps=(core/glibc $ruby_origin/$ruby core/libxml2 core/libxslt core/libiconv core/xz core/zlib core/openssl core/cacerts core/libffi core/tar core/jq-static)
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

# do_download() {
#   if [[ -z "$pkg_source"]]
# }
#
# do_verify() {
#   return 0
# }
#
# do_unpack() {
#   cd $HAB_CACHE_SRC_PATH
#   git clone --branch v${pkg_version} https://github.com/berkshelf/${pkg_name}.git ${pkg_dirname}
# }

do_build() {
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"

  local _libxml2_dir=$(pkg_path_for "core/libxml2")
  local _libxslt_dir=$(pkg_path_for "core/libxslt")
  local _zlib_dir=$(pkg_path_for "core/zlib")

  export RUBY_GEM_PATH=$(dirname $(grep rubygems.rb $(pkg_path_for "$ruby_origin/$ruby")/FILES | awk '{print $2}'))
  build_line "RUBY_GEM_PATH = ${RUBY_GEM_PATH}"
  export GEM_HOME=${pkg_prefix}/lib/ruby
  export GEM_PATH=${RUBY_GEM_PATH}:${GEM_HOME}

  $(pkg_path_for "$ruby_origin/$ruby")/bin/gem install bundler

  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  ${RUBY_GEM_PATH}/bin/bundle config --local build.nokogiri '${NOKOGIRI_CONFIG}'
  ${RUBY_GEM_PATH}/bin/bundle config --local silence_root_warning 1

  # We need to add tzinfo-data to the Gemfile since we're not in an
  # environment that has this from the OS
  if [[ -z "`grep 'gem .*tzinfo-data.*' Gemfile`" ]]; then
    echo 'gem "tzinfo-data"' >> Gemfile
  fi

  ${RUBY_GEM_PATH}/bin/bundle update
  ${RUBY_GEM_PATH}/bin/bundle install --no-deployment --jobs 2 --retry 5 --path $pkg_prefix/lib

  ${RUBY_GEM_PATH}/bin/bundle exec 'cd ./chef-config && rake package'
  ${RUBY_GEM_PATH}/bin/bundle exec 'rake package'
  mkdir -p chef-gems/gems
  cp pkg/chef-$pkg_version.gem chef-gems/gems
  cp chef-config/pkg/chef-config-$pkg_version.gem chef-gems/gems
  ${RUBY_GEM_PATH}/bin/bundle exec gem generate_index -d chef-gems

  sed -e "s#gem \"chef\".*#gem \"chef\", source: \"file://$HAB_CACHE_SRC_PATH/$pkg_dirname/chef-gems\"#" -i Gemfile
  sed -e "s#gem \"chef-config\".*#gem \"chef-config\", source: \"file://$HAB_CACHE_SRC_PATH/$pkg_dirname/chef-gems\"#" -i Gemfile

  ${RUBY_GEM_PATH}/bin/bundle install --no-deployment --jobs 2 --retry 5 --path $pkg_prefix/lib

}

do_install() {

  mkdir -p $pkg_prefix/bin

  ${RUBY_GEM_PATH}/bin/bundle exec appbundler $HAB_CACHE_SRC_PATH/$pkg_dirname $pkg_prefix/bin chef
  ${RUBY_GEM_PATH}/bin/bundle exec appbundler $HAB_CACHE_SRC_PATH/$pkg_dirname $pkg_prefix/bin ohai

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
