package main

import "core:fmt"
//import "core:strings"
import sdl "vendor:sdl3"
import ttf "vendor:sdl3/ttf"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 1024
TILE_SIZE :: 64
WIDTH_TILES_PITCH :: 15
HEIGHT_TILES_PITCH :: 28

Game_State :: struct {
	window:          ^sdl.Window,
	renderer:        ^sdl.Renderer,
	scroll_coord:    [2]int,
	zoom:            u8,
	zoom_max:        u8,
	is_running:      bool,
	is_pause:        bool,
	scroll_delta:    u8,
	list_grid_pitch: [WIDTH_TILES_PITCH][HEIGHT_TILES_PITCH]Ground_Tile,
	font:            ^ttf.Font,
	mode:            Game_Mode,
}

Game_Mode :: enum {
	pitch,
	home,
}

Ground_Tile :: struct {
	tile_rect:        sdl.FRect,
	texture:          ^sdl.Texture,
	has_player:       bool,
	has_ball:         bool,
	is_outside_pitch: bool,
	is_touchdown:     bool,
	is_selected:      bool,
	is_hovered:       bool,
}

main :: proc() {
	if !sdl.Init({.VIDEO}) {
		fmt.println("Initializing sdl video failed: ", sdl.GetError())
		return
	}
	defer sdl.Quit()

	state := Game_State {
		is_running   = true,
		is_pause     = false,
		mode         = .pitch,
		zoom         = 1,
		zoom_max     = 4,
		scroll_coord = {0, 0},
		scroll_delta = 10,
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
	init_pitch(&state)
	defer clear_all(&state)

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
			resized_needed: bool = false
			fmt.println("The key pressed is: ", event.key.scancode)
			if event.key.scancode == .ESCAPE do state.is_running = false
			if event.key.scancode == .DOWN && state.mode == .pitch {
				resized_needed = true
				state.scroll_coord[1] += int(state.scroll_delta)
				fmt.println("Adding to the scrolling")
			} else if event.key.scancode == .UP && state.mode == .pitch {
				resized_needed = true
				state.scroll_coord[1] -= int(state.scroll_delta)
				if state.scroll_coord[1] < -100 do state.scroll_coord[1] = -100
				fmt.println("Adding to the scrolling")
			} else if event.key.scancode == .RIGHT && state.mode == .pitch {
				resized_needed = true
				state.scroll_coord[0] += int(state.scroll_delta)
				fmt.println("Adding to the scrolling")

			} else if event.key.scancode == .LEFT && state.mode == .pitch {
				resized_needed = true
				state.scroll_coord[0] -= int(state.scroll_delta)
				if state.scroll_coord[0] < -100 do state.scroll_coord[0] = -100
				fmt.println("Adding to the scrolling")
			}
			fmt.println(state.scroll_coord)
			if resized_needed do resize_pitch_tiles_rect(state)
		case .MOUSE_MOTION: //when the mouse move

		//state.mouse_coord[0] = event.motion.x
		//state.mouse_coord[1] = event.motion.y
		}
	}
}

update :: proc(state: ^Game_State) {

}

render :: proc(state: ^Game_State) {
	if !sdl.SetRenderDrawColor(state.renderer, 20, 20, 20, 255) {
		fmt.println("SetRenderDrawCOlor failed: ", sdl.GetError())
	}
	if !sdl.RenderClear(state.renderer) do fmt.println("Renderer clear failed: ", sdl.GetError())
	draw_pitch(state)
	sdl.RenderPresent(state.renderer)
}

clear_all :: proc(state: ^Game_State) {
	clear_pitch(state)
}
