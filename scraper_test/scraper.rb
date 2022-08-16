require 'nokogiri'
require 'open-uri'
require 'pry'

class TestScraper
  def scrapeFirstUrl
    shopUrl = "https://webscraper.io/test-sites/e-commerce/allinone/computers/laptops"
    unparsedPage = open(shopUrl)
    parsedPage = Nokogiri::HTML(unparsedPage)
    productLink = parsedPage.css('.title').css('a')
    pageUrls = []

    productLink.each do |product|
      productUrl = product.attribute('href').value
      pageUrls << productUrl
    end
    createProductLinks(pageUrls)
  end

  def createProductLinks(pageUrls)
    productList = []
    pageUrls.each do |pageUrl|
      itemUrl = "https://webscraper.io#{pageUrl}"
      productHtml = open(itemUrl)
      doc = Nokogiri::HTML(productHtml)

      productList << doc.css('div.caption')
    end
    createProduct(productList)
  end
  
  def createProduct(productList)
    products = []
    
    productList.each do |product|
      name = product.xpath('//h4/text()').map(&:text)[1]
      price = product.xpath('//h4/text()').map(&:text)[0]
      description = product.css('p.description').text
      
      finalProduct = {
        name: name,
        price: price,
        description: description
      }
      
      products << finalProduct
      # puts products
      puts "\nParsed\n#{finalProduct[:name]}\n#{finalProduct[:price]}\n#{finalProduct[:description]}"
    end
  end
end

scrape = TestScraper.new
scrape.scrapeFirstUrl