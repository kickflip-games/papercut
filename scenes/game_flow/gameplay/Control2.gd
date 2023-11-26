extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var seconds=0
var minutes=0

var dseconds=0
var dminutes=0


func _on_timer_timeout():
	seconds+=1
	if seconds==60:
		minutes+=1
		seconds=0
	
	if (seconds < 10) && (minutes < 10):
		$timer_label.text = "0" + str(minutes) + ":" + "0" + str(seconds)
	elif(seconds >= 10) && (minutes < 10):
		$timer_label.text = "0" + str(minutes) + ":" + str(seconds)
	elif(seconds < 10) && (minutes >= 10):
		$timer_label.text = str(minutes) + ":" + "0" + str(seconds)
	else:
		$timer_label.text = str(minutes) + ":" + str(seconds)
		
	pass # Replace with function body.

func reset_timer():
	seconds=dseconds
	minutes=dminutes
