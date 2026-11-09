package main

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"
import ttf "vendor:sdl3/ttf"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 1024
TILE_SIZE :: 64

Game_State :: struct {
	window:         ^sdl.Window,
	renderer:       ^sdl.Renderer,
	is_running:     bool,
	is_pause:       bool,
	player_id_turn: u8,
	font:           ^ttf.Font,
	mode:           Game_Mode,
}

Game_Mode :: enum {
	pitch,
	home,
}

Player :: struct {
	name: string,
	id:   u8,
}

main :: proc() {
	if !sdl.Init({.VIDEO}) {
		fmt.println("Initializing sdl video failed: ", sdl.GetError())
		return
	}
	defer sdl.Quit()

	state := Game_State {
		is_running = true,
		is_pause   = false,
		mode       = .home,
	}

	state.window = sdl.CreateWindow("Rugby Fantasy Simulator 0.0", SCREEN_WIDTH, SCREEN_HEIGHT, {})
	if state.window == nil {
		fmt.println("Error creating the game window: ", sdl.GetError())
		return
	}
	defer sdl.DestroyWindow(state.window)

	state.renderer = sdl.CreateRenderer(state.window, nil)
	if state.renderer == nil {
		fmt.println("Error creating the sdl rendrere: ", sdl.GetError())
		return
	}
	defer sdl.DestroyRenderer(state.renderer)

	vsync_ok := sdl.SetRenderVSync(state.renderer, 1)
	if !vsync_ok {
		fmt.println("Vsync failed")
		sdl.SetHint(sdl.HINT_RENDER_VSYNC, "1")
	}

	sdl.SetRenderDrawBlendMode(state.renderer, sdl.BLENDMODE_BLEND)

	for state.is_running {
		handle_events(&state)
		update(&state)
		render(&state)
	}
}

handle_events :: proc(state: ^Game_State) {
	event: sdl.Event
	for sdl.PollEvent(&event) {
		#partial switch event.type {
		case .QUIT:
			state.is_running = false
		case .KEY_DOWN:
			if event.key.scancode == .ESCAPE do state.is_running = false
		case .MOUSE_MOTION:
		//state.mouse_coord[0] = event.motion.x
		//state.mouse_coord[1] = event.motion.y
		}
	}
}

update :: proc(state: ^Game_State) {

}

render :: proc(state: ^Game_State) {
	sdl.SetRenderDrawColor(state.renderer, 20, 20, 20, 255)
	sdl.RenderClear(state.renderer)
}
