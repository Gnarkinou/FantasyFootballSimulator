package main

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"
import img "vendor:sdl3/image"

resize_pitch_tiles_rect :: proc(state: ^Game_State) {
	for i := 0; i < HEIGHT_TILES_PITCH; i += 1 {
		for j := 0; j < WIDTH_TILES_PITCH; j += 1 {
			tile := &state.list_grid_pitch[j][i]
			tile.tile_rect.x = f32(TILE_SIZE * j * int(state.zoom) - state.scroll_coord[0])
			tile.tile_rect.y = f32(TILE_SIZE * i * int(state.zoom) - state.scroll_coord[1])
			tile.tile_rect.w = f32(TILE_SIZE * int(state.zoom))
			tile.tile_rect.h = f32(TILE_SIZE * int(state.zoom))
		}
	}
}

init_pitch :: proc(state: ^Game_State) {
	path: string
	for i := 0; i < HEIGHT_TILES_PITCH; i += 1 {
		for j := 0; j < WIDTH_TILES_PITCH; j += 1 {
			path = "sources/tiles_pitch/pitch_2/grass_1.png"
			tile := &state.list_grid_pitch[j][i]
			tile.is_touchdown = false
			tile.is_outside_pitch = false
			tile.tile_rect.x = f32(TILE_SIZE * j * int(state.zoom) - state.scroll_coord[0])
			tile.tile_rect.y = f32(TILE_SIZE * i * int(state.zoom) - state.scroll_coord[1])
			tile.tile_rect.w = f32(TILE_SIZE * int(state.zoom))
			tile.tile_rect.h = f32(TILE_SIZE * int(state.zoom))

			switch j {
			case 0:
				path = "sources/tiles_pitch/pitch_2/border_left_marks.png"
			case 3:
				path = "sources/tiles_pitch/pitch_2/border_right_marks.png"
			case WIDTH_TILES_PITCH - 4:
				path = "sources/tiles_pitch/pitch_2/border_left_marks.png"
			case WIDTH_TILES_PITCH - 1:
				path = "sources/tiles_pitch/pitch_2/border_right_marks.png"
			}

			switch i {
			case 0:
				path = "sources/tiles_pitch/pitch_2/border_bottom_marks.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			case 1:
				if j == 0 {
					path = "sources/tiles_pitch/pitch_2/border_corner_top_left.png"
				} else if j == WIDTH_TILES_PITCH - 1 {
					path = "sources/tiles_pitch/pitch_2/border_corner_top_right.png"
				}
			case int((HEIGHT_TILES_PITCH / 2) - 1):
				if j == int(WIDTH_TILES_PITCH / 2) {
					path = "sources/tiles_pitch/pitch_2/middle_circle_top.png"
				}
			case HEIGHT_TILES_PITCH / 2:
				if j == int(WIDTH_TILES_PITCH / 2) {
					path = "sources/tiles_pitch/pitch_2/middle_circle_down.png"
				}
			case HEIGHT_TILES_PITCH - 2:
				path = "sources/tiles_pitch/pitch_2/border_bottom_marks.png"
			case HEIGHT_TILES_PITCH - 1:
				path = "sources/tiles_pitch/pitch_2/border_top_marks.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			}

			tile.has_ball = false
			tile.has_player = false
			tile.is_hovered = false
			tile.is_selected = false

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
				sdl.DestroyTexture(texture)
				continue
			}
			tile.texture = texture
		}
	}
}

draw_pitch :: proc(state: ^Game_State) {
	for &tile_h in state.list_grid_pitch {
		for &tile in tile_h {
			if tile.tile_rect.x > SCREEN_WIDTH || tile.tile_rect.x < -tile.tile_rect.w do continue
			if tile.tile_rect.y < -tile.tile_rect.h || tile.tile_rect.y > SCREEN_HEIGHT do continue
			if tile.texture == nil {
				fmt.println("Error loading tile texture: ")
				continue
			}
			sdl.RenderTexture(state.renderer, tile.texture, nil, &tile.tile_rect)
		}
	}
}

clear_pitch :: proc(state: ^Game_State) {
	for &tile_h in state.list_grid_pitch {
		for &tile in tile_h {
			sdl.DestroyTexture(tile.texture)
		}
	}
	state.list_grid_pitch = {}
}
