class MountedEngineTest < ActionDispatch::IntegrationTest
  test "Has been mounted successfully" do
    get "/design_system"
    assert_response :redirect
  end

  # test "Custom path can be applied to styleguide resource" do
  #   styleguide_path = FenrirView.configuration.styleguide_path

  #   # Set the new path
  #   FenrirView.configuration.styleguide_path = "style-guide"
  #   Rails.application.reload_routes!

  #   get "/design_system/style-guide"
  #   assert_response :success

  #   # Reset back to original
  #   FenrirView.configuration.styleguide_path = styleguide_path
  #   Rails.application.reload_routes!
  # end
end
