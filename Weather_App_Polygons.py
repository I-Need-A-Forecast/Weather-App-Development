#Step 1: Establish array for points and bounding points.

#Imports this dictionary, not sure what it does, check later.
from collections import defaultdict

#--------------
#Defines my function for seeing if duplicates are listed.
def list_duplicates(seq):
    
    #Seems to generate a running list of all inputs to see if a duplicate
    #is raised.
    tally = defaultdict(list)

    #Checks what the incoming item is and its location in the list of items.
    #If it is new, it starts a new tally list, if one exists, it appends
    #the location of the duplicate.
    for i,item in enumerate(seq):
        tally[item].append(i)

    #Returns the findings. len(locs)>0 returns all, >1 returns duplicates.
    return ((key,locs) for key,locs in tally.items() if len(locs)>1)


#--------------
#Defines my function to list the locations of duplicate items in various lists.
#This list only returns the location within the array of the evaluated list.
#Additionally, it calls the 'list_duplicates' array to initially search for the
#potential duplicates and return the results.
def duplicate_locations(source):

    #Sets a blank array.
    skip_list = []

    #Calls the 'list_duplicates' function to see if duplicates are listed.
    for duplicate in sorted(list_duplicates(source)):

        #For any duplicates found, it calls the second array (the enumerated
        #portion of the return and finds how many locations were found.
        #It will cycle through the length of that list minus one.
        for n in range(len(duplicate[1])-1):

            #We use +1 to make sure the inital time the value is seen is still
            #utilized during this function. All other instances can be skipped,
            #and therefore added to the skip_list.
            skip_list.append(duplicate[1][n+1])

    #Finally, it sorts the list based on value.
    skip_list.sort()

    #Returns the findings.
    return(skip_list)


def perp_bisector(x_1, y_1, x_2, y_2):

    midpoint = [((x_1 + x_2) / 2), ((y_1 + y_2) / 2)]

    if x_2 == x_1:
        slope = False
    else:
        slope = (y_2 - y_1) / (x_2 - x_1)

    if y_2 == y_1:
        slope_perp = False
    else:
        slope_perp = (x_1 - x_2) / (y_2 - y_1)
        y_intersection_perp = midpoint[1] - (slope_perp * midpoint[0])

    return(slope_perp, y_intersection_perp)
    

def line_intersection(c_points, bounds):

    new_polygon = []
    print(points)




#THIS WAS ONLY FOR TESTING PURPOSES!
        #---------
#print("First you are here:")
#source = [(0,0),(1,1),(2,2),(0,0),(3,3),(3,3),(2,2),(0,0),(3,2),(2,2)]
#print(duplicate_locations(source))
        #---------


#This section will be for importing the bounding box and each individual
#location.
#The bounding box will need to be listed sequentially from one point immediately
#followed by its linked point and continuing on until a closed polygon is formed.

bounds = [
    (0, 4),
    (4, 4),
    (4, 0),
    (0, 0),
    (0, 0)]

points = [
    (1, 3),
    (3, 3),
    (3, 1),
    (1, 1),
    (1, 3),
    (1, 1)]

#--------------
#This section will make a pass through the bounding box list and then the
#points list to identify any duplicates. This will ensure the program doesn't
#recalculate the same point again or potentially raise errors.
#It will only print any duplicates found and references the above
#listed 'list_duplicates' definition.
#Finally, it will remove any duplicates it finds from the main lists.

#Calls above function to find duplicates and generate a list of their positions.
bounds_duplicates = duplicate_locations(bounds) #list of duplicate bounds
points_duplicates = duplicate_locations(points) #list of duplicate points

#Removes duplicates from main list, reversed loop direction is negate errors.
for n in reversed(bounds_duplicates):
    del(bounds[n])

for n in reversed(points_duplicates):
    del(points[n])

del(bounds_duplicates, points_duplicates)

#-------------
#Time to get the core of this script where we generate our best-fit polygons.
all_polygons = []
skipped_pairs = []

for main_count, main in enumerate(points):
    #all_polygons.append([step])
    #all_polygons[n].extend(bounds)

    temp_box = bounds
    print("0, points:", points)
    print("1, temp_box:", temp_box)

    for check_count, check in enumerate(points):
        if (2**(main_count) + 2**(check_count)) in skipped_pairs:
            print("New skip:", 2**(main_count) + 2**(check_count) in skipped_pairs)
            print("Skipped_pairs:", skipped_pairs, "& check:", 2**(main_count) + 2**(check_count))
            break
        if check_count != main_count:

            x_mid = (main[0] + check[0]) / 2
            y_mid = (main[1] + check[1]) / 2
            print("2, Main, Mid, Check", main, (x_mid, y_mid), check)

            #This is purely if the new perpendicular line is vertical!
            #See the 'else' section for all other computations.
            if check[1] == main[1]:
                #slope_perp = False
                print("3, vertical perpendicular bisecting line")

                for turn in range(len(temp_box)):
                    print("4, looping through bounding box:", temp_box[turn], turn)

                    #Checks if any of the bounding lines are also vertical.
                    #If they are not, the script continues.
                    if temp_box[turn-1][0] != temp_box[turn][0]:
                        print("5, TRUE, not vertical, different x_values:", temp_box[turn-1][0], temp_box[turn][0])
                        temp_slope = ((temp_box[turn-1][1] - temp_box[turn][1])
                                      / (temp_box[turn-1][0] - temp_box[turn][0]))

                        temp_intercept = temp_box[turn][1] - (temp_slope *
                                            temp_box[turn][0])
                        print("6, Temp_slope:", temp_slope, "int:", temp_intercept)

                        new_point = (x_mid, (temp_slope * x_mid) + temp_intercept)
                        print("7, NEW POINT on bounding box:", new_point)

                        #Now to find out what points stays and which one goes.
                        #This section takes the first evaluted point and finds
                        #the line to one of the bounding points.
                        print("From here, we are seeing where the cross point is, and if it is in range")
                        if new_point not in temp_box:
                            print("8, Entering New_Point")
                            if main[0] != temp_box[turn][0]:
                                print("9, main_x & bounding_x not vertical", main, temp_box[turn])                    
                                check_slope = ((temp_box[turn][1] - main[1])
                                               / (temp_box[turn][0] - main[0]))
                                check_intercept = main[1] - (check_slope * main[0])
                                print("10, Check slope, intercept:", check_slope, check_intercept)

                                #Proves where the crossing occurs.
                                cross_point = (x_mid, (check_slope * x_mid) + check_intercept)

                                print("11, Cross_point:", cross_point)

                                print("12, Low, x, high", min(main[0],temp_box[turn][0]), cross_point[0], max(main[0],temp_box[turn][0]))
                                print("13, Low, y, high", min(main[1],temp_box[turn][1]), cross_point[1], max(main[1],temp_box[turn][1]))
                                
                                if ((min(main[0],temp_box[turn][0]) < cross_point[0] < max(main[0],temp_box[turn][0]))
                                and (min(main[1],temp_box[turn][1]) < cross_point[1] < max(main[1],temp_box[turn][1]))):
                                    print("*********Holy crap, you did it!")
                                    temp_box[turn] = new_point
                                    print("14, temp_box", temp_box)
                                    print("main, check count:", main_count, check_count)
                                    skipped_pairs.append(2**(main_count) + 2**(check_count))
                                else:
                                    print("CRAAAAAAAAP!")
                                
                                

                        
            else:
                slope_perp = (main[0] - check[0]) / (check[1] - main[1])
                y_intersection_perp = y_mid - (slope_perp * x_mid)
                print("slope of:", slope_perp, "crossing at", y_intersection_perp)

                #if slope == slope, parallel

            
            

#r = line_intersection(points, bounds)

#Step 2: Find new point, ma-*9rk as calculated
