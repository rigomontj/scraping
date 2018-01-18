require "nokogiri"
require "open-uri"

$tiime = "0" #variable globale égale au temps d'attente entré au lancement du programme 

def get_info
array = []
db = Hash.new
i = 0
j = 0
doc = Nokogiri::HTML(open('https://coinmarketcap.com/'))

doc.css('a.currency-name-container').each do |name| #les noms de cryptos
	File.open('crypto_db_names.txt', 'a') { |file| 
	file.puts(name.text) #feedback de ce que le programme est entrain d'importer
	}
end

File.readlines('crypto_db_names.txt').each do |line| #les noms de cryptos qui sont dans le fichier texte
        array[i] = line[0..-2] #enregistrer le nom(sans le '\n') dans un tableau
        i = i + 1
end

doc.css('a.price').each do |usd| #les prix de cryptos
	File.open('crypto_db_usd.txt', 'a') { |file| 
	file.puts("$" + usd['data-usd']) #feeback de ce que le programme est entrain d'importer
	}
end

File.readlines('crypto_db_usd.txt').each do |line| #pour chaque ligne du fichier texte avec les prix de crypto
        db[(array[j]).to_sym] = line[0..-2] #on associe des keys(nomdelacrypto) avec leurs valeurs(priceusd)
        j = j + 1
end

return db #return le hash

end

def perform
	#prompt de temps avant le prochain refresh
	if $tiime == "0"
		puts "How long do you want to wait between each price update ? :"
		$tiime = gets.chomp
	end
	system "clear"	
	puts get_info
	sleep(1)
	puts "=>  Waiting #{$tiime}s before updating cryptocurrency prices"
	sleep($tiime.to_i)
	perform #lance le programme
end

perform
