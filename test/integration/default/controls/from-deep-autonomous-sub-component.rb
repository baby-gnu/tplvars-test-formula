# frozen_string_literal: true

control "tplvars-test.deep.autonomous.sub.component.from-deep-autonomous-sub-component" do
  title 'Check value of tplvars for imported jinja file from a deep autonomous subcomponent'

  describe file('/tmp/from-deep-autonomous-sub-component-without-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/deep/autonomous/sub/component/map.jinja" }
    its('content') { should include "tpldir: tplvars-test/deep/autonomous/sub/component" }
  end

  describe file('/tmp/from-deep-autonomous-sub-component-with-context.txt') do
    it { should be_file }
    its('content') { should include "tplfile: tplvars-test/deep/autonomous/sub/component/from-deep-autonomous-sub-component.sls" }
    its('content') { should include "tpldir: tplvars-test/deep/autonomous/sub/component" }
  end
end
