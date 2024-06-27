# frozen_string_literal: true

module SolidusPicker
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :auto_run_migrations, type: :boolean, default: false

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_picker.rb'
      end

      def add_migrations
        run 'bin/rails railties:install:migrations FROM=solidus_picker'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bin/rails db:migrate'
        else
          puts 'Skipping bin/rails db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end
    end
  end
end
