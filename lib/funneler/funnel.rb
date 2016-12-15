module Funneler
  class Funnel

    attr_reader :data

    def initialize(data = {})
      @data = data
      @url_cache = Hash.new {|h, key| h[key] = generate_page_for_index(key) }
    end

    def first_page(additional_params = {})
      url = @url_cache[0]
      return url if additional_params.empty?

      add_params_to_url(url, additional_params)
    end

    def next_page
      @url_cache[next_index]
    end

    def previous_page
      @url_cache[previous_index]
    end

    def is_last_page?
      routes.empty? || (current_page_index + 1) >= routes.length
    end

    def current_page
      @url_cache[current_page_index]
    end

    def meta
      data['meta'] || {}
    end

    def current_page_index
      data.fetch('current_page_index', 0)
    end

    def token
      TokenHandler.generate_token(data: data)
    end

    private

    def generate_page_for_index(index)
      return if bad_index?(index)

      token = TokenHandler.generate_token(data: data.merge('current_page_index' => index))
      add_params_to_url(routes[index], "funnel_token" => token)
    end

    def add_params_to_url(path, new_params)
      uri = URI.parse(path)
      params = URI.decode_www_form(uri.query || "").concat(new_params.to_a)
      uri.query = URI.encode_www_form(params)

      uri.to_s
    end

    def routes
      data.fetch('routes', [])
    end

    def next_index
      current_page_index + 1
    end

    def previous_index
      index = current_page_index - 1
      index < 0 ? 0 : index
    end

    def bad_index?(index)
      index.nil? ||
        index < 0 ||
        index >= routes.length
    end
  end
end
