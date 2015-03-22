require 'spec_helper'
require 'scrapper/app_store'

describe Scrapper do
  it 'has a version number' do
    expect(Scrapper::VERSION).not_to be nil
  end

  it 'check class methods' do
    expect(Scrapper::AppStore.countries.length).to eq(4)
    expect(Scrapper::AppStore.genres.length).to eq(38)
    expect(Scrapper::AppStore.game_genres.length).to eq(19)
    expect(Scrapper::AppStore.country_id("JP")).to eq("143462")
    expect(Scrapper::AppStore.category_name(1)).to eq("toppaidapplications")
    expect(Scrapper::AppStore.ranking_url(Scrapper::AppStore.category_name(1),1)).to eq("https://itunes.apple.com/jp/rss/toppaidapplications/limit=1/json")
    expect(Scrapper::AppStore.ranking_genre_url(Scrapper::AppStore.category_name(1),Scrapper::AppStore.genre_name(1),1)).to eq("https://itunes.apple.com/jp/rss/toppaidapplications/limit=1/genre=6018/json")
  end

  it 'search app' do
    Scrapper::AppStore.new.search_app("JP","KOLA")
  end

  it 'suggest search app' do
    Scrapper::AppStore.new.suggest_search_app("JP","KOLA")
  end

  it 'ranking app' do
    result = Scrapper::AppStore.new.ranking_app("JP",0,100)
    result = Scrapper::AppStore.new.ranking_genre_app("JP",1,0,100)
    puts result
  end
end
