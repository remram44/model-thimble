finger_hole = [17, 15];
round_length = 17;
tube_length = 10;
thickness = 1;
rugged_size = 0.5;

module _end_of_customizer_vars() {}

$fn = $preview ? 30 : 80;

module round_part() {
    difference() {
        scale([finger_hole.x/2 + thickness, round_length + thickness, finger_hole.y/2 + thickness])
        sphere(1);

        scale([finger_hole.x/2, round_length, finger_hole.y/2])
        sphere(1);

        translate([-finger_hole.x/2-thickness, -round_length-thickness, 0])
        cube([finger_hole.x+thickness*2, round_length*2+thickness*2, finger_hole.y/2+thickness]);

        translate([-finger_hole.x/2-thickness, -round_length-thickness, -finger_hole.y/2-thickness])
        cube([finger_hole.x+thickness*2, round_length+thickness, finger_hole.y+thickness*2]);
    }
}

module rugged() {
    xy_diam = sqrt(finger_hole.x*finger_hole.y);
    xy_n = floor(PI*xy_diam/4/rugged_size);

    yz_diam = sqrt(finger_hole.y*round_length*2);
    yz_n = floor(PI*yz_diam/8/rugged_size);

    z_n = floor(tube_length / rugged_size / 2);

    for(xy = [0:xy_n]) {
        xy_angle = xy * 180/xy_n;

        for(yz = [0:yz_n]) {
            yz_angle = yz * 90/yz_n;

            pos = [
                cos(yz_angle)*cos(xy_angle)*finger_hole.x/2,
                sin(yz_angle)*round_length,
                -cos(yz_angle)*sin(xy_angle)*finger_hole.y/2,
            ];

            if(pos.z < -rugged_size*2)
            translate(pos)
            sphere(rugged_size/2, $fn=10);
        }

        for(z = [1:z_n-1]) {
            pos = [
                cos(xy_angle)*finger_hole.x/2,
                -z * rugged_size * 2,
                -sin(xy_angle)*finger_hole.y/2,
            ];

            translate(pos)
            sphere(rugged_size/2, $fn=10);

            translate([pos.x, pos.y, -pos.z])
            sphere(rugged_size/2, $fn=10);
        }
    }
}

module tube_part() {
    rotate([90, 0, 0])
    difference() {
        scale([finger_hole.x/2+thickness, finger_hole.y/2+thickness, tube_length])
        cylinder(1, 1, 1);

        translate([0, 0, -1])
        scale([finger_hole.x/2, finger_hole.y/2, tube_length+2])
        cylinder(1, 1, 1);
    }
}

round_part();
rugged();
tube_part();
