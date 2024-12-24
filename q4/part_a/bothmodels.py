from matplotlib import pyplot as plt
import random
import math
import numpy as np
import pandas as pd

from polygon import join_all_polygons
def keyboard_event(event):
    if event.key=='escape' or event.key=="q":
        print('You pressed:', event.key, " - bye!")
        exit()

# Show window
fig1 = plt.figure(1, figsize=(12, 2))
manager = plt.get_current_fig_manager()
manager.window.wm_geometry("+080+080") 
fig2 = plt.figure(2, figsize=(12, 2))
manager = plt.get_current_fig_manager()
manager.window.wm_geometry("+080+480") 
cid = fig1.canvas.mpl_connect('key_press_event', keyboard_event)
cid = fig2.canvas.mpl_connect('key_press_event', keyboard_event)
plt.ion()

class Vehicle:
    def __init__(self, x, v, v_desired):
        self.x = x                          # Current vehicle position (m)
        self.v = v                          # Current vehicle speed (m/s)
        self.v_desired = v_desired          # Desired (free) vehicle speed (m/s

class Simulation1:
    def __init__(self):
        self.time = 0
        self.crashcount = 0
        # Vehicle data
        self.vehicles = []                               # List of vehicles currently on the road
        self.trajectories = {                            # Vehicle trajectories
            "t": [],
            "cc": [],
            "x": [],
            "speed": [], 
            "density": [],
            "flow": []
        }                                 
        # Model parameters
        self.inflow = 3                               # Cars per second
        self.dt = 0.1                                    # Time step (s)
        self.Lc = 5                                      # Car length (m)
        self.Lr = 1000                                   # Road length (m)
        self.tau = 1                                     # Relaxation time (s)
        self.d_c = 50                                    # Model parameter, characteristic distance (m)
        # Intersection definition
        self.intersection = {"position": self.Lr / 2, "is_green": True}

    def update(self, dt):
        self.time += dt
        # Introduce new cars onto the road
        if random.random()<self.inflow*dt:
            # Make sure that there is free space
            if len(self.vehicles)==0 or self.vehicles[0].x>self.Lc:
                speed = 20 #+ 5*random.random()
                self.vehicles.insert(0, Vehicle(x=0, v=0, v_desired=speed))

        # Update vehicles
        n = len(self.vehicles)
        for i in range(n-1, -1, -1):
            d_alpha = self.vehicles[i+1].x - self.vehicles[i].x if n>1 and i<n-1 else 999999.0
            d_alpha_light = self.intersection["position"] - self.vehicles[i].x if (not self.intersection["is_green"]) and self.vehicles[i].x < self.intersection["position"] else 999999.0
            v_e = self.vehicles[i].v_desired/2*(math.tanh(min(d_alpha, d_alpha_light) - self.d_c) + math.tanh(self.d_c))
            acc = (v_e - self.vehicles[i].v)/self.tau

            # Add traffic jam
            #if self.vehicles[i].x>=700 and self.vehicles[i].x<=710:
            #    self.vehicles[i].v = min(5, self.vehicles[i].v)

            self.vehicles[i].v += dt*acc
            self.vehicles[i].x += dt*self.vehicles[i].v
            # Prevent crashes
            if i<n-1 and self.vehicles[i].x > self.vehicles[i+1].x - 1: # maintains minimum distance between vehicles, somehow the difference between 0.1 and 5 is not visually obvious
                if not hasattr(self.vehicles[i], 'has_crashed') or not self.vehicles[i].has_crashed:
                    # Only increment the crash counter if the car hasn't already crashed
                    self.crashcount += 1
                    self.vehicles[i].has_crashed = True  # Mark this car as having crashed

                #Ensure that the car doesn't overlap with the next car
                self.vehicles[i].x = self.vehicles[i+1].x - 5
            # Add current position to trajectories
            self.trajectories["t"].append(self.time) # simulation time
            self.trajectories["cc"].append(self.crashcount) # crash count
            self.trajectories["x"].append(self.vehicles[i].x) # road position
            self.trajectories["speed"].append(self.vehicles[i].v) # speed
            self.trajectories["density"].append(len(self.vehicles) / self.Lr) # number of vehicles on the road / road length
            self.trajectories["flow"].append(len(self.vehicles) / self.Lr * self.vehicles[i].v) # number of vehicles on road currently / road length * speed of vehicle(i)

        # Remove vehicles outside road
        for i in range(n):
            if self.vehicles[i].x > self.Lr:
                self.vehicles.pop(i)

    def render(self):
        # Plot current state
        plt.figure(1)
        plt.cla()
        plt.fill([0, self.Lr, self.Lr, 0], [-3, -3, 3, 3], facecolor="lightgray", edgecolor="lightgray")
        for i in range(len(self.vehicles)):
            plt.plot(self.vehicles[i].x, 0.0, "ko", markersize=1, linewidth=10)

        plt.xlim(-5, self.Lr + 5)
        plt.ylim(-5, self.Lr/100)
        plt.title("Model 1: " + str(round(100*self.time)/100.0) + " s")
        plt.show(block=False)
        plt.pause(0.001)

class Simulation2:
    def __init__(self):
        self.time = 0
        self.crashcount = 0
        # Vehicle data
        self.vehicles = []                               # List of vehicles currently on the road
        self.trajectories = {                            # Vehicle trajectories
            "t": [],
            "cc": [],
            "x": [],
            "speed": [], 
            "density": [],
            "flow": []
        }                                 
        # Model parameters
        self.inflow = 3                                # Cars per second
        self.dt = 0.1                                    # Time step (s)
        self.Lc = 5                                      # Car length (m)
        self.Lr = 1000                                   # Road length (m)
        self.tau = 1                                     # Relaxation time (s)
        #self.d_c = 50                                    # Model parameter, characteristic distance (m)
        # Intersection definition
        self.intersection = {"position": self.Lr / 2, "is_green": True}

    def update(self, dt):
        self.time += dt
        # Introduce new cars onto the road
        if random.random()<self.inflow*dt:
            # Make sure that there is free space
            if len(self.vehicles)==0 or self.vehicles[0].x>self.Lc:
                speed = 20 #+ 5*random.random() #this generates a random number from 30,31,32,33,34
                self.vehicles.insert(0, Vehicle(x=0, v=0, v_desired=speed))

        # Update vehicles
        n = len(self.vehicles)
        for i in range(n-1, -1, -1):
            d_alpha = self.vehicles[i+1].x - self.vehicles[i].x if n>1 and i<n-1 else 999999.0
            d_alpha_light = self.intersection["position"] - self.vehicles[i].x if (not self.intersection["is_green"]) and self.vehicles[i].x < self.intersection["position"] else 999999.0
            if min(d_alpha, d_alpha_light) > 5: # this value is preventing the vehicles gathering at the light with 5m bumper to bumper
                func = (math.tanh((min(d_alpha, d_alpha_light)/(self.vehicles[i].v + 0.00000001)) - 1) + math.tanh(1))
            else:
                func = 0
            v_e = self.vehicles[i].v_desired/2*(func)
            acc = (v_e - self.vehicles[i].v)/self.tau

            # Add traffic jam
            #if self.vehicles[i].x>=700 and self.vehicles[i].x<=710:
            #    self.vehicles[i].v = min(5, self.vehicles[i].v)

            self.vehicles[i].v += dt*acc
            self.vehicles[i].x += dt*self.vehicles[i].v
            # Prevent crashes
            if i<n-1 and self.vehicles[i].x > self.vehicles[i+1].x - 1:
                if not hasattr(self.vehicles[i], 'has_crashed') or not self.vehicles[i].has_crashed:
                    # Only increment the crash counter if the car hasn't already crashed
                    self.crashcount += 1
                    self.vehicles[i].has_crashed = True  # Mark this car as having crashed

                #Ensure that the car doesn't overlap with the next car
                self.vehicles[i].x = self.vehicles[i+1].x - 5
            # Add current position to trajectories
            self.trajectories["t"].append(self.time) # simulation time
            self.trajectories["cc"].append(self.crashcount) # crash count
            self.trajectories["x"].append(self.vehicles[i].x) # position
            self.trajectories["speed"].append(self.vehicles[i].v) # speed
            self.trajectories["density"].append(len(self.vehicles) / self.Lr) # 
            self.trajectories["flow"].append(len(self.vehicles) / self.Lr * self.vehicles[i].v) # number of vehicles on road currently / road length * speed of vehicle(i)

        # Remove vehicles outside road
        for i in range(n):
            if self.vehicles[i].x > self.Lr:
                self.vehicles.pop(i)

    def render(self):
        # Plot current state
        plt.figure(2)
        plt.cla()
        plt.fill([0, self.Lr, self.Lr, 0], [-3, -3, 3, 3], facecolor="lightgray", edgecolor="lightgray")
        for i in range(len(self.vehicles)):
            plt.plot(self.vehicles[i].x, 0.0, "ko", markersize=1, linewidth=10)

        plt.xlim(-5, self.Lr + 5)
        plt.ylim(-5, self.Lr/100)
        plt.title("Model 2: " + str(round(100*self.time)/100.0) + " s")
        plt.show(block=False)
        plt.pause(0.001)

# # free flow scenario
# dt = 0.05
# sim1 = Simulation1()
# sim1.inflow = 0.1
# sim1.d_c = 50
# sim2 = Simulation2()
# sim2.inflow = 0.1
# for i in range(int(240/dt)):
#     sim1.update(dt)
#     sim2.update(dt)
#     if i%20==0:
#         sim1.render()
#         sim2.render()

# # traffic light scenario
# # not convinced I have the 5 distance correct yet - I definitely have it wrong - now the 5m is almost too small
# # we almost need pre light dynamics and post light dynamics for both models
# # if self.tau is too high then both models just ignore the traffic light
# dt = 0.05
# sim1 = Simulation1()
# sim1.Lr = 600
# sim1.tau = 0.2 # what is this number? and what is a realistic value for it to be
# sim1.d_c = 5  # if this is above 5 then it ruins the traffic light distance situation, but changing this changes the dynamics after the light as well
# sim1.intersection = {"position": 200, "is_green": False}
# sim2 = Simulation2()
# sim2.Lr = 600
# sim2.tau = 0.2 # what is this number? and what is a realistic value for it to be
# sim2.intersection = {"position": 200, "is_green": False}
# for i in range(int(120/dt)):
#     sim1.intersection["is_green"] = i > 1200
#     sim2.intersection["is_green"] = i > 1200
#     sim1.update(dt)
#     sim2.update(dt)
#     if i%20==0:
#         sim1.render()
#         sim2.render()

# # # post processing flow values
# print("Average Speed in Model 1:", sum(sim1.trajectories["speed"]) / len(sim1.trajectories["speed"]))
# print("Average Speed in Model 2:", sum(sim2.trajectories["speed"]) / len(sim2.trajectories["speed"]))
# # how can I post process flows for only after the light turns green

# sudden car crash scenario
dt = 0.05
sim1 = Simulation1()
sim1.Lr = 1200
sim1.tau = 0.5 # what is this number? and what is a realistic value for it to be
sim1.d_c = 20
sim1.inflow = 1   # if this is above 5 then it ruins the traffic light distance situation, but changing this changes the dynamics after the light as well
sim1.intersection = {"position": 1000, "is_green": True}
sim2 = Simulation2()
sim2.Lr = 1200
sim2.tau = 0.5 # what is this number? and what is a realistic value for it to be
sim2.inflow = 1  # what is this number? and what is a realistic value for it to be



sim2.intersection = {"position": 1000, "is_green": True}
for i in range(int(120/dt)):
    sim1.intersection["is_green"] = i < 400
    sim2.intersection["is_green"] = i < 400
    sim1.update(dt)
    sim2.update(dt)
    if i%20==0:
        sim1.render()
        sim2.render()

# I still don't like that this relies on a light

# # model each cars deccelaration as it approaches the light
# print("Crash Counter for Model 2: ", (sim2.trajectories["cc"]))
# print("Simulation Time: ", sim2.trajectories["t"])
# # print("Average Speed in Model 2:", sum(sim2.trajectories["speed"]) / len(sim2.trajectories["speed"]))

# Find the minimum length among the arrays
min_length = min(len(sim1.trajectories["t"]), len(sim1.trajectories["cc"]),
                 len(sim2.trajectories["t"]), len(sim2.trajectories["cc"]))

# Trim all arrays to the minimum length
sim1_t = sim1.trajectories["t"][:min_length]
sim1_cc = sim1.trajectories["cc"][:min_length]
sim2_t = sim2.trajectories["t"][:min_length]
sim2_cc = sim2.trajectories["cc"][:min_length]

# Create a DataFrame with only 't' (time) and 'cc' (crash count)
trajectories_df = pd.DataFrame({
    'SimulationTime1': sim1_t,
    'CrashCount1': sim1_cc,
    'SimulationTime2': sim2_t,
    'CrashCount2': sim2_cc
})
# Save the DataFrame to a CSV file
trajectories_df.to_csv('dcequals20.csv', index=False)