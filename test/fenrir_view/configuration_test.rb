require "test_helper"

class FenrirViewConfigurationTest < ActiveSupport::TestCase
  test "default value for styleguide_path is nil" do
    assert_nil FenrirView::Configuration.new.styleguide_path
  end

  test "set custom styleguide_path" do
    config = FenrirView::Configuration.new
    config.styleguide_path = "style-guide"

    assert_equal config.styleguide_path, "style-guide"
  end
end
