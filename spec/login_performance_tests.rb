require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load'

def setup_driver
  Selenium::WebDriver.for :chrome
end

RSpec.describe 'Performance Tests' do
  before(:all) do
    @driver = setup_driver
    @driver.manage.window.maximize
    @base_url = 'https://www.hudl.com/login'
  end

  after(:all) do
    @driver.quit
  end

  it 'checks page load performance' do
    start_time = Time.now
    @driver.navigate.to @base_url
    load_time = Time.now - start_time

    puts "Page load time: #{load_time} seconds"
    expect(load_time).to be < 5 # Ensure the page loads within 5 seconds
  end
end
