local particles = {}


local function add_particle(px, py, pz, vx, vy, vz, ax, ay, az)
    local p = { x = tonumber(px), y = tonumber(py), z = tonumber(pz) }
    local v = { x = tonumber(vx), y = tonumber(vy), z = tonumber(vz) }
    local a = { x = tonumber(ax), y = tonumber(ay), z = tonumber(az) }
    particles[#particles+1] = { p = p, v = v, a = a }
end


local function add_xyz(t1, t2)
    t1.x = t1.x + t2.x
    t1.y = t1.y + t2.y
    t1.z = t1.z + t2.z
end


local function update_particles()
    for i, part in pairs(particles) do
        add_xyz(part.v, part.a)
        add_xyz(part.p, part.v)
    end
end


local function len(t)
    local i = 0
    for _ in pairs(t) do i = i + 1 end
    return i
end


local function check_collisions()
    local collisions = {}
    local dims = {}

    for i, part in pairs(particles) do
        local x, y, z = part.p.x, part.p.y, part.p.z
        if not dims[x] then dims[x] = {} end
        local dimx = dims[x]
        if not dimx[y] then dimx[y] = {} end
        local dimy = dimx[y]
        local dimz = dimy[z]
        if dimz then
            dimz[#dimz+1] = i
            collisions[dimz] = true
        else dimy[z] = { i } end
    end

    for t in pairs(collisions) do
        for _, i in ipairs(t) do
            particles[i] = nil
        end
    end

    return len(collisions) > 0
end


-- main code start here

for line in io.lines('input') do
    add_particle(line:match('p=<(.-),(.-),(.-)>, '
                         .. 'v=<(.-),(.-),(.-)>, '
                         .. 'a=<(.-),(.-),(.-)>'))
end

local no_collision_count = 0
while no_collision_count < 15 do
    local collision = check_collisions()
    update_particles()

    if not collision then
        no_collision_count = no_collision_count + 1
    else
        no_collision_count = 0
    end
end

print(len(particles))
