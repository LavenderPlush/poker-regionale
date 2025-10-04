extends Node
class_name Card

enum Suits {
	SPADE,
	CLUB,
	DIAMOND,
	HEART
}

var suit: Suits
var rank: int

static func rank_sort (e1: Card, e2: Card) -> bool:
	if e1.rank == e2.rank:
		return e1.suit > e2.suit
	return e1.rank < e2.rank

static func suit_sort (e1: Card, e2: Card) -> bool:
	if e1.suit == e2.suit:
		return e1.rank < e2.rank
	return e1.suit > e2.suit

func equals(other: Card) -> bool:
	return suit == other.suit and rank == other.rank

func _init(card_suit: Suits, card_rank: int) -> void:
	suit = card_suit
	rank = card_rank
