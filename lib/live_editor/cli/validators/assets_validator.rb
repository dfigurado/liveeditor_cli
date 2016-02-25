require 'live_editor/cli/validators/validator'

module LiveEditor
  module CLI
    module Validators
      class AssetsValidator < Validator
        # Constants.
        SOURCE_EXTENSIONS = %w(scss sass less coffee ts)

        # Returns whether or not any errors were found within the `/assets`
        # folder.
        #
        # An array of errors and notices will also be stored in the `errors`
        # attribute after running this method.
        def valid?
          # Grab location of `/assets` folder.
          assets_folder_loc = LiveEditor::CLI::theme_root_dir + '/assets'

          # `assets` folder is optional.
          return true unless File.exist?(assets_folder_loc)

          # Look for source files that probably shouldn't be published to the
          # CDN.
          Dir[assets_folder_loc + '/*/**'].each do |file|
            filename = file.split('/').last
            extension = filename.split('.').size > 1 ? filename.split('.').last : nil

            if extension.present? && SOURCE_EXTENSIONS.include?(extension)
              filename = file.sub(assets_folder_loc, '/assets')

              self.messages << {
                type: :warning,
                message: "The file at `/#{filename}` is a source file. In most cases, we recommend moving this outside of the `/assets` folder."
              }
            end
          end

          self.errors.size == 0
        end
      end
    end
  end
end
