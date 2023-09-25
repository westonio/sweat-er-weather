require 'rails_helper'

RSpec.describe Forecast, type: :poro do
  describe 'Instance Methods', :vcr do
    before(:each) do
      @location = "Taipei"
      @quantity = 3
      @book_data = BooksService.new.get_books(@location, @quantity)
      @weather = WeatherFacade.new(@location).forecast
      @book = Book.new(@location, @weather, @book_data)
    end

    it 'exists' do
      expect(@book).to be_a(Book)
    end

    it 'has attributes for id, destination, forecast, total books found, and books' do
      expect(@book.id).to eq(nil) # Needs to be null in json response
      expect(@book.destination).to eq(@location)
      expect(@book.forecast).to be_a(Hash)
      expect(@book.total_books_found).to be_an(Integer)
      expect(@book.books).to be_an(Array)
    end

    it 'can format book data into required format' do
      book_data = {:key=>"/works/OL24411582W",
                    :type=>"work",
                    :seed=>["/books/OL32333152M", "/books/OL33434012M", "/books/OL34737572M", "/books/OL33612124M", "/books/OL34716676M", "/works/OL24411582W", "/subjects/city_planning_asia", "/authors/OL2698054A"],
                    :title=>"Globalizing Taipei",
                    :title_suggest=>"Globalizing Taipei",
                    :title_sort=>"Globalizing Taipei",
                    :edition_count=>5,
                    :edition_key=>["OL32333152M", "OL33434012M", "OL34737572M", "OL33612124M", "OL34716676M"],
                    :publish_date=>["2005", "Jun 14, 2005", "2006"],
                    :publish_year=>[2005, 2006],
                    :first_publish_year=>2005,
                    :number_of_pages_median=>272,
                    :isbn=>["9781134326303", "9781134326280", "041575903X", "1134326300", "1134326289", "9781134326310", "1134326319", "1280435704", "9781280435706", "9780415759038"],
                    :last_modified_i=>1673943351,
                    :ebook_count_i=>0,
                    :ebook_access=>"no_ebook",
                    :has_fulltext=>false,
                    :public_scan_b=>false,
                    :cover_edition_key=>"OL32333152M",
                    :cover_i=>10955461,
                    :publisher=>["Taylor & Francis Group", "Routledge"],
                    :language=>["eng"],
                    :author_key=>["OL2698054A"],
                    :author_name=>["Reginald Kwok"],
                    :subject=>["City planning, asia"],
                    :publisher_facet=>["Routledge", "Taylor & Francis Group"],
                    :subject_facet=>["City planning, asia"],
                    :_version_=>1767915655595556864,
                    :author_facet=>["OL2698054A Reginald Kwok"],
                    :subject_key=>["city_planning_asia"]
                  }
      expected = {
                    isbn: ["9781134326303", "9781134326280", "041575903X", "1134326300", "1134326289", "9781134326310", "1134326319", "1280435704", "9781280435706", "9780415759038"],
                    title: "Globalizing Taipei"
                  }

      expect(@book.send(:format_book, book_data)).to eq(expected)
    end

    it 'can format weather data into required format' do
      weather_data = {
                      :last_updated=>"2023-09-26 00:45", 
                      :temperature=>82.4, 
                      :feels_like=>92.5, 
                      :humidity=>84, 
                      :uvi=>1.0, 
                      :visibility=>6.0, 
                      :condition=>"Clear", 
                      :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"}

      expected = {
        summary: "Clear",
        temperature: "82.4 °F"
      }

      expect(@book.send(:format_weather, weather_data)).to eq(expected)
    end

    it 'can format numerous books from the data' do
      book_data = [{:key=>"/works/OL24411582W",
                    :type=>"work",
                    :seed=>["/books/OL32333152M", "/books/OL33434012M", "/books/OL34737572M", "/books/OL33612124M", "/books/OL34716676M", "/works/OL24411582W", "/subjects/city_planning_asia", "/authors/OL2698054A"],
                    :title=>"Globalizing Taipei",
                    :title_suggest=>"Globalizing Taipei",
                    :title_sort=>"Globalizing Taipei",
                    :edition_count=>5,
                    :edition_key=>["OL32333152M", "OL33434012M", "OL34737572M", "OL33612124M", "OL34716676M"],
                    :publish_date=>["2005", "Jun 14, 2005", "2006"],
                    :publish_year=>[2005, 2006],
                    :first_publish_year=>2005,
                    :number_of_pages_median=>272,
                    :isbn=>["9781134326303", "9781134326280", "041575903X", "1134326300", "1134326289", "9781134326310", "1134326319", "1280435704", "9781280435706", "9780415759038"],
                    :last_modified_i=>1673943351,
                    :ebook_count_i=>0,
                    :ebook_access=>"no_ebook",
                    :has_fulltext=>false,
                    :public_scan_b=>false,
                    :cover_edition_key=>"OL32333152M",
                    :cover_i=>10955461,
                    :publisher=>["Taylor & Francis Group", "Routledge"],
                    :language=>["eng"],
                    :author_key=>["OL2698054A"],
                    :author_name=>["Reginald Kwok"],
                    :subject=>["City planning, asia"],
                    :publisher_facet=>["Routledge", "Taylor & Francis Group"],
                    :subject_facet=>["City planning, asia"],
                    :_version_=>1767915655595556864,
                    :author_facet=>["OL2698054A Reginald Kwok"],
                    :subject_key=>["city_planning_asia"]},
                  {:key=>"/works/OL20639252W",
                    :type=>"work",
                    :title=>"Loveboat, Taipei",
                    :title_suggest=>"Loveboat, Taipei",
                    :title_sort=>"Loveboat, Taipei",
                    :edition_count=>5,
                    :edition_key=>["OL35258261M", "OL27900361M", "OL32933576M", "OL35973807M", "OL36017431M"],
                    :publish_date=>["2020", "Jan 07, 2020", "2021"],
                    :publish_year=>[2020, 2021],
                    :first_publish_year=>2020,
                    :number_of_pages_median=>208,
                    :publish_place=>["New York, USA"],
                    :lcc=>["PZ-0007.10000000.W43565Lo 2020"],
                    :isbn=>["9781094106465", "9781094106489", "0062957287", "0062957279", "9780062957290", "9780062957276", "0062957295", "1094106461", "9780062957283", "1094106488"],
                    :last_modified_i=>1670133172,
                    :ebook_count_i=>0,
                    :ebook_access=>"no_ebook",
                    :has_fulltext=>false,
                    :public_scan_b=>false,
                    :readinglog_count=>16,
                    :want_to_read_count=>16,
                    :currently_reading_count=>0,
                    :already_read_count=>0,
                    :cover_edition_key=>"OL27900361M",
                    :cover_i=>9255235,
                    :publisher=>["HarperCollins B and Blackstone Publishing", "HarperTeen", "Harpercollins", "HarperCollins Publishers", "Blackstone Pub"],
                    :language=>["eng"],
                    :author_key=>["OL7898165A"],
                    :author_name=>["Abigail Hing Wen"],
                    :subject=>["nyt:young-adult-hardcover=2020-01-26", "New York Times bestseller", "Young adult fiction, diversity & multicultural", "Young adult fiction, coming of age", "Young adult fiction, romance, romantic comedy"],
                    :id_wikidata=>["Q113681573"],
                    :publisher_facet=>["Blackstone Pub", "HarperCollins B and Blackstone Publishing", "HarperCollins Publishers", "HarperTeen", "Harpercollins"],
                    :subject_facet=>["New York Times bestseller", "Young adult fiction, coming of age", "Young adult fiction, diversity & multicultural", "Young adult fiction, romance, romantic comedy", "nyt:young-adult-hardcover=2020-01-26"],
                    :_version_=>1767909043494453248,
                    :lcc_sort=>"PZ-0007.10000000.W43565Lo 2020",
                    :author_facet=>["OL7898165A Abigail Hing Wen"],
                    :subject_key=>["new_york_times_bestseller", "nytyoung-adult-hardcover2020-01-26", "young_adult_fiction_coming_of_age", "young_adult_fiction_diversity__multicultural", "young_adult_fiction_romance_romantic_comedy"]}]

    expected = [
                  {
                    :isbn=>["9781134326303", "9781134326280", "041575903X", "1134326300", "1134326289", "9781134326310", "1134326319", "1280435704", "9781280435706", "9780415759038"], 
                    :title=>"Globalizing Taipei"
                  },
                  {
                    :isbn=>["9781094106465", "9781094106489", "0062957287", "0062957279", "9780062957290", "9780062957276", "0062957295", "1094106461", "9780062957283", "1094106488"], 
                    :title=>"Loveboat, Taipei"
                  }
                ]              
                    
    expect(@book.send(:book_results, book_data)).to eq(expected)
    end
  end
end