require 'json'
require 'uri'
require 'net/http'

require './app/helpers/coin_helper.rb'

Coin.delete_all

def createCoinsFromSymbols

  info_uri = URI("https://api.binance.us/api/v3/exchangeInfo")
  info_res = Net::HTTP.get_response(info_uri)

	if info_res.is_a?(Net::HTTPSuccess)
		symbols_info = JSON(info_res.body)["symbols"]

    symbols_info.each do |symbol_info|

      spot = symbol_info["isSpotTradingAllowed"]

      has_usd_conversion = symbol_info["quoteAsset"] == "USD"

      if spot and has_usd_conversion
        coin = Coin.create(symbol: symbol_info["baseAsset"])
        CoinHelper.getTicker(coin)
        CoinHelper.getDaySummary(coin)
      end

    end
	else
		nil
	end
end

createCoinsFromSymbols