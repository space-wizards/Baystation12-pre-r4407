#define KSA_ICON_SIZE 32
#define KSA_MAX_ICON_DIMENSION 1024

#define KSA_TILES_PER_IMAGE (KSA_MAX_ICON_DIMENSION / KSA_ICON_SIZE)

//Call this proc to dump your world to a series of image files (!!)
//NOTE: Does not explicitly support non 32x32 icons, so don't blame me if it doesn't work

/mob/verb/ksa_DumpImage()
	set name = "Dump Map"
	ksa_DumpInternal()

/mob/verb/ksa_DumpImageSpecific()
	set name = "Dump Map from Offset"
	ksa_DumpInternal(text2num(input("X")), text2num(input("Y")), text2num(input("Z")))

/mob/verb/ksa_DumpImageSuperSpecific()
	set name = "Dump Single Map Section"
	ksa_DumpTile(text2num(input("X")), text2num(input("Y")), text2num(input("Z")))


/mob/proc/ksa_DumpInternal(var/sx = 1, var/sy = 1, var/sz = 1)

	var/Number_Images_X = ksa_Ceil(world.maxx / KSA_TILES_PER_IMAGE)
	var/Number_Images_Y = ksa_Ceil(world.maxy / KSA_TILES_PER_IMAGE)

	for(var/ImageZ = sz, ImageZ <= world.maxz, ImageZ++)
		for(var/ImageX = sx, ImageX <= Number_Images_X, ImageX++)
			for(var/ImageY = sy, ImageY <= Number_Images_Y, ImageY++)

				ksa_DumpTile(ImageX, ImageY, ImageZ)

			sy = 1
		sx = 1
	world.log << "DONE"

/mob/proc/ksa_DumpTile(var/ImageX, var/ImageY, var/ImageZ)
	world.log << "Making [ImageX]-[ImageY]-[ImageZ]"
	sleep(1)
	var/icon/Tile = icon(file("mapbase.png"))
	for(var/WorldX = 1 + ((ImageX - 1) * KSA_TILES_PER_IMAGE), WorldX <= (ImageX * KSA_TILES_PER_IMAGE) && WorldX <= world.maxx, WorldX++)
		for(var/WorldY = 1 + ((ImageY - 1) * KSA_TILES_PER_IMAGE), WorldY <= (ImageY * KSA_TILES_PER_IMAGE) && WorldY <= world.maxy, WorldY++)
			var/atom/Turf = locate(WorldX, WorldY, ImageZ)
			Tile.Blend(icon(Turf.icon, Turf.icon_state, Turf.dir, 1, 0), ICON_OVERLAY, ((WorldX - ((ImageX - 1) * KSA_TILES_PER_IMAGE)) * KSA_ICON_SIZE) - 31, ((WorldY - ((ImageY - 1) * KSA_TILES_PER_IMAGE)) * KSA_ICON_SIZE) - 31)

	for(var/WorldX = 1 + ((ImageX - 1) * KSA_TILES_PER_IMAGE), WorldX <= (ImageX * KSA_TILES_PER_IMAGE) && WorldX <= world.maxx, WorldX++)
		for(var/WorldY = 1 + ((ImageY - 1) * KSA_TILES_PER_IMAGE), WorldY <= (ImageY * KSA_TILES_PER_IMAGE) && WorldY <= world.maxy, WorldY++)
			var/atom/Turf = locate(WorldX, WorldY, ImageZ)

			var/LowestLayerLeftToDraw
			var/KeepDrawing = 1
			var/HighestDrawnLayer = 0

			while (KeepDrawing)
				LowestLayerLeftToDraw = 1e31
				KeepDrawing = 0
				for(var/atom/A in Turf)
					if (A.layer < LowestLayerLeftToDraw && A.layer > HighestDrawnLayer)
						LowestLayerLeftToDraw = A.layer
						KeepDrawing = 1

				for(var/atom/A in Turf)
					if (A.layer >= LowestLayerLeftToDraw)
						Tile.Blend(icon(A.icon, A.icon_state, A.dir, 1, 0), ICON_OVERLAY, ((WorldX - ((ImageX - 1) * KSA_TILES_PER_IMAGE)) * KSA_ICON_SIZE) - 31 + A.pixel_x, ((WorldY - ((ImageY - 1) * KSA_TILES_PER_IMAGE)) * KSA_ICON_SIZE) - 31 + A.pixel_y)
						HighestDrawnLayer = A.layer

	world.log << "Created."
	sleep(1)
	usr << browse(Tile, "window=picture;file=[ImageX]-[ImageY]-[ImageZ].png;display=0")
	sleep(10)

//prefixed with ksa_ to prevent any duplicate definitions.  Standard Ceiling function (e.g. 2 -> 2; 2.2 -> 3; 2.6 -> 3)
/proc/ksa_Ceil(var/num)
	var/a = round(num, 1)
	if (a < num)
		return a + 1
	return a