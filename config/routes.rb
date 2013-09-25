if Poll.config.engine_routing
  Poll::Engine.routes.draw do
    match '/:slug'  => 'poll#show',  :as => 'poll',    :via => [:get]
  end
end