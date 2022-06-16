module Lookbook
  class PreviewGroup < Entity
    attr_reader :name, :examples, :preview

    def initialize(name, preview, examples)
      @name = name
      @preview = preview
      @examples = examples
      super("#{@preview.path}/#{name}")
    end

    def url_path
      lookbook_inspect_path lookup_path
    end

    def label
      name.titleize
    end

    def type
      :group
    end

    def params
      examples.map(&:params).flatten.uniq { |param| param[:name] }
    end

    def display_params
      merged = {}
      examples.reverse.map do |example|
        merged.merge! example.display_params
      end
      merged
    end

    def hidden?
      false
    end

    def position
      10000
    end

    def matchers
      normalize_matchers(@preview.label, label)
    end

    def hierarchy_depth
      @preview.hierarchy_depth + 1
    end

    alias_method :lookup_path, :path
  end
end
