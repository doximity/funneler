module Funneler
  module ControllerMethods
    def funnel
      @funnel ||= Funneler.from_token(token: params[:funnel_token])
    end
  end
end
