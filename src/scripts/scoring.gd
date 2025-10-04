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

func get_score_function(hand: Hands) -> Array[Array]:
	match hand:
		Hands.STRAIGHT_FLUSH:
			return score_template()
		Hands.FOUR_OF_A_KIND:
			return score_template()
		Hands.RAINBOW_FLUSH:
			return score_template()
		Hands.FULL_HOUSE:
			return score_template()
		Hands.FLUSH:
			return score_flushes()
		Hands.STRAIGHT:
			return score_straights()
		Hands.THREE_OF_A_KIND:
			return score_three_of_a_kinds()
		Hands.TWO_PAIR:
			return score_two_pair()
		Hands.ONE_PAIR:
			return score_one_pair()
		Hands.HIGH_CARD:
			return score_high_card()
	return score_template()


func score_template() -> Array[Array]:
	return []


func score_high_card() -> Array[Array]:
	#var highest_card: Card = cards_suit_sorted.get(cards.size() - 1)
	#var high_cards: Array[Array] = []
	#if highest_card:
	#	for card in cards_rank_sorted:
	#		if card.suit == highest_card.suit:
	#			high_cards.append(card)
	#	return high_cards
	#return high_cards
	var high_cards = []
	for card in cards:
		high_cards.append([card])
	return high_cards

func score_one_pair() -> Array[Array]:
	var pairs: Array[Array] = []
	var prev_card: Card = null
	for card: Card in cards_rank_sorted:
		if prev_card and prev_card.rank == card.rank:
			pairs.append([prev_card, card])
		prev_card = card
	return pairs

func score_two_pair() -> Array[Array]:
	var pairs: Array[Array] = score_one_pair()
	var two_pairs: Array[Array] = []
	if pairs.size() >= 2:
		for i in range(len(pairs)):
			for j in range(i, len(pairs)):
				if i != j:
					var two_pair = pairs[i]
					two_pair.append_array(pairs[j])
	return two_pairs

func score_three_of_a_kinds() -> Array[Array]:
	var three_of_a_kinds: Array[Array] = []
	for i in range(len(cards) - 2):
		var first_card = cards_rank_sorted[i]
		var second_card = cards_rank_sorted[i + 1]
		var third_card = cards_rank_sorted[i + 2]
		if first_card.rank == second_card.rank and second_card.rank == third_card.rank:
			three_of_a_kinds.append([first_card, second_card, third_card])
	return three_of_a_kinds

func find_card(rank: int) -> Card:
	for card in cards_rank_sorted:
		if card.rank == rank:
			return card
	return null

func score_straights() -> Array[Array]:
	var straights: Array[Array] = []
	for i in range(len(cards) - 4):
		var first_card = cards_rank_sorted[i]
		var second_card = find_card(first_card.rank + 1)
		var third_card = find_card(first_card.rank + 2)
		var fourth_card = find_card(first_card.rank + 3)
		var fifth_card = find_card(first_card.rank + 4)
		if second_card and third_card and fourth_card and fifth_card:
			straights.append([first_card, second_card, third_card, fourth_card, fifth_card])
		if first_card.rank == 1:
			var ten = find_card(10)
			var jack = find_card(11)
			var queen = find_card(12)
			var king = find_card(13)
			if ten and jack and queen and king:
				straights.append([ten, jack, queen, king, first_card])
	return straights

func score_flushes() -> Array[Array]:
	var flushes: Array[Array] = []
	for i in range(len(cards) - 4):
		var first_card = cards_suit_sorted[i]
		var second_card = cards_suit_sorted[i + 1]
		var third_card = cards_suit_sorted[i + 2]
		var fourth_card = cards_suit_sorted[i + 3]
		var fifth_card = cards_suit_sorted[i + 4]
		if (
			first_card.suit == second_card.suit and
			first_card.suit == third_card.suit and 
			first_card.suit == fourth_card.suit and 
			first_card.suit == fifth_card.suit
		):
			flushes.append([first_card, second_card, third_card, fourth_card, fifth_card])
	return flushes

func score_full_houses() -> Array[Array]:
	var full_houses: Array[Array] = []
	var pairs = score_one_pair()
	var three_of_a_kinds = score_three_of_a_kinds()
	return full_houses

func _init(cards_in_hand: Array[Card]) -> void:
	cards = cards_in_hand
	cards_rank_sorted = cards.duplicate_deep()
	cards_rank_sorted.sort_custom(Card.rank_sort)
	cards_suit_sorted = cards.duplicate_deep()
	cards_suit_sorted.sort_custom(Card.suit_sort)
	
	evaluate_hand_type()

func evaluate_hand_type() -> Array[Array]:
	print(cards.map(func (card): return str(card.suit) + ", " + str(card.rank)))
	for i in range(len(Hands)):
		var curr_hand_type: Hands = i as Hands
		var found_score: Array[Array] = get_score_function(curr_hand_type)
		if found_score:
			hand_type = curr_hand_type
			return found_score
	return []
