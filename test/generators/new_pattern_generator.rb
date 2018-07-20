require "test_helper"

class NewPatternGeneratorTest < Rails::Generators::TestCase
  tests FenrirView::Generators::NewPattern

  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    # reset engines
    Rails.application.config.app_generators.template_engine nil
    Rails.application.config.app_generators.stylesheet_engine nil
    Rails.application.config.app_generators.javascript_engine nil

    run_generator %w( widget )

    assert_file "app/components/widget/_widget.html.erb"
    assert_file "app/components/widget/widget.scss"
    assert_file "app/components/widget/widget.js"
    assert_file "app/components/widget/widget.yml"
  end
end
