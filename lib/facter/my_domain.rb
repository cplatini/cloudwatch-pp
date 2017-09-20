Facter.add('my_domain') do
  setcode do
    Facter::Util::Resolution.exec("facter domain")
  end
end
