CloudFormation do

  tags = external_parameters.fetch(:tags, {})
  ssm_param_tags = []
  ssm_param_tags.push({ Key: 'Environment', Value: Ref(:EnvironmentName) })
  ssm_param_tags.push({ Key: 'EnvironmentType', Value: Ref(:EnvironmentType) })
  ssm_param_tags.push(*tags.map {|k,v| {Key: FnSub(k), Value: FnSub(v)}})

  ssm_parameters =  external_parameters.fetch(:ssm_parameters, {})

  ssm_parameters.each do |name, ssm_param|
    SSM_Parameter("#{name.gsub('-','').gsub('_','')}Parameter") do
      Type 'String'
      Name FnSub(ssm_param['name'])
      Value FnSub(ssm_param['value'])
      Description  FnSub(ssm_param['description']) if ssm_param.has_key?('description')
      AllowedPattern  ssm_param['allowed_pattern'] if ssm_param.has_key?('allowed_pattern')
      Tags ssm_param_tags
    end
  end

end