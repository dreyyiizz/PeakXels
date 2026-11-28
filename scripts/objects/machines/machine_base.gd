extends StaticBody2D

enum MachineState {
	LOCKED,
	AVAILABLE,
	CHALLENGE_ACTIVE,
	RESTORED
}

signal state_changed(new_state: MachineState)

var current_state: MachineState = MachineState.LOCKED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var interaction_area = $InteractionArea
	
	interaction_area.player_entered.connect(_on_player_entered)
	interaction_area.player_exited.connect(_on_player_exited)
	
	state_changed.connect(_on_state_change)

# This is giving notification or message that player enters and exits the range around the machine
func _on_player_entered() -> void:
	print("Player entered the machine interaction range.")
	
func _on_player_exited() -> void:
	print("Player exited the machine interaction range.")

# This needs adjustment in the future regarding actual response
func _on_state_change(new_state: MachineState) -> void:
	print("Signal received. New machine state:", MachineState.keys()[new_state])

# This for the state management of the machine when player interacts
func set_machine_state(new_state: MachineState) -> void:
	var is_valid_transition := false
	
	# This is for proper transition of machine states.
	# Proper flow like: Locked first then when sub challenges are finished, the machine will be available then challenge is active, then after finishing, it will be restored.
	match current_state:
		MachineState.LOCKED:
			is_valid_transition = new_state == MachineState.AVAILABLE
		
		MachineState.AVAILABLE:
			is_valid_transition = new_state == MachineState.CHALLENGE_ACTIVE
		
		MachineState.CHALLENGE_ACTIVE:
			is_valid_transition = new_state == MachineState.RESTORED
	
	if is_valid_transition:
		current_state = new_state
		state_changed.emit(current_state)
		print("Machine change state to: ", MachineState.keys()[current_state])
	else:
		print("Invalid machine state transition")
	
func start_challenge() -> void:
	if current_state == MachineState.AVAILABLE:
		set_machine_state(MachineState.CHALLENGE_ACTIVE)

func restore_machine() -> void:
	if current_state == MachineState.CHALLENGE_ACTIVE:
		set_machine_state(MachineState.RESTORED)

# This is for how the machine will be unlocked from locked state
func unlock_machine() -> void:
	if current_state == MachineState.LOCKED:
		set_machine_state(MachineState.AVAILABLE)
	
	
	
	
