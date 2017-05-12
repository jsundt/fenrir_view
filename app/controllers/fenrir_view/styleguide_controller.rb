module FenrirView
  class StyleguideController < FenrirController

    def show
      @component = FenrirView::Component.new(params[:variant], params[:id])
    end
  end
end
