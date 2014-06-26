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

#require 'net/http'
require 'httparty'
require 'uri'
require 'json'

class ServiceClient

  def initialize(service_url, token)
    @service_url = service_url
    @token = token
  end

  def request(input)
    body = JSON.dump(input)
    headers = {'x-eurosentiment-token'=> @token}
    response = HTTParty.post(@service_url, {:headers=> headers, :body=> body})
    return JSON.load(response.body)
  end
end


class ResourceClient
  def initialize(resource_url, token)
    @resource_url = resource_url
    @token = token
  end


  def request(input)
    body = JSON.dump(input)
    headers = {'x-eurosentiment-token' => @token, 'Content-Type' => "application/json"}
    response = HTTParty.post(@resource_url, {:headers=>headers, :body=>body})
    return JSON.load(response.body)
  end

end

if __FILE__ == $0
  require './conf/configuration'
  require './lib/sparql_queries'
  serv_client = ServiceClient.new(LANG_DETECTION_URL, TOKEN)
  #lang_result = serv_client.request({"text"=>"Everything was good"})
  lang_result = serv_client.request({"text"=>"Todo muy bueno"})
  resource_client = ResourceClient.new(RESOURCES_URL, TOKEN)
  language = lang_result["dc:language"]
  query = ELECTRONICS_POSITIVE_ENTRIES % language
  p query
  input = {"query"=> query,
           "format"=> "application/json"}
  resources_result = resource_client.request(input)
  p "resources_result #{resources_result}"

end

