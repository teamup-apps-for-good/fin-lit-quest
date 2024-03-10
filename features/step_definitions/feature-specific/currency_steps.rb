Then('I have {string} in {string}') do |amount, field|
case field
    when 'Balance'
        expect(page).to have_content(/Balance: \d+/)
        balance = page.find('p', text: /Balance:/).text.scan(/\d+/).first.to_i
        expect(balance).to eq(amount.to_i)
    else
        raise "Unknown field: #{field}"
    end
end