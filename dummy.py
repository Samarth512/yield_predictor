import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import pickle

# Load dataset
data = pd.read_csv('processed_dataset.csv')

# Encode categorical features
data['Crop'] = data['Crop'].astype('category').cat.codes
data['Season'] = data['Season'].astype('category').cat.codes
data['State'] = data['State'].astype('category').cat.codes

# Feature engineering (if Yield is not already calculated)
if 'Yield' not in data.columns:
    data['Yield'] = data['Production'] / data['Area']

# Features (X) and target (y)
X = data[['Crop', 'Season', 'State', 'Area', 'Annual_Rainfall', 'Fertilizer', 'Pesticide']]
y = data['Yield']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train Random Forest model
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate the model
y_pred = model.predict(X_test)
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
rmse = mean_squared_error(y_test, rmse=mean )
 

print(f"Root Mean Squared Error: {rmse}")

# Save the trained model
with open('random_forest_model.pkl', 'wb') as f:
    pickle.dump(model, f)

print("Model saved as random_forest_model.pkl")

# Get feature importances
importances = model.feature_importances_

# Create a DataFrame to display feature importances
feature_importance_df = pd.DataFrame({
    'Feature': X.columns,
    'Importance': importances
})

# Sort by importance (highest to lowest)
feature_importance_df = feature_importance_df.sort_values(by='Importance', ascending=False)

# Print feature importances
print("Feature importance hierarchy:")
print(feature_importance_df)
