extends Node
## Centralized audio playback so scenes never load AudioStreams directly.
## Deliberately tolerant of missing files right now: you haven't uploaded
## assets yet, so every call below just logs a warning and continues
## instead of crashing. Drop a matching file into assets/audio/sfx/ or
## assets/audio/music/ (any of .ogg/.wav/.mp3) and it starts playing
## automatically - no code changes needed.

const SFX_DIR := "res://assets/audio/sfx/"
const MUSIC_DIR := "res://assets/audio/music/"
const EXTENSIONS := ["ogg", "wav", "mp3"]

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
const SFX_POLYPHONY := 6

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Master"
	add_child(_music_player)

	for i in SFX_POLYPHONY:
		var p := AudioStreamPlayer.new()
		p.bus = "Master"
		add_child(p)
		_sfx_players.append(p)

func play_sfx(sfx_name: String) -> void:
	var stream := _resolve(SFX_DIR, sfx_name)
	if stream == null:
		push_warning("AudioManager: sfx '%s' not found yet (skipped)" % sfx_name)
		return
	var player := _next_free_sfx_player()
	player.stream = stream
	player.play()

func play_music(track_name: String) -> void:
	var stream := _resolve(MUSIC_DIR, track_name)
	if stream == null:
		push_warning("AudioManager: music '%s' not found yet (skipped)" % track_name)
		return
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func _resolve(dir: String, name_no_ext: String) -> AudioStream:
	for ext in EXTENSIONS:
		var path := "%s%s.%s" % [dir, name_no_ext, ext]
		if ResourceLoader.exists(path):
			return load(path)
	return null

func _next_free_sfx_player() -> AudioStreamPlayer:
	for p in _sfx_players:
		if not p.playing:
			return p
	return _sfx_players[0]
