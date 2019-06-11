require "open-uri"
require "pry"
require "nokogiri"

#twitter url, linkedin url, github url, blog url, profile quote, and bio

class Scraper
  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)
    index_page.css("div.student-card").map do |card|
      {
        name: card.css("h4.student-name").text,
        location: card.css("p.student-location").text,
        profile_url: card.css("a").attribute("href").value,
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    prof_page = Nokogiri::HTML(html)

    hash_to_ret = {}

    sm = prof_page.css(".social-icon-container")
    sm.children.each do |anchor|
      if anchor.attribute("href")
        url = anchor.attribute("href").value
        if url.include?("twitter.com")
          hash_to_ret[:twitter] = url
        elsif url.include?("linkedin.com")
          hash_to_ret[:linkedin] = url
        elsif url.include?("github.com")
          hash_to_ret[:github] = url
        elsif !url.include?("facebook.com")
          hash_to_ret[:blog] = url
        end
      end
    end
    hash_to_ret[:profile_quote] = prof_page.css(".profile-quote").text
    hash_to_ret[:bio] = prof_page.css(".bio-block p").text

    hash_to_ret
  end
end

puts Scraper.scrape_index_page("fixtures/student-site/index.html")
