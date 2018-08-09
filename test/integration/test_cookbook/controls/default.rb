# # encoding: utf-8

# Inspec test for recipe test-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'test_cookbook-baseline' do
  title 'Baseline for test_cookbook'
  impact 0.1

  unless os.windows?
    describe user('root') do
      it { should exist }
      # skip 'This is an example test, replace with your own test.'
    end
  end

  filename = if os.windows?
               'C:\\cheftest.txt'
             else
               '/tmp/cheftest.txt'
             end

  describe file(filename) do
    it { should exist }
    its('content') { should include('Hello world!') }
  end
end
