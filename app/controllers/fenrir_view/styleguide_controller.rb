# frozen_string_literal: true

module FenrirView
  class StyleguideController < FenrirController
    before_action :set_component, only: [:show, :preview]

    helper 'fenrir_view/styleguide'

    def index; end

    def show
      render 'fenrir_view/styleguide/missing' unless @component.facade_loaded?
    end

    def preview
      render layout: 'plain'
    end

    def set_component
      @component = FenrirView::Component.new(params[:variant], params[:id], design_system_policy: @design_system_policy)
    end
  end
end
