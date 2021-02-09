# frozen_string_literal: true

control "tplvars-test.subcomponent.from-subcomponent" do
  title 'Check value of tplvars for imported jinja file from a subcomponent directory'

  describe file('/tmp/from-subcomponent-without-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/map.jinja" }
    its('content') { should include "tpldir: tplvars-test" }
  end

  describe file('/tmp/from-subcomponent-with-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/subcomponent/from-subcomponent.sls" }
    its('content') { should include "tpldir: tplvars-test/subcomponent" }
  end
end
