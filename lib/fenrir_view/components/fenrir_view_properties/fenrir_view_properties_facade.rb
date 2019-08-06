# frozen_string_literal: true

class FenrirViewPropertiesFacade < FenrirView::Presenter
  property :property_list, required: true, one_of_type: [Hash]
  property :style, one_of_type: [String]

  # Return class for the parent item.
  def item_classes
    item_classes = ['properties-table']
    item_classes << style if style?

    item_classes.join(' ')
  end

  # Got style? (⌐■_■)
  def style?
    !!style
  end

  # Are any types specified?
  def any_types?(property)
    property[:one_of_type].present? && property[:one_of_type].any?
  end

  # Does the property specify any validations?
  def any_validations?(property)
    property[:validations].present? && property[:validations].any?
  end

  # Turn a rule name into something human readable.
  def rule_name(rule_name)
    rule_name.gsub('_', ' ').titleize
  end

  # Display the default value. Handle things like boolean false and hashes.
  def default_value(property)
    return if property[:default].nil?

    # Returns a text representation of a boolean value or a stringified version
    # of a data structure.
    if !!property[:default] == property[:default]
      return property[:default] ? 'true' : 'false'
    elsif property[:default].is_a?(Array) || property[:default].is_a?(Hash)
      return property[:default].inspect
    elsif property[:default].is_a?(Symbol)
      return ":#{property[:default]}"
    end

    # Cast everything else as a string.
    property[:default].to_s
  end
end
