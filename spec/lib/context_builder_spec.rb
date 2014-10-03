require 'spec_helper'
require 'context_builder'

describe ContextBuilder do

  let(:clazz) do
    Class.new do
      def lookup_bar
        'bar from clazz'
      end
      def self.name
        'TestClass'
      end
    end
  end

  let(:mod) do
    Module.new do
      extend ContextBuilder

      context_attr :foo, :bar
      context_attr(:baz) { |options| options[:not_baz] }

      def lookup_bar
        'bar from mod'
      end

      def lookup_foo
        'foo from mod'
      end
    end
  end

  subject { clazz.tap { |c| c.send(:include, mod) }.new }

  specify 'initialize context with options' do
    subject.initialize_context(:foo => 12, :bar => 'stuff', :not_baz => 'weird, huh?')
    expect(subject.to_hash).to eq(:foo => 12, :bar => 'stuff', :baz => 'weird, huh?')
  end

  specify 'initialize context from lookups' do
    expect(subject.to_hash).to eq(:foo => 'foo from mod', :bar => 'bar from clazz', :baz => nil)
  end

  specify 'provides inspect method on extended modules' do
    expect(subject.inspect).to eq('#<TestClass foo=foo from mod, bar=bar from clazz, baz=>')
  end

  specify 'preserve included on extended modules' do
    mod2 = Module.new do
      def self.included(base)
        base.send(:define_method, :inspect) do
          'preserved inspect'
        end
      end
      extend ContextBuilder
    end
    clazz2 = Class.new { include mod2 }
    expect(clazz2.new.inspect).to eq('preserved inspect')
  end

  specify 'overwrite included on extended modules' do
    mod.module_eval do
      def self.included(base)
        # By defining this AFTER 'extend Context', we kill self.included
        # and prevent Context from doing anything to clazz
      end
    end
    expect { subject.initialize_context }.to raise_error(/undefined method/)
  end

end
