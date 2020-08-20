music = {
     list = {}
}

music_playing = nil

local song = {}

minetest.mkdir(minetest.get_modpath("tmusic_player") .. "/sounds")

function music_list()
        music.list = minetest.get_dir_list(minetest.get_modpath("tmusic_player") ..
	"/sounds", false)
        local s = minetest.serialize(music.list)
        return s:gsub("_", ""):gsub("return ",""):gsub("tmusicplayer", ""):
	gsub("%.ogg", ""):gsub("{", ""):gsub("}", ""):gsub("\"", ""):gsub(" ", "")
end

function music_form(player)
        minetest.show_formspec(player:get_player_name(), "tmusic_player:songs",
		"size[12,12]" ..
		"label[0,0;Playable songs:]" ..
	     	"image[8,0;6,1.5;tmusic_player.png]" ..
	     	"textlist[.5,1;9,11;song_list;".. music_list() .. "]" ..
	     	"button[10,8.5;2,1;stop;Stop]" ..
	     	"button[10,7.5;2,1;loop_current;Loop Current]" ..
	     	"button[10,9.5;2,1;help;Help]" ..
	     	"button_exit[10,10.5;2,1;exit;Close]")
end

minetest.register_chatcommand("music", {
        func = function(name, param)
	        local player = minetest.get_player_by_name(name)
	        music_form(player)
        end
})

minetest.setting_set("individual_loop", "true")

minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "tmusic_player:songs" then
          	if fields.stop then
               		if music_playing == nil then
                    		return false
               		else
				song = {}
                    		music_playing = minetest.sound_stop(music_playing)
                    		minetest.setting_set("individual_loop", "false")
               		end
          	end
          	if fields.loop_current then
               		if minetest.setting_getbool("individual_loop") == true then
                    		if music_playing ~= nil then
                         		music_playing = minetest.sound_stop(
					music_playing)
				end
                         	if music_playing == nil then
                              		music_playing = minetest.sound_play(
					song, {
                                   	gain = 10,
                                   	to_player = minetest.get_connected_players(),
					loop = true
                              		})
                         	end
               		end
          	end
          	if fields.help then
               		minetest.show_formspec(player:get_player_name(),
			"tmusic_player:help",
                        "size[9,9]" ..
                    	"label[4,0;Help]" ..
                    	"label[.25,.5;Adding Music:]" ..
                    	"label[0,1;To add music, convert your audio file into" ..
			" an OGG Vorbis format and save it to the mod's" ..
			" sounds folder.  The]" .. "label[0,1.25;filename" ..
		        " convention is - tmusic_player_soundname.  An" ..
			" example is tmusic_player_bowwowcow.]" ..
			"label[.25,1.75;Playing Music:]" ..
			"label[0,2.25;To play music click on the song you" ..
			" would like to play.]" ..
                    	"label[.25,3;Stopping Music:]" ..
                    	"label[0,3.5;To stop music, click the Stop button." ..
			"  If there was no music playing to begin with," ..
			" nothing will happen.]" ..
                    	"label[.25,4;Looping Current Song:]" ..
                    	"label[0,4.5;To repeat the current song, click the song" ..
		 	" and click Loop Current.]" ..
                    	"image[2,5.5;6,1.5;tmusic_player.png]" ..
                    	"button[0,8;2,1;back;Back]" ..
                    	"button_exit[2,8;2,1;exit;Close]")
          	end
		local event = minetest.explode_textlist_event(fields.song_list)
		if event.type == "CHG" then
			if #music.list >= 1 then
				if music_playing ~= nil then
					music_playing = minetest.sound_stop(
					music_playing)
				end
				if music_playing == nil then
					song = music.list[event.index]:gsub(
					"%.ogg", "")
					music_playing = minetest.sound_play(song, {
					gain = 10,
					to_player = minetest.get_connected_players()
					})
				end
			end
		end
     	end
     	if formname == "tmusic_player:help" then
	     	if fields.back then
                  	music_form(player)
             	end
	end
end)
