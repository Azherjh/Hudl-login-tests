require 'httparty'
require 'rspec'
require 'dotenv/load'
require 'json'

RSpec.describe 'Hudl Login API Tests' do
  before(:all) do
    @base_url = 'https://www.hudl.com/api/v2/login'
    @valid_email = ENV['HUDL_EMAIL']
    @valid_password = ENV['HUDL_PASSWORD']
    @headers = { 'Content-Type' => 'application/json' }
  end

  it 'returns success for valid credentials' do
    payload = { email: @valid_email, password: @valid_password }.to_json
    response = HTTParty.post(@base_url, body: payload, headers: @headers)
    
    expect(response.code).to eq(200)
    expect(response.parsed_response).to include('userId')
    puts "Response Code: #{response.code}, Response Body: #{response.body}"
  end

  it 'returns error for invalid credentials' do
    payload = { email: 'invalid@example.com', password: 'wrongpassword' }.to_json
    response = HTTParty.post(@base_url, body: payload, headers: @headers)
    
    expect(response.code).to eq(401)
    expect(response.parsed_response).to include('error' => 'Invalid credentials')
    puts "Response Code: #{response.code}, Response Body: #{response.body}"
  end

  it 'returns error for missing email field' do
    payload = { password: 'password123' }.to_json
    response = HTTParty.post(@base_url, body: payload, headers: @headers)
    
    expect(response.code).to eq(400)
    expect(response.parsed_response).to include('error' => 'Email is required')
    puts "Response Code: #{response.code}, Response Body: #{response.body}"
  end

  it 'returns error for missing password field' do
    payload = { email: @valid_email }.to_json
    response = HTTParty.post(@base_url, body: payload, headers: @headers)
    
    expect(response.code).to eq(400)
    expect(response.parsed_response).to include('error' => 'Password is required')
    puts "Response Code: #{response.code}, Response Body: #{response.body}"
  end

  it 'handles too many login attempts' do
    5.times do
      payload = { email: 'invalid@example.com', password: 'wrongpassword' }.to_json
      HTTParty.post(@base_url, body: payload, headers: @headers)
    end

    payload = { email: 'invalid@example.com', password: 'wrongpassword' }.to_json
    response = HTTParty.post(@base_url, body: payload, headers: @headers)

    expect(response.code).to eq(429)
    expect(response.parsed_response).to include('error' => 'Too many attempts. Try again later.')
    puts "Response Code: #{response.code}, Response Body: #{response.body}"
  end
end
