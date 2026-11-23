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
			switch j {
			case 0:
				path = "sources/tiles_pitch/Ligne_vertical_droite.png"
				state.list_grid_pitch[j][i].is_outside_pitch = true
			case 1:
				path = "sources/tiles_pitch/Ligne_vertical_gauche.png"
			case 3:
				path = "sources/tiles_pitch/Ligne_vertical_droite.png"
			case WIDTH_TILES_PITCH - 3:
				path = "sources/tiles_pitch/Ligne_vertical_gauche.png"
			case WIDTH_TILES_PITCH - 1:
				path = "sources/tiles_pitch/Ligne_vertical_droite.png"
			case WIDTH_TILES_PITCH:
				path = "sources/tiles_pitch/Ligne_vertical_gauche.png"
				state.list_grid_pitch[j][i].is_outside_pitch = true
			}

			switch i {
			case 0:
				state.list_grid_pitch[j][i].is_outside_pitch = true
			case 1:
				path = "sources/tiles_pitch/Ligne_horizontale_bas.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			case 2:
				path = "sources/tiles_pitch/Ligne_horizontale_haut.png"
			case (HEIGHT_TILES_PITCH / 2) - 1:
				path = "sources/tiles_pitch/Ligne_horizontale_bas.png"
			case HEIGHT_TILES_PITCH / 2:
				path = "sources/tiles_pitch/Ligne_horizontale_haut.png"
			case HEIGHT_TILES_PITCH - 1:
				path = "sources/tiles_pitch/Ligne_horizontale_haut.png"
				state.list_grid_pitch[j][i].is_touchdown = true
			case HEIGHT_TILES_PITCH - 2:
				path = "sources/tiles_pitch/Ligne_horizontale_bas.png"
			case HEIGHT_TILES_PITCH:
				state.list_grid_pitch[j][i].is_outside_pitch = true
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
	for &tile in state.list_grid_pitch {

	}

}
