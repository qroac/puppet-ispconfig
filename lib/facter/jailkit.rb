Facter.add(:isp3node) do
  has_weight 100
  setcode do
    {
      jailkit: jailkit
    }
  end
end

def jailkit()
  jk = {
    :installed => jailkit_installed?
  }
  if(jk[:installed])
    jk[:version] = jailkit_version
  end
  jk
end

def jailkit_installed?()
  Facter::Core::Execution.execute('dpkg -s jailkit > /dev/null && echo true', {:on_fail => 'false'}) == 'true'
end

def jailkit_version()
  Facter::Core::Execution.execute('dpkg -s jailkit | grep --line-buffered Version | awk \'{print $2}\'', {:on_fail => ''})
end
