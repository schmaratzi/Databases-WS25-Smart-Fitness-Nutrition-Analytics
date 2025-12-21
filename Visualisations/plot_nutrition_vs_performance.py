import matplotlib.pyplot as plt
import pandas as pd

#Read the data
workout_df = pd.read_csv('workout_probid.csv')
proband_df = pd.read_csv('proband_probid.csv')
nutrition_df = pd.read_csv('nutrition_probid.csv')

#Merge on proband_id
merge_df = (proband_df[['proband_id', 'Gender']]
    .merge(workout_df, on='proband_id')
    .merge(nutrition_df, on='proband_id'))

#Calculate calories burned per hour
merge_df['calories_burned_per_hour'] = merge_df['Calories_Burned'] / merge_df['Session_Duration (hours)']

#Create scatter plot for Calories Consumed vs Calories Burned per Hour
plt.figure(figsize=(8, 6))

#Female points in orange
female_df = merge_df[merge_df['Gender'] == 'Female']
plt.scatter(female_df['Calories'], female_df['calories_burned_per_hour'], color='orange', alpha=0.5, label='Female')
#Male points in blue
male_df = merge_df[merge_df['Gender'] == 'Male']
plt.scatter(male_df['Calories'], male_df['calories_burned_per_hour'], color='blue', alpha=0.5, label='Male')

plt.title('Query 4: Calories Consumed vs Calories Burned per Hour')
plt.xlabel('Calories Consumed')
plt.ylabel('Calories Burned per Hour')
plt.legend()
plt.grid(True)

plt.tight_layout()
#Save the figure
plt.savefig('scatter_nutrition_vs_performance.png')
print("Created scatter_nutrition_vs_performance.png")


### Not included in the presentation but kept for completeness of query visualizations ###

# #Create scatter plot for Water Intake vs Calories Burned per Hour
# plt.figure(figsize=(8, 6))

# #Female points in orange
# plt.scatter(female_df['Water_Intake (liters)'], female_df['calories_burned_per_hour'], color='orange', alpha=0.5, label='Female')
# #Male points in blue
# plt.scatter(male_df['Water_Intake (liters)'], male_df['calories_burned_per_hour'], color='blue', alpha=0.5, label='Male')

# plt.title('Water Intake (liters) vs Calories Burned per Hour')
# plt.xlabel('Water Intake (liters)')
# plt.ylabel('Calories Burned per Hour')
# plt.legend()
# plt.grid(True)

# plt.tight_layout()
# #Save the figure
# plt.savefig('scatter_water_vs_performance.png')
# print("Created scatter_water_vs_performance.png")
