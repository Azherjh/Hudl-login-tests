require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load'
require_relative '../page_objects/login_page'

def setup_driver
  Selenium::WebDriver.for :chrome
end

RSpec.describe 'Security Tests' do
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

  it 'checks for HTTPS and secure cookies' do
    @driver.navigate.to @base_url
    url = @driver.current_url

    # Check that the page is served over HTTPS
    expect(url).to start_with('https://')

    cookies = @driver.manage.all_cookies

    # Verify all cookies are secure and HttpOnly
    cookies.each do |cookie|
      puts "Cookie: #{cookie[:name]}, Secure: #{cookie[:secure]}, HttpOnly: #{cookie[:http_only]}"
      expect(cookie[:secure]).to be_truthy # All cookies should be marked as secure
      expect(cookie[:http_only]).to be_truthy # All cookies should be HttpOnly
    end
  end

  it 'verifies login email field is protected against SQL injection' do
    sql_email_payload = [
      {email: "' OR '1'='1--", password: ""},
      {email: "admin' #", password: ""},
      {email: "admin' --", password: ""},
      {email: "admin' /*", password: ""},
      {email: "' or 1=1#", password: ""},
      {email: "' or 1=1/*", password: ""}
    ]
    
    # Typical SQL injection payload
    sql_email_payload.each do |credentials|
      @login_page.navigate_to(@base_url)
      @login_page.login(credentials[:email], credentials[:password])

    # Wait for the error message to appear
      error_message = Selenium::WebDriver::Wait.new(timeout: 10).until do
        @login_page.error_message
      end
      expect(error_message).to include("Enter a valid email.")
    end  
  end

  it 'verifies login password field is protected against SQL injection' do
    sql_email_payload = [
      {email: @email, password: "' OR '1'='1--"},
      {email: @email, password: "admin' #"},
      {email: @email, password: "admin' --"},
      {email: @email, password: "admin' /*"},
      {email: @email, password: "' or 1=1#"},
      {email: @email, password: "' or 1=1/*"}
    ]
    
    # Typical SQL injection payload
    sql_email_payload.each do |credentials|
      @login_page.navigate_to(@base_url)
      @login_page.login(credentials[:email], credentials[:password])

    # Wait for the error message to appear
      error_message = Selenium::WebDriver::Wait.new(timeout: 10).until do
        @login_page.error_message
      end
      expect(error_message).to include("Your email or password is incorrect. Try again.")
    end  
  end 
end
