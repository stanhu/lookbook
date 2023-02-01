module Lookbook
  class PreviewsController < ApplicationController
    include TargetableConcern
    include WithPreviewControllerConcern

    layout false

    def self.controller_path
      "lookbook/previews"
    end

    def index
      respond_to do |format|
        format.json do
          render(
            json: Lookbook.previews.map do |preview|
              {
                name: preview.name,
                scenarios: preview.scenarios.map { |scenario|
                  {
                    inspect_path: scenario.url_path,
                    name: scenario.name
                  }
                }
              }
            end
          )
        end
      end
    end

    def show
      if @target
        begin
          opts = {layout: @preview.layout}
          if params[:lookbook_embed] == "true"
            opts[:append_html] = render_to_string("lookbook/partials/_iframe_content_scripts", layout: nil)
          end
          @preview_html = preview_controller.process(:render_in_layout_to_string, "lookbook/previews/group", inspector_data, **opts)
        rescue => exception
          render_in_layout "lookbook/error",
            layout: "lookbook/skeleton",
            error: prettify_error(exception)
        end
      else
        show_404
      end
    end
  end
end
