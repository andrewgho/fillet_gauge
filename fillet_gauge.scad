// fillet_gauge.scad - radius measurement tool
// Andrew Ho (andrew@zeuscat.com)
//
// Similar idea to: https://www.thingiverse.com/thing:1184315

// Sum of integers from start to end
function sum(start, end) = end * (start + end) / 2;

// From smallest radius to largest (TODO: how to handle steps?)
smallest = 1;
biggest = 8;

corner_radius = 4;
corner_offset = 12;
width = sum(smallest, biggest) + corner_offset;
height = sum(smallest, biggest) + corner_radius;
thickness = 4;

e = 0.1;
e2 = e * 2;
$fn = 180;

// Rectangular with corners rounded to radius in X-Y plane
module rounded_rectangle(width, height, depth, radius) {
    module corner() {
        cylinder(r = radius, h = depth);
    }
    hull() {
        translate([radius, radius]) corner();
        translate([width - radius, radius]) corner();
        translate([width - radius, height - radius]) corner();
        translate([radius, height - radius]) corner();
    }
}

// Cylinder with thickness extended by epsilon in both Z dimensions
module cutout_cylinder(x, y, depth, radius) {
    translate([x, y, -e]) {
        cylinder(r = radius, h = depth + e2);
    }
}

difference() {
    // Base rounded rectangle
    rounded_rectangle(width, height, thickness, corner_radius);

    // Cut out smaller set of 1-8mm radius circles along lower left diagonal
    y0 = height - corner_radius;
    for (r = [smallest:1:biggest]) {
        cutout_cylinder(sum(smallest, r - 1), y0 - sum(smallest, r),
                        thickness, r);
    }

    // Cut out lower left along line described by the cut out circle centers
    translate([0, 0, -e]) {
        linear_extrude(thickness + e2) {
            polygon([[-e, y0], [0, y0],
                     [sum(smallest, biggest - 1), y0 - sum(smallest, biggest)],
                     [sum(smallest, biggest - 1), -e],
                     [-e, -e]]);
        }
    }

    // Cut out larger set of 9-11mm radius circles along lower left diagonal
    // TODO: calculate these
    y1 = corner_offset + biggest;
    cutout_cylinder(width, y1, thickness, biggest + 1);
    cutout_cylinder(width - (biggest + 1), y1 + (biggest + 2),
                    thickness, biggest + 1);
    cutout_cylinder(width - ((biggest + 2) + (biggest + 1)),
                    y1 + (biggest + 2) + (biggest + 1),
                    thickness, biggest + 2);

    // Cut out upper right along line described by the cut out circle centers
    x1 = width - ((biggest + 2) + (biggest + 1) + biggest + e);
    translate([0, 0, -e]) {
        linear_extrude(thickness + e2) {
            polygon([[x1, height + e], [width + e, height + e],
                     [width + e, y1 - biggest], [width, y1 - biggest]]);
        }
    }
}

// TODO: add labels
