extends Node2D

func _ready():
	var deck = Deck.new()
	var example_cards: Array[Card] = [
		deck.cards[0],
		deck.cards[5],
		deck.cards[20],
		deck.cards[40],
		deck.cards[34],
		deck.cards[50],
	]
	Scoring.new(example_cards)
	
