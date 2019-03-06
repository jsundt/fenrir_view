# frozen_string_literal: true

module FenrirView
  class Metrics
    def initialize
      @metrics = {}
    end

    def run
      # Setup keys and initial values
      component_metric_keys
      extra_metric_keys
      file_type_metric_keys
      total_metric_keys

      puts 'Looking through erb files...'
      parse_erb_files

      puts "\nReading facade files..."
      parse_facade_files

      puts 'Reading design system erb files...'
      parse_system_files

      puts 'Counting totals...'
      @metrics[:file_types][:facades][:lines] += count_lines(facade_files)
      @metrics[:file_types][:scss][:lines] += count_lines(scss_files)
      @metrics[:file_types][:scss][:classes] += count_css_classes
      @metrics[:file_types][:js][:lines] += count_lines(js_files)
      @metrics[:file_types][:js][:functions] += count_js_functions

      count_total_component_usage
      count_total_extras

      @metrics[:totals][:all_instances] = calculate_filtered_instance_count
      @metrics[:totals][:saturation] = calculate_saturation

      generate_metrics_file(@metrics)

      puts @metrics[:totals][:saturation]
      @metrics[:totals][:saturation]
    end

    private

    def component_metric_keys
      @metrics[:components] = {}

      component_names.each do |component_name|
        @metrics[:components][component_name] = {
          component_count: 0,
          property_hash_count: 0,
          deprecated_instance_count: 0,
          composition_usage: 0,
        }
      end
    end

    def extra_metric_keys
      @metrics[:extras] = {}

      misc_deprecated.each do |name, _|
        @metrics[:extras][name] = 0
      end
    end

    def total_metric_keys
      @metrics[:totals] = {
        components: 0,
        property_hashes: 0,
        deprecated: 0,
        additional_deprecated: 0,
        ignored_deprecation: 0,
        composition: 0,
        all_instances: 0,
        saturation: 0,
      }
    end

    def file_type_metric_keys
      @metrics[:file_types] = {
        erb: {
          files: erb_files.length,
          lines: 0,
        },
        facades: {
          files: facade_files.length,
          lines: 0,
        },
        scss: {
          files: scss_files.length,
          lines: 0,
          classes: 0,
        },
        js: {
          files: js_files.length,
          lines: 0,
          functions: 0,
        },
      }
    end

    def components
      return @components if defined? @components

      components = {}

      component_names.each do |component_name|
        components[component_name] = {
          name: component_name,
          components: /ui_component\(('|")#{component_name}/,
          property_hashes: /(DesignSystem|FenrirView).properties\(('|")#{component_name}/,
          deprecated: get_deprecated_grep_as_string(component_name),
        }
      end

      @components = components
    end

    def parse_erb_files
      erb_files.each_with_index do |file_name, i|
        file = File.readlines(file_name)

        printf("\rReading erb files: #{i}/#{erb_files.length}") if (i % 100).zero?

        @metrics[:file_types][:erb][:lines] += file.size
        @metrics[:totals][:ignored_deprecation] += ignored_deprecation(file)

        misc_deprecated.each do |name, v|
          @metrics[:extras][name] += count_item(file, v)
        end

        components.each do |name, _|
          @metrics[:components][name][:component_count] += count_item(file, components[name][:components])
          @metrics[:components][name][:property_hash_count] += count_item(file, components[name][:property_hashes])

          if components[name][:deprecated].present?
            @metrics[:components][name][:deprecated_instance_count] += count_item(file, /#{components[name][:deprecated]}/)
          end
        end
      end
    end

    def parse_facade_files
      facade_files.each do |file_name|
        file = File.readlines(file_name)

        components.each do |name, _|
          @metrics[:components][name][:property_hash_count] += count_item(file, components[name][:property_hashes])
        end
      end
    end

    def parse_system_files
      system_files.each do |file_name|
        file = File.readlines(file_name)

        @metrics[:totals][:ignored_deprecation] += ignored_deprecation(file)

        misc_deprecated.each do |name, v|
          @metrics[:extras][name] += count_item(file, v)
        end

        components.each do |name, _|
          @metrics[:components][name][:component_count] += count_item(file, components[name][:components])
          @metrics[:components][name][:composition_usage] += count_item(file, components[name][:components])

          if components[name][:deprecated].present?
            @metrics[:components][name][:deprecated_instance_count] += count_item(file, /#{components[name][:deprecated]}/)
            @metrics[:components][name][:composition_usage] += count_item(file, /#{components[name][:deprecated]}/)
          end
        end
      end
    end

    def count_total_component_usage
      @metrics[:components].each do |_, v|
        @metrics[:totals][:components] += v[:component_count]
        @metrics[:totals][:property_hashes] += v[:property_hash_count]
        @metrics[:totals][:deprecated] += v[:deprecated_instance_count]
        @metrics[:totals][:composition] += v[:composition_usage]
      end
    end

    def count_total_extras
      @metrics[:extras].each do |_, v|
        @metrics[:totals][:additional_deprecated] += v
      end
    end

    def calculate_filtered_instance_count
      count = calculate_instance_count
      count -= @metrics[:extras][:layout_rules]
      count -= @metrics[:extras][:modals]
      count -= @metrics[:extras][:charlie_talks]
      count -= @metrics[:extras][:best_in_place]
      count -= @metrics[:extras][:uploaders]
      count
    end

    def calculate_instance_count
      count = @metrics[:totals][:components]
      count += @metrics[:totals][:deprecated]
      count += @metrics[:totals][:additional_deprecated]
      count -= @metrics[:totals][:ignored_deprecation]
      count
    end

    def calculate_saturation
      return 0 if @metrics[:totals][:components].zero? || @metrics[:totals][:all_instances].zero?

      ((@metrics[:totals][:components].to_f / @metrics[:totals][:all_instances]) * 100).round(2)
    end

    def count_css_classes
      css_classes = 0

      scss_files.each do |file_name|
        classes = File.readlines(file_name).grep(/\.[A-z]/)
        css_classes += classes.length
      end

      css_classes
    end

    def count_js_functions
      js_functions = 0

      js_files.each do |file_name|
        functions = File.readlines(file_name).grep(/function ?(\w+)?\((((\w)(, )?)+)?\) ?{/)
        js_functions += functions.length
      end

      js_functions
    end

    def count_lines(files)
      count = 0

      files.each do |file_name|
        count += File.readlines(file_name).size
      end

      count
    end

    def count_item(file, item)
      file.grep(item).length
    end

    def ignored_deprecation(file)
      file.grep(/(as: :(checkbox|charlie_checkbox|select|grouped_select|charlie_filter_date|year_picker|month_picker|date_picker|hidden))/).length
    end

    def misc_deprecated
      {
        layout_rules: /css_columns|col-xs-/,
        content_cards: /(content_card)/,
        misc_cards: /(charlie_empty_content_block|(j |= )note_card|notification_card|registered_company_card|special_day_card|card_stats|time_off_card)/,
        misc: /(slice_beta_feedback|info_slice\(|c_slice_cta|cell_header_options|onboarding_steps|nav_onboarding__item|charlie_clock|charlie_hint|content_hint|content_loader|content_member_type)/,
        modals: /\$.charlie.modal|content_modal/,
        charlie_talks: /shared\/charlie_talks/,
        best_in_place: /charlie_bip/,
        uploaders: /charlie_document_type|charlie_document_uploader|doc_uploader/,
      }
    end

    def facade_files
      facades = Dir.glob(app_root.join('app', 'facades', '**', '*_facade.rb'))
      facades.select { |f| File.file?(f) }
    end

    def erb_files
      erb = Dir.glob(app_root.join('app', 'views', '**', '*.erb'))
      erb.select { |f| File.file?(f) }
    end

    def system_files
      erb = Dir.glob(app_root.join('lib', 'design_system', '**', '*.erb'))
      erb.select { |f| File.file?(f) }
    end

    def scss_files
      scss_files = Dir.glob(app_root.join('app', 'assets', 'stylesheets', '**', '*.scss'))
      scss_files.select { |f| File.file?(f) }
    end

    def js_files
      js_files = Dir.glob(app_root.join('app', 'assets', 'javascripts', '**', '*.js'))
      js_files.select { |f| File.file?(f) }
    end

    def component_names
      @component_names ||= Dir.glob(FenrirView.patterns_for('components')).map { |dir| File.basename(dir) }.sort
    end

    def get_deprecated_grep_as_string(component_name)
      facade = FenrirView::Component.new('components', component_name)
      facade.meta_deprecated
    rescue Psych::SyntaxError
      throw "Unable to parse deprecated string in yaml for #{component_name}"
    end

    def generate_metrics_file(metrics)
      file = metrics_file

      file_content = {
        design_system: {
          metrics: metrics,
        },
      }

      file.write(file_content.deep_symbolize_keys.to_yaml)
      file.close
    end

    def metrics_file
      File.new(app_root.join('lib/design_system/metrics.yml'), 'w')
    end

    def app_root
      Rails.root
    end
  end
end
