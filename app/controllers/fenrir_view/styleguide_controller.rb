# frozen_string_literal: true

module FenrirView
  class StyleguideController < FenrirController
    helper 'fenrir_view/styleguide'

    def index; end

    def show
      @component = FenrirView::Component.new(params[:variant], params[:id], design_system_policy: @design_system_policy)

      render 'fenrir_view/styleguide/missing' unless @component.facade_loaded?
    end
  end
end
