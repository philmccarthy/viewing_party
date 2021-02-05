class MovieDbFacade
  class << self
    def discover_films
      json = MovieDbService.call_top_films
      create_films(json)
    end

    def search_films(query)
      json = MovieDbService.call_search_films(query)
      create_films(json)
    end

    private

    def create_films(json)
      json[:results].map do |film_data|
        Film.new(film_data)
      end
    end
  end
end
