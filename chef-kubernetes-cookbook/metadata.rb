name 'kubernetes-cookbook'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures kubernetes-cookbook'
long_description 'Installs/Configures kubernetes-cookbook'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/ncerny/kubernetes-cookbook/issues'
source_url 'https://github.com/ncerny/kubernetes-cookbook'

depends 'habitat'
depends 'openssl'
