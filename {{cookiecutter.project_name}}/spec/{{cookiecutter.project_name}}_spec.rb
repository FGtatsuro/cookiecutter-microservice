require "spec_helper_#{ENV['TARGET_BACKEND']}"

describe file('/opt/{{ cookiecutter.project_name }}/services.sh') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end
