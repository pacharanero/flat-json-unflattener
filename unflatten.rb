require 'json'
require 'byebug'
require 'awesome_print'

def unflatten(input_flat_json)
  output_hash = {}
  input_hash = JSON.parse(input_flat_json)
  # each line of the hash is passed as 'path' and corresponding 'value'
  input_hash.each do |path, value|
    path = path.gsub("|", "/|") # regularises object finding with pipes
    process(path, value, output_hash)
  end
  ap output_hash
end

  def process(path, value, output_hash)
    # split path by / into each object
    ref = output_hash
    objects = path.split('/')
    objects.each_with_index do |object, index|
      # byebug
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
          ref[object_name][array_index.to_i] = {}
        end
        ref = ref[object_name][array_index.to_i]
      end
    end
    #byebug
    return ref
  end # def process

def set_test
  flat_json = '{
    "ctx/composer_name": "Dr Jonty Shannon",
    "ctx/health_care_facility|id": "999999-345",
    "ctx/health_care_facility|name": "Home",
    "ctx/id_namespace": "NHS-UK",
    "ctx/id_scheme": "2.16.840.1.113883.2.1.4.3",
    "ctx/language": "en",
    "ctx/territory": "GB",
    "ctx/time": "2016-12-20T00:11:02.518+02:00",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/_uid": "{{$guid}}",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/causative_agent|code": "304270095",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/causative_agent|value": "Erythromycin",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/causative_agent|terminology": "SNOMED-CT",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/category|code": "at0122",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/manifestation:0|code": "422400008",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/manifestation:0|value": "Vomiting",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/manifestation:0|terminology": "SNOMED-CT",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/manifestation:1|value": "Itching",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/comment": "Reported by patient\'s carer",
    "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/last_updated": "2017-12-20T00:11:02.518+02:00"
  }'
end
