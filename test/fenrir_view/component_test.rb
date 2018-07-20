require "test_helper"

class FenrirViewComponentTest < ActiveSupport::TestCase
  def test_name
    component = FenrirView::Component.new("components", "header")

    assert_equal "header", component.name
  end

  def test_humanized_title
    component = FenrirView::Component.new("components", "social_media_icons")

    assert_equal "Social media icons", component.title
  end

  def test_styleguide_stubs
    component = FenrirView::Component.new("components", "header")
    expected_stub =
      {
        meta: {
          status: "Testing",
          description: "There is this different classes"
        },
        stubs: [
          {
            props: {
              id:  1,
              title: "20 Mountains you didn't know they even existed",
              subtitle: "Buzzfeed title"
            },
          },
          {
            props: {
              id: 2,
              title: "You won't believe what happened to this man at Aspen"
            },
          },
        ],
      }

    assert_instance_of Hash, component.styleguide_stubs
    assert_equal expected_stub, component.styleguide_stubs
  end

  def test_component_stubs
    component = FenrirView::Component.new("components", "header")
    expected_stub =
      [
        {
          props: {
            id: 1,
            title: "20 Mountains you didn't know they even existed",
            subtitle: "Buzzfeed title"
          },
        },
        {
          props: {
            id: 2,
            title: "You won't believe what happened to this man at Aspen"
          },
        },
      ]
    assert_instance_of Array, component.component_stubs
    assert_equal expected_stub, component.component_stubs
  end

  def test_component_stubs?
    component_with_stubs = FenrirView::Component.new("components", "header")
    component_with_empty_stub_file = FenrirView::Component.new("components", "breadcrumbs")
    component_without_stub_file =
      FenrirView::Component.new("components", "social_media_icons")
    compoenet_with_stubs_but_incorrect_format =
      FenrirView::Component.new("components", "card")
    assert_equal true, component_with_stubs.component_stubs?
    assert_equal false, component_without_stub_file.component_stubs?
    assert_equal false, component_with_empty_stub_file.component_stubs?
    assert_equal true, compoenet_with_stubs_but_incorrect_format.
      component_stubs?
  end

  def test_stubs_extra_info
    component_with_extra_info = FenrirView::Component.new("components", "header")
    component_with_empty_stub_file =
      FenrirView::Component.new("components", "breadcrumbs")
    component_without_stub_file =
      FenrirView::Component.new("components", "paragraph")
    expected_extra_info_stub = { status: "Testing", description: "There is this different classes" }

    assert_equal expected_extra_info_stub, component_with_extra_info.
      stubs_extra_info
    assert_equal true, component_with_empty_stub_file.stubs_extra_info.empty?
    assert_equal true, component_without_stub_file.stubs_extra_info.empty?
  end

  def test_stubs_extra_info?
    component_with_stubs = FenrirView::Component.new("components", "header")
    component_with_empty_stub_file =
      FenrirView::Component.new("components", "breadcrumbs")
    component_without_stub_file =
      FenrirView::Component.new("components", "social_media_icons")
    component_with_stubs_but_no_extra_info =
      FenrirView::Component.new("components", "card")

    assert_equal true, component_with_stubs.stubs_extra_info?
    assert_equal false, component_without_stub_file.stubs_extra_info?
    assert_equal false, component_with_empty_stub_file.stubs_extra_info?
    assert_equal false, component_with_stubs_but_no_extra_info.
      stubs_extra_info?
  end

  def test_stubs_correct_format?
    component_with_correct_stubs = FenrirView::Component.new("components", "header")
    component_with_empty_stub_file = FenrirView::Component.new("components", "breadcrumbs")
    component_without_stub_file =
      FenrirView::Component.new("components", "social_media_icons")
    component_with_stubs_but_old_syntax =
      FenrirView::Component.new("components", "card")

    assert_equal true, component_with_correct_stubs.stubs_correct_format?
    assert_equal false, component_without_stub_file.stubs_correct_format?
    assert_equal false, component_with_empty_stub_file.stubs_correct_format?
    assert_equal true, component_with_stubs_but_old_syntax.
      stubs_correct_format?
  end

  def test_stubs_file
    component = FenrirView::Component.new("components", "header")

    expected_stubs_file = Rails.root.join("lib/design_system/components/header/header.yml")
    assert_equal expected_stubs_file, component.stubs_file
  end

  def test_stubs?
    component_with_stubs = FenrirView::Component.new("components", "header")
    component_without_stub_file = FenrirView::Component.new("components", "social_media_icons")
    component_with_empty_stub_file = FenrirView::Component.new("components", "breadcrumbs")

    assert_equal true, component_with_stubs.stubs?
    assert_equal false, component_without_stub_file.stubs?
    assert_equal false, component_with_empty_stub_file.stubs?
  end
end
