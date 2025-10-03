extends Node
class_name Deck

var cards: Array[Card]

func _init() -> void:
	cards = []
	for i in range(len(Card.Suits)):
		for j in range(1, 14):
			var new_card = Card.new(i, j)
			cards.append(new_card)
	
	cards.shuffle()

func draw() -> Card:
	return cards.pop_back()
