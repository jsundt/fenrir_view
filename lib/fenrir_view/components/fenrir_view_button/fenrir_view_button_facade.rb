# frozen_string_literal: true

class FenrirViewButtonFacade < FenrirView::Presenter
  # Required properties
  property :title
  property :link

  # Optional styling properties
  property :style
  property :full_size, default: false
  property :size, default: 'normal' # 'normal' || 'big'

  # Optional button properties
  property :disabled    # disable button on load
  property :target      # safe target _blank
  property :remote      # rails js link
  property :link_method # patch/destroy buttons
  property :trigger     # javascript trigger class
  property :submit      # submit form data with this button
  property :tabindex    # integer tabindex for focus changes
  property :name        # Name attribute on the button
  property :data_options, default: {}

  def html_options
    html_options = {}
    html_options.merge!(style_classes)

    html_options.merge!(disabled_options) if disabled?
    html_options.merge!(remote_link_options) if remote?
    html_options.merge!(trigger_options) if trigger?
    html_options.merge!(target_blank_options) if target_blank?
    html_options.merge!(link_method_options) if link_method?
    html_options.merge!(tabindex_options) if tabindex?
    html_options[:href] = link if link?
    html_options.merge!(data_options) if data_options.any?
    html_options[:name] = name if name.present?

    html_options
  end

  def element_symbol
    if disabled?
      :div
    elsif trigger?
      :button
    else
      :a
    end
  end

  def link?
    link && !disabled? && !trigger?
  end

  def remote?
    remote
  end

  def tabindex?
    tabindex
  end

  def trigger?
    trigger || submit_button?
  end

  def target_blank?
    target == "_blank"
  end

  def disabled?
    disabled
  end

  def size_small?
    size == 'small'
  end

  def size_big?
    size == 'big'
  end

  def link_method?
    link_method
  end

  private

  def submit_button?
    !!submit
  end

  def style_classes
    link_style = ["fenrir-view-button"]
    link_style.push("fenrir-view-button--disabled") if disabled?
    link_style.push("fenrir-view-button--block") if !!full_size
    link_style.push("fenrir-view-button--sm") if size_small?
    link_style.push("fenrir-view-button--lg") if size_big?
    link_style.push(style.to_s) if style.present?
    link_style.push(trigger.to_s) if trigger?

    { class: link_style.join(" ") }
  end

  def remote_link_options
    { "data-remote" => true }
  end

  def trigger_options
    if submit_button?
      { type: "submit", value: submit, name: name || "submit_button" }
    else
      { type: "button" }
    end
  end

  def tabindex_options
    { tabindex: tabindex }
  end

  def target_blank_options
    {
      target: "_blank",
      rel: "noopener noreferrer",
    }
  end

  def disabled_options
    { disabled: true }
  end

  def link_method_options
    { "data-method" => link_method }
  end
end
