module Vito

  # This is a parent class for recipes and shouldn't be used directly.
  class Recipe
    def initialize(options, connection)
      @options = options
      @connection = connection
    end

    def method_missing(name, args)
      raise "#{self.class.name} recipe needs to define a ##{name} method"
    end

    def with(args)

    end

    def install
      raise "#{self.class.name} recipe needs to define a #install method"
    end

    def remove
      raise "#{self.class.name} recipe needs to define a #remove method"
    end

    def update
      raise "#{self.class.name} recipe needs to define a #update method"
    end

    def depends_on_recipe(recipe, options = {})
      Dsl::Installation.new(recipe, options, @connection).install
    end

    def run_command(command)
      @connection.run(command)
    end

    def query(command)
      @connection.query(command)
    end

    # Helper methods
    #
    # should be extracted later
    def program_version(version_command)
      Vito::Utils::ProgramVersion.new(version_command, @connection)
    end

    def os
      @os ||= Vito::OperatingSystem.new(@connection).os
    end

    def install_os_dependencies(os_dependencies = nil)
      os.update_packages
      os.install_dependencies(os_dependencies) if os_dependencies
    end
  end
end
