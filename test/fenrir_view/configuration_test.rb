require "test_helper"

class FenrirViewConfigurationTest < ActiveSupport::TestCase
  test "default value for included_stylesheets is an empty array" do
    assert_equal FenrirView::Configuration.new.included_stylesheets, []
  end

  test "default value for styleguide_path is nil" do
    assert_nil FenrirView::Configuration.new.styleguide_path
  end

  test "set custom included_stylesheets" do
    config = FenrirView::Configuration.new
    config.included_stylesheets = ["global", "fonts"]

    assert_equal config.included_stylesheets, ["global", "fonts"]
  end

  test "set custom styleguide_path" do
    config = FenrirView::Configuration.new
    config.styleguide_path = "style-guide"

    assert_equal config.styleguide_path, "style-guide"
  end
end
