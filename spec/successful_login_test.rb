require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load' # To load environment variables from a .env file
require_relative '../page_objects/login_page' # Require the separate LoginPage file

# Ensure you have a .env file with the following keys:
# HUDL_EMAIL=<your_email>
# HUDL_PASSWORD=<your_password>

def setup_driver
  Selenium::WebDriver.for :chrome
end

RSpec.describe 'Successful Login Tests' do
  before(:all) do
    @driver = setup_driver
    @driver.manage.window.maximize
    @base_url = 'https://www.hudl.com/login'
    @login_page = LoginPage.new(@driver)
    @email = ENV['HUDL_EMAIL']
    @password = ENV['HUDL_PASSWORD']
  end

  after(:all) do
    @driver.quit
  end

  it 'successful login scenario' do
    successful_logins = [
      { email: @email, password: @password }
    ]

    successful_logins.each do |credentials|
      @login_page.navigate_to(@base_url)
      @login_page.login(credentials[:email], credentials[:password])

      # Verify login success by checking for the presence of a dashboard element
      dashboard_element = Selenium::WebDriver::Wait.new(timeout: 10).until {
        @driver.find_element(:css, 'a[href="/home"]')
      }
      expect(dashboard_element.displayed?).to be_truthy
    end
  end
end

