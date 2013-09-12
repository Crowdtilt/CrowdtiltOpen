class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    record.errors[attribute] << 'is not a valid domain' unless PublicSuffix.valid?(value)
  end
end
