require "poll/engine"

module Poll
  mattr_accessor :cache_sweeper
  @@cache_sweeper = false

  mattr_accessor :image_styles
  @@image_styles = {:large => ["466x377#", :jpg], :thumb => ["70x70#", :jpg]}

  class Engine < Rails::Engine
    isolate_namespace Poll

    initializer :poll, :after=> :engines_blank_point do
      ActiveAdmin.application.load_paths.unshift Dir[Poll::Engine.root.join('app', 'admin')] if defined?(ActiveAdmin)
    end
  end

  def self.config(&block)
    yield self if block
    return self
  end
end
