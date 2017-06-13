class ModalFacade < FenrirView::Presenter
  properties :title, :content, :html_content
  property :style, default: "u-bg--charcoal"
  property :form, default: false
  property :actions, default: { cancel: {} }

  def modal_body
    if has_content?
      content
    elsif has_partial?
      html_content
    end
  end

  def user_actions
    user_actions = []

    user_actions << cancel_action unless actions[:cancel] == false
    user_actions << confirm_action if actions[:confirm]

    user_actions
  end

  def has_content?
    content.present?
  end

  def has_partial?
    html_content.present?
  end

  private

  def cancel_action
    cancel = {
      title: "Cancel",
      trigger: "js-modal-cancel",
      style: "u-bg--white u-bg--to-charcoal"
    }.merge(actions[:cancel])

    cancel
  end

  def confirm_action
    confirm = {
      title: "Confirm",
      style: ""
    }.merge(actions[:confirm])

    confirm[:style] << " js-modal-confirm"

    confirm
  end
end