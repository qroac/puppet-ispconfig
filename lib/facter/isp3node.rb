Facter.add(:isp3node) do
  has_weight 100
  setcode do
    {
      :bind      => bind,
      :dovecot   => dovecot,
      :fail2ban  => fail2ban,
      :jailkit   => jailkit,
      :mysql     => mysql,
      :nginx     => nginx,
      :postfix   => postfix,
      :pureftpd  => pureftpd,
      :roundcube => roundcube,
    }
  end
end

def bind()
  b = {
    :installed => package_installed?('bind9')
  }
  if(b[:installed])
    b[:version] = package_version('bind9'),
    b[:haveged] = package_version('haveged')
  end
  b
end

def dovecot()
  d = {
    :installed => package_installed?('dovecot-core')
  }
  if(d[:installed])
    d[:version] = package_version('dovecot-core')
    d[:rspamd] = package_version('rspamd')
  end
  d
end

def fail2ban()
  f2b = {
    :installed => package_installed?('fail2ban')
  }
  if(f2b[:installed])
    f2b[:version] = package_version('fail2ban')
  end
  f2b
end

def jailkit()
  jk = {
    :installed => package_installed?('jailkit')
  }
  if(jk[:installed])
    jk[:version] = package_version('jailkit')
  end
  jk
end

def mysql()
  ms = {
    :installed => !!Facter.value('mysqld_version')
  }
  if(ms[:installed])
    ms[:version] = package_version('mariadb-server')
  end
  ms
end

def nginx()
  nx = {
    :installed => !!Facter.value('nginx_version')
  }
  if(nx[:installed])
    nx[:version] = Facter.value('nginx_version')
  end
  nx
end

def postfix()
  pf = {
    :installed => package_installed?('postfix')
  }
  if(pf[:installed])
    pf[:version] = package_version('postfix')
    relay = Facter::Core::Execution.execute("postconf -h relayhost", :on_fail => '')
    if(relay == '')
      pf[:mode] = 'standalone'
    else
      pf[:mode] = 'satellite'
      pf[:relay] = relay
    end
    pf[:allowed_hosts] = Facter::Core::Execution.execute("postconf -h mynetworks", :on_fail => '').split(' ')
  end
  pf
end

def pureftpd()
  pf = {
    :installed => package_installed?('pure-ftpd-common')
  }
  if(pf[:installed])
    pf[:version] = package_version('pure-ftpd-common')
  end
  pf
end

def roundcube()
  rc = {
    :installed => package_installed?('roundcube')
  }
  if(rc[:installed])
    rc[:version] = package_version('roundcube')
  end
  rc
end

def package_installed?(package)
  Facter::Core::Execution.execute("dpkg -s #{package} > /dev/null && echo true", {:on_fail => 'false'}) == 'true'
end

def package_version(package)
  Facter::Core::Execution.execute("dpkg -s #{package} | grep --line-buffered Version | awk '{print $2}'", {:on_fail => ''})
end
