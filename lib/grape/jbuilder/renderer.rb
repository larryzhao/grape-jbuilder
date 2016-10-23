module Grape
  module Jbuilder
    class Renderer
      def initialize(view_path, template)
        @view_path, @template = view_path, template
      end

      def render(scope, locals = {})
        unless view_path
          raise "Use Rack::Config to set 'api.tilt.root' in config.ru"
        end

        if GJ_TILT_CACHE.nil?
          engine = ::Tilt.new file, nil, view_path: view_path
          engine.render scope, locals
        else
          engine = GJ_TILT_CACHE.fetch(file, nil, view_path: view_path) do
                    ::Tilt.new file, nil, view_path: view_path
                   end
          engine.render scope, locals
        end
      end

      private

      attr_reader :view_path, :template

      def file
        File.join view_path, template_with_extension
      end

      def template_with_extension
        template[/\.jbuilder$/] ? template : "#{template}.jbuilder"
      end
    end
  end
end
