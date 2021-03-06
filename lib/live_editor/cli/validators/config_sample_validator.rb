require 'live_editor/cli/validators/validator'

module LiveEditor
  module CLI
    module Validators
      class ConfigSampleValidator < Validator
        # Returns an array of errors if any were found with `/config.sample.json`.
        def valid?
          # Grab location of /config.sample.json.
          config_sample_loc = LiveEditor::CLI::theme_root_dir + '/config.json.sample'

          # Validate existence of config.sample.json.
          if File.exist?(config_sample_loc)
            # Validate format of config.sample.json.
            begin
              sample_config = JSON.parse(File.read(config_sample_loc))
            rescue Exception => e
              self.messages << {
                type: :warning,
                message: 'The file at `/config.json.sample` does not contain valid JSON markup.'
              }

              return true
            end

            # Validate presence of `admin_domain` attribute.
            if sample_config['admin_domain'].present? && sample_config['admin_domain'] != '.liveeditorapp.com'
              self.messages << {
                type: :warning,
                message: "It is not recommended to store `admin_domain` in the `/config.sample.json` file."
              }
            end
          end

          self.errors.size == 0
        end
      end
    end
  end
end
