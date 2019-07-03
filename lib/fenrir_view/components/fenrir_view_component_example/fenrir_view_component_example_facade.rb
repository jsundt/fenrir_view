# frozen_string_literal: true

class FenrirViewComponentExampleFacade < FenrirView::Presenter
  property :title, required: true, one_of_type: [String]
  property :description, one_of_type: [String]

  property :devices, default: ['320x500', '1200x500'], note: 'Array of width x heights. Eg. ["320x500", "1200x500"]', required: true

  property :examples, default: [], array_of: {
    hash_of: {
      variant: { one_of: ['components', 'system'] },
      name: { one_of_type: [String], required: true },
      component: { one_of_type: [String], required: true },
      properties: { one_of_type: [Hash, FalseClass] },
      yields: {
        array_of: {
          hash_of: {
            key: { one_of_type: [Symbol, String] },
            args: { one_of_type: [Hash] },
            content: { one_of_type: [Symbol, String], required: true }
          }
        }
      }
    }
  }

  def identifier
    title.parameterize(separator: '_')
  end

  def devices
    @devices ||= properties[:devices].map.with_index do |device, index|
      size = device.split('x')

      OpenStruct.new(
        width: "#{size[0]}px",
        height: "#{size[1]}px",
        name: "#{identifier}_#{index}",
      )
    end
  end

  def examples
    @examples ||= properties[:examples].map do |example|
      Example.new(example: example)
    end
  end

  class Example
    def initialize(example:)
      @example = example
    end

    def variant
      @example.fetch(:variant, 'components')
    end

    def name
      @example.fetch(:name)
    end

    def component
      @example.fetch(:component)
    end

    def properties
      @example.fetch(:properties, {})
    end

    def helper
      "<%= #{helper_start}('#{component}', #{pretty_properties}) #{helper_end}".html_safe
    end

    def helper_start
      if variant == 'system'
        'system_component'
      else
        'ui_component'
      end
    end

    def yields
      @yields ||= yields_array.map do |content|
        OpenStruct.new(
          key?: content[:key].present?,
          key: content.fetch(:key, nil)&.to_sym,
          args: content.fetch(:args, {}),
          content: content.fetch(:content),
        )
      end
    end

    def yields_array
      [
        @example.fetch(:yields),
        ([{ content: properties.fetch(:yield) }] if properties.fetch(:yield, false))
      ].compact.flatten
    end

    private

    def pretty_properties
      JSON.pretty_generate(properties.except(:yield)).gsub(/\"(\S+)?\":/, '\1:')
    end

    def helper_end
      if yields.any?
        if yields.first.key?
          'do |layout| %>'
        else
          'do %>'
        end
      else
        '%>'
      end
    end
  end
end
