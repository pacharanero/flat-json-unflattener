# Flat JSON Unflattener
This is a simple Ruby Gem which Unflattens the Flat JSON data format from the EtherCIS openEHR Clinical Data Repository. It's based on [this Unflattener written in JavaScript for the same purpose](https://github.com/robtweed/qewd-hit-platform/blob/master/openehr-ms/utils/unflatten.js) by [Rob Tweed](https://github.com/robtweed) an independent healthcare developer and key member of the Ripple Foundation. We have more-or-less transliterated the code into Ruby, with a few Rubyisms where felt suitable.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'flat_json_unflattener'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flat_json_unflattener

## Usage
It's all a bit functional at the moment, it could do with refactoring into a more OO pattern.
Also I can see there being a partner `flatten` tool not far behind, so the whole thing will get renamed to something more appropriate

You can use the Ruby code in your own programs with
`require 'flat_json_unflattener'`

and

`include Unflatten`

then

`unflattener(<my-Flat-JSON-string>)`

The `unflatten` method expects a JSON string as its single argument. A typical Flat JSON string would look like this:

```ruby
'{
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
  "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/reaction_details/comment": "Reported by patient\'s carer",
  "adverse_reaction_list/allergies_and_adverse_reactions/adverse_reaction_risk:0/last_updated": "2017-12-20T00:11:02.518+02:00"
}'
```

When you run it through `unflatten` you should get something looking more structured, like this

```js
{
                      "ctx" => {
               "composer_name" => "Dr Jonty Shannon",
        "health_care_facility" => {
              "|id" => "999999-345",
            "|name" => "Home"
        },
                "id_namespace" => "NHS-UK",
                   "id_scheme" => "2.16.840.1.113883.2.1.4.3",
                    "language" => "en",
                   "territory" => "GB",
                        "time" => "2016-12-20T00:11:02.518+02:00"
    },
    "adverse_reaction_list" => {
        "allergies_and_adverse_reactions" => {
            "adverse_reaction_risk" => [
                [0] {
                                "_uid" => "{{$guid}}",
                     "causative_agent" => {
                               "|code" => "304270095",
                              "|value" => "Erythromycin",
                        "|terminology" => "SNOMED-CT"
                    },
                            "category" => {
                        "|code" => "at0122"
                    },
                    "reaction_details" => {
                        "manifestation" => [
                            [0] {
                                       "|code" => "422400008",
                                      "|value" => "Vomiting",
                                "|terminology" => "SNOMED-CT"
                            },
                            [1] {
                                "|value" => "Itching"
                            }
                        ],
                              "comment" => "Reported by patient's carer"
                    },
                        "last_updated" => "2017-12-20T00:11:02.518+02:00"
                }
            ]
        }
    }
}
```

## Command Line Usage
I've added a Thor-based command line tool which is useful for testing stuff out
If you have the gem installed then you should be able to call
`unflatten unflatten 'spec/flat_json_unflattener/fixtures/test_flat_json.json'`

But if that doesnt' work then you can clone this repo and call it with
`chmod +x bin/unflatten`
`bin/unflatten unflatten 'spec/flat_json_unflattener/fixtures/test_flat_json.json'`

The command line tool is a work in progress

## Tests
Yay, there are a test!

`bundle exec rspec spec` will run the test which compares output against a known-correct pair of Flat JSON and Unflattened Flat JSON

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/pacharanero/flat_json_unflattener.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
