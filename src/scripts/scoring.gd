extends Node
class_name Scoring

###
### Evaluation pipeline:
###  1. check hand type value
###  2. suit precedence
###  3. rank precedence
### 
### returns a scoring object for comparison with other scoring objects
###

enum Hands {
	STRAIGHT_FLUSH,
	FOUR_OF_A_KIND,
	RAINBOW_FLUSH, # CUSTOM
	FULL_HOUSE,
	FLUSH,
	STRAIGHT,
	THREE_OF_A_KIND,
	TWO_PAIR,
	ONE_PAIR,
	HIGH_CARD,
}

var cards: Array[Card]
var cards_rank_sorted: Array[Card]
var cards_suit_sorted: Array[Card]


var hand_type: Hands
var best_suit: Card.Suits
var best_rank: int

func _init(cards_in_hand: Array[Card]) -> void:
	cards = cards_in_hand
	cards_rank_sorted = cards.duplicate_deep()
	cards_rank_sorted.sort_custom(Card.rank_sort)
	cards_suit_sorted = cards.duplicate_deep()
	cards_suit_sorted.sort_custom(Card.suit_sort)
	
	evaluate_hand_type()


func evaluate_hand_type() -> void:
	cards.sort_custom(Card.rank_sort)
	for hand in Hands:
		print(cards)
