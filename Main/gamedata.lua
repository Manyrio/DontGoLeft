

WorldTypes = {}

WorldTypes.Spawn = {smooth = 20,
											size = 50, --size in buckets
											xheight = -500,
											yheight = 2500,
											startx = 3000,
											starty = 0,
											layers = {
													{label = "air", depth = -6000},
													{label = "dirt", depth = 2000},
													{label = "stone", depth = 8000},
													{label = "rock", depth = 15000},
														{label = "deadstone", depth = 20000},
													},
											Ores = { gold = {size = 1,mindepth = 3000, maxdepth = 20000, rare = 100},
													 mud = {size = 8,mindepth = 2000, maxdepth = 7000, rare = 700},
										
													}
											
											}
					
ItemTypes = {
							dirt = {
											background = {107,76,53,255},
											foreground = {119,92,45,255},
											stack = 500,
											},
							stone = {
											background = {163, 163, 163, 255},
											foreground = {120,120,120,255},
											stack = 500,
											},
							rock = {
											background = {115,115,115,255},
											foreground = {80,80,80,255},
											stack = 500,
											},
							deadstone = {
											background = {59,60,111,255},
											foreground = {20,21,65,255},
											stack = 500,
											},
							gold = {
											background = {199,205,152,255},
											foreground = {215,203,67,255},
											stack = 500,
											},
							mud = {
											background = {91,84,109,255},
											foreground = {80,70,90,255},
											stack = 500,
											}
							}
							
