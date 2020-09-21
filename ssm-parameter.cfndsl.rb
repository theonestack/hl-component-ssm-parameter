CloudFormation do

  tags = external_parameters.fetch(:tags, {})
  tags.merge!({ Environment: Ref(:EnvironmentName) })
  tags.merge!({ EnvironmentType: Ref(:EnvironmentType) })

  ssm_parameters =  external_parameters.fetch(:ssm_parameters, {})

  ssm_parameters.each do |name, ssm_param|
    SSM_Parameter("#{name.gsub('-','').gsub('_','')}Parameter") do
      Type 'String'
      Name FnSub(ssm_param['name'])
      Value FnSub(ssm_param['value'])
      Description  FnSub(ssm_param['description']) if ssm_param.has_key?('description')
      AllowedPattern  ssm_param['allowed_pattern'] if ssm_param.has_key?('allowed_pattern')
      Tags tags
    end
  end

end