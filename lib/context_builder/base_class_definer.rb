module ContextBuilder
  class BaseClassDefiner

    attr_reader :base_class

    def initialize(base_class)
      @base_class = base_class
    end

    def define_all(all_attrs)
      define_initialize_context_method(all_attrs)
      define_all_attr_methods(all_attrs)
      define_context_method(all_attrs)
      define_to_hash_method(all_attrs)
      define_inspect_method(all_attrs)
    end

    private

    def define_initialize_context_method(all_attrs)
      base_class.send(:define_method, :initialize_context) do |options|
        all_attrs.each do |name, block|
          @__context ||= {}
          @__context[name] = block ? block.call(options) : options[name]
        end
      end
    end

    def define_all_attr_methods(all_attrs)
      all_attrs.keys.each do |name|
        base_class.send(:define_method, name) do
          @__context ||= {}
          @__context[name] ||= [self.class, *self.class.included_modules].reduce(nil) do |val, mod|
            val ||= begin
              if mod.method_defined? "lookup_#{name}"
                mod.instance_method("lookup_#{name}").bind(self).call
              end
            end
          end
        end
      end
    end

    def define_context_method(all_attrs)
      base_class.send(:define_method, :context) do
        all_attrs.keys.reduce({}) do |hash, name|
          hash.merge! name => send(name)
        end
      end
    end

    def define_to_hash_method(all_attrs)
      base_class.send(:define_method, :to_hash) do
        context
      end
    end

    def define_inspect_method(all_attrs)
      base_class.send(:define_method, :inspect) do
        data = to_hash.map { |a| a.join '=' }.join ', '
        "#<#{self.class.name} #{data}>"
      end
    end

  end
end
