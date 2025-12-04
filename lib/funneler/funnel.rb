module Funneler
  class Funnel
    attr_reader :data, :current_page_index

    # Routes can be specified as either an array of routes (e.g ['/welcome',
    # '/complete']), or an array of 2 items that include a route and a page
    # title (e.g [['/welcome', 'Welcome!'], ['/complete', 'You are all done']])
    def initialize(data = {}, current_page_index = nil)
      @data = unpack(data)
      @current_page_index = (current_page_index || data.fetch("current_page_index", nil)).to_i
      @url_cache = Hash.new { |h, key| h[key] = generate_page_for_index(key) }
    end

    def first_page(additional_params = {})
      url = @url_cache[0]
      return url if additional_params.empty?

      add_params_to_url(url, additional_params)
    end

    def next_step
      titles[next_index]
    end

    def previous_step
      return if previous_index == current_page_index

      titles[previous_index]
    end

    def current_step
      titles[current_page_index]
    end

    def stepper
      titles.zip(Array.new(current_page_index) { |index| @url_cache[index] })
    end

    def progress_percentage
      return 100 if routes.empty?

      ((current_page_index + 1.0) / routes.length * 100).round
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
      data.fetch("meta", {})
    end

    def routes
      data.fetch("routes", [])
    end

    def titles
      data.fetch("titles", [])
    end

    def token
      TokenHandler.generate_token(data: data)
    end

    private

    def generate_page_for_index(index)
      return if bad_index?(index)

      token = TokenHandler.generate_token(data: data.merge('current_page_index' => index))
      path  = add_params_to_url(routes[index], "funnel_token" => token )
      add_params_to_url(path, "funnel_index" => index)
    end

    def add_params_to_url(path, new_params)
      uri = URI.parse(path)
      params = URI.decode_www_form(uri.query || "").concat(new_params.to_a)
      uri.query = URI.encode_www_form(params)

      uri.to_s
    end

    def next_index
      current_page_index.to_i + 1
    end

    def previous_index
      index = current_page_index.to_i - 1
      index < 0 ? 0 : index
    end

    def bad_index?(index)
      index.nil? ||
        index < 0 ||
        index >= routes.length
    end

    # This method unpacks the routes and titles information from the original
    # routes data
    def unpack(data)
      data["routes"] ||= []
      data["titles"] ||= []

      titles_from_routes = data["routes"].map { |route| Array(route)[1] }

      # Fills the titles data from routes when it's present and there isn't
      # already a title specified for that index
      titles_from_routes.each.with_index do |title_from_route, index|
        data["titles"][index] ||= title_from_route
      end

      # Remove title information from routes
      data["routes"].map! { |route| Array(route)[0] }

      # Remove any empty or incomplete data
      data.delete_if { |key, value| value.class < Enumerable && (value.empty? || value.any?(&:nil?)) }

      data
    end
  end
end
