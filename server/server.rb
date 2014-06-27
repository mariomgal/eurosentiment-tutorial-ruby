# encoding: utf-8
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
#
#  The original code are licensed under the GNU Lesser General Public License.

require 'json'
require 'sinatra'
require './lib/simple_sentiment_analyzer'

sentiment_analyzer = SimpleSentimentAnalyzer.new()

set :port, 5000

get '/hi' do
  'Hello World'
end

post '/sentiment' do 
  content_type :json
  data = JSON.load(request.body.read)
  text = data["input"]
  sentiment = sentiment_analyzer.calculate_sentiment(text) 
  p "Calculated sentiment: #{sentiment}"
  response = {"@context"=> "http://eurosentiment.eu/contexts/basecontext.jsonld",
                "@type"=> "marl:SentimentAnalysis",
                "marl:polarityValue"=> sentiment}  
  response.to_json
end
