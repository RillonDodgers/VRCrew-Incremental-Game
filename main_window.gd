extends Control

# ============================================================================ #
# global variable definition and importing of Big number asset                 #
# ============================================================================ #
const Big = preload("res://Big.gd")

# Variable Declarations
var currency = Big.new(0)
var currency_per_click = Big.new(1)
var currency_per_second = Big.new(1)
var cps_upgrades = 1
var _timer = null

# ============================================================================ #
# Upgrade costs                                                                #
# ============================================================================ #
var upgrade_costs = {
	'Click': {
		'cost': Big.new(10),
		'increase': Big.new(1.07)
	},
	'CPS': {
		'cost': Big.new(10000),
		'increase': Big.new(1.11)
	},
	'Ozvern': {
		'cost': Big.new(1000),
		'increase': Big.new(1.08)
	},
	'Captain': {
		'cost': Big.new(100000),
		'increase': Big.new(1.10)
	}
}

# ============================================================================ #
# People upgrade costs                                                         #
# ============================================================================ #
var people_costs = {
	'Ozvern': {
		'cost': Big.new(100),
		'increase': Big.new(2),
		'upgrades': Big.new(1)
	},
	'Captain': {
		'cost': Big.new(10000),
		'increase': Big.new(4),
		'upgrades': Big.new(1)
	},
	'Shuun': {
		'cost': Big.new(1000000),
		'increase': Big.new(8),
		'upgrades': Big.new(1)
	}
}

# ============================================================================ #
# Initialize and timeout functions                                             #
# ============================================================================ #
func _ready():
	"""
	This function gets called anytime the game gets initialized and is ready.
	This would be a great place to load up a saved configed once implemented
	into this game. Here, we setup the timout signal for our timer and updates
	the label text of the people costs to be most accurate based on what's
	configured in the dictionary delcared above.
	"""
	_timer = $Timer
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	for person in people_costs:
		var label = get_node(
			"PeopleMenu/ScrollContainer/VBoxContainer/" + person + "/label"
		)
		var cost = people_costs[person]['cost'].toAA()
		var increase = people_costs[person]['increase'].toAA()
		var text = person \
			+ ", increases by " \
			+ increase \
			+ " coins per second\ncost " \
			+ cost
		label.text = text

func _on_Timer_timeout():
	"""Update the money yo!"""
	var cps = Big.new(currency_per_second)
	for person in people_costs:
		cps.plus(_currency_per_second(person))
	currency.plus(cps)


func _process(delta):
	"""
	This function happens every time a frame is updated. It's determined by FPS
	"""
	$currency.text = str(currency.toAA())


func _on_button_clicker_pressed():
	"""Add the currency_per_click variable to the current currency count"""
	currency.plus(currency_per_click)

# ============================================================================ #
# Popup window functions                                                       #
# ============================================================================ #
func _on_button_upgrades_pressed():
	"""Opens Upgrade menu"""
	$UpgradeMenu.popup()


func _on_button_people_pressed():
	"""Opens People menu"""
	$PeopleMenu.popup()


func _on_button_close_upgrades_pressed():
	"""Hides Upgrade menu"""
	$UpgradeMenu.hide()


func _on_button_close_people_pressed():
	"""Hides People menu"""
	$PeopleMenu.hide()

# ============================================================================ #
# Signal functions for all of the people and buy upgrades                      #
# TODO: Refactor the the button upgrades to look like people ones below        #
# ============================================================================ #
func _on_btnBuyClickUpgrade_pressed():
	"""signal function to buy the click upgrade"""
	var cost = upgrade_costs['Click']['cost']
	var increase = upgrade_costs['Click']['increase']
	var cost_copy = Big.new(cost)
	var new_cost = cost_copy.multiply(increase)
	if currency.isLargerThanOrEqualTo(cost):
		currency.minus(cost)
		currency_per_click.plus(1)
		upgrade_costs['Click']['cost'] = new_cost
		var txt = "increase click by 1\nCosts " + new_cost.toAA()
		$UpgradeMenu/ScrollContainer/VBoxContainer/ClickUpgrade/label.text = txt

func _on_btnBuyCPSUpgrade_pressed():
	"""signal function to buy the cps (currency per second) upgrade"""
	var cost = upgrade_costs['CPS']['cost']
	var increase = upgrade_costs['CPS']['increase']
	var cost_copy = Big.new(cost)
	var new_cost = cost_copy.multiply(increase)
	if currency.isLargerThanOrEqualTo(cost):
		currency.minus(cost)
		cps_upgrades += 1
		currency_per_second.multiply(cps_upgrades)
		upgrade_costs['CPS']['cost'] = new_cost
		var text = "increase click by 1\nCosts " + new_cost.toAA()
		$UpgradeMenu/ScrollContainer/VBoxContainer/CPSUpgrade/label.text = text

func _on_btnBuyOzvernUpgrade_pressed():
	"""signal function to buy the ozvern upgrade"""
	var person = 'Ozvern'
	var cost = upgrade_costs[person]['cost']
	var increase = upgrade_costs[person]['increase']
	var cost_copy = Big.new(cost)
	var new_cost = cost_copy.multiply(increase)
	if currency.isLargerThanOrEqualTo(cost):
		currency.minus(cost)
		people_costs[person]['upgrades'].plus(1)
		upgrade_costs[person]['cost'] = new_cost
		var text = "Multiplies " \
			+ person \
			+ "s ability by " \
			+  people_costs[person]['upgrades'].toAA() \
			+ "\nCosts " \
			+ new_cost.toAA()
		$UpgradeMenu/ScrollContainer/VBoxContainer/OzvernUpgrade/label.text = text

func _on_btnBuyCaptainUpgrade_pressed():
	"""signal function to buy the captain upgrade"""
	var person = 'Captain'
	var cost = upgrade_costs[person]['cost']
	var increase = upgrade_costs[person]['increase']
	var cost_copy = Big.new(cost)
	var new_cost = cost_copy.multiply(increase)
	if currency.isLargerThanOrEqualTo(cost):
		currency.minus(cost)
		people_costs[person]['upgrades'].plus(1)
		upgrade_costs[person]['cost'] = new_cost
		var text = "Multiplies " \
			+ person \
			+ "s ability by " \
			+  people_costs[person]['upgrades'].toAA() \
			+ "\nCosts " \
			+ new_cost.toAA()
		$UpgradeMenu/ScrollContainer/VBoxContainer/CaptainUpgrade/label.text = text


func _on_btnBuyOzvern_pressed():
	"""signal function to buy ozvern"""
	buy_person_upgrade("Ozvern")


func _on_btnBuyShuun_pressed():
	"""signal function to buy shuun"""
	buy_person_upgrade("Shuun")


func _on_btnBuyCaptain_pressed():
	"""signal function to buy captain"""
	buy_person_upgrade("Captain")


# ============================================================================ #
# Helper functions                                                             #
# ============================================================================ #
func _currency_per_second(person):
	"""
	Calculates currency per second for a person and their upgrades.
	If the buy button is disabled that means the person has been bought so
	automatically this will return their increase found in the dictionary
	declared at the top. If the amount of upgrades they have is > 1, then it
	will multiply their increase by the amount of upgrades
		ex: Ozvern is a base 2 and has 6 upgrades bought. So it'd come out as 12
			(2 * 6) = 12
	"""
	var buy_button = get_node(
		"PeopleMenu/ScrollContainer/VBoxContainer/" \
			+ person \
			+ "/btnBuy" \
			+ person
	)
	var increase = people_costs[person]['increase']
	var increase_copy = Big.new(increase)
	if buy_button.disabled:
		var upgrades = people_costs[person]['upgrades']
		if upgrades.isLargerThan(Big.new(1)):
			return increase_copy.multiply(upgrades)
		return increase
	return Big.new(0)


func buy_person_upgrade(person):
	"""
	Whatever person gets passed, this function dynamically disables the buy
	button so no money is wasted on something already bought. It gets the node
	based off of the person passed using string concatination.
	"""
	var cost = people_costs[person]['cost']
	var increase = people_costs[person]['increase']
	if currency.isLargerThanOrEqualTo(cost):
		currency.minus(cost)
		# currency_per_second.plus(increase)
		var buy_button = get_node(
			"PeopleMenu/ScrollContainer/VBoxContainer/" \
				+ person \
				+ "/btnBuy" \
				+ person
		)
		buy_button.set_disabled(true)



