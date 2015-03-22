require 'nokogiri'
require 'httpclient'
require 'oj'

module Scrapper
  class AppStore
    def self.countries
      [
        {:name => "JP", :id => '143462'},
        {:name => "US", :id => '143441'},
        {:name => "CN", :id => '143465'},
        {:name => "KR", :id => '143466'},
      ]
    end

    def self.country_id(country_name)
      AppStore.countries.each{|code|
          return code[:id] if code[:name] == country_name;
      }
      nil
    end

    def self.genres
      [
        {:genre_id => 1, :label => 'book', :name => '6018'},
        {:genre_id => 2, :label => 'business', :name => '6000'},
        {:genre_id => 3, :label => 'catalog', :name => '6022'},
        {:genre_id => 4, :label => 'education', :name => '6017'},
        {:genre_id => 5, :label => 'entertainment', :name => '6016'},
        {:genre_id => 6, :label => 'finance', :name => '6015'},
        {:genre_id => 7, :label => 'foot & drink', :name => '6023'},
        {:genre_id => 8, :label => 'game', :name => '6014'},
        {:genre_id => 9, :label => 'health & fitness', :name => '6013'},
        {:genre_id => 10, :label => 'lifestyle', :name => '6012'},
        {:genre_id => 11, :label => 'medical', :name => '6020'},
        {:genre_id => 12, :label => 'music', :name => '6011'},
        {:genre_id => 13, :label => 'navigation', :name => '6010'},
        {:genre_id => 14, :label => 'news', :name => '6009'},
        {:genre_id => 15, :label => 'newsstang', :name => '6021'},
        {:genre_id => 16, :label => 'photo & video', :name => '6008'},
        {:genre_id => 17, :label => 'productivity', :name => '6007'},
        {:genre_id => 18, :label => 'reference', :name => '6006'},
        {:genre_id => 19, :label => 'social networking', :name => '6005'},
        {:genre_id => 20, :name  => '7001',:label => 'Action'},
        {:genre_id => 21, :name  => '7002',:label => 'Adventure'},
        {:genre_id => 22, :name  => '7003',:label => 'Arcade'},
        {:genre_id => 23, :name  => '7004',:label => 'Board'},
        {:genre_id => 24, :name  => '7005',:label => 'Card'},
        {:genre_id => 25, :name  => '7006',:label => 'Casino'},
        {:genre_id => 26, :name  => '7007',:label => 'Dice'},
        {:genre_id => 27, :name  => '7008',:label => 'Educational'},
        {:genre_id => 28, :name  => '7009',:label => 'Family'},
        {:genre_id => 29, :name  => '7010',:label => 'Kids'},
        {:genre_id => 30, :name  => '7011',:label => 'Music'},
        {:genre_id => 31, :name  => '7012',:label => 'Puzzle'},
        {:genre_id => 32, :name  => '7013',:label => 'Racing'},
        {:genre_id => 33, :name  => '7014',:label => 'Role Playing'},
        {:genre_id => 34, :name  => '7015',:label => 'Simulation'},
        {:genre_id => 35, :name  => '7016',:label => 'Sports'},
        {:genre_id => 36, :name  => '7017',:label => 'Strategy'},
        {:genre_id => 37, :name  => '7018',:label => 'Trivia'},
        {:genre_id => 38, :name  => '7019',:label => 'Word'},
      ]
    end

    def self.genre_name(genre_id)
      AppStore.genres.each{|code|
          return code[:name] if code[:genre_id] == genre_id;
      }
      nil
    end


    def self.game_genres
      AppStore.genres.select{|genre| genre[:genre_id] > 19 }
    end

    def self.categories
      [
         {:category_id => 0 ,:name => 'topfreeapplications'},
         {:category_id => 1 ,:name => 'toppaidapplications'},
         {:category_id => 2 ,:name => 'topgrossingapplications'},
         {:category_id => 3 ,:name => 'newapplications'},
      ]
    end

 
    def self.category_name(category_id)
      AppStore.categories.each{|code|
          return code[:name] if code[:category_id] == category_id;
      }
      nil
    end


    def self.detail_url
      "https://play.google.com/store/apps/details"
    end 

    def self.review_url
      "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews"
    end

    def self.search_url
      "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch"
    end

    def self.suggest_url
      "https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints"
    end


    def self.ranking_url(category_name,limit)
      "https://itunes.apple.com/jp/rss/%s/limit=%d/json" % [category_name,limit]
    end

    def self.ranking_genre_url(category_name,genre_name,limit)
        "https://itunes.apple.com/jp/rss/%s/limit=%s/genre=%s/json" % [category_name,limit,genre_name ]
    end

    def store_client
      HTTPClient.new
    end

    def store_header(country_name)
      {
          "User-Agent" => "iTunes/9AppStore/2.0 iOS/7.0.2 model/iPhone5,2 (6; dt:82)",
          'Accept-Language' => "ja",
          'X-Apple-Store-Front' => AppStore.country_id(country_name) + '-9,21 t:native'
      }
    end 

    def search_app(country_name,query)
      result = self.store_client.get AppStore.search_url, {"country"=>country_name,"media" => "software" ,"term" => query} ,self.store_header(country_name)  
      if result.status > 400
          abort("request error")
      else
          return Oj.load(result.body)
      end 
    end
 
   def suggest_search_app(country_name,query)
      result = self.store_client.get AppStore.suggest_url, {"country"=>country_name,"clientApplication" => "Software","media" => "software" ,"term" => query} ,self.store_header(country_name)  
      if result.status > 400
          abort("request error")
      else
          doc =  Nokogiri::XML.parse(result.body)
          result = doc.xpath("//array/dict").map {|node|
            {
              :name => node.at("./string[1]").text,
              :point => node.at("./integer").text,
              :url => node.at("./string[2]").text,
            }
          }
      end 
    end


 
    def ranking_app(country_name,category_id,limit)
      result = self.store_client.get AppStore.ranking_url(Scrapper::AppStore.category_name(category_id),limit), nil ,self.store_header(country_name)  

puts result.body
      if result.status > 400
          abort("request error")
      else
          return Oj.load(result.body)
      end 
    end

    def ranking_genre_app(country_name,category_id,genre_id,limit)
      result = self.store_client.get AppStore.ranking_genre_url(Scrapper::AppStore.category_name(category_id),AppStore.genre_name(genre_id),limit), nil ,self.store_header(country_name)  

puts result.body
      if result.status > 400
          abort("request error")
      else
          return Oj.load(result.body)
      end 
    end



  end

end
