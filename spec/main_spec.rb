require 'spec_helper'

RSpec.describe LiveEditor::Cli::Main do
  describe 'version' do
    it 'returns the current version number' do
      output = capture(:stdout) { subject.version }
      expect(output).to eql "Live Editor CLI v#{LiveEditor::Cli::VERSION}"
    end
  end

  describe 'new' do
    # Clean up generated my_theme directory.
    after do
      FileUtils.rm_rf(File.dirname(File.realpath(__FILE__)).sub('spec', 'my_theme'))
    end

    context 'with underscored NAME' do
      it "echoes new theme's NAME" do
        output = capture(:stdout) { subject.new('my_theme') }
        expect(output).to match /Creating a new Live Editor theme titled "My Theme".../
      end

      it 'creates a `my_theme` folder with the correct contents' do
        output = capture(:stdout) { subject.new('my_theme') }

        # Check that correct files were generated.
        theme_root = File.dirname(File.realpath(__FILE__)).sub('spec', 'my_theme')
        expect(File).to exist "#{theme_root}/assets/css/site.css"
        expect(File).to exist "#{theme_root}/assets/fonts/.keep"
        expect(File).to exist "#{theme_root}/assets/images/.keep"
        expect(File).to exist "#{theme_root}/assets/js/init.js"
        expect(File).to exist "#{theme_root}/assets/js/site.js"
        expect(File).to exist "#{theme_root}/content_templates/.keep"
        expect(File).to exist "#{theme_root}/includes/.keep"
        expect(File).to exist "#{theme_root}/layouts/layouts.json"
        expect(File).to exist "#{theme_root}/layouts/site_layout.liquid"
        expect(File).to exist "#{theme_root}/navigation/global_navigation.liquid"
        expect(File).to exist "#{theme_root}/navigation/navigation.json"
        expect(File).to exist "#{theme_root}/.gitignore"
        expect(File).to exist "#{theme_root}/config.json.sample"
        expect(File).to exist "#{theme_root}/README.md"
        expect(File).to exist "#{theme_root}/theme.json"

        # Check that template files were generated and parsed correctly.
        expect(IO.read("#{theme_root}/README.md")).to match /^# My Theme/
        expect(IO.read("#{theme_root}/theme.json")).to match /"title": "My Theme"/
      end
    end

    context 'with titleized NAME' do
      it "echoes new theme's name when titleized" do
        output = capture(:stdout) { subject.new('My Theme') }
        expect(output).to match /Creating a new Live Editor theme titled "My Theme".../
      end

      it 'creates a `my_theme` folder with the correct contents' do
        output = capture(:stdout) { subject.new('My Theme') }

        # Check that correct files were generated.
        theme_root = File.dirname(File.realpath(__FILE__)).sub('spec', 'my_theme')
        expect(File).to exist "#{theme_root}/assets/css/site.css"
        expect(File).to exist "#{theme_root}/assets/fonts/.keep"
        expect(File).to exist "#{theme_root}/assets/images/.keep"
        expect(File).to exist "#{theme_root}/assets/js/init.js"
        expect(File).to exist "#{theme_root}/assets/js/site.js"
        expect(File).to exist "#{theme_root}/content_templates/.keep"
        expect(File).to exist "#{theme_root}/includes/.keep"
        expect(File).to exist "#{theme_root}/layouts/layouts.json"
        expect(File).to exist "#{theme_root}/layouts/site_layout.liquid"
        expect(File).to exist "#{theme_root}/navigation/global_navigation.liquid"
        expect(File).to exist "#{theme_root}/navigation/navigation.json"
        expect(File).to exist "#{theme_root}/.gitignore"
        expect(File).to exist "#{theme_root}/config.json.sample"
        expect(File).to exist "#{theme_root}/README.md"
        expect(File).to exist "#{theme_root}/theme.json"

        # Check that template files were generated and parsed correctly.
        expect(IO.read("#{theme_root}/README.md")).to match /^# My Theme/
        expect(IO.read("#{theme_root}/theme.json")).to match /"title": "My Theme"/
      end
    end
  end # new
end
