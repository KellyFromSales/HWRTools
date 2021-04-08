namespace Soundtest
{
	SoundtestInterface@ g_interface;

	[Hook]
	void GameModeStart(Campaign@ campaign, SValue@ save)
	{
		campaign.m_userWindows.insertLast(@g_interface = SoundtestInterface(campaign.m_guiBuilder));
	}

	[Hook]
    void GameModeConstructor(Campaign@ campaign)
    {
        AddFunction("soundtest", soundtestcfunc);
    }

	void soundtestcfunc()
	{
		auto gm = cast<Campaign>(g_gameMode);
		gm.ToggleUserWindow(g_interface);
	}

	class SoundtestInterface : UserWindow
	{
		FilteredListWidget@ m_wList;
		Widget@ m_wTemplateButton;
		TextInputWidget@ m_wFilter;

		SoundtestInterface(GUIBuilder@ b)
		{
			super(b, "gui/testmenus/soundtest.gui");

			@m_wList = cast<FilteredListWidget>(m_widget.GetWidgetById("list"));
			@m_wFilter = cast<TextInputWidget>(m_widget.GetWidgetById("filter"));
			@m_wTemplateButton = m_widget.GetWidgetById("template-button");
		}

		void Show() override
		{
			m_wList.PauseScrolling();

			if(m_wList.m_children.length() == 0)
			{
				for (uint i = 0; i < SoundTestEvents.length(); i++)
				{
					string unit = SoundTestEvents[i];

					Widget@ wNewSound = null;

					auto wNewButton = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
					wNewButton.m_func = "action " + i;
					wNewButton.SetText(unit);
					wNewButton.m_filter = (unit).toLower();

					m_wList.AddChild(wNewButton);
				}
			}

			m_wList.ResumeScrolling();
			m_wFilter.ClearText();
			m_wList.ShowAll();
			UserWindow::Show();
		}

		void OnFunc(Widget@ sender, string name) override
		{
			auto parse = name.split(" ");
			auto record = GetLocalPlayerRecord();
        	SoundInstance@ pSound;

			if (parse[0] == "action" && parse.length() == 2)
			{
				int index = parseInt(parse[1]);
				string cSoundName = SoundTestEvents[index];
				if (pSound !is null)
					pSound.Stop();
				@pSound = (Resources::GetSoundEvent(cSoundName)).PlayTracked(record.actor.m_unit.GetPosition());
			}
			else if (name == "filterlist")
				m_wList.SetFilter(m_wFilter.m_text.plain());
			else if (name == "filterlist-clear")
			{
				m_wFilter.ClearText();
				m_wList.ShowAll();
			}
			else
				UserWindow::OnFunc(sender, name);
		}
	}

	array<string> SoundTestEvents = {
		"event:/ambient/archives",
		"event:/ambient/armory",
		"event:/ambient/battlements",
		"event:/ambient/bridge",
		"event:/ambient/chambers",
		"event:/ambient/desert",
		"event:/ambient/desert_storm",
		"event:/ambient/dragon",
		"event:/ambient/genie",
		"event:/ambient/mines",
		"event:/ambient/mt_common",
		"event:/ambient/mt_poor",
		"event:/ambient/mt_rich",
		"event:/ambient/mummy",
		"event:/ambient/planeofmagic",
		"event:/ambient/prison",
		"event:/ambient/pyramid_fancy",
		"event:/ambient/pyramid_slum",
		"event:/ambient/town_outlook",
		"event:/arena/crowd",
		"event:/arena/crowd_1",
		"event:/arena/crowd_5",
		"event:/arena/crowd_ambience",
		"event:/arena/crowd_chant",
		"event:/arena/crowd_generic",
		"event:/arena/down-1",
		"event:/arena/down-2",
		"event:/arena/down-3",
		"event:/arena/next_wave",
		"event:/arena/up-1",
		"event:/arena/up-2",
		"event:/arena/up-3",
		"event:/enemy/banner/death",
		"event:/enemy/bat/death",
		"event:/enemy/bat/death_spawner",
		"event:/enemy/bat/swarm",
		"event:/enemy/bat_mb/attack",
		"event:/enemy/bat_mb/death",
		"event:/enemy/bat_mb/hit",
		"event:/enemy/bat_mb/melee",
		"event:/enemy/bat_mb/shoot",
		"event:/enemy/battlemage/shoot",
		"event:/enemy/boss_agents/charge",
		"event:/enemy/boss_agents/charge-hit",
		"event:/enemy/boss_agents/death",
		"event:/enemy/boss_agents/fireball-impact",
		"event:/enemy/boss_agents/nightbuff",
		"event:/enemy/boss_agents/shoot_blaze",
		"event:/enemy/boss_agents/shoot_blaze-night",
		"event:/enemy/boss_agents/shoot_decay",
		"event:/enemy/boss_agents/shoot_decay-bounce",
		"event:/enemy/boss_agents/shoot_decay-night",
		"event:/enemy/boss_agents/shoot_rime",
		"event:/enemy/boss_agents/shoot_rime-night",
		"event:/enemy/boss_agents/shoot_star",
		"event:/enemy/boss_agents/shoot_star-night",
		"event:/enemy/boss_agents/starbomb-impact",
		"event:/enemy/boss_agents/sword",
		"event:/enemy/boss_agents/sword-hit",
		"event:/enemy/boss_agents/twirl-hit",
		"event:/enemy/boss_dragon/death",
		"event:/enemy/boss_dragon/foot",
		"event:/enemy/boss_dragon/frostball",
		"event:/enemy/boss_dragon/frostball-start",
		"event:/enemy/boss_dragon/laugh",
		"event:/enemy/boss_dragon/shard",
		"event:/enemy/boss_dragon/shard-start",
		"event:/enemy/boss_dragon/wave",
		"event:/enemy/boss_dragon/wave-start",
		"event:/enemy/boss_eye/attack",
		"event:/enemy/boss_eye/attack_looping",
		"event:/enemy/boss_eye/attack_spew",
		"event:/enemy/boss_eye/death",
		"event:/enemy/boss_eye/glyph",
		"event:/enemy/boss_eye/jump",
		"event:/enemy/boss_eye/spawn",
		"event:/enemy/boss_eye/wisp",
		"event:/enemy/boss_genie/arc",
		"event:/enemy/boss_genie/arc-start",
		"event:/enemy/boss_genie/arc-travel",
		"event:/enemy/boss_genie/blink-in",
		"event:/enemy/boss_genie/blink-out",
		"event:/enemy/boss_genie/bomb-explode",
		"event:/enemy/boss_genie/bomb-spawn",
		"event:/enemy/boss_genie/death",
		"event:/enemy/boss_genie/magic-strike",
		"event:/enemy/boss_genie/spawn",
		"event:/enemy/boss_genie/superheal",
		"event:/enemy/boss_genie/sword",
		"event:/enemy/boss_genie/sword-raise",
		"event:/enemy/boss_golem/death",
		"event:/enemy/boss_golem/ground_slam",
		"event:/enemy/boss_golem/shoot_spikes",
		"event:/enemy/boss_mummy/charge",
		"event:/enemy/boss_mummy/charge-long",
		"event:/enemy/boss_mummy/curse",
		"event:/enemy/boss_mummy/curse_ball",
		"event:/enemy/boss_mummy/curse_ball-travel",
		"event:/enemy/boss_mummy/death",
		"event:/enemy/boss_mummy/flies",
		"event:/enemy/boss_mummy/flies-death",
		"event:/enemy/boss_mummy/flies-hit",
		"event:/enemy/boss_mummy/flies-start",
		"event:/enemy/boss_mummy/spawn",
		"event:/enemy/boss_mummy/stomp",
		"event:/enemy/boss_vampire/attack-blades",
		"event:/enemy/boss_vampire/attack-rapiers",
		"event:/enemy/boss_vampire/bat_spray",
		"event:/enemy/boss_vampire/blade",
		"event:/enemy/boss_vampire/blade_hit",
		"event:/enemy/boss_vampire/chuckle_appear",
		"event:/enemy/boss_vampire/chuckle_disappear",
		"event:/enemy/boss_vampire/cross_activate",
		"event:/enemy/boss_vampire/cross_place",
		"event:/enemy/boss_vampire/death",
		"event:/enemy/boss_vampire/feeding",
		"event:/enemy/boss_vampire/feeding_laugh",
		"event:/enemy/boss_vampire/fire_wall",
		"event:/enemy/boss_vampire/laugh",
		"event:/enemy/boss_vampire/poof",
		"event:/enemy/boss_vampire/rapier",
		"event:/enemy/boss_vampire/rapier_hit",
		"event:/enemy/boss_warden/attack-bow",
		"event:/enemy/boss_warden/attack-club",
		"event:/enemy/boss_warden/attack-spin",
		"event:/enemy/boss_warden/attack-spin_hit",
		"event:/enemy/boss_warden/death",
		"event:/enemy/boss_wisp/death",
		"event:/enemy/boss_wisp/ice_break",
		"event:/enemy/boss_wisp/pylon_beam",
		"event:/enemy/boss_wisp/pylon_break",
		"event:/enemy/boss_wisp/pylon_down",
		"event:/enemy/boss_wisp/pylon_up",
		"event:/enemy/boss_wisp/whirlwind",
		"event:/enemy/boss_wisp/wisp_spawn",
		"event:/enemy/boss_wolf/attack",
		"event:/enemy/boss_wolf/breath",
		"event:/enemy/boss_wolf/death",
		"event:/enemy/boss_wolf/death_impact",
		"event:/enemy/boss_wolf/gore",
		"event:/enemy/boss_wolf/howl",
		"event:/enemy/boss_wolf/jump",
		"event:/enemy/boss_wolf/land",
		"event:/enemy/boss_wolf/lurker",
		"event:/enemy/boss_wolf/run",
		"event:/enemy/boss_wolf/stomp",
		"event:/enemy/boss_worm/death",
		"event:/enemy/boss_worm/diving",
		"event:/enemy/boss_worm/slithering",
		"event:/enemy/boss_worm/stone_big_impact",
		"event:/enemy/boss_worm/stone_big_spit",
		"event:/enemy/boss_worm/surfacing",
		"event:/enemy/boss_worm/surfacing_attack",
		"event:/enemy/boss_wraith/attack-mage",
		"event:/enemy/boss_wraith/attack-scythe",
		"event:/enemy/boss_wraith/attack-staff",
		"event:/enemy/boss_wraith/death",
		"event:/enemy/boss_wraith/spawn",
		"event:/enemy/djinn/death",
		"event:/enemy/djinn/spawn",
		"event:/enemy/djinn/sphere",
		"event:/enemy/djinn/teleport",
		"event:/enemy/elemental_ice/hit",
		"event:/enemy/elemental_ice/shoot",
		"event:/enemy/elemental_stone/death",
		"event:/enemy/eye/death",
		"event:/enemy/eye/death_spawner",
		"event:/enemy/flower/death",
		"event:/enemy/flower/hit",
		"event:/enemy/flower_frost/attack",
		"event:/enemy/flower_frost/death",
		"event:/enemy/flower_frost/hit",
		"event:/enemy/gargoyle/attack-trident",
		"event:/enemy/gargoyle/break_free",
		"event:/enemy/gargoyle/death",
		"event:/enemy/gargoyle/trident_hit",
		"event:/enemy/ghost/arrow",
		"event:/enemy/ghost/arrow_hit",
		"event:/enemy/ghost/comet_hit",
		"event:/enemy/ghost/comet_summon",
		"event:/enemy/ghost/death",
		"event:/enemy/ghost/drain_area",
		"event:/enemy/ghost/knives",
		"event:/enemy/glyph/attack",
		"event:/enemy/glyph/attack_curse",
		"event:/enemy/glyph/spawn",
		"event:/enemy/glyph/spawn_curse",
		"event:/enemy/glyph/visible",
		"event:/enemy/glyph/visible_curse",
		"event:/enemy/golem_sand/blink-in",
		"event:/enemy/golem_sand/blink-out",
		"event:/enemy/golem_sand/death",
		"event:/enemy/golem_sand/hit",
		"event:/enemy/golem_sand/hit_rock",
		"event:/enemy/golem_sand/spawn",
		"event:/enemy/golem_sand/throw",
		"event:/enemy/hellcube/attack",
		"event:/enemy/hellcube/cube_damage_old",
		"event:/enemy/hellcube/damage",
		"event:/enemy/hellcube/death",
		"event:/enemy/high_priest/attack",
		"event:/enemy/high_priest/beam",
		"event:/enemy/high_priest/fireball",
		"event:/enemy/ice_melee_troll/death",
		"event:/enemy/ice_melee_troll/jump",
		"event:/enemy/ice_melee_troll/jump_strike",
		"event:/enemy/ice_melee_troll/smash",
		"event:/enemy/ice_shaman_troll/chant",
		"event:/enemy/ice_shaman_troll/snow_bomb",
		"event:/enemy/ice_shaman_troll/snow_bomb_explode",
		"event:/enemy/ice_shaman_troll/snowball",
		"event:/enemy/ice_shaman_troll/snowball_shoot",
		"event:/enemy/lich/blink",
		"event:/enemy/lich/death",
		"event:/enemy/lich/hit",
		"event:/enemy/lich/manashield",
		"event:/enemy/lich/shoot",
		"event:/enemy/lich/summon",
		"event:/enemy/lich_frost/breath",
		"event:/enemy/lich_frost/shoot",
		"event:/enemy/lich_mb/area",
		"event:/enemy/lich_mb/attack",
		"event:/enemy/maggot/death",
		"event:/enemy/maggot/death_spawner",
		"event:/enemy/maggot/hit",
		"event:/enemy/mb_eye/beam",
		"event:/enemy/mb_eye/summon",
		"event:/enemy/mt_wisp/attack",
		"event:/enemy/mt_wisp/death",
		"event:/enemy/mt_wisp/death_explosion",
		"event:/enemy/mt_wisp/explosion",
		"event:/enemy/mummy/death",
		"event:/enemy/mummy/khopesh_hit",
		"event:/enemy/mummy/shoot",
		"event:/enemy/mummy_mb/curse_ball",
		"event:/enemy/mummy_mb/death",
		"event:/enemy/mummy_mb/puke",
		"event:/enemy/orb_of_night/attack",
		"event:/enemy/orb_of_night/idle",
		"event:/enemy/orb_of_night/pulse",
		"event:/enemy/scarab/death",
		"event:/enemy/scarab/death-big",
		"event:/enemy/scorpion/shoot",
		"event:/enemy/scorpion/spawn_hole",
		"event:/enemy/scorpion_mb/lurker",
		"event:/enemy/sentinel/death",
		"event:/enemy/sentinel/shoot",
		"event:/enemy/sentinel/spawn",
		"event:/enemy/sentinel_ice/melee_hit",
		"event:/enemy/sentinel_ice/ranged_hit",
		"event:/enemy/sentinel_ice/ranged_shoot",
		"event:/enemy/sentinel_ice_mb/beams",
		"event:/enemy/sentinel_ice_mb/charge",
		"event:/enemy/sentinel_ice_mb/hit",
		"event:/enemy/sentinel_ice_mb/shoot",
		"event:/enemy/sentinel_mb/nova",
		"event:/enemy/sentinel_mb/shoot",
		"event:/enemy/shade/attack",
		"event:/enemy/shade/death",
		"event:/enemy/shade/impact",
		"event:/enemy/shade/shoot",
		"event:/enemy/skeleton/death",
		"event:/enemy/skeleton/death_spawner",
		"event:/enemy/slime/death_host",
		"event:/enemy/slime/death_spawn",
		"event:/enemy/snake/death",
		"event:/enemy/snake/spit",
		"event:/enemy/spider/death",
		"event:/enemy/spider/shoot_acid",
		"event:/enemy/spider/shoot_web",
		"event:/enemy/spider/spawner-death",
		"event:/enemy/thrall/death",
		"event:/enemy/thrall/explosion",
		"event:/enemy/thrall/revive",
		"event:/enemy/thrall/slash",
		"event:/enemy/thrall_mb/attack",
		"event:/enemy/thrall_mb/death",
		"event:/enemy/thrall_mb/groan",
		"event:/enemy/thrall_mb/revive",
		"event:/enemy/thrall_mb/teleport",
		"event:/enemy/tick/death",
		"event:/enemy/tick/death_explode",
		"event:/enemy/tick/death_spawner",
		"event:/enemy/tower/death",
		"event:/enemy/tower/elevate",
		"event:/enemy/tower/shoot",
		"event:/enemy/tower_ballista/ballista_hit",
		"event:/enemy/tower_ballista/ballista_net",
		"event:/enemy/tower_ballista/ballista_shoot",
		"event:/enemy/tower_ballista/death",
		"event:/enemy/tower_bomb/hit",
		"event:/enemy/tower_bomb/shoot",
		"event:/enemy/tower_frost/hit",
		"event:/enemy/tower_frost/shoot",
		"event:/enemy/tower_rail/shoot",
		"event:/enemy/tower_rail/shoot-rail",
		"event:/enemy/tower_rock/shoot",
		"event:/enemy/tower_sun/beam",
		"event:/enemy/tower_sun/overload",
		"event:/enemy/tower_sun/shoot",
		"event:/enemy/tower_turret_wall/attack",
		"event:/enemy/tower_turret_wall/hit",
		"event:/enemy/trapper/attack",
		"event:/enemy/vampire/crescent_hit",
		"event:/enemy/vampire/crescent_shoot",
		"event:/enemy/vampire/crossbow",
		"event:/enemy/vampire/death",
		"event:/enemy/vampire/rapier_hit",
		"event:/enemy/vampire/rapier_throw",
		"event:/enemy/vampire/spawn",
		"event:/enemy/vampire/spawner_break",
		"event:/enemy/vampire/teleport",
		"event:/enemy/wisp/attack",
		"event:/enemy/wisp/death",
		"event:/enemy/wisp/death_explosion",
		"event:/enemy/wisp/death_spawner",
		"event:/enemy/wisp/whirl",
		"event:/item/blowgun",
		"event:/item/break_barrel",
		"event:/item/break_crate",
		"event:/item/break_sack",
		"event:/item/break_vase",
		"event:/item/chakram",
		"event:/item/chakram_bounce",
		"event:/item/chapel_blast",
		"event:/item/chapel_bomb",
		"event:/item/chapel_hammer_hit",
		"event:/item/chapel_hammer_throw",
		"event:/item/chapel_ray",
		"event:/item/coin_copper",
		"event:/item/coin_crystal",
		"event:/item/coin_gold",
		"event:/item/coin_nugget",
		"event:/item/coin_silver",
		"event:/item/conflagration",
		"event:/item/diamond1",
		"event:/item/diamond2",
		"event:/item/diamond3",
		"event:/item/diamond4",
		"event:/item/duke_area",
		"event:/item/earthsplitter_shoot",
		"event:/item/elven_ruby",
		"event:/item/golden_lamp",
		"event:/item/guardian_figurine",
		"event:/item/health",
		"event:/item/item_common",
		"event:/item/item_epic",
		"event:/item/item_legendary",
		"event:/item/item_meteor",
		"event:/item/item_meteor-fall",
		"event:/item/item_rare",
		"event:/item/item_uncommon",
		"event:/item/key_ace",
		"event:/item/key_bronze",
		"event:/item/key_gold",
		"event:/item/key_silver",
		"event:/item/keyring",
		"event:/item/magic_missile_hit",
		"event:/item/magic_missile_shoot",
		"event:/item/mana_big",
		"event:/item/mana_small",
		"event:/item/moonartifact",
		"event:/item/ore",
		"event:/item/pickup_blueprint",
		"event:/item/pickup_color",
		"event:/item/pickup_cross",
		"event:/item/pickup_drink",
		"event:/item/scarab_dart",
		"event:/item/skullsmasher",
		"event:/item/sphere_of_heroes",
		"event:/item/symbol_of_zeal",
		"event:/item/wand_of_chaos",
		"event:/misc/altar_activated",
		"event:/misc/altar_event_cancel",
		"event:/misc/altar_event_loop",
		"event:/misc/arena_gate_close",
		"event:/misc/arena_gate_open",
		"event:/misc/battle_horn",
		"event:/misc/blacksmith_hammer",
		"event:/misc/blood-altar",
		"event:/misc/bridge_collapse",
		"event:/misc/bridge_roller_off",
		"event:/misc/bridge_roller_on",
		"event:/misc/bridge_stone",
		"event:/misc/button_hatch",
		"event:/misc/button_hatch2",
		"event:/misc/button_magic",
		"event:/misc/button_metal",
		"event:/misc/crystal_break",
		"event:/misc/crystal_hit",
		"event:/misc/curse-gain",
		"event:/misc/door_mt_teleport_close",
		"event:/misc/door_mt_teleport_enter",
		"event:/misc/door_mt_teleport_enter_disconnected",
		"event:/misc/door_mt_teleport_open",
		"event:/misc/dragon_wake",
		"event:/misc/drawbridge_closed",
		"event:/misc/drawbridge_closing",
		"event:/misc/drawbridge_opened",
		"event:/misc/drawbridge_opening",
		"event:/misc/elevator",
		"event:/misc/fountain_loop",
		"event:/misc/gore_hit",
		"event:/misc/gore_slash",
		"event:/misc/ice_break",
		"event:/misc/ice_grow",
		"event:/misc/iceblock_break",
		"event:/misc/icerain",
		"event:/misc/imp_off",
		"event:/misc/imp_on",
		"event:/misc/lightning",
		"event:/misc/lunar_shield_hit",
		"event:/misc/lunar_shield_pickup",
		"event:/misc/lunar_shield_recharge",
		"event:/misc/mt_rich_door_unlock",
		"event:/misc/mt_room_clear",
		"event:/misc/open_chest_ace",
		"event:/misc/open_chest_bronze",
		"event:/misc/open_chest_gold",
		"event:/misc/open_chest_silver",
		"event:/misc/open_chest_wood",
		"event:/misc/paper",
		"event:/misc/plane_pulse",
		"event:/misc/pyramid_reveal",
		"event:/misc/rift-close",
		"event:/misc/rift-open",
		"event:/misc/scorpion-spawn",
		"event:/misc/secret",
		"event:/misc/sequence_complete",
		"event:/misc/shrine",
		"event:/misc/snake-spawn",
		"event:/misc/spawn_tele",
		"event:/misc/summon-fail",
		"event:/misc/summon-loop",
		"event:/misc/summon-start",
		"event:/misc/summon-success",
		"event:/misc/torch",
		"event:/misc/trap_arrow_hit",
		"event:/misc/trap_arrow_shoot",
		"event:/misc/trap_block",
		"event:/misc/trap_curse-off",
		"event:/misc/trap_curse-on",
		"event:/misc/trap_default-off",
		"event:/misc/trap_default-on",
		"event:/misc/trap_fireball_hit",
		"event:/misc/trap_fireball_shoot",
		"event:/misc/trap_flamethrower",
		"event:/misc/trap_furrow-off",
		"event:/misc/trap_furrow-on",
		"event:/misc/trap_indieball",
		"event:/misc/trap_indieball-open",
		"event:/misc/trap_indieball-travel",
		"event:/misc/trap_indieball_break",
		"event:/misc/trap_laser",
		"event:/misc/trap_quicksand",
		"event:/misc/trap_sandstorm",
		"event:/misc/trap_spikes",
		"event:/misc/wall_break",
		"event:/misc/wall_hit",
		"event:/misc/wall_move",
		"event:/misc/web-break",
		"event:/misc/web-hit",
		"event:/misc/wind-great_threat",
		"event:/misc/wind-long",
		"event:/misc/wind-short",
		"event:/misc/wing-lift",
		"event:/music/archives",
		"event:/music/arena",
		"event:/music/armory",
		"event:/music/battlements",
		"event:/music/bonus",
		"event:/music/boss_agents",
		"event:/music/boss_elderwisp",
		"event:/music/boss_genie",
		"event:/music/boss_icewolf",
		"event:/music/boss_killed",
		"event:/music/boss_mummy",
		"event:/music/boss_worm",
		"event:/music/chambers",
		"event:/music/desert",
		"event:/music/dragon",
		"event:/music/menu",
		"event:/music/menu_mt",
		"event:/music/menu_pop",
		"event:/music/menu_wh",
		"event:/music/mines",
		"event:/music/moon_temple_common",
		"event:/music/moon_temple_poor",
		"event:/music/moon_temple_rich",
		"event:/music/planeofmagic",
		"event:/music/prison",
		"event:/music/prison_old",
		"event:/music/pyramid_fancy",
		"event:/music/pyramid_midway",
		"event:/music/pyramid_slum",
		"event:/music/town_brightmoore",
		"event:/music/town_city_of_stone",
		"event:/music/town_outlook",
		"event:/player/combo/active",
		"event:/player/combo/blast",
		"event:/player/combo/deactivate",
		"event:/player/combo/failed",
		"event:/player/confused",
		"event:/player/cooldown",
		"event:/player/darkness",
		"event:/player/death",
		"event:/player/dodge",
		"event:/player/drink_potion",
		"event:/player/drink_potion_curse",
		"event:/player/gladiator/gladius",
		"event:/player/gladiator/gladius-hit",
		"event:/player/gladiator/net",
		"event:/player/gladiator/net_charge",
		"event:/player/gladiator/reinforcements",
		"event:/player/gladiator/reinforcements-attack",
		"event:/player/gladiator/reinforcements-death",
		"event:/player/gladiator/trident",
		"event:/player/hurt",
		"event:/player/levelup",
		"event:/player/magical_block",
		"event:/player/mana_drain",
		"event:/player/mana_drained",
		"event:/player/mercenary/ballista_shoot",
		"event:/player/mercenary/ballista_spawn",
		"event:/player/mercenary/banner_spawn",
		"event:/player/mercenary/first_aid",
		"event:/player/nimbus/explosion",
		"event:/player/no_mana",
		"event:/player/paladin/charge",
		"event:/player/paladin/heal",
		"event:/player/paladin/spin",
		"event:/player/paladin/sword_hit",
		"event:/player/paladin/sword_swing",
		"event:/player/physical_block",
		"event:/player/potion_health",
		"event:/player/priest/aura",
		"event:/player/priest/beam",
		"event:/player/priest/drain_area",
		"event:/player/priest/orb_beam",
		"event:/player/priest/shield",
		"event:/player/priest/smite",
		"event:/player/projectile_block",
		"event:/player/ranger/bomb_explode",
		"event:/player/ranger/bow_hit",
		"event:/player/ranger/bow_shoot",
		"event:/player/ranger/flurry",
		"event:/player/ranger/powershot",
		"event:/player/ranger/powershot_charge",
		"event:/player/ranger/snare_growth",
		"event:/player/ranger/snare_summon",
		"event:/player/sorcerer/comet_hit",
		"event:/player/sorcerer/comet_summon",
		"event:/player/sorcerer/icebarrier",
		"event:/player/sorcerer/nova",
		"event:/player/sorcerer/orb",
		"event:/player/sorcerer/orb_break",
		"event:/player/sorcerer/orb_summon",
		"event:/player/sorcerer/shard_hit",
		"event:/player/sorcerer/shard_shoot",
		"event:/player/sorcerer/shatter",
		"event:/player/thief/bomb",
		"event:/player/thief/chain_hit",
		"event:/player/thief/chain_miss",
		"event:/player/thief/fan_of_knives",
		"event:/player/thief/knife_hit",
		"event:/player/thief/knife_swing",
		"event:/player/thief/strike",
		"event:/player/voice/default/death",
		"event:/player/voice/default/hurt",
		"event:/player/voice/female-1/chat/1",
		"event:/player/voice/female-1/chat/2",
		"event:/player/voice/female-1/chat/3",
		"event:/player/voice/female-1/chat/4",
		"event:/player/voice/female-1/chat/5",
		"event:/player/voice/female-1/chat/6",
		"event:/player/voice/female-1/chat/7",
		"event:/player/voice/female-1/chat/8",
		"event:/player/voice/female-1/chat/9",
		"event:/player/voice/female-1/chat/10",
		"event:/player/voice/female-1/chat/11",
		"event:/player/voice/female-1/chat/12",
		"event:/player/voice/female-1/chat/13",
		"event:/player/voice/female-1/chat/14",
		"event:/player/voice/female-1/chat/15",
		"event:/player/voice/female-1/chat/16",
		"event:/player/voice/female-1/chat/17",
		"event:/player/voice/female-1/chat/18",
		"event:/player/voice/female-1/chat/19",
		"event:/player/voice/female-1/chat/20",
		"event:/player/voice/female-1/chat/21",
		"event:/player/voice/female-1/chat/22",
		"event:/player/voice/female-1/chat/23",
		"event:/player/voice/female-1/chat/24",
		"event:/player/voice/female-1/chat/25",
		"event:/player/voice/female-1/chat/26",
		"event:/player/voice/female-1/chat/27",
		"event:/player/voice/female-1/chat/28",
		"event:/player/voice/female-1/chat/29",
		"event:/player/voice/female-1/chat/30",
		"event:/player/voice/female-1/chat/31",
		"event:/player/voice/female-1/chat/32",
		"event:/player/voice/female-1/chat/33",
		"event:/player/voice/female-1/chat/34",
		"event:/player/voice/female-1/chat/35",
		"event:/player/voice/female-1/chat/36",
		"event:/player/voice/female-1/chat/37",
		"event:/player/voice/female-1/chat/38",
		"event:/player/voice/female-1/chat/39",
		"event:/player/voice/female-1/chat/40",
		"event:/player/voice/female-1/chat/41",
		"event:/player/voice/female-1/chat/42",
		"event:/player/voice/female-1/death",
		"event:/player/voice/female-2/hurt",
		"event:/player/voice/female-2/chat/1",
		"event:/player/voice/female-2/chat/2",
		"event:/player/voice/female-2/chat/3",
		"event:/player/voice/female-2/chat/4",
		"event:/player/voice/female-2/chat/5",
		"event:/player/voice/female-2/chat/6",
		"event:/player/voice/female-2/chat/7",
		"event:/player/voice/female-2/chat/8",
		"event:/player/voice/female-2/chat/9",
		"event:/player/voice/female-2/chat/10",
		"event:/player/voice/female-2/chat/11",
		"event:/player/voice/female-2/chat/12",
		"event:/player/voice/female-2/chat/13",
		"event:/player/voice/female-2/chat/14",
		"event:/player/voice/female-2/chat/15",
		"event:/player/voice/female-2/chat/16",
		"event:/player/voice/female-2/chat/17",
		"event:/player/voice/female-2/chat/18",
		"event:/player/voice/female-2/chat/19",
		"event:/player/voice/female-2/chat/20",
		"event:/player/voice/female-2/chat/21",
		"event:/player/voice/female-2/chat/22",
		"event:/player/voice/female-2/chat/23",
		"event:/player/voice/female-2/chat/24",
		"event:/player/voice/female-2/chat/25",
		"event:/player/voice/female-2/chat/26",
		"event:/player/voice/female-2/chat/27",
		"event:/player/voice/female-2/chat/28",
		"event:/player/voice/female-2/chat/29",
		"event:/player/voice/female-2/chat/30",
		"event:/player/voice/female-2/chat/31",
		"event:/player/voice/female-2/chat/32",
		"event:/player/voice/female-2/chat/33",
		"event:/player/voice/female-2/chat/34",
		"event:/player/voice/female-2/chat/35",
		"event:/player/voice/female-2/chat/36",
		"event:/player/voice/female-2/chat/37",
		"event:/player/voice/female-2/chat/38",
		"event:/player/voice/female-2/chat/39",
		"event:/player/voice/female-2/chat/40",
		"event:/player/voice/female-2/chat/41",
		"event:/player/voice/female-2/chat/42",
		"event:/player/voice/female-2/death",
		"event:/player/voice/female-2/hurt",
		"event:/player/voice/male-1/chat/1",
		"event:/player/voice/male-1/chat/2",
		"event:/player/voice/male-1/chat/3",
		"event:/player/voice/male-1/chat/4",
		"event:/player/voice/male-1/chat/5",
		"event:/player/voice/male-1/chat/6",
		"event:/player/voice/male-1/chat/7",
		"event:/player/voice/male-1/chat/8",
		"event:/player/voice/male-1/chat/9",
		"event:/player/voice/male-1/chat/10",
		"event:/player/voice/male-1/chat/11",
		"event:/player/voice/male-1/chat/12",
		"event:/player/voice/male-1/chat/13",
		"event:/player/voice/male-1/chat/14",
		"event:/player/voice/male-1/chat/15",
		"event:/player/voice/male-1/chat/16",
		"event:/player/voice/male-1/chat/17",
		"event:/player/voice/male-1/chat/18",
		"event:/player/voice/male-1/chat/19",
		"event:/player/voice/male-1/chat/20",
		"event:/player/voice/male-1/chat/21",
		"event:/player/voice/male-1/chat/22",
		"event:/player/voice/male-1/chat/23",
		"event:/player/voice/male-1/chat/24",
		"event:/player/voice/male-1/chat/25",
		"event:/player/voice/male-1/chat/26",
		"event:/player/voice/male-1/chat/27",
		"event:/player/voice/male-1/chat/28",
		"event:/player/voice/male-1/chat/29",
		"event:/player/voice/male-1/chat/30",
		"event:/player/voice/male-1/chat/31",
		"event:/player/voice/male-1/chat/32",
		"event:/player/voice/male-1/chat/33",
		"event:/player/voice/male-1/chat/34",
		"event:/player/voice/male-1/chat/35",
		"event:/player/voice/male-1/chat/36",
		"event:/player/voice/male-1/chat/37",
		"event:/player/voice/male-1/chat/38",
		"event:/player/voice/male-1/chat/39",
		"event:/player/voice/male-1/chat/40",
		"event:/player/voice/male-1/chat/41",
		"event:/player/voice/male-1/chat/42",
		"event:/player/voice/male-1/death",
		"event:/player/voice/male-1/hurt",
		"event:/player/voice/male-2/chat/1",
		"event:/player/voice/male-2/chat/2",
		"event:/player/voice/male-2/chat/3",
		"event:/player/voice/male-2/chat/4",
		"event:/player/voice/male-2/chat/5",
		"event:/player/voice/male-2/chat/6",
		"event:/player/voice/male-2/chat/7",
		"event:/player/voice/male-2/chat/8",
		"event:/player/voice/male-2/chat/9",
		"event:/player/voice/male-2/chat/10",
		"event:/player/voice/male-2/chat/11",
		"event:/player/voice/male-2/chat/12",
		"event:/player/voice/male-2/chat/13",
		"event:/player/voice/male-2/chat/14",
		"event:/player/voice/male-2/chat/15",
		"event:/player/voice/male-2/chat/16",
		"event:/player/voice/male-2/chat/17",
		"event:/player/voice/male-2/chat/18",
		"event:/player/voice/male-2/chat/19",
		"event:/player/voice/male-2/chat/20",
		"event:/player/voice/male-2/chat/21",
		"event:/player/voice/male-2/chat/22",
		"event:/player/voice/male-2/chat/23",
		"event:/player/voice/male-2/chat/24",
		"event:/player/voice/male-2/chat/25",
		"event:/player/voice/male-2/chat/26",
		"event:/player/voice/male-2/chat/27",
		"event:/player/voice/male-2/chat/28",
		"event:/player/voice/male-2/chat/29",
		"event:/player/voice/male-2/chat/30",
		"event:/player/voice/male-2/chat/31",
		"event:/player/voice/male-2/chat/32",
		"event:/player/voice/male-2/chat/33",
		"event:/player/voice/male-2/chat/34",
		"event:/player/voice/male-2/chat/35",
		"event:/player/voice/male-2/chat/36",
		"event:/player/voice/male-2/chat/37",
		"event:/player/voice/male-2/chat/38",
		"event:/player/voice/male-2/chat/39",
		"event:/player/voice/male-2/chat/40",
		"event:/player/voice/male-2/chat/41",
		"event:/player/voice/male-2/chat/42",
		"event:/player/voice/male-2/death",
		"event:/player/voice/male-2/hurt",
		"event:/player/warlock/attack",
		"event:/player/warlock/bolt",
		"event:/player/warlock/bolt-fail",
		"event:/player/warlock/dagger",
		"event:/player/warlock/dagger-hit",
		"event:/player/warlock/gargoyle",
		"event:/player/warlock/storm-hit",
		"event:/player/witch_hunter/brand_appear",
		"event:/player/witch_hunter/brand_explode",
		"event:/player/witch_hunter/brand_spawn",
		"event:/player/witch_hunter/crossbow_hit",
		"event:/player/witch_hunter/crossbow_shoot",
		"event:/player/witch_hunter/crossbow_shoot_old",
		"event:/player/witch_hunter/crow_death",
		"event:/player/witch_hunter/crow_hit",
		"event:/player/witch_hunter/crows",
		"event:/player/witch_hunter/hound_hit",
		"event:/player/witch_hunter/hound_shoot",
		"event:/player/witch_hunter/pyre_blast",
		"event:/player/witch_hunter/pyre_death",
		"event:/player/witch_hunter/pyre_loop",
		"event:/player/witch_hunter/pyre_spawn",
		"event:/player/witch_hunter/searing_torch_hit",
		"event:/player/witch_hunter/searing_torch_throw",
		"event:/player/wizard/attack",
		"event:/player/wizard/breath",
		"event:/player/wizard/fireball",
		"event:/player/wizard/flameshield",
		"event:/player/wizard/flameshield_regen",
		"event:/player/wizard/meteor-summon",
		"event:/player/wizard/wave",
		"event:/ui/announce",
		"event:/ui/attune",
		"event:/ui/button_click",
		"event:/ui/button_hover",
		"event:/ui/buy_free",
		"event:/ui/buy_gold",
		"event:/ui/buy_ore",
		"event:/ui/buy_skill",
		"event:/ui/cant_buy",
		"event:/ui/craft",
		"event:/ui/gain_curse",
		"event:/ui/game-cardflip",
		"event:/ui/game-lose",
		"event:/ui/game-suspense",
		"event:/ui/game-win",
		"event:/ui/greath_threat",
		"event:/ui/lockin",
		"event:/ui/sarcophagus-close",
		"event:/ui/speechbubble-magic",
		"event:/ui/speechbubble-normal",
		"event:/ui/statue_build",
		"event:/ui/statue_upgrade",
		"event:/ui/swallow_drink"
	};
}