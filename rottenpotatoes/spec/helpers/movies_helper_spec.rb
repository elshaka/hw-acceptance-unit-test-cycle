require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MoviesHelper. For example:
#
# describe MoviesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MoviesHelper, type: :helper do
  describe "#oddness" do
    it "should return 'odd' for odd numbers" do
      odd_numbers = 10.times.map { |n| 2 * rand(n + 1) + 1 }
      odd_numbers.each { |odd_number| expect(oddness(odd_number)).to eq "odd" }
    end

    it "should return 'even' for even numbers" do
      even_numbers = 10.times.map { |n| 2 * rand(n + 1)}
      even_numbers.each { |even_number| expect(oddness(even_number)).to eq "even" }
    end
  end
end
