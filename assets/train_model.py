import pandas as pd
import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.impute import SimpleImputer
import json

# 1. Load the Data
# Ensure this matches your actual filename exactly
filename = "Crop_recommendation.csv" 
data = pd.read_csv(filename)

print("--- Data Loaded ---")

# 2. Prepare Data
# Inputs (Features): Everything except the label
X = data.drop('label', axis=1) 

# Handling Missing data 
#if any value in NaN , replace it with column's average
imputer=SimpleImputer(strategy='mean')
X_imputed=imputer.fit_transform(X)

# Output (Target): Only the label
y = data['label']

# 3. Encode Labels (Convert "Rice", "Maize" to numbers 0, 1, 2...)
# Computers understand numbers, not words.
le = LabelEncoder()
y_encoded = le.fit_transform(y)

# Save this mapping! We need it for the App later to translate numbers back to names.
label_map = {int(index): label for index, label in enumerate(le.classes_)}
with open('labels.json', 'w') as f:
    json.dump(label_map, f)
print("--- Labels Saved to labels.json ---")

# 4. Split Data (80% for training, 20% for testing)
X_train, X_test, y_train, y_test = train_test_split(X_imputed, y_encoded, test_size=0.2, random_state=42)

# 5. Build the Neural Network (The "Brain")
model = tf.keras.models.Sequential([
    # Input Layer: We have 7 inputs (N, P, K, Temp, Hum, pH, Rain)
    tf.keras.layers.Dense(64, activation='relu', input_shape=(7,)),
    # Hidden Layer: Thinks about patterns
    tf.keras.layers.Dense(32, activation='relu'),
    # Output Layer: One neuron for each possible crop. 'softmax' gives probability.
    tf.keras.layers.Dense(len(le.classes_), activation='softmax')
])

# 6. Compile the Model
model.compile(optimizer='adam', 
              loss='sparse_categorical_crossentropy', 
              metrics=['accuracy'])

# 7. Train! (Epochs = how many times it reads the data)
print("--- Starting Training ---")
model.fit(X_train, y_train, epochs=50, batch_size=32, verbose=1)

# 8. Check Accuracy
loss, accuracy = model.evaluate(X_test, y_test)
print(f"\n--- Final Accuracy: {accuracy*100:.2f}% ---")

# 9. Save and Convert to TensorFlow Lite (For the Mobile App)
# This creates the file we will actually put on the phone.
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('crop_model.tflite', 'wb') as f:
    f.write(tflite_model)

print("\n--- SUCCESS: Model saved as 'crop_model.tflite' ---")
