require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load'
require_relative '../page_objects/login_page'

def setup_driver(browser)
  case browser
  when :chrome
    Selenium::WebDriver.for :chrome
  when :firefox
    Selenium::WebDriver.for :firefox
  when :edge
    Selenium::WebDriver.for :edge
  else
    raise ArgumentError, "Unsupported browser: #{browser}"
  end
end

RSpec.describe 'Successful Login Tests Across Browsers' do
  before(:all) do
    @browsers = [:chrome, :firefox, :edge]
    @base_url = 'https://www.hudl.com/login'
    @valid_email = ENV['HUDL_EMAIL']
    @valid_password = ENV['HUDL_PASSWORD']
  end

  after(:each) do
    #@driver.quit if @driver
  end

  it 'logs in successfully across multiple browsers' do
    @browsers.each do |browser|
      @driver = setup_driver(browser)
      @driver.manage.window.maximize
      @login_page = LoginPage.new(@driver)

      @login_page.navigate_to(@base_url)
      @login_page.login(@valid_email, @valid_password)

      dashboard_element = Selenium::WebDriver::Wait.new(timeout: 10).until {
        @driver.find_element(:css, 'a[href="/home"]')
      }
      expect(dashboard_element.displayed?).to be_truthy

      @driver.quit
    end
  end
end
