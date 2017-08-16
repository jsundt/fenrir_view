module FenrirView
  class StyleguideController < FenrirController

    helper "fenrir_view/styleguide"

    def show
      @component = FenrirView::Component.new(params[:variant], params[:id])
    end
  end
end
