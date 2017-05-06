module FenrirView
  class StyleguideController < ::ApplicationController
    layout "fenrir_view"

    def show
      @component = FenrirView::Component.new(params[:id])
    end
  end
end
