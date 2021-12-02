require "binance-ruby"
require 'httparty'
# RestClient.proxy = ENV["IPB_HTTP"]
# response = RestClient.post("http://binance.us/api/v3/order")

module OrderApi


  def self.check_orders
    ENV["BINANCE_API_KEY"] = current_user.binance_public_key
    ENV["BINANCE_SECRET_KEY"] = current_user.encryptedBinanceApiKey
    open_orders = Binance::Api::Order.all_open!
    Binance::Api::Configuration.api_key = nil
    Binance::Api::Configuration.secret_key = nil
    ENV["BINANCE_API_KEY"] = nil
    ENV["BINANCE_SECRET_KEY"] = nil
    open_orders
  end


  def self.account_info(user)
    # reqire_login
    ENV["BINANCE_API_KEY"] = user.binance_public_key
    ENV["BINANCE_SECRET_KEY"] = user.encryptedBinanceApiKey
    info = Binance::Api::Account.info!
    Binance::Api::Configuration.api_key = nil
    Binance::Api::Configuration.secret_key = nil
    ENV["BINANCE_API_KEY"] = nil
    ENV["BINANCE_SECRET_KEY"] = nil
    info
  end


  def self.buy(user, coin, qty)
    # ENV["BINANCE_API_KEY"] = user.binance_public_key
    # ENV["BINANCE_SECRET_KEY"] = user.encryptedBinanceApiKey

    puts qty.to_s
    puts coin.binance_symbol
    # puts ENV["BINANCE_API_KEY"]
    # puts ENV["BINANCE_SECRET_KEY"]

    params = {
      quantity => qty.to_s,
      side => 'BUY',
      symbol => coin.binance_symbol,
      type => 'MARKET'
  }

    puts binance_order_req(params, user.binance_public_key, user.encryptedBinanceApiKey)

    # ENV["BINANCE_TRADING_API_KEY"] = nil
    # ENV["BINANCE_SECRET_KEY"] = nil
  end


  def self.sell(user, coin, qty)
    # require_login
    puts qty.to_s
    puts coin.binance_symbol
    params = {
      quantity => qty.to_s,
      side => 'BUY',
      symbol => coin.binance_symbol,
      type => 'MARKET'
  }

    puts binance_order_req(params, user.binance_public_key, user.encryptedBinanceApiKey)
    # ENV["BINANCE_API_KEY"] = user.binance_public_key
    # ENV["BINANCE_SECRET_KEY"] = user.encryptedBinanceApiKey

    # info = Binance::Api::Account.info!
  
    # sell_response = Binance::Api::Order.create!(
    #   quantity: qty.to_s,
    #   side: 'SELL',
    #   symbol: coin.binance_symbol,
    #   type: 'MARKET'
    # )
    # puts sell_response
    # ENV["BINANCE_API_KEY"] = nil
    # ENV["BINANCE_SECRET_KEY"] = nil
  end

  # For testing 


  def self.check_orders(user)
    ENV["BINANCE_API_KEY"] = user.binance_public_key
    ENV["BINANCE_SECRET_KEY"] = user.encryptedBinanceApiKey
    open_orders = Binance::Api::Order.all_open!
    Binance::Api::Configuration.api_key = nil
    Binance::Api::Configuration.secret_key = nil
    ENV["BINANCE_API_KEY"] = nil
    ENV["BINANCE_SECRET_KEY"] = nil
    open_orders
  end

  private
  include ApiUtils
  include HTTParty

  def binance_order_req(params, api_key, secret_key)
    fixie = URI.parse ENV['FIXIE_URL']
    params.merge!(signature: signed_request_signature(params, secret_key))
    response = post(
      "https://api.binance.us/api/v3/order", 
      query: params, 
      headers: key_header(api_key), 
      http_proxyaddr: fixie.host,
      http_proxyport: fixie.port,
      http_proxyuser: fixie.user,
      http_proxypass: fixie.password
      )
  end

end