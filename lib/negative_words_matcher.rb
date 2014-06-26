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


require './conf/configuration'
require './lib/clients'
require './lib/sparql_queries'
require './utils/text_utils'

class NegativeWordsMatcher

  def initialize()
    @language_detector = ServiceClient.new(LANG_DETECTION_URL, TOKEN)
    @domain_detector = ServiceClient.new(DOMAIN_DETECTION_URL, TOKEN)
    @resource_client = ResourceClient.new(RESOURCES_URL, TOKEN)
  end

  def negative_words(text)
    lang_result = @language_detector.request({"text"=> text})
    language = lang_result["dc:language"]
    domain_result = @domain_detector.request({"text"=> text})
    domain = domain_result["domain"].split(":")[1]
    query = sparql(NEGATIVE_ENTRIES, language, domain)
    input = {"query"=> query,
             "format"=> "application/json"}
    resources_result = @resource_client.request(input)
    sentiment_words = extract_words_from_response(resources_result)
    return matches_count(text, sentiment_words)
  end

  private

  def extract_words_from_response(resources_response)
    words = []
    resources_response.default = {"bindings"=>[]}
    for word in resources_response["results"]["bindings"]
        words << word["wordWithSentiment"]["value"]
    end
    return words
  end

end


if __FILE__== $0
  matcher = NegativeWordsMatcher.new()
  p "Negative words #{matcher.negative_words("estaba todo muy malo mal horrible bueno y muy fino")}"
end
