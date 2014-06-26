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

require './lib/positive_words_matcher'
require './lib/negative_words_matcher'

class SimpleSentimentAnalyzer

  def initialize()
    @positive_words_matcher = PositiveWordsMatcher.new
    @negative_words_matcher = NegativeWordsMatcher.new
  end

  def calculate_sentiment(text)
    positive_words = @positive_words_matcher.positive_words(text)
    negative_words = @negative_words_matcher.negative_words(text)
    positive_count = positive_words.values().inject{|sum,x|  sum+x}
    negative_count = negative_words.values().inject{|sum,x| sum+x}
    positive_count = positive_count.to_f ? positive_count : 0.0
    if not positive_count
      positive_count = 0 
    end
    if not negative_count
      negative_count = 0.0
    end
    total = positive_count + negative_count
    if total>0
      return positive_count.to_f-negative_count.to_f / total
    end
    return 0.0
  end
end

if __FILE__ == $0
  analyzer = SimpleSentimentAnalyzer.new
  sentiment = analyzer.calculate_sentiment("Esta es un atraco")
  p "Sentiment: #{sentiment}"
end
