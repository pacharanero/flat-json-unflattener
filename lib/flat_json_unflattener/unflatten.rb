module Unflatten

require 'json'

  def unflattener(input_flat_json)
    output_hash = {}
    input_hash = JSON.parse(input_flat_json)
    # each line of the hash is passed as 'path' and corresponding 'value'
    input_hash.each do |path, value|
      path = path.gsub("|", "/|") # regularises object finding with pipes
      process(path, value, output_hash)
    end
    return output_hash.to_json
  end

  def process(path, value, output_hash)
    # split path by / into each object
    ref = output_hash
    objects = path.split('/')
    objects.each_with_index do |object, index|
      # split by : to find the arrays
      arrays = object.split(':');
      object_name = arrays[0]
      array_index = arrays[1]
      if array_index == nil # if it's a part of the object tree, not a leaf node
        if ref[object_name] == nil # if it doesn't already exist in the tree we're building
          if index == objects.count-1 # if it's the last object
            ref[object_name] = value # then set the key and value
          else
            ref[object_name] = {} # else set it to an empty object (as a placeholder)
          end
        end
        ref = ref[object_name]
      else # handle arrays
        if ref[object_name] == nil
          ref[object_name] = []
          if index == objects.count-1
            ref[object_name][array_index.to_i] = value
          else
            ref[object_name][array_index.to_i] = {}
          end
        end
        if ref[object_name][array_index.to_i] == nil #if it's not already set
          if index == objects.count-1 # if it's the last object
            ref[object_name][array_index.to_i] = value # then set the key and value
          else
            ref[object_name][array_index.to_i] = {} # else set it to an empty object (as a placeholder)
          end
        end
        ref = ref[object_name][array_index.to_i]
      end
    end
    return ref
  end

end
