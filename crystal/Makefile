sphere_shadow.ppm: sphere_shadow.cr src/*
	crystal run sphere_shadow.cr

sphere_material.ppm: sphere_material.cr src/*
	crystal run sphere_material.cr

camera_scene.ppm: camera_scene.cr src/*
	crystal run camera_scene.cr

plane_scene.ppm: plane_scene.cr src/*
	crystal run plane_scene.cr

stripe_scene.ppm: stripe_scene.cr src/*
	crystal run stripe_scene.cr

grad_scene.ppm: grad_scene.cr src/*
	crystal run grad_scene.cr

rings_scene.ppm: rings_scene.cr src/*
	crystal run rings_scene.cr

checks_scene.ppm: checks_scene.cr src/*
	crystal run checks_scene.cr

all : *.ppm

test :
	crystal spec

