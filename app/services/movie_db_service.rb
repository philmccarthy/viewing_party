class MovieDbService
  class << self
    def call_top_films
      page_one = discover(1)
      page_two = discover(2)
      page_one.merge(page_two) { |key, p1, p2| p1 + p2 }
    end

    def call_search_films(query)
      page_one = search(query, 1)
      page_two = search(query, 2)
      page_one.merge(page_two) { |key, p1, p2| p1 + p2 }
    end

    private

    def discover(page)
      response = conn.get("discover/movie") do |req|
        req.params['api_key'] = ENV['TMDB_API_KEY']
        req.params['sort_by'] = 'popularity.desc'
        req.params['page'] = page
      end
      parse_data(response)
    end

    def search(query, page)
      response = conn.get('search/movie') do |req|
        req.params['api_key'] = ENV['TMDB_API_KEY']
        req.params['query'] = query
        req.params['page'] = page
      end
      parse_data(response)
    end

    def conn
      Faraday.new('https://api.themoviedb.org/3/')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
