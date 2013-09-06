class SubdomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    reserved_names = %w(www ftp mail pop smtp admin ssl sftp)
    reserved_names = options[:reserved] if options[:reserved]
    if reserved_names.include?(value)
      record.errors[attribute] << 'cannot be a reserved name'
    end                                              
    
    record.errors[attribute] << 'must have between 3 and 63 letters' unless (3..63) === value.length
    record.errors[attribute] << 'cannot start or end with a hyphen' unless value =~ /^[^-].*[^-]$/i                                                                                                    
    record.errors[attribute] << 'must be alphanumeric; A-Z, 0-9 or hyphen' unless value =~ /^[a-z0-9\-]*$/i
  end
end
