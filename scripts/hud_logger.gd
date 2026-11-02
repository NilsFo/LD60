extends RichTextLabel

signal message_printed(message: String,error:bool)
@export var show_fps:bool=true
@export var show_console:bool=true

class PrintCapture extends Logger:
    var target: Node

    func _init(node: Node) -> void:
        target = node

    func _log_message(message: String, error: bool) -> void:
        target.call_deferred(
            "emit_signal", "message_printed", message, error
        )

    func _log_error(
        function: String,
        file: String,
        line: int,
        code: String,
        rationale: String,
        editor_notify: bool,
        error_type: int,
        script_backtraces: Array[ScriptBacktrace]
    ) -> void:
        pass

class LogEntry:
    var _timer:float
    var text:String
    var error:bool
    var time:String
    
    func _init(p_timer:float,p_text:String,p_error:bool) -> void:
        _timer=p_timer
        text=p_text
        error=p_error
        
        time=Time.get_time_string_from_system()
    
    func tick(delta:float):
        _timer-=delta
        
    func is_expired()->bool:
        return _timer<=0

var _logger: PrintCapture
var _log_archive:Array[LogEntry]

func _init() -> void:
    _log_archive = []
    _logger = PrintCapture.new(self)
    OS.add_logger(_logger)

func _exit_tree() -> void:
    OS.remove_logger(_logger)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    message_printed.connect(_on_printed)
    
    # Setting initial flags so devs don't need to do that every time
    set_mouse_filter(MOUSE_FILTER_IGNORE)
    set_mouse_behavior_recursive(MOUSE_BEHAVIOR_DISABLED)
    scroll_active=false


func _on_printed(message: String, error: bool) -> void:
    # Called for each printed message!
    var new_entry:LogEntry = LogEntry.new(3.0,message,error)
    _log_archive.append(new_entry)

func _process(delta: float) -> void:
    var log_text:String = ""
    var logs_to_delete:Array[LogEntry] = []
    
    # Adding the current FPS as the first element of the log
    if show_fps:
        log_text="FPS: " + str(int(Engine.get_frames_per_second()))+"\n"
    
    # looping through all logs and updating their internal timers
    # then adding their text to the main text
    if show_console:
        for l:LogEntry in _log_archive:
            l.tick(delta)
            if l.is_expired():
                logs_to_delete.append(l)
            
            log_text=log_text+"["+l.time+"] "+l.text
        
        # removing the logs that were marked for death
        for l in logs_to_delete:
            _log_archive.remove_at(_log_archive.find(l))
    
    log_text=log_text.strip_edges()
    text=log_text
    
