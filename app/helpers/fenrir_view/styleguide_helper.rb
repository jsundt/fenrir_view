module FenrirView
  module StyleguideHelper
    def mv_components
      component_dirs = FenrirView.configuration.components_path.join("*")
      Dir.glob(component_dirs).map do |component_dir|
        FenrirView::Component.new File.basename(component_dir)
      end
    end
  end
end
