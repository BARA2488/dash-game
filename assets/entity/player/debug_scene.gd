extends CanvasLayer

@onready var label = $Control/Label

func _process(delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var frame_time = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	var nodes = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var primitives = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)

	label.text = "FPS: %d\nFrame time: %.2f ms\nNodes: %d\nDraw calls: %d\nPrimitives: %d" % [
		fps, frame_time, nodes, draw_calls, primitives
	]
