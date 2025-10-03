extends Node2D

func _ready():
	var deck = Deck.new()
	Scoring.new(deck.cards)
