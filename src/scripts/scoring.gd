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


# NOTE: To anyone reading this script: I'M SORRY 🥲 - Benjamin


enum Hands {
	STRAIGHT_FLUSH,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	FLUSH,
	STRAIGHT,
	THREE_OF_A_KIND,
	TWO_PAIR,
	RAINBOW_FLUSH, # CUSTOM
	ONE_PAIR,
	HIGH_CARD,
}

var cards: Array[Card]
var cards_rank_sorted: Array[Card]
var cards_suit_sorted: Array[Card]

var hand_type: Hands
var best_suit: Card.Suits
var best_rank: int
var score: int = 0


func get_score_function(hand: Hands) -> Array[Array]:
	match hand:
		Hands.STRAIGHT_FLUSH:
			return score_straight_flushes()
		Hands.FOUR_OF_A_KIND:
			return score_four_of_a_kinds()
		Hands.FULL_HOUSE:
			return score_full_houses()
		Hands.FLUSH:
			return score_flushes()
		Hands.STRAIGHT:
			return score_straights()
		Hands.THREE_OF_A_KIND:
			return score_three_of_a_kinds()
		Hands.TWO_PAIR:
			return score_two_pair()
		Hands.RAINBOW_FLUSH:
			return score_rainbow_flushes()
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
	var high_cards: Array[Array] = []
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
			for j in range(i + 1, len(pairs)):
				var two_pair = pairs[i].duplicate(true)
				two_pair.append_array(pairs[j])
				assert(len(two_pair) == 4)
				two_pairs.append(two_pair)
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

func find_rank(rank: int) -> Card:
	for card in cards_rank_sorted:
		if card.rank == rank:
			return card
	return null

func find_suit(suit: Card.Suits) -> Card:
	for card in cards_suit_sorted:
		if card.suit == suit:
			return card
	return null

func score_straights() -> Array[Array]:
	var straights: Array[Array] = []
	for i in range(len(cards) - 4):
		var first_card = cards_rank_sorted[i]
		var second_card = find_rank(first_card.rank + 1)
		var third_card = find_rank(first_card.rank + 2)
		var fourth_card = find_rank(first_card.rank + 3)
		var fifth_card = find_rank(first_card.rank + 4)
		if second_card and third_card and fourth_card and fifth_card:
			straights.append([first_card, second_card, third_card, fourth_card, fifth_card])
		if first_card.rank == 1:
			var ten = find_rank(10)
			var jack = find_rank(11)
			var queen = find_rank(12)
			var king = find_rank(13)
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
	if pairs and three_of_a_kinds:
		for pair in pairs:
			assert(len(pair) == 2)
			for three_of_a_kind in three_of_a_kinds:
				assert(len(three_of_a_kind) == 3)
				var is_overlapping = false
				for pair_card: Card in pair:
					for three_of_a_kind_card: Card in three_of_a_kind:
						if pair_card.equals(three_of_a_kind_card):
							is_overlapping = true
							break
					if is_overlapping:
						break
				if not is_overlapping:
					var full_house = pair.duplicate(true)
					full_house.append_array(three_of_a_kind)
					assert(len(full_house) == 5)
					full_houses.append(full_house)
	return full_houses


func score_rainbow_flushes() -> Array[Array]:
	var heart: Card = find_suit(Card.Suits.HEART)
	var diamond: Card = find_suit(Card.Suits.DIAMOND)
	var club: Card = find_suit(Card.Suits.CLUB)
	var spade: Card = find_suit(Card.Suits.SPADE)
	
	if heart and diamond and club and spade:
		return [[heart, diamond, club, spade]]
	else:
		return []

func score_four_of_a_kinds() -> Array[Array]:
	var four_of_a_kinds: Array[Array] = []
	for i in range(len(cards) - 3):
		var first_card = cards_rank_sorted[i]
		var second_card = cards_rank_sorted[i + 1]
		var third_card = cards_rank_sorted[i + 2]
		var fourth_card = cards_rank_sorted[i + 3]
		if (
			first_card.rank == second_card.rank and 
			first_card.rank == third_card.rank and
			first_card.rank == fourth_card.rank
		):
			four_of_a_kinds.append([first_card, second_card, third_card, fourth_card])
	return four_of_a_kinds

func score_straight_flushes() -> Array[Array]:
	var straight_flushes: Array[Array] = []
	var straights = score_straights()
	for straight: Array in straights:
		var first_suit: Card.Suits = straight[0].suit
		var second_suit: Card.Suits = straight[1].suit
		var third_suit: Card.Suits = straight[2].suit
		var fourth_suit: Card.Suits = straight[3].suit
		var fifth_suit: Card.Suits = straight[4].suit
		if (
			first_suit == second_suit and
			first_suit == third_suit and
			first_suit == fourth_suit and
			first_suit == fifth_suit
		):
			straight_flushes.append(straight)
	return straight_flushes

func _init(cards_in_hand: Array[Card]) -> void:
	cards = cards_in_hand.duplicate(true)
	cards_rank_sorted = cards.duplicate_deep()
	cards_rank_sorted.sort_custom(Card.rank_sort)
	cards_suit_sorted = cards.duplicate_deep()
	cards_suit_sorted.sort_custom(Card.suit_sort)
	
	var found_hands: Array[Array] = evaluate_hand_type()
	var hands_filtered_by_suit: Array[Array] = filter_suits(found_hands)
	var final_hand: Array = filter_ranks(hands_filtered_by_suit)
	best_suit = get_best_suit(final_hand)
	best_rank = get_best_rank(final_hand)
	print("Found best suit: " + str(best_suit))
	print("Found best rank: " + str(best_rank))
	
	score = (20 - hand_type) * 1000 + best_suit * 100 + best_rank

func evaluate_hand_type() -> Array[Array]:
	print(cards.map(func (card): return str(card.suit) + ", " + str(card.rank)))
	for i in range(len(Hands)):
		var curr_hand_type: Hands = i as Hands
		var found_hands: Array[Array] = get_score_function(curr_hand_type)
		if found_hands:
			hand_type = curr_hand_type
			print("Found hand type: " + str(curr_hand_type))
			return found_hands
	print("Couldn't find ANY hand type")
	assert(false)
	return []

func score_suits(hand: Array) -> int:
	var hearts: int = 0
	var diamonds: int = 0
	var clubs: int = 0
	var spades: int = 0
	for card in hand:
		match card.suit:
			Card.Suits.HEART:
				hearts += 1
			Card.Suits.DIAMOND:
				diamonds += 1
			Card.Suits.CLUB:
				clubs += 1
			Card.Suits.SPADE:
				spades += 1
	if hearts: return hearts * 1000
	if diamonds: return diamonds * 100
	if clubs: return clubs * 10
	if spades: return spades
	return 0

func get_best_suit(hand: Array) -> Card.Suits:
	var hearts: int = 0
	var diamonds: int = 0
	var clubs: int = 0
	for card in hand:
		match card.suit:
			Card.Suits.HEART:
				hearts += 1
			Card.Suits.DIAMOND:
				diamonds += 1
			Card.Suits.CLUB:
				clubs += 1
	if hearts: return Card.Suits.HEART
	if diamonds: return Card.Suits.DIAMOND
	if clubs: return Card.Suits.CLUB
	return Card.Suits.SPADE

func get_best_rank(hand: Array) -> int:
	hand.sort_custom(Card.rank_sort)
	return hand[0].rank

func score_ranks(hand: Array) -> int:
	var min_rank: int = 100_000
	for card in hand:
		if card.rank < min_rank:
			min_rank = card.rank
	assert(min_rank != 100_000)
	return min_rank

func filter_suits(found_hands: Array[Array]) -> Array[Array]:
	var filtered_hands: Array[Array] = []
	var hand_suit_scores: Array[int] = []
	for hand in found_hands:
		var squeeb = score_suits(hand)
		hand_suit_scores.append(squeeb)
	var highest_suit_score: int = hand_suit_scores.max()
	for i in range(len(found_hands)):
		var hand_suit_score = hand_suit_scores[i]
		var hand = found_hands[i]
		if hand_suit_score == highest_suit_score:
			filtered_hands.append(hand)
	return filtered_hands

func filter_ranks(found_hands: Array[Array]) -> Array:
	assert(len(found_hands))
	found_hands.sort_custom(func(a, b): return score_ranks(a) < score_ranks(b))
	return found_hands[0]
