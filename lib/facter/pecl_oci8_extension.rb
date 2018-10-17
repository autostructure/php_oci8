if File.File? '/bin/pecl'

  pecl_output = Facter::Core::Execution.exec('/bin/pecl info oci8 | grep "^Release Version" | cut -d " " -f 9')
  pecl_output_array = pecl_output.split('.')

  pecl_oci8_extension = {}

  if pecl_output_array.length > 1
    pecl_oci8_extension['version'] = {
      'major' => df_output_array[1].to_i,
      'minor' => df_output_array[2].to_i,
      'patch' => df_output_array[3].to_i,
      'full' => "#{df_output_array[1].to_s}.#{df_output_array[2].to_s}.#{df_output_array[3].to_s}",
    }
  end

  Facter.add('pecl_oci8_extension') do
    confine kernel: :linux
    setcode do
      pecl_oci8_extension
    end
  end
end
