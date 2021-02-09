# frozen_string_literal: true

control "tplvars-test.from-tplroot" do
  title 'Check value of tplvars for imported jinja file from tplroot'

  describe file('/tmp/from-tplroot-without-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/map.jinja" }
    its('content') { should include "tpldir: tplvars-test" }
  end

  describe file('/tmp/from-tplroot-with-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/from-tplroot.sls" }
    its('content') { should include "tpldir: tplvars-test" }
  end
end
