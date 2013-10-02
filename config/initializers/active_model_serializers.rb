ActiveSupport.on_load(:active_model_serializers) do
  ActiveModel::Serializer.root = false
  ActiveModel::ArraySerializer.root = false
end