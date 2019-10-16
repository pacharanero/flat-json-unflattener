require 'thor'
require_relative './unflatten'

module Unflatten
  class CLI < Thor
    include Unflatten
    desc "unflatten", "Unflattens Flat JSON into structured JSON"
    method_option :file, aliases: "-f"
    def unflatten(filename)
      puts unflattener(File.read(filename))
    end

    desc "flatten", "Flattens Structured JSON into Flat JSON"
    def flatten(filename)
    end
  end
end
