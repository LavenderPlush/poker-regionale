extends Node2D

func _ready():
	
	var full_house: Array[Card] = [
		Card.new(Card.Suits.SPADE, 5),
		Card.new(Card.Suits.HEART, 5),
		Card.new(Card.Suits.DIAMOND, 5),
		Card.new(Card.Suits.DIAMOND, 8),
		Card.new(Card.Suits.HEART, 8),
	]
	Scoring.new(full_house)
	
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
	
	var straight_flush: Array[Card] = [
		Card.new(Card.Suits.HEART, 10),
		Card.new(Card.Suits.HEART, 11),
		Card.new(Card.Suits.HEART, 12),
		Card.new(Card.Suits.HEART, 13),
		Card.new(Card.Suits.HEART, 9),
	]
	
	Scoring.new(straight_flush)
	
