from world_4 import World, normalise_vector, vector_length, get_nearest_position
import math
import numpy as np

deltat = 0.1

def pedestrian_initialisation(pedestrian, polygons, statistics):
    pass

def update_directions(pedestrians, boundaries, polygons, centre=np.array([0, 0])):
    for i, ped in pedestrians.items():
        reference_angle = math.pi / 2 
        # modify desired direction
        direction_to_centre = normalise_vector(centre - ped.pos)
        tangent_direction = np.array([direction_to_centre[1], -direction_to_centre[0]])
        ped.desired_direction = tangent_direction

        destination_weight = 0.1 # how much they want to be close to the kaaba
        #destination_polygon_centroid = polygons[ped.destination]["nodes"].mean(axis=0)
        #ped.desired_direction = normalise_vector(destination_polygon_centroid - ped.pos)
        # Perpendicular direction to ensure counter-clockwise motion (tangent to the circle)
        tangent_direction = np.array([direction_to_centre[1], -direction_to_centre[0]])  # 90-degree counter-clockwise rotation
        # Set the desired direction to be tangential (circular walking)
        combined_direction = normalise_vector(tangent_direction + destination_weight * direction_to_centre)
        # Initialize the starting position if not already recorded
        if not ped.has_started:
            ped.start_angle = math.atan2(ped.pos[1] - centre[1], ped.pos[0] - centre[0])  # Record the initial angle
            ped.has_started = True
            ped.desired_direction = combined_direction
        else:
            angle_to_centre = math.atan2(ped.pos[1] - centre[1], ped.pos[0] - centre[0])
            if ped.num_circles < 2: # change this to 8
                ped.desired_direction = combined_direction# Check if the pedestrian crosses the 12 o'clock position
                if ped.prev_angle < reference_angle <= angle_to_centre or (ped.prev_angle > angle_to_centre and (reference_angle <= angle_to_centre or ped.prev_angle < reference_angle)):
                    ped.num_circles += 1
                ped.prev_angle = angle_to_centre

            else:
                if ped.rand < 150:
                    ped.desired_direction = combined_direction
                    ped.rand += 1
                else:
                    # Calculate direction tangentially away from the center
                    direction_away_from_center = normalise_vector(ped.pos - centre)
                    ped.desired_direction = direction_away_from_center

def process_interactions(pedestrians, boundaries, polygons, delta_t=deltat):
    # Parameters
    tau = 0.5 # was 0.5
    A_boundary_social, B_boundary_social = 4, 4 # 0.5, 2
    A_boundary_physical = 60
    A_social, B_social = 0.5, 4 # 0.5, 2.... 1 2.5
    A_physical, B_physical = 4, 2
    Lambda = 0.2

    # for additional social force
    centre = np.array([0, 0])  # central point is (0,0)
    radius_threshold = 6
    radius_check = 5
    local_density = 0
    area_of_circle = math.pi * radius_check**2

    for i, ped_i in pedestrians.items():
        # velocity force
        ped_i.acc = (ped_i.desired_walking_speed*ped_i.desired_direction - ped_i.vel) * (1/tau) # VF
        # Pairwise forces from other pedestrians
        for j, ped_j in pedestrians.items():
            if i!=j:
                distance = vector_length(ped_i.pos - ped_j.pos)
                tangent = normalise_vector(ped_i.pos - ped_j.pos)
                # Angular dependency
                vec_ij = normalise_vector(ped_j.pos - ped_i.pos)
                cos_phi = normalise_vector(ped_i.vel).dot(vec_ij)
                angular_dependency = Lambda + (1.0 - Lambda)*((1+cos_phi)/2.0)
                # # Apply physical force
                # if distance <= ped_i.radius+ped_j.radius:
                #     ped_i.acc += A_physical*tangent

                # Improved Elliptical Physical Force Model
                if distance <= ped_i.radius + ped_j.radius:
                    # Relative position vector (d_alpha_beta)
                    norm_d_ab = distance
                    delta_v = ped_j.vel - ped_i.vel  # Relative velocity
                    delta_v = np.asarray(delta_v)  # Ensure delta_v is an array
                    delta_t = float(delta_t)  
                    b_ab = norm_d_ab + np.sqrt(np.maximum(0, (norm_d_ab - np.dot(delta_v, delta_t))**2 - (np.linalg.norm(delta_v) * delta_t)**2))
                    modified_physical_force = (A_physical * B_physical * np.exp(-b_ab / B_social))
                    ped_i.acc += modified_physical_force
                # Apply social force
                ped_i.acc += A_social*angular_dependency*math.exp(-(distance)/B_social)*tangent

                # Apply additional social force - local density
                distance_to_ped_j = vector_length(ped_i.pos - ped_j.pos)
                if distance_to_ped_j <= radius_check:
                    local_density += 1
                density = local_density / area_of_circle
                if density > radius_threshold: # If density exceeds the threshold, apply a force pushing away from the center
                    # Force pushing away from the central point to reduce density
                    away_from_center = normalise_vector(ped_i.pos - centre)
                    ped_i.acc += A_social * away_from_center
                    
        # Forces from boundaries
        for boundary in boundaries:
            pos_b  = get_nearest_position(ped_i.pos, boundary)
            distance = vector_length(ped_i.pos - pos_b)
            tangent = normalise_vector(ped_i.pos - pos_b)
            # Apply physical boundary force
            if distance <= ped_i.radius:
                ped_i.acc += A_boundary_physical*tangent
            # Apply social boundary force
            ped_i.acc += A_boundary_social*math.exp(-(distance)/B_boundary_social)*tangent

        # # 1. Circular Walking Behavior (Around a Central Point)
        # # Calculate the direction towards the center
        # direction_to_center = normalise_vector(centre - ped_i.pos)
        # # Perpendicular direction to ensure counter-clockwise motion (tangent to the circle)
        # tangent_direction = np.array([-direction_to_center[1], direction_to_center[0]])  # 90-degree counter-clockwise rotation
        # ped_i.desired_direction = tangent_direction
        
        # 2. Local Density Check and Social Force for High Density Areas
        local_density = 0
        for j, ped_j in pedestrians.items():
            if i != j:
                distance_to_ped_j = vector_length(ped_i.pos - ped_j.pos)
                if distance_to_ped_j <= radius_check:
                    local_density += 1
        # Calculate the area of the circle (for density calculation)
        area_of_circle = math.pi * radius_check**2
        # Density in persons per square meter
        density = local_density / area_of_circle
        # If density exceeds the threshold, apply a force pushing away from the center
        if density > radius_threshold:
            # Force pushing away from the central point to reduce density
            away_from_center = normalise_vector(ped_i.pos - centre)
            ped_i.acc += A_social * away_from_center  # You can adjust this force as needed

        # The walking direction of each person should be circular, around a central point, in a counter-clockwise direction.

        # If the local density around a pedestrian exceeds 6m−2 (measured within a 5 metre radius around that person), 
        # an additional social force will act upon that pedestrian away from the central point, in order to seek out a lower density environment.

        # When a pedestrian has completed the seven laps, the person will change their walking direction to be tangentially away from the centre.


# Define modelling scenario
# Define the radius of the circle
r = 12  # for example, radius = 5

circle = []
for i in range(128):
    x = r * math.cos(2 * math.pi * i / 16.0)  # Multiply by radius
    y = r * math.sin(2 * math.pi * i / 16.0)  # Multiply by radius
    circle.append([x, y])

circle = np.array(circle)

# or create another bigger circle around the kaaba where the people are generated
# walk around it counter clockwise 7 times
# kinda want to start with people already there and with a random amount of circles completed
   
world_definition = {
    "space": {
        #"walking space": {"type": "polygon", "coordinates": [[-40, -40], [-40, -38], [38, -38], [38, 38], [-38, 38], [-38,-38], [-40,-38], [-40, 40], [40, 40], [40, -40]], "colour": "red", "add_boundaries": False},
        #"walking space": {"type": "polygon", "coordinates": [[-30, -30], [-30, -28], [28, -28], [28, 28], [-28, 28], [-28,-28], [-30,-28], [-30, 30], [30, 30], [30, -30]], "colour": "white", "add_boundaries": False},
        #"walking space": {"type": "rectangle", "coordinates": [-40, -40, 40, 40], "colour": "lightyellow", "add_boundaries": False},
        "walking space": {"type": "rectangle", "coordinates": [-30, 29, 30, 30], "colour": "white", "add_boundaries": False},
        "kaaba": {"type": "rectangle", "coordinates": [-5, -8, 5, 8], "colour": "black", "add_boundaries": True},
        #"kaaba2": {"type": "polygon", "coordinates": circle, "colour": "black", "add_boundaries": True}, # it was -5 -5 5 10
        #"irrelevant": {"type": "rectangle", "coordinates": [-40, -38, 40, -40], "colour": "black", "add_boundaries": False},
        "end": {"type": "polygon", "coordinates": [[-40, -40], [-40, -38], [38, -38], [38, 38], [-38, 38], [-38,-38], [-40,-38], [-40, 40], [40, 40], [40, -40]], "colour": "white", "add_boundaries": False},
    },
    "pedestrians": {
        "group1": {"source": "walking space", "destination": "end", "middle": "kaaba", "colour": "red", "birth_rate": 0.5, "max_count": 200},
    },
    #"boundaries": [[2, 0, corridor_length, 0], [2, corridor_width, corridor_length, corridor_width]],
    #"periodic_boundaries": {"axis": "x", "pos1": 0, "pos2": corridor_length},
    "functions": {
        "update_directions": update_directions,
        "process_interactions": process_interactions,
        "pedestrian_initialisation": pedestrian_initialisation
    }
}

world = World(world_definition)

# # Run simulation for 60 seconds
# for i in range(60000):
#     world.update(deltat)
#     if i%20==0:
#         world.render()

world.save_animation('kaaba_elliptical.gif')

# improvements
# be able to add lots of people and the simulation still work (maybe it all needs to be smaller?)
# what defines the pedestrian speeds, are they realistic?
# how can I validate this model?