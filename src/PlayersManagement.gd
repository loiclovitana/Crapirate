extends Node

var registered_players : Array[Boat] = []

signal new_player(player : Boat)
signal player_left(player : Boat)

func register_player(player : Boat):
	if player not in registered_players:
		registered_players.append(player)
		new_player.emit(player)
		

func unregister_player(player : Boat):
	if player in registered_players:
		registered_players.erase(player)
		player_left.emit(player)

func clear_players():
	for player in  registered_players:
		player_left.emit(player)
	registered_players.clear()
