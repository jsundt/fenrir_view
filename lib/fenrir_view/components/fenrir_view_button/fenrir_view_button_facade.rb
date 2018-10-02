# frozen_string_literal: true

class FenrirViewButtonFacade < FenrirView::Presenter
  # Required properties
  property :title
  property :link

  # Optional styling properties
  property :style
  property :icon
  property :icon_style, default: "o-icon--xs"
  property :icon_inline, default: false
  property :full_size, default: false
  property :size, default: 'normal' # 'normal' || 'big'

  # Optional button properties
  property :disabled    # disable button on load
  property :target      # safe target _blank
  property :remote      # rails js link
  property :link_method # patch/destroy buttons
  property :trigger     # javascript trigger class
  property :submit      # submit form data with this button
  property :modal       # content hash for javascript modal
  property :loader      # boolean, show spinner when clicked
  property :tabindex    # integer tabindex for focus changes
  property :tooltip     # Tooltip explanation text
  property :name        # Name attribute on the button
  property :expandable, default: {}
  property :data_options, default: {}

  def html_options
    html_options = {}
    html_options.merge!(style_classes)

    html_options.merge!(disabled_options) if disabled?
    html_options.merge!(remote_link_options) if remote?
    html_options.merge!(trigger_options) if trigger?
    html_options.merge!(target_blank_options) if target_blank?
    html_options.merge!(link_method_options) if link_method?
    html_options.merge!(modal_options) if modal?
    html_options.merge!(tabindex_options) if tabindex?
    html_options[:href] = link if link?
    html_options.merge!(aria_options) if expandable?
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

  def title?
    title.present?
  end

  def link?
    link && !disabled? && !trigger?
  end

  def icon?
    icon.present?
  end

  def remote?
    remote
  end

  def modal?
    modal
  end

  def tabindex?
    tabindex
  end

  def trigger?
    trigger || modal? || submit_button?
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

  def loader?
    !!loader ||
      (modal? && modal[:loader])
  end

  def expandable?
    !expandable.empty?
  end

  def tooltip?
    tooltip.present?
  end

  def aria_options
    {
      role: "button",
      "aria-controls": expandable[:controls],
      "aria-expanded": expandable[:expanded],
    }
  end

  def icon_styles
    style = ["o-icon"]
    style.push("u-margin--r-5") if title?
    style.push(icon_style) if icon_style
    style.join(" ")
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
    link_style.push("js-modal-link") if modal?
    link_style.push("js-button--loader") if !!loader
    link_style.push("js-toggle-collapse") if expandable?
    link_style.push("is-collapsing") if expandable? && !expandable[:expanded]
    link_style.push("fenrir-view-button--icon") if icon? && !title?
    link_style.push("fenrir-view-button--tooltip") if tooltip?

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

  def modal_options
    raise Exception, "Modal button missing required fields title and link" unless modal[:title] && modal[:link]

    modal_options = {}

    modal_options["data-modal-title"] = modal[:title]
    modal_options["data-modal-path"] = modal[:link]

    # Optional fields
    modal_options['data-modal-content'] = modal[:content]
    modal_options['data-modal-type'] = modal[:type]
    modal_options['data-modal-animation'] = modal[:animation]
    modal_options['data-modal-method'] = modal[:method]
    modal_options['data-modal-confirm-btn'] = modal[:confirm_btn]
    modal_options['data-modal-close-btn'] = modal[:close_btn]
    modal_options['data-modal-loader'] = modal[:loader]
    modal_options['data-modal-loader-target'] = modal[:loader_target]
    modal_options['data-modal-remote'] = modal[:remote]
    modal_options['data-modal-event-name'] = modal[:event_name]

    modal_options
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
