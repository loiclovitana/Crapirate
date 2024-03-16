extends Node

var registered_players : Array[Boat] = []


func register_player(player : Boat):
	if player not in registered_players:
		registered_players.append(player)
