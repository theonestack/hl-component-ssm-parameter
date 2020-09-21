require 'yaml'
require 'spec_helper'

describe 'compiled component' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/default.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/default/ssm-parameter.compiled.yaml") }

  context 'Test SSM Parameter' do
    let(:properties) { template["Resources"]["testParameter"]["Properties"] }

    it 'has property Name' do
      expect(properties["Name"]).to eq({"Fn::Sub" => "/my/ssm/param"})
    end

    it 'has property Value' do
      expect(properties["Value"]).to eq({"Fn::Sub" => "xyz"})
    end
  end

  context 'Test SSM Parameter with Description' do
    let(:properties) { template["Resources"]["testwithdescParameter"]["Properties"] }

    it 'has property Name' do
      expect(properties["Name"]).to eq({"Fn::Sub" => "/my/ssm/param1"})
    end

    it 'has property Value' do
      expect(properties["Value"]).to eq({"Fn::Sub" => "xyz"})
    end

    it 'has property Description' do
      expect(properties["Description"]).to eq({"Fn::Sub" => "my cool ssm param"})
    end
  end

  context 'Test SSM Parameter with Allowed Pattern' do
    let(:properties) { template["Resources"]["testwithpatternParameter"]["Properties"] }

    it 'has property Name' do
      expect(properties["Name"]).to eq({"Fn::Sub" => "/my/ssm/param2"})
    end

    it 'has property Value' do
      expect(properties["Value"]).to eq({"Fn::Sub" => "xyz"})
    end

    it 'has property AllowedPattern' do
      expect(properties["AllowedPattern"]).to eq("^[a-zA-Z]{1,10}$")
    end
  end
end
