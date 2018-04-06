name 'infra-cookbook'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'Apache-2.0'
description 'Cookbook for installing and configuring my base infrastructure.'
long_description 'Cookbook for installing and configuring my base infrastructure.'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/ncerny/infra-cookbook/issues'
source_url 'https://github.com/ncerny/infra-cookbook'

depends 'habitat'
