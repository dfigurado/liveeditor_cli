require 'live_editor/cli/validators/validator'

module LiveEditor
  module CLI
    module Validators
      class ThemeValidator < Validator
        # Returns an array of errors if any were found with `/theme.json`.
        def valid?
          # Grab location of `/theme.json`.
          theme_config_loc = LiveEditor::CLI::theme_root_dir + '/theme.json'

          # Validate existence of `theme.json`.
          if File.exist?(theme_config_loc)
            theme_config = LiveEditor::CLI::theme_config

            # Validate format of theme.json.
            unless theme_config.parsed?
              self.messages << {
                type: :error,
                message: 'The file at `/theme.json` does not contain valid JSON markup.'
              }

              return false
            end

            config = theme_config.config

            # Validate presence of `title` attribute.
            if config['title'].blank?
              self.messages << {
                type: :error,
                message: 'The file at `/theme.json` must contain a `title` attribute.'
              }
            end
          # No `theme.json`.
          else
            self.messages << {
              type: :error,
              message: '`/theme.json` does not exist.'
            }
          end

          self.errors.size == 0
        end
      end
    end
  end
end
