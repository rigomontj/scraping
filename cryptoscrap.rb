require "nokogiri"
require "open-uri"

$tiime = "0"

def get_info
array = []
db = Hash.new
i = 0
j = 0
doc = Nokogiri::HTML(open('https://coinmarketcap.com/'))

doc.css('a.currency-name-container').each do |name|
	File.open('crypto_db_names.txt', 'a') { |file| 
	file.puts(name.text)
	}
end

File.readlines('crypto_db_names.txt').each do |line|
        array[i] = line[0..-2]
        i = i + 1
end

doc.css('a.price').each do |usd|
	File.open('crypto_db_usd.txt', 'a') { |file| 
	file.puts("$" + usd['data-usd'])
	}
end

File.readlines('crypto_db_usd.txt').each do |line|
        db[(array[j]).to_sym] = line[0..-2]
        j = j + 1
end

return db

end

def perform
	if $tiime == "0"
		puts "How long do you want to wait between each price update ? :"
		$tiime = gets.chomp
	end
	system "clear"	
	puts get_info
	sleep(1)
	puts "=>  Waiting #{$tiime}s before updating cryptocurrency prices"
	sleep($tiime.to_i)
	perform
end

perform
