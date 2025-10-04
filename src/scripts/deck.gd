extends Node
class_name Deck

var cards: Array[Card]
var played_cards: Array[Card]

func _init() -> void:
	cards = []
	for i in range(len(Card.Suits)):
		for j in range(1, 14):
			var new_card = Card.new(i, j)
			cards.append(new_card)
	
	cards.shuffle()

func draw() -> Card:
	# THIS WILL RESULT IN DUPLICATE CARDS :D
	if cards.size() == 0:
		cards = played_cards
		played_cards = []
	var card = cards.pop_back()
	played_cards.append(card)
	return card
