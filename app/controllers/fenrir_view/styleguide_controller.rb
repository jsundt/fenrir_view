module FenrirView
  class StyleguideController < FenrirController
    
    def show
      @component = FenrirView::Component.new(params[:id])
    end
  end
end
