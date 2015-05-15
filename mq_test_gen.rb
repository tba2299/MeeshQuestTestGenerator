require 'securerandom.rb'

# Allows the user to specify the parameters for
# the surrounding commands tag. Then, returns a String
# representation of the tag.
def createInitialCommandTag

	# specify the g-parameter
	print("Enter the g parameter: ")
	$g_param = $stdin.readline
	while ($g_param !~ /^[0-9]+$/)
		print("Enter a valid g parameter: ")
		$g_param = $stdin.readline
	end

	# specify the pmOrder
	print("\nEnter the pmOrder: ")
	$pm_order = $stdin.readline
	while ($pm_order !~ /^[123]{1}$/)
		print("Enter a valid pmOrder (1, 2, or 3): ")
		$pm_order = $stdin.readline
	end

	# specify the remote width
	print("\nEnter the remote spatial width: ")
	$remote_width = $stdin.readline
	while ($remote_width !~ /^[0-9]+$/)
		print("Enter a valid remote_width: ")
		$remote_width = $stdin.readline
	end

	# specify the remote height
	print("\nEnter the remote spatial height: ")
	$remote_height = $stdin.readline
	while ($remote_height !~ /^[0-9]+$/)
		print("Enter a valid remote_height: ")
		$remote_height = $stdin.readline
	end

	# specify the local width
	print("\nEnter the local spatial width: ")
	$local_width = $stdin.readline
	while ($local_width !~ /^[0-9]+$/)
		print("Enter a valid local_width: ")
		$local_width = $stdin.readline
	end

	# specify the local height
	print("\nEnter the local spatial height: ")
	$local_height = $stdin.readline
	while ($local_height !~ /^[0-9]+$/)
		print("Enter a valid local_height: ")
		$local_height = $stdin.readline
	end

	# chop off new line chars
	$g_param.chomp!
	$pm_order.chomp!
	$remote_width.chomp!
	$remote_height.chomp!
	$local_width.chomp!
	$local_height.chomp!

	return "<commands xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"part3in.xsd\"" +
			" remoteSpatialWidth=\"" + $remote_width + "\" remoteSpatialHeight=\"" + $remote_height +
			"\" localSpatialWidth=\"" + $local_width + "\" localSpatialHeight=\"" + $local_height +
			"\" pmOrder=\"" + $pm_order + "\" g=\"" + $g_param + "\">"

end


# Generates a map airport command for how
# ever many times the user specified.
def generateMapAirport(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {
	
		# generate random or custom values
		if (genRandom)
			new_airport = SecureRandom.hex
			new_airline = SecureRandom.hex
			while (new_airport !~ /^[a-zA-Z]/)
				new_airport = SecureRandom.hex
			end
			while (new_airline !~ /^[a-zA-Z]/)
				new_airline = SecureRandom.hex
			end

			remoteX = rand($remote_width.to_i + 2)
			remoteY = rand($remote_height.to_i + 2)
			localX = rand($local_width.to_i + 5)
			localY = rand($local_height.to_i + 5)
		else
			print("\nEnter an airport name: ")
			new_airport = $stdin.readline.chomp
			print("\nEnter an airline name: ")
			new_airline = $stdin.readline.chomp
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
			print("\nEnter a localX: ")
			localX = $stdin.readline.chomp
			print("\nEnter a localY: ")
			localY = $stdin.readline.chomp
		end

		$airports << new_airport
		xml_result += "\n<mapAirport id=\"1\" name=\"#{new_airport}\" localX=\"#{localX}\"" +
						" localY=\"#{localY}\" remoteX=\"#{remoteX}\"" +
						" remoteY=\"#{remoteY}\" airlineName=\"#{new_airline}\" />"

	}

	return xml_result

end


# Generates a create city command for
# the amount of times that is given.
def generateCreateCity(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generate random or custom values
		if (genRandom)
			new_city = SecureRandom.hex
			while (new_city !~ /^[a-zA-Z]/)
				new_city = SecureRandom.hex
			end

			remoteX = rand($remote_width.to_i + 2)
			remoteY = rand($remote_height.to_i + 2)
			localX = rand($local_width.to_i + 5)
			localY = rand($local_height.to_i + 5)
			radius = rand($remote_width.to_i / 2)
			color = $colors[rand($colors.length)]
		else
			print("\nEnter a city name: ")
			new_city = $stdin.readline.chomp
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
			print("\nEnter a localX: ")
			localX = $stdin.readline.chomp
			print("\nEnter a localY: ")
			localY = $stdin.readline.chomp
			print("\nEnter a radius: ")
			radius = $stdin.readline.chomp
			print("\nEnter a color: ")
			color = $stdin.readline.chomp
		end

		$cities << new_city
		xml_result += "\n<createCity id=\"2\" name=\"#{new_city}\" localX=\"#{localX}\"" +
						" localY=\"#{localY}\" remoteX=\"#{remoteX}\"" +
						" remoteY=\"#{remoteY}\" radius=\"#{radius}\" color=\"#{color}\" />"

	}

	return xml_result

end



# Generates a delete city command and
# removes the city from the city array.
def generateDeleteCity(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generate random or custom values
		if (genRandom)
			cityToDelete = $cities[rand($cities.length)]
		else
			print("\nEnter the name of the city to delete: ")
			cityToDelete = $stdin.readline.chomp
		end

		xml_result += "\n<deleteCity id=\"3\" name=\"#{cityToDelete}\" />"
		$cities.delete(cityToDelete)

	}

	return xml_result

end


# Generates a specified amount of clearAll commands.
def generateClearAll(times_to_gen)

	xml_result = ""
	times_to_gen.times {
		xml_result += "\n<clearAll id=\"4\" />"
	}

	return xml_result

end


# Creates the given number of list cities
# commands and asks to list by name or by
# coordinates each iteration.
def generateListCities(times_to_gen)

	xml_result = ""
	sortBy = ""
	times_to_gen.times {

		print("\nEnter a sort method (name or coordinates): ")
		sortBy = $stdin.readline.chomp
		while (sortBy != "name" && sortBy != "coordinates")
			print("\nEnter a valid sort method (name or coordinates): ")
			sortBy = $stdin.readline.chomp
		end

		xml_result += "\n<listCities id=\"5\" sortBy=\"#{sortBy}\" />"

	}

	return xml_result

end



# Creates the given number of printAvlTree commands.
def generatePrintAvlTree(times_to_gen)

	xml_result = ""
	times_to_gen.times {
		xml_result += "\n<printAvlTree id=\"6\" />"
	}

	return xml_result

end


# Generates 'times_to_gen' number of map road commands.
def generateMapRoad(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			startCity = $cities[rand($cities.length)]
			endCity = $cities[rand($cities.length)]
		else
			print("\nEnter start city of road: ")
			startCity = $stdin.readline.chomp
			print("\nEnter end city of road: ")
			endCity = $stdin.readline.chomp
		end

		xml_result += "\n<mapRoad id=\"7\" start=\"#{startCity}\" end=\"#{endCity}\" />" 
		$roads << "#{startCity} -> #{endCity}"

	}

	return xml_result

end


# Generates an unmap road command a given number of times.
def generateUnmapRoad(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			roadToDelete = $roads[rand($roads.length)]
		else
			print("\nEnter start city of road: ")
			startCity = $stdin.readline.chomp
			print("\nEnter end city of road: ")
			endCity = $stdin.readline.chomp
			roadToDelete = startCity + " -> " + endCity
		end

		extractCities = roadToDelete =~ /^([0-9a-zA-Z]+) -> ([0-9a-zA-Z]+)$/
		xml_result += "\n<unmapRoad id=\"8\" start=\"#{$1}\" end=\"#{$2}\" />" 
		$roads.delete(roadToDelete)

	}

	return xml_result

end



# Generates an unmap airport command a given number of times.
def generateUnmapAirport(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			airportToDelete = $airports[rand($airports.length)]
		else
			print("\nEnter an airport to unmap: ")
			airportToDelete = $stdin.readline.chomp
		end

		xml_result += "\n<unmapAirport id=\"9\" name=\"#{airportToDelete}\" />" 
		$airports.delete(airportToDelete)

	}

	return xml_result

end


# Generates a printPMQuadtree a given number of times for
# randomly selected quadtrees.
def generatePrintPMQuadtree(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			remoteX = rand($remote_width.to_i + 5)
			remoteY = rand($remote_height.to_i + 5)
		else
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
		end

		xml_result += "\n<printPMQuadtree id=\"10\" remoteX=\"#{remoteX}\" remoteY=\"#{remoteY}\" />" 
	
	}

	return xml_result

end



# Generates a saveMap command for the specific number of times.
def generateSaveMap(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			remoteX = rand($remote_width.to_i + 5)
			remoteY = rand($remote_height.to_i + 5)
		else
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
		end

		print("\nEnter a filename for saveMap: ")
		name = $stdin.readline.chomp
		xml_result += "\n<saveMap id=\"11\" name=\"#{name}\" remoteX=\"#{remoteX}\" remoteY=\"#{remoteY}\" />" 

	}

	return xml_result

end


# Generates a specific number of globalRangeCities commands.
def generateGlobalRangeCities(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			remoteX = rand($remote_width.to_i + 5)
			remoteY = rand($remote_height.to_i + 5)
			radius = rand($local_width.to_i / 2)
		else
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
			print("\nEnter a radius: ")
			radius = $stdin.readline.chomp
		end

		xml_result += "\n<globalRangeCities id=\"12\" remoteX=\"#{remoteX}\" remoteY=\"#{remoteY}\" radius=\"#{radius}\" />" 
	
	}

	return xml_result

end


# Generates a given number of nearestCity commands.
def generateNearestCity(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			remoteX = rand($remote_width.to_i + 5)
			remoteY = rand($remote_height.to_i + 5)
			localX = rand($local_width.to_i + 5)
			localY = rand($local_height.to_i + 5)
		else
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
			print("\nEnter a localX: ")
			localX = $stdin.readline.chomp
			print("\nEnter a localY: ")
			localY = $stdin.readline.chomp
		end

		xml_result += "\n<nearestCity id=\"13\" remoteX=\"#{remoteX}\" remoteY=\"#{remoteY}\"" + 
							" localX=\"#{localX}\" localY=\"#{localY}\" />" 

	}

	return xml_result

end


# Generate nearestAirport command a given number of times.
def generateNearestAirport(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# generating random or custom values
		if (genRandom)
			remoteX = rand($remote_width.to_i + 5)
			remoteY = rand($remote_height.to_i + 5)
			localX = rand($local_width.to_i + 5)
			localY = rand($local_height.to_i + 5)
		else
			print("\nEnter a remoteX: ")
			remoteX = $stdin.readline.chomp
			print("\nEnter a remoteY: ")
			remoteY = $stdin.readline.chomp
			print("\nEnter a localX: ")
			localX = $stdin.readline.chomp
			print("\nEnter a localY: ")
			localY = $stdin.readline.chomp
		end

		xml_result += "\n<nearestAirport id=\"14\" remoteX=\"#{remoteX}\" remoteY=\"#{remoteY}\"" + 
							" localX=\"#{localX}\" localY=\"#{localY}\" />" 
	
	}

	return xml_result

end


# Generates a shortestPath command for the provided number of times.
def generateShortestPath(times_to_gen, genRandom)

	xml_result = ""
	times_to_gen.times {

		# determining if need to generate random
		if (genRandom)
			startCity = $cities[rand($cities.length)]
			endCity = $cities[rand($cities.length)]
		else
			print("\nEnter start city: ")
			startCity = $stdin.readline.chomp
			print("\nEnter end city: ")
			endCity = $stdin.readline.chomp
		end

		xml_result += "\n<shortestPath id=\"15\" start=\"#{startCity}\" end=\"#{endCity}\" />" 

	}

	return xml_result
	
end



# Generates an xml comment from user input.
def generateComment

	print("\nEnter a comment: ")
	comment = $stdin.readline.chomp

	return "<!-- #{comment} -->"

end



# Prints the available commands to screen
def printHelpScreen

	puts("\n--- AVAILABLE COMMANDS ---")
	puts("'createCity':  Adds a city to the city dictionary.")
	puts("'deleteCity':  Deletes a city from the city dictionary and possibly the spatial map.")
	puts("'clearAll':  Clears all entries of the dictionaries and spatial map.")
	puts("'listCities':  Lists all cities in dictionary based on name or coordinates.")
	puts("'printAvlTree':  Prints the data stored in the AVL tree.")
	puts("'mapRoad':  Maps a road to the spatial map.")
	puts("'mapAirport':  Maps an airport to the spatial map.")
	puts("'unmapRoad':  Removes a road from the spatial map.")
	puts("'unmapAirport':  Removes an airport from the spatial map.")
	puts("'printPMQuadtree':  Prints the data stored in the spatial map.")
	puts("'saveMap':  Saves the spatial map as an image file.")
	puts("'globalRangeCities':  Locates all metros within the spatial map and lists all cities of these metros.")
	puts("'nearestCity':  Locates the nearest city in the spatial map to the given coordinate.")
	puts("'nearestAirport':  Locates the nearest airport in the spatial map to the given coordinate.")
	puts("'shortestPath':  Finds the shortest path from one city to another.")
	puts("'comment':  Inserts a comment into the generated XML document.")
	puts("'help':  Displays the help menu.")
	puts("'done'/'stop':  Halts the XML document generation.")

end



# Lets the user specify how many tests to generate
# for a specific command.
def generateXMLInput

	# keep generating commands until user specifies
	command = ""
	xml_full_results = ""
	while (command != "done" && command != "stop")

		# specifying the command to add
		print("\nInput command to test (mapRoad, etc.): ")
		command = $stdin.readline.chomp
		while (command !~ /^[a-zA-Z]+$/)
			print("\nInput a valid command to test (mapRoad, etc.): ")
			command = $stdin.readline.chomp
		end

		# specify how many tests to generate
		if (command != "done" && command != "stop" && command != "comment" && command != "help")
			print("\nHow many tests to generate: ")
			test_amount = $stdin.readline.chomp
			while (test_amount !~ /^[0-9]+$/)
				print("Enter a valid number of tests to generate: ")
				test_amount = $stdin.readline.chomp
			end
		end

		# determine whether to generate parameters randomly or custom
		if (command != "done" && command != "stop" && command != "clearAll" && command != "listCities" && command != "printAvlTree" && command != "comment" && command != "help")
			print("\nEnter how to generate parameters (random or custom): ")
			paramGen = $stdin.readline.chomp
			while ((paramGen != "random" && paramGen != "custom" && paramGen.length > 1) || (paramGen.length == 1 && paramGen[0] != 'r' && paramGen[0] != 'c'))
				print("\nEnter a valid way to generate parameters (random or custom): ")
				paramGen = $stdin.readline.chomp
			end
		end

		# determining which tags to create
		if (command == "mapAirport")
			xml_full_results += "\n" + generateMapAirport(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "createCity")
			xml_full_results += "\n" + generateCreateCity(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "deleteCity")
			xml_full_results += "\n" + generateDeleteCity(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "clearAll")
			xml_full_results += "\n" + generateClearAll(test_amount.to_i)
		elsif (command == "listCities")
			xml_full_results += "\n" + generateListCities(test_amount.to_i)
		elsif (command == "printAvlTree")
			xml_full_results += "\n" + generatePrintAvlTree(test_amount.to_i)
		elsif (command == "mapRoad")
			xml_full_results += "\n" + generateMapRoad(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "unmapRoad")
			xml_full_results += "\n" + generateUnmapRoad(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "unmapAirport")
			xml_full_results += "\n" + generateUnmapAirport(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "printPMQuadtree")
			xml_full_results += "\n" + generatePrintPMQuadtree(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "saveMap")
			xml_full_results += "\n" + generateSaveMap(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "globalRangeCities")
			xml_full_results += "\n" + generateGlobalRangeCities(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "nearestCity")
			xml_full_results += "\n" + generateNearestCity(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "nearestAirport")
			xml_full_results += "\n" + generateNearestAirport(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "shortestPath")
			xml_full_results += "\n" + generateShortestPath(test_amount.to_i, paramGen[0] == 'r')
		elsif (command == "comment")
			xml_full_results += "\n" + generateComment
		elsif (command == "help")
			printHelpScreen
		elsif (command != "done" && command != "stop")
			puts("Invalid command was provided.")
		end

	end

	return xml_full_results

end






##################################### CONSTRUCTING XML DOCUMENT ######################################

puts("Hello, welcome to the MeeshQuest-Part3 Test Generator!\n\n")

# used to keep track of cities, airports, roads, and colors
$cities = Array.new
$airports = Array.new
$roads = Array.new
$colors = ["red", "green", "blue", "yellow", "purple", "orange", "black"]

# generating the xml input
xml_input = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
xml_input += createInitialCommandTag
xml_input += generateXMLInput
xml_input += "\n\n</commands>"

# creating the xml file
print("\nEnter a filename: ")
filename = $stdin.readline.chomp
if (filename =~ /.xml$/)
	File.open(filename, "w+") { |file| file.write(xml_input) }
else
	File.open(filename + ".xml", "w+") { |file| file.write(xml_input) }
end


puts("\nSuccessfully completed test generation!\n\n")





