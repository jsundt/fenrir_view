# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::PropertyTypes do
  let(:mock_instance) do
    lambda { |instance_props, component_props|
      FenrirView::PropertyTypes.new({
                                      component_class: CardFacade,
                                      component_properties: component_props,
                                      instance_properties: instance_props,
                                    })
    }
  end

  let(:dummy_instance) { mock_instance[{}, {}] }

  let(:mock_component) do
    lambda { |content, validations|
      dummy_instance.validate_property(:title, content, validations)
    }
  end

  let(:title_property) { 'The best title' }

  describe 'Presenter initializes validator' do
    let(:card_facade_property_types) {
      FenrirView::Presenter.component_for('component', 'card', {
        title: 'everything',
      }, validate: true).send(:property_types)
    }

    let(:component_properties) do
      {
        yield: {},
        title: { required: true },
        description: {},
        link: {},
        image_url: {},
        location: {},
        data: { default: [] }
      }
    end

    let(:instance_properties) do
      {
        yield: nil,
        title: 'everything',
        description: nil,
        link: nil,
        image_url: nil,
        location: nil,
        data: []
      }
    end

    it 'Presenter can initialize validator' do
      expect(card_facade_property_types).to respond_to(:validate_properties)

      expect(card_facade_property_types.instance_variable_get(:@component_class)).to eq(CardFacade)
      expect(card_facade_property_types.instance_variable_get(:@component_properties)).to eq(component_properties)
      expect(card_facade_property_types.instance_variable_get(:@instance_properties)).to eq(instance_properties)
    end
  end

  describe '#validate_properties' do
    it 'returns instance properties when correct' do
      expect(mock_instance[{ title: title_property }, { title: {}}].validate_properties).to eq({ title: title_property })
    end

    it 'returns nil if instance is protected by guard clause' do
      expect(mock_instance[false, { title: {}}].validate_properties).to be_nil
    end

    it 'raises error if properties is not a hash' do
      expect { mock_instance[[1,2,3], { title: {}}].validate_properties }.to raise_error('An instance of CardFacade has properties as Array. Should be Hash or false.')
    end

    it 'raises error if properties include unknown keys' do
      expect { mock_instance[{ not_a_property: true }, { title: {}}].validate_properties }.to raise_error('CardFacade has unkown keys: not_a_property. Should be one of: title')
    end

    it 'raises error if properties has no keys' do
      expect { mock_instance[{}, { title: {}}].validate_properties }.to raise_error('CardFacade has unkown keys: . Should be one of: title')
    end
  end

  describe '#validate_property' do
    it 'raises error if property is deprecated' do
      expect { mock_component[title_property, { deprecated: true }] }.to raise_error('An instance of CardFacade is using the deprecated property title')
    end

    it 'raises error if component facade has unknown validations' do
      expect { mock_component[title_property, { not_a_validation: true }] }.to raise_error('CardFacade has unkown property validations: not_a_validation. Should be one of: required, one_of_type, one_of, array_of, hash_of, deprecated, default, note')
    end

    describe 'property validations' do
      describe 'required' do
        let(:title_validations) { { required: true } }

        it 'component returns if required property is present' do
          expect { mock_component[title_property, title_validations] }.not_to raise_error
          expect(mock_component[title_property, title_validations]).to eq({ required: true })
        end

        it 'property value can be nil if required rule is false or not present' do
          expect { mock_component[nil, { required: false }] }.not_to raise_error
          expect { mock_component[nil, {}] }.not_to raise_error
        end

        it 'raises error if validation rule is not a boolean' do
          expect { mock_component[title_property, { required: 'Yes it is required' }] }.to raise_error('An instance of CardFacade has a required validation with a value of \'Yes it is required\', but it should be of type: Boolean')
        end

        it 'raises error if a required property value is nil' do
          expect { mock_component[nil, title_validations] }.to raise_error('An instance of CardFacade is missing the required property: title')
        end
      end

      describe 'one_of_type' do
        let(:title_validations) { { one_of_type: [String] } }
        let(:array_validations) { { one_of_type: [Array] } }

        it 'returns if property is correct type' do
          expect { mock_component[title_property, title_validations] }.not_to raise_error
          expect(mock_component[title_property, title_validations]).to eq({ one_of_type: [String] })
          expect { mock_component[[title_property], array_validations] }.not_to raise_error
        end

        it 'raises error when validation rule is not an array' do
          expect { 
            mock_component['The best title', { one_of_type: 'The best title' }] 
          }.to raise_error('An instance of CardFacade has a one_of_type validation with a value of \'The best title\', but it should be of type: Array of Classes')

          expect { 
            mock_component['The best title', { one_of_type: String }] 
          }.to raise_error('An instance of CardFacade has a one_of_type validation with a value of \'String\', but it should be of type: Array of Classes')
        end

        it 'raises error if property is wrong type' do
          expect { mock_component[title_property, array_validations] }.to raise_error("An instance of CardFacade has the wrong type: 'String' for property: 'title'. The value is: 'The best title', Should be one of: Array")
        end

        it 'does not raise if value is nil' do
          expect { mock_component[nil, title_validations] }.not_to raise_error
        end
      end

      describe 'one_of' do
        let(:title_validations) { { one_of: ['The best title', 'The second best title'] } }

        it 'returns if property is one of the allowed values' do
          expect { mock_component[title_property, title_validations] }.not_to raise_error
          expect { mock_component['The second best title', title_validations] }.not_to raise_error
        end

        it 'raises error when validation rule is not an array' do
          expect { 
            mock_component['The best title', { one_of: 'The best title' }] 
          }.to raise_error('An instance of CardFacade has a one_of validation with a value of \'The best title\', but it should be of type: Array')

          expect { 
            mock_component['The best title', { one_of: String }] 
          }.to raise_error('An instance of CardFacade has a one_of validation with a value of \'String\', but it should be of type: Array')
        end

        it 'raises error if value is not one of the allowed values' do
          expect { mock_component['Terrible title', title_validations] }.to raise_error("An instance of CardFacade has the wrong value for property: 'title' (value: 'Terrible title'). Should be one of: The best title, The second best title")
        end

        it 'does not raise if value is nil' do
          expect { mock_component[nil, title_validations] }.not_to raise_error
        end
      end

      describe 'array_of' do
        let(:simple_validations) { { array_of: { one_of: ['The best title', 'The second best title', 'Valid title'] } } }

        it 'returns if property has proper values' do
          expect {
            mock_component[['The best title', 'The second best title'], simple_validations]
          }.not_to raise_error
        end

        it 'raises error if validation rule is not a hash' do
          expect {
            mock_component[['The best title', 'The second best title'], { array_of: ['The best title', 'The second best title'] }]
          }.to raise_error('An instance of CardFacade has a array_of validation with a value of \'["The best title", "The second best title"]\', but it should be of type: Hash of validations')
        end

        it 'raises error if value is not an array' do
          expect {
            mock_component[title_property, simple_validations]
          }.to raise_error('An instance of CardFacade has the wrong type: \'String\' for property: \'title\'. The value is: \'The best title\', Should be one of: Array')

          expect {
            mock_component[{ data: title_property }, simple_validations]
          }.to raise_error('An instance of CardFacade has the wrong type: \'Hash\' for property: \'title\'. The value is: \'{:data=>"The best title"}\', Should be one of: Array')
        end

        it 'raises error if array values do not pass validations' do
          expect {
            mock_component[['Terrible title'], simple_validations]
          }.to raise_error("An instance of CardFacade has the wrong value for property: 'title[0]' (value: 'Terrible title'). Should be one of: The best title, The second best title, Valid title")

          expect {
            mock_component[['The best title', 'Terrible title', 'The second best title'], simple_validations]
          }.to raise_error("An instance of CardFacade has the wrong value for property: 'title[1]' (value: 'Terrible title'). Should be one of: The best title, The second best title, Valid title")

          expect {
            mock_component[[1, 2, 3], simple_validations]
          }.to raise_error("An instance of CardFacade has the wrong value for property: 'title[0]' (value: '1'). Should be one of: The best title, The second best title, Valid title")
        end

        it 'does not raise if value is nil' do
          expect { mock_component[nil, simple_validations] }.not_to raise_error
        end
      end

      describe 'hash_of' do
        let(:simple_validations) do
          {
            hash_of: {
              id: { required: true },
              title: { one_of_type: [String] }
            }
          }
        end

        it 'returns if property has proper values' do
          expect { mock_component[{ id: 1, title: title_property }, simple_validations] }.not_to raise_error

          expect { mock_component[{ id: 2 }, simple_validations] }.not_to raise_error
        end

        it 'raises error if value is not a hash' do
          expect { 
            mock_component['The best title', simple_validations] 
          }.to raise_error('An instance of CardFacade has the wrong type: \'String\' for property: \'title\'. The value is: \'The best title\', Should be one of: Hash')

          expect { 
            mock_component[['id', 1], simple_validations] 
          }.to raise_error('An instance of CardFacade has the wrong type: \'Array\' for property: \'title\'. The value is: \'["id", 1]\', Should be one of: Hash')
        end

        it 'raises error if hash values do not pass validations' do
          expect { mock_component[{ id: 1, title: 2, }, simple_validations] }.to raise_error("An instance of CardFacade has the wrong type: 'Integer' for property: 'title[title]'. The value is: '2', Should be one of: String")

          expect { mock_component[{ title: title_property }, simple_validations] }.to raise_error("An instance of CardFacade is missing the required property: title[id]")
        end

        it 'does not raise if value is nil' do
          expect { mock_component[nil, simple_validations] }.not_to raise_error
        end
      end

      describe 'deeply nested validations' do
        let(:complex_validations) do
          {
            hash_of: {
              id: { required: true, one_of_type: [Integer] },
              title: { one_of_type: [String] },
              buttons: {
                array_of: {
                  hash_of: {
                    title: { required: true, one_of_type: [String] },
                    link: { required: true, one_of_type: [String] },
                    style: { required: true, one_of: ['primary', 'success', 'warning', 'danger'] }
                  },
                },
                required: true,
              },
            }
          }
        end

        it 'returns when all nested validations are passed in correctly' do
          expect { mock_component[{
            id: 1,
            title: title_property,
            buttons: [
              {
                title: 'Edit',
                link: '/edit',
                style: 'primary',
              },
            ],
          }, complex_validations] }.not_to raise_error
        end

        it 'raises when you pass bad values in any part of a nested rule' do
          expect { mock_component[{ id: 1, title: title_property }, complex_validations] }.to raise_error("An instance of CardFacade is missing the required property: title[buttons]")

          # TODO: figure out funny business
          # expect { mock_component[{
          #   id: 1,
          #   title: title_property,
          #   buttons: {
          #     title: 'Edit',
          #     link: '/edit',
          #     style: 'primary',
          #   },
          # }, complex_validations] }.to raise_error
          #
          # expect { mock_component[{
          #   id: 1,
          #   title: title_property,
          #   buttons: [['new', 'edit', 'delete']],
          # }, complex_validations] }.to raise_error

          expect { mock_component[{
            id: 1,
            title: title_property,
            buttons: [
              {
                title: 'New',
                link: '/new',
                style: 'primary',
              },
              {
                title: 'Edit',
                link: '/edit',
                style: 'ghost',
              },
            ],
          }, complex_validations] }.to raise_error("An instance of CardFacade has the wrong value for property: 'title[buttons][1][style]' (value: 'ghost'). Should be one of: primary, success, warning, danger")
        end
      end
    end
  end
end
