@tool
extends LogStream

##A default instance of the LogStream. Instanced as the main log singelton.


func _init():
	# Set to Warn/Info to reduce logs
	super("Main", LogLevel.INFO)
