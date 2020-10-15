# frozen_string_literal: true

control 'ad/member/linux/config/krb5' do
  title 'verify krb5.conf lines'

  # It's not really an ini file
  describe file('/etc/krb5.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }

    its('content') { should match(/^\[libdefaults\]$/) }
    its('content') { should match(/^\s+default_realm = "EXAMPLE\.NET"$/) }
    its('content') { should match(/^\s+dns_lookup_realm = true$/) }
    its('content') { should match(/^\s+dns_lookup_kdc = true$/) }
    its('content') { should match(/^\s+rdns = false$/) }

    its('content') { should match(/^\[realms\]$/) }
    its('content') { should match(/^ EXAMPLE.NET = {$/) }
    its('content') { should match(/^\s+kdc = dc1\.example\.net:88$/) }
    its('content') { should match(/^\s+admin_server = dc1\.example\.net:749$/) }
    its('content') { should match(/^\s+default_domain = example\.net$/) }

    its('content') { should match(/^\[domain_realm\]$/) }
    its('content') { should match(/^\s+\.example\.net = EXAMPLE.NET$/) }
    its('content') { should match(/^\s+example\.net = EXAMPLE.NET$/) }
  end
end
