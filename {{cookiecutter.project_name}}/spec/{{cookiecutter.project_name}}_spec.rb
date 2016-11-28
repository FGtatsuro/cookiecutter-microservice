require "spec_helper_#{ENV['SPEC_TARGET_BACKEND']}"

describe command('which python') do
  its(:exit_status) { should eq 0 }
end
