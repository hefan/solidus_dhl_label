# frozen_string_literal: true

module SolidusDhlLabel
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def self.exit_on_failure?
        true
      end

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_dhl_label.rb'
      end

    end
  end
end
