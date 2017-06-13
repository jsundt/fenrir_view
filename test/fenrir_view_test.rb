require 'test_helper'

class FenrirViewTest < ActionDispatch::IntegrationTest
  teardown { clean_sprockets_cache }

  test "engine is loaded" do
    assert_equal ::Rails::Engine, FenrirView::Engine.superclass
  end

  test "stylesheets are properly served" do
    get "/assets/components.css"

    assert_response :success
    assert_match(/\.header {/, response.body)
    refute_match(/Sprockets::FileNotFound/, response.body)
    assert_match(/FenrirView: stylesheet not found for component 'paragraph'/, response.body)
  end

  test "javascripts are properly served" do
    get "/assets/components.js"

    assert_response :success
    assert_match(/console\.log\("header"\)/, response.body)
    refute_match(/Sprockets::FileNotFound/, response.body)
    assert_match(/FenrirView: javascript not found for component 'paragraph'/, response.body)
  end

  test "shows styleguide" do
    get "/fenrir_view/docs/overview/index"

    assert_response :success
    assert_match(/Select one of the components from the side to view its examples and documentation/, response.body)
  end

  test "shows specific component" do
    get "/fenrir_view/styleguide/components/header"

    assert_response :success
    assert_match(/Header/, response.body)
    assert_match(/20 Mountains you didn.+t know they even existed/, response.body)
  end

  test "shows specific component that uses a main app url okay" do
    get "/fenrir_view/styleguide/components/header"

    assert_response :success
    assert_match(/href=\"\/products\/2\"/, response.body)
  end

  test "shows a hint message if the component stub file is empty" do
    get "/fenrir_view/styleguide/components/breadcrumbs"

    assert_response :success
    assert_match(/Hint/, response.body)
    assert_match(/You should write stub examples here:/, response.body)
    assert_match(/app\/components\/breadcrumbs\/breadcrumbs.yml/, response.body)
  end

  test "shows a hint message if the component stub file is not found" do
    get "/fenrir_view/styleguide/components/something"

    assert_response :success
    assert_match(/Hint/, response.body)
    assert_match(/You should write stub examples here:/, response.body)
    assert_match(/app\/components\/something\/something.yml/, response.body)
  end

  private

  def clean_sprockets_cache
    FileUtils.rm_rf File.expand_path("../dummy/tmp",  __FILE__)
  end
end
