# frozen_string_literal: true

require 'mini_magick'

module FenrirView
  class Component
    class AccessibilityScreenshot
      attr_reader :screenshot

      delegate :data, :height, :width, to: :screenshot

      def initialize(screenshot:)
        @screenshot = screenshot
      end

      def cropped(width:, height:, left:, top:)
        image = MiniMagick::Image.open(tempfile.path)
        image.crop("#{width}x#{height}+#{left}+#{top}")

        "data:#{data_parts[1]};base64,#{Base64.strict_encode64(image.to_blob)}"
      end

      private

      def data_parts
        @data_parts ||= data.match(%r{\Adata:([-\w]+/[-\w+.]+)?;base64,(.*)}m) || []
      end

      # Based on the Base64 string, return the file extension to use for this
      # screenshot.
      def extension
        MIME::Types[data_parts[1]].first.preferred_extension
      end

      # Convert the Base64 image to an actual (temporary) file so that we can
      # work with it.
      def tempfile
        @tempfile ||= begin
          file = Tempfile.new(['screenshot-', ".#{extension}"])
          file.binmode
          file.write(Base64.decode64(data_parts[2]))
          file.rewind
          file
        end
      end
    end
  end
end
