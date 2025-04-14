// Player Initialization (Create Event)

// Movement variables
move_speed = 100;
acceleration = 400;
max_speed = 100;
friction = 600;
dash_speed = 700;

// Dash variables
dash_velocity = 0;
dash_duration = 0.2 * room_speed; // Convert seconds to frames
dash_timer = 0;

// Player velocity (optional)
hspeed = 0;
vspeed = 0;

// Player Movement & Dash (Step Event)

// Get input for movement (WASD or arrow keys)
var input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
var input_y = keyboard_check(vk_down) - keyboard_check(vk_up);

// Normalize the input vector (direction)
var input_vector = vector2(input_x, input_y);

// Normalize the input if it's not zero
if (input_vector != [0, 0]) {
    input_vector = vector2_normalize(input_vector);
}

// Dash mechanic (when "Shift" is pressed)
if (keyboard_check_pressed(vk_shift) && dash_timer <= 0) {
    dash_velocity = dash_speed;   // Start dashing
    dash_timer = dash_duration;   // Set dash duration (time in frames)
}

// Decrease dash timer, slow down dash velocity over time (smooth out dash)
if (dash_timer > 0) {
    dash_timer -= 1; // Decrease dash time
} else {
    dash_velocity = lerp(dash_velocity, 0, 0.1); // Smooth transition to zero
}

// Final movement speed (accounting for dash speed)
var speed = move_speed + dash_velocity;
var vel = input_vector * speed;  // Velocity vector (movement)

// Apply movement if input is detected
if (input_vector != [0, 0]) {
    hspeed = vel.x;
    vspeed = vel.y;
} else {
    // Apply friction when no input is given
    hspeed = lerp(hspeed, 0, friction * delta_time);
    vspeed = lerp(vspeed, 0, friction * delta_time);
}

// Apply the final position
x += hspeed;
y += vspeed;

// Handle basic collision (if you use `move_and_slide()` or custom physics)
var new_x = x + hspeed;
var new_y = y + vspeed;

// Check for collisions here (basic check)
if (!place_meeting(new_x, new_y, obj_wall)) {
    x = new_x; // Apply X position
    y = new_y; // Apply Y position
} else {
    // Handle collisions (if any)
    // Bounce, slide, or stop the movement depending on your needs
}

// Particle system for dash trail (if desired)
if (keyboard_check_pressed(vk_shift)) {
    var part = part_system_create();  // Create particle system
    var particle = part_emitter_create(part);
    part_emitter_region(part, particle, x, y, x, y, ps_shape_point);
    part_emitter_emit(particle, ps_dust, 10);  // 10 particles on dash start
}

// Dash sound (if you want to add sound effects for dash)
if (keyboard_check_pressed(vk_shift)) {
    audio_play_sound(snd_dash, 0, false);
}