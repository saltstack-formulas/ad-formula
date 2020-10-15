# frozen_string_literal: true

conflicts = %w[
  libnss-ldap
  libnss-ldapd
  libpam-ldap
  libpam-ldapd
  nscd
  nslcd
  nslcd-utils
]

dependencies = %w[
  adcli
  heimdal-clients
  libnss-sss
  libpam-sss
  realmd
  sssd
  sssd-tools
]

control 'ad/member/linux/package/conflicts/removed' do
  title 'conflicting packages should be removed'

  conflicts.each do |name|
    describe package(name) do
      it { should_not be_installed }
    end
  end
end

control 'ad/member/linux/package/installed' do
  title 'required packages should be installed'

  dependencies.each do |name|
    describe package(name) do
      it { should be_installed }
    end
  end
end
