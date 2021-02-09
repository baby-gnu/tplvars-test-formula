# frozen_string_literal: true

control "tplvars-test.deep.autonomous.sub.component.from-deep-autonomous-sub-component-for-tplroot" do
  title 'Check value of tplvars for imported jinja file from a deep autonomous subcomponent with import from tplroot'

  describe file('/tmp/from-deep-autonomous-sub-component-for-tplroot-without-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/map.jinja" }
    its('content') { should include "tpldir: tplvars-test" }
  end

  describe file('/tmp/from-deep-autonomous-sub-component-for-tplroot-with-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/deep/autonomous/sub/component/from-deep-autonomous-sub-component-for-tplroot.sls" }
    its('content') { should include "tpldir: tplvars-test/deep/autonomous/sub/component" }
  end
end
