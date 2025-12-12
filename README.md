# PantryPartnersApp

Pantry Partners is an operational support tool designed to help food banks monitor and manage real-time distribution conditions. The system collects data on wait times, food inventory, volunteer availability, and external factors such as weather. Pantry Partners presents this information through a dashboard, enabling staff to anticipate shortages, balance distribution across windows, and make quick adjustments during peak hours. Pantry Partners aims to reduce wait times, minimize waste, and ensure a smoother distribution process for volunteers and the community.
This project is a Processing-based simulation that models people entering, queueing, waiting, becoming hungry, getting served, and leaving a community food-distribution line.


# Features
### Queue System
- Automatic spawning of new people.
- Assignment to one of four serving windows.
- `posInLine` determines queue order.
- Correct draw ordering so front-of-line appears visually in front.

## Food Inventory:
- This feature will show food supply throughout the day. 
- It will decrease as food is given out and increase as food is donated.

## Window Locking System
- able to close windows
- people currently in queue will move to another windows
- if all windows are closed they will get more hungry and leave

## Hunger levels
- People with different hunger amounts will affect the amount of food that each person gets
- This can be seen with the color of the people on screen.
 - red --> 0-10 cans --> Most hungry
 - yellow --> 0-5 cans --> hungry
 - green --> 0 cans --> satisfied

## Weather Adjusted Factors
- The feature will adjust related factors (wait time, speed, etc) based on the severity of weather conditions
- e.g. sunny days will be smoother, rainy days will be slower.

## Movement Algorithm
- Each person moves toward their assigned window or queue position.
- After being served, they exit the screen.