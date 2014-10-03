require "context_builder/version"

module ContextBuilder

  autoload :BaseClassDefiner, 'context_builder/base_class_definer'

  def self.extended(base_mod)
    base_mod.module_eval do
      @__context_attrs = {}
    end

    orig_included = base_mod.method(:included)
    base_mod.define_singleton_method(:included) do |base_class|
      BaseClassDefiner.new(base_class).define_all(@__context_attrs)
      orig_included.call(base_class)
    end
  end

  def context_attr(*names, &block)
    names.flatten.each do |name|
      @__context_attrs[name.to_sym] = block
    end
  end

end
