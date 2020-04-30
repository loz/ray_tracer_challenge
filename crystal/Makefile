sphere_shadow.ppm: sphere_shadow.cr
	crystal run sphere_shadow.cr

sphere_material.ppm: sphere_material.cr
	crystal run sphere_material.cr

camera_scene.ppm: camera_scene.cr
	crystal run camera_scene.cr

plane_scene.ppm: plane_scene.cr
	crystal run plane_scene.cr

stripe_scene.ppm: stripe_scene.cr
	crystal run stripe_scene.cr

all : sphere_material.ppm sphere_material.ppm 

test :
	crystal spec

