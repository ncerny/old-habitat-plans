%w(
  cups
  cups-pdf
  system-config-printer
  networkmanager-openvpn
  network-manager-applet
).each do |pkg|
  package pkg do
    action :update
  end
end

%w(
  xorg-server
  xorg-server-common
  xorg-xrandr
  xf86-video-intel
  mesa
  nvidia
  nvidia-utils
  i3-wm
  i3blocks
  i3lock
  i3status
  alsa-firmware
  alsa-utils
  pulseaudio
  pulseaudio-alsa
  lightdm
  lightdm-gtk-greeter
  accountsservice
  ttf-dejavu
).each do |pkg|
  package pkg do
    action :update
  end
end

cookbook_file '/home/ncerny/.config/i3/config' do
  source 'dot-i3-config'
  owner 'ncerny'
  group 'ncerny'
  mode '0644'
end

# Utilities
log 'Installing User Utilities'

%w(
  diffutils
  chromium
  firefox
  git
  rxvt-unicode
  rxvt-unicode-terminfo
  slack-desktop
  etcd-bin
  kubectl-bin
).each do |pkg|
  package pkg do
    action :update
  end
end

# Virtualization
%w(
  libvirt
  qemu
  virt-manager
  docker
).each do |pkg|
  package pkg do
    action :update
  end
end

service 'lightdm' do
  if chroot?
    action :enable
  else
    action [:enable, :start]
  end
end
