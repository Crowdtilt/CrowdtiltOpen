module ActiveRecordExtension

  extend ActiveSupport::Concern

  module ClassMethods
  end

  def to_object(*args)
    temp_hash = {}

    args.each do |arg|
      if self.has_attribute? arg
        temp_hash[arg] = self.send arg
      end
    end

    return OpenStruct.new temp_hash
  end
end

# include the extension 
ActiveRecord::Base.send(:include, ActiveRecordExtension)
