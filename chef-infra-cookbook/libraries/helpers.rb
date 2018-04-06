def chroot?
  uroot = Mixlib::ShellOut.new('stat -c %d:%i /').run_command.stdout
  sroot = Mixlib::ShellOut.new('stat -c %d:%i /proc/1/root/.').run_command.stdout
  !uroot.eql?(sroot)
end

def cpu_type
  if node['cpu']['0']
    node['cpu']['0']['vendor_id']
  else
    node['cpu']['vendor_id']
  end
end
