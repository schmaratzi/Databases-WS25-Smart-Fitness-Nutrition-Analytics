import matplotlib.pyplot as plt
import pandas as pd

#Read the data
workout_df = pd.read_csv('workout_probid.csv')
proband_df = pd.read_csv('proband_probid.csv')

#Merge on proband_id
merged_df = pd.merge(workout_df, proband_df[['proband_id', 'Gender']], on='proband_id')

#Create boxplots for Average Calories Burned by Gender and for Average Session Duration by Gender
plt.figure(figsize=(10, 5))

#Figure has two subplots side by side and start with the left one
plt.subplot(1, 2, 1)
#Boxplot for Average Calories Burned by Gender
#ax=plt.gca() otherwise only one boxplot is shown
merged_df.boxplot(column='Calories_Burned', by='Gender', ax=plt.gca())
plt.title('Calories Burned by Gender')
plt.ylabel('Calories Burned')

#Subplot on the right
plt.subplot(1, 2, 2)
#Boxplot for Average Session Duration by Gender
merged_df.boxplot(column='Session_Duration (hours)', by='Gender', ax=plt.gca())
plt.title('Session Duration by Gender')
plt.ylabel('Session Duration (hours)')

plt.tight_layout()
#Add a main title
plt.suptitle('Query 3: Gender vs Performance Metrics')

#Save the figure
plt.savefig('boxplots_gender_vs_performance.png')
print("Created boxplots_gender_vs_performance.png")
