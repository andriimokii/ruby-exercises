# frozen_string_literal: true

require 'json'

module BasicSerializable
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.each do |key, value|
      instance_variable_set(key, value)
    end
  end
end
