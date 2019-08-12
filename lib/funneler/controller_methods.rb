module Funneler
  module ControllerMethods
    def funnel
      @funnel ||= Funneler.from_token(token: params[:funnel_token], current_page_index: params[:funnel_index])
    end
  end
end
