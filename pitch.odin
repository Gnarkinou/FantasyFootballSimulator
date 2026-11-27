package main

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"
import img "vendor:sdl3/image"

init_pitch :: proc(state: ^Game_State) {
	path: string
	path = "sources/tiles_pitch/grass_1.png"
	for i := 0; i <= HEIGHT_TILES_PITCH; i += 1 {
		for j := 0; j <= WIDTH_TILES_PITCH; j += 1 {
			state.list_grid_pitch[j][i].is_touchdown = false
			state.list_grid_pitch[j][i].is_outside_pitch = false
			state.list_grid_pitch[j][i].tile_rect.x = f32(
				TILE_SIZE * i * int(state.zoom) - state.scroll_coord[0],
			)
			state.list_grid_pitch[j][i].tile_rect.y = f32(
				TILE_SIZE * j * int(state.zoom) - state.scroll_coord[1],
			)
			state.list_grid_pitch[j][i].tile_rect.w = f32(TILE_SIZE * int(state.zoom))
			state.list_grid_pitch[j][i].tile_rect.h = f32(TILE_SIZE * int(state.zoom))

			switch j {
			case 0:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_left_marks.png"
			case 3:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_right_marks.png"
			case WIDTH_TILES_PITCH - 3:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_left_marks.png"
			case WIDTH_TILES_PITCH:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_right_marks.png"
			}

			switch i {
			case 0:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_bottom_marks.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			case 1:
				path = "sources/tiles_pitch/Ligne_horizontale_haut.png"
			case (HEIGHT_TILES_PITCH / 2) - 1:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/middle_circle_down.png"
			case HEIGHT_TILES_PITCH / 2:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/middle_circle_top.png"
			case HEIGHT_TILES_PITCH - 1:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_bottom_marks.png"
			case HEIGHT_TILES_PITCH:
				path = "/home/mouton/Project/FantasyFootballSimulator/sources/tiles_pitch/pitch_2/border_top_marks.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			}

			state.list_grid_pitch[j][i].has_ball = false
			state.list_grid_pitch[j][i].has_player = false
			state.list_grid_pitch[j][i].is_hovered = false
			state.list_grid_pitch[j][i].is_selected = false

			c_path := strings.clone_to_cstring(path, context.temp_allocator)
			if len(c_path) == 0 || len(path) == 0 {
				fmt.println("Error loading the c_path of: ", path)
				continue
			}
			texture := img.LoadTexture(state.renderer, c_path)
			if texture == nil {
				fmt.println("Error loading texture:", path, "Error:", sdl.GetError())
				continue
			}
			if !sdl.SetTextureBlendMode(texture, sdl.BLENDMODE_BLEND) {
				fmt.println("Failed to enable texture blending: ", sdl.GetError())
				continue
			}
			state.list_grid_pitch[j][i].texture = texture
		}
	}
}

draw_pitch :: proc(state: ^Game_State) {
	for &tile_h in state.list_grid_pitch {
		for &tile in tile_h {

		}

	}
}
