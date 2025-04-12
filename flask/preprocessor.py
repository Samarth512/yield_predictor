import pandas as pd
from sklearn.preprocessing import MinMaxScaler

# Load dataset
data = pd.read_csv('crop_yield.csv')

# Handle missing values
data['Annual_Rainfall'] = data['Annual_Rainfall'].fillna(data['Annual_Rainfall'].mean())
data['Fertilizer'] = data['Fertilizer'].fillna(data['Fertilizer'].mean())
data['Pesticide'] = data['Pesticide'].fillna(data['Pesticide'].mean())
data['Crop'] = data['Crop'].fillna(data['Crop'].mode()[0])
data['Season'] = data['Season'].fillna(data['Season'].mode()[0])
data['State'] = data['State'].fillna(data['State'].mode()[0])

# Encode categorical variables
data['Crop'] = data['Crop'].astype('category').cat.codes
data['Season'] = data['Season'].astype('category').cat.codes
data['State'] = data['State'].astype('category').cat.codes

# Calculate Yield (if not present)
if 'Yield' not in data.columns:
    data['Yield'] = data['Production'] / data['Area']

# Normalize numerical columns
scaler = MinMaxScaler()
data[['Area', 'Annual_Rainfall', 'Fertilizer', 'Pesticide']] = scaler.fit_transform(
    data[['Area', 'Annual_Rainfall', 'Fertilizer', 'Pesticide']]
)

# Save processed dataset
data.to_csv('processed_dataset.csv', index=False)
print("Dataset saved as processed_dataset.csv")
