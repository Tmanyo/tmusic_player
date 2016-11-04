music = {
     list = {}
}

music_playing = nil

function music_list()
     music.list = minetest.get_dir_list(minetest.get_modpath("tmusic_player") .. "/sounds", false)
     local s = minetest.serialize(music.list)
     return s:gsub("%p", ""):gsub("return",""):gsub("tmusicplayer", ""):gsub("ogg", ""):gsub(" ", ",")
end

minetest.register_chatcommand("music", {
     func = function(name, param)
          minetest.show_formspec(name, "tmusic_player:songs",
               "size[12,12]" ..
               "label[0,0;Playable songs:]" ..
               "image[8,0;6,1.5;tmusic_player.png]" ..
               "table[.5,1;9,9;song_list;".. music_list() .. "]" ..
               "field[.5,10.75;5,1;song_to_play;Song to play:; ]" ..
               "button[10,4;2,1;play;Play]" ..
               "button[10,5;2,1;stop;Stop]" ..
               "button[10,1;2,1;loop_current;Loop Current]" ..
               "button[10,9;2,1;help;Help]" ..
               "button_exit[10,10.5;2,1;exit;Close]")
     end
})

minetest.setting_set("individual_loop", "true")

minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "tmusic_player:songs" then
          if fields.play then
               if music_playing ~= nil then
                    music_playing = minetest.sound_stop(music_playing)
                    if music_playing == nil then
                         music_playing = minetest.sound_play("tmusic_player_" .. fields.song_to_play, {
                              gain = 10,
                              to_player = minetest.get_connected_players()
                         })
                    end
               else
                    music_playing = minetest.sound_play("tmusic_player_" .. fields.song_to_play, {
                         gain = 10,
                         to_player = minetest.get_connected_players()
                    })
               end
          elseif fields.stop then
               if music_playing == nil then
                    return false
               else
                    music_playing = minetest.sound_stop(music_playing)
                    minetest.setting_set("individual_loop", "false")
               end
          end
          if fields.loop_current then
               if minetest.setting_getbool("individual_loop") == true then
                    if music_playing ~= nil then
                         music_playing = minetest.sound_stop(music_playing)
                         if music_playing == nil then
                              music_playing = minetest.sound_play("tmusic_player_" .. fields.song_to_play, {
                                   gain = 10,
                                   to_player = minetest.get_connected_players()
                              })
                         end
                    else
                         music_playing = minetest.sound_play("tmusic_player_" .. fields.song_to_play, {
                              gain = 10,
                              object = player,
                              loop = true
                         })
                    end
               end
          end
          if fields.help then
               minetest.show_formspec(player:get_player_name(), "tmusic_player:help",
                    "size[9,9]" ..
                    "label[4,0;Help]" ..
                    "label[.25,.5;Adding Music:]" ..
                    "label[0,1;To add music, convert your audio file into an OGG Vorbis format and save it to the mod's sounds folder.  The]" ..
                    "label[0,1.25;filename convention is - tmusic_player_soundname.  An example is tmusic_player_bowwowcow.]" ..
                    "label[.25,1.75;Playing Music:]" ..
                    "label[0,2.25;To play music, enter the song's name exactly as it is in the list into the text box and]" ..
                    "label[0,2.5;click Play.  If the song does not start playing, you entered the song name incorrectly.]" ..
                    "label[.25,3;Stopping Music:]" ..
                    "label[0,3.5;To stop music, click the Stop button.  If there was no music playing to begin with, nothing will happen.]" ..
                    "label[.25,4;Looping Current Song:]" ..
                    "label[0,4.5;To repeat the current song, enter the song's name exactly as it is in the list into the text box]" ..
                    "label[0,4.75;and click Loop Current.  If the song does not start playing, you entered the song name incorrectly.]" ..
                    "image[2,5.5;6,1.5;tmusic_player.png]" ..
                    "button[0,8;2,1;back;Back]" ..
                    "button_exit[2,8;2,1;exit;Close]")
          end
     end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "tmusic_player:help" then
          if fields.back then
               minetest.show_formspec(player:get_player_name(), "tmusic_player:songs",
                    "size[12,12]" ..
                    "label[0,0;Playable songs:]" ..
                    "image[8,0;6,1.5;tmusic_player.png]" ..
                    "table[.5,1;9,9;song_list;".. music_list() .. "]" ..
                    "field[.5,10.75;5,1;song_to_play;Song to play:; ]" ..
                    "button[10,4;2,1;play;Play]" ..
                    "button[10,5;2,1;stop;Stop]" ..
                    "button[10,1;2,1;loop_current;Loop Current]" ..
                    "button[10,9;2,1;help;Help]" ..
                    "button_exit[10,10.5;2,1;exit;Close]")
          end
     end
end)
