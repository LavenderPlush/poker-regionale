extends Node
class_name Deck

var cards: Array[Card]

func _init() -> void:
	cards = []
	for suit in Card.Suits:
		for i in range(1, 14):
			var new_card = Card.new(suit, i)
			cards.append(new_card)
	
	cards.shuffle()

func draw() -> Card:
	return cards.pop_back()
