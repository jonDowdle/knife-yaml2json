require 'chef/knife'

module Yaml2json  
  class Yaml2json < Chef::Knife

    deps do
      require 'json'
      require 'yaml'
    end

    banner "knife yaml2json"

    def run

      if !File.exist?(".kitchen.yml")
        puts "No .kitchen.yml found in current directory"
        exit 1
      end

      ymlFile = File.open( ".kitchen.yml" )
       
      data = YAML::load(ymlFile)

      # We only care about the attributes in the suites
      suites = data['suites'] rescue []

      suites.each do |suite|
        
        attributes = suite['attributes'] rescue {}

        json = JSON.pretty_generate(attributes)
        
        puts "#{suite['name']}.json writen to ./.kitchen/attributes"

        f = File.new( "./.kitchen/attributes/#{suite['name']}.json", "w" ) 
        f.write( json );
        f.close

      end

    end
  end
end
