# frozen_string_literal: true













When('I fill in {string} with {string}') do |element_name, value|
  fill_in element_name, with: value
end
