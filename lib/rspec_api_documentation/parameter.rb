module RspecApiDocumentation
  class Parameter
    def initialize(name, description = "", options={})
      @name = name
      @description = description
      @options = options
      @document = [*@options.delete(:document)].compact

      if !!@options.delete(:private)
        @document.push(:private)
      end
    end

    def [](key)
      @options[key]
    end

    def []=(key, value)
      @options[key] = value
    end

    def should_document?(example)
      return true if document.include?(:all)

      if document_config = RSpec.configuration.exclusion_filter[:document]
        return !(document.include?(document_config.to_sym))
      else
        return true
      end
    end

    def document
      @document || [:all]
    end

    def public?
      [:all, :public].include?(document)
    end

    def to_json
      {
        name: @name,
        description: @description,
      }.merge(@options)
    end
    alias_method :to_hash, :to_json
  end
end
