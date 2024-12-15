require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load'
require_relative '../page_objects/login_page' 

def setup_driver
  Selenium::WebDriver.for :chrome
end

RSpec.describe 'Failing Login Tests' do
  before(:all) do
    @driver = setup_driver
    @driver.manage.window.maximize
    @base_url = 'https://www.hudl.com/login'
    @login_page = LoginPage.new(@driver)
    @valid_email = ENV['HUDL_EMAIL']
    @valid_password = ENV['HUDL_PASSWORD']
  end

  after(:all) do
    @driver.quit
  end

  it 'handles failing login scenarios' do
    failing_logins = [
      { email: 'invalid@example.com', password: 'invalidpassword', error: "Incorrect username or password." },
      { email: 'invalid@@example.com', password: 'password', error: "Enter a valid email." },
      { email: 'invalidemail', password: '', error: "Enter a valid email." },
      { email: 'verylongemail' + ('a' * 255) + '@example.com', password: 'password', error: "Enter a valid email." },
      { email: @valid_email, password: 'invalidpassword', error: "Your email or password is incorrect. Try again." },
      { email: ' ', password: '', error: "Enter a valid email." }, #Added a whitespace in email field
      { email: @valid_email, password: '   ', error: "Your email or password is incorrect. Try again." }, #Added a whitespace in password field
      { email: "!$%&*()/=+~`{}|<>?@example.com", password: 'password', error: "Enter a valid email." },
      { email: 'username@', password: 'password', error: "Enter a valid email." },
      { email: @valid_email, password: '123', error: "Your email or password is incorrect. Try again." },
      { email: @valid_email, password: 'a' * 256, error: "Your email or password is incorrect. Try again." },
      #{ email: nil, password: 'password', error: "Enter a valid email." }, # Add null string to email
      #{ email: @valid_email, password: nil, error: "Your email or password is incorrect. Try again." }
    ]

    failing_logins.each do |credentials|
      @login_page.navigate_to(@base_url)
      @login_page.login(credentials[:email], credentials[:password])

      # Wait for the error message to appear
      error_message = Selenium::WebDriver::Wait.new(timeout: 10).until do
        @login_page.error_message
      end
      expect(error_message).to include(credentials[:error])
    end
  end
end
