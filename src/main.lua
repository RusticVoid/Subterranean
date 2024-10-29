require "textures"
require "world"
require "tile"
require "player"

function love.load()
    
    windowWidth, windowHeight = love.window.getMode()
    fps = 0
    debug = false
    WorldSize = 64

    print("Welcome To Subterranean By Homeless Studios")
    print("Develper: RusticVoid")
    print("Writer: DogWoodDan, Large_man")
    print("Soon to be artist: Orange_Aide")
    print("Right now artist: RusticVoid")
    print("")
    print("Pick a number for an option")
    print("1: Start")
    print("2: Quit")
    option = io.read()

    if option == "1" then
        print("")
        print("World Size:")
        print("1: Small (64x64 in chunks, 1024x1024 in tiles)")
        print("2: Medium (128x128 in chunks, 2048x2048 in tiles)")
        print("3: Large (256x256 in chunks, 4096x4096 in tiles)")
        option = io.read()
        if option == "1" then
            WorldSize = 64
        end
        if option == "2" then
            WorldSize = 128
        end
        if option == "3" then
            WorldSize = 256
        end
    else
        print("Give it a second!")
        love.event.quit()
    end

    print("")
    print("STARTING WORLD GEN!")

    print("SETTING RANDOM SEED!")
    math.randomseed(os.clock())

    print("SETTING TILE SIZE!")
    tileSize = 30

    print("INITIALIZING TEXTURES!")
    InitTextures()

    print("INITIALIZING TILES!")
    wallTile = Tile.new(wallTexture)
    floorTile = Tile.new(floorTexture)
    spawnTile = Tile.new(redGroundTexture)

    print("CREATING WORLD!")
    world = World.new(WorldSize)
    world:genWorld()

    print("GENERATING CAVES!")
    world:genCave(500, 2000)
    
    print("SPAWING PLAYER!")
    spawned = false
    while spawned == false do
        ChunkX = math.random(0, world.size)
        ChunkY = math.random(0, world.size)
        ChunkSize = world.chunks[ChunkX][ChunkY].size
        SpawnX = math.random(0, ChunkSize)
        SpawnY = math.random(0, ChunkSize)

        if world.chunks[ChunkY][ChunkX].chunkData[SpawnY][SpawnX] == floorTile then
            world.chunks[ChunkY][ChunkX].chunkData[SpawnY][SpawnX] = spawnTile
            spawned = true
            world.x = -((((ChunkX*ChunkSize)*tileSize)+(SpawnX*tileSize)-(windowWidth/2)+(tileSize/1.5)))
            world.y = -((((ChunkY*ChunkSize)*tileSize)+(SpawnY*tileSize)-(windowHeight/2)+(tileSize/1.5)))
        end
    end

    player = Player.new((windowWidth/2)-(tileSize/1.5), (windowHeight/2)-(tileSize/1.5), 8)

    print("STARTING WORLD GEN!")
end

function love.update(dt)
    DeltaTime = dt
    fps = love.timer.getFPS()

    windowWidth, windowHeight = love.window.getMode()

    if love.keyboard.isDown("w") then
        world.y = world.y + player.speed * DeltaTime
    end
    if love.keyboard.isDown("a") then
        world.x = world.x + player.speed * DeltaTime
    end
    if love.keyboard.isDown("s") then
        world.y = world.y - player.speed * DeltaTime
    end
    if love.keyboard.isDown("d") then
        world.x = world.x - player.speed * DeltaTime
    end

    world:update()
end

function love.keypressed(key)
    if key == "f1" then
        debug = not debug
    end
    if debug == true then
        if key == "f2" then

        end
    end
end

function love.draw()
    world:draw()
    love.graphics.print("FPS: "..fps)
    if debug == true then
        love.graphics.print("Player X:"..-math.floor(((world.x-player.x)/tileSize)/16)-1, 0, 15)
        love.graphics.print("Player Y:"..-math.floor(((world.y-player.y)/tileSize)/16)-1, 0, 30)
    end
    player:draw()
end
