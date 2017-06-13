require "test_helper"

class InheritedPresenter < FenrirView::Presenter
  properties :title, :description
  property :data, default: []

  def title
    "Foo#{properties[:title].downcase}"
  end
end

class FenrirView::PresenterTest < ActiveSupport::TestCase
  test "returns the correct partial path" do
    presenter = FenrirView::Presenter.new("components", "header")
    assert_equal "header/header", presenter.partial
  end

  test "exposes properties as provided" do
    properties = { foo: "bar", hello: "world" }
    presenter = FenrirView::Presenter.new("components", "header", properties)
    assert_equal properties, presenter.properties
  end

  test "inherited presenter returns the correct title" do
    presenter = InheritedPresenter.new("components", "inherited", title: "Bar")
    assert_equal "Foobar", presenter.title
  end

  test "inherited presenter responds to #data" do
    presenter = InheritedPresenter.new("components", "inherited", data: ["Foobar"])
    assert_equal ["Foobar"], presenter.data
  end

  test "inherited presenter returns the default value for #data" do
    presenter = InheritedPresenter.new("components", "inherited", {})
    assert_equal [], presenter.data
  end
end
