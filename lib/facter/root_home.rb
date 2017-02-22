# A facter fact to determine the root home directory.
# This varies on PE supported platforms and may be
# reconfigured by the end user.

module Facter::Util::RootHome
  class << self
  def get_root_home
    root_ent = Facter::Util::Resolution.exec(_("getent passwd root"))
    # The home directory is the sixth element in the passwd entry
    # If the platform doesn't have getent, root_ent will be nil and we should
    # return it straight away.
    root_ent && root_ent.split(":")[5]
  end
  end
end

Facter.add(:root_home) do
  setcode { Facter::Util::RootHome.get_root_home }
end

Facter.add(:root_home) do
  confine :kernel => :darwin
  setcode do
    str = Facter::Util::Resolution.exec(_("dscacheutil -q user -a name root"))
    hash = {}
    str.split("\n").each do |pair|
      key,value = pair.split(/:/)
      hash[key] = value
    end
    hash['dir'].strip
  end
end

Facter.add(:root_home) do
  confine :kernel => :aix
  root_home = nil
  setcode do
    str = Facter::Util::Resolution.exec(_("lsuser -c -a home root"))
    str && str.split("\n").each do |line|
      next if line =~ /^#/
      root_home = line.split(/:/)[1]
    end
    root_home
  end
end
