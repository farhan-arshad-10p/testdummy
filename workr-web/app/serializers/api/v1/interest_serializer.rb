module Api
  module V1
    class InterestSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
