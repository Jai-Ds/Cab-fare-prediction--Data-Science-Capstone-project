

# Cab Fare Prediction - Data Science Capstone Project

This project aims to apply analytics for fare prediction using historical data from a pilot project.

## Files

- **Train Data:**
  - Variables:
    - `pickup_datetime`
    - `pickup_longitude`
    - `pickup_latitude`
    - `dropoff_longitude`
    - `dropoff_latitude`
    - `passenger_count`

- **Test Data:**
  - Test data requiring fare prediction

- **Original Predictions:**
  - Python Predictions: `Original_with_fare&Dist_python.csv`
  - R Predictions: `Original_with_fare_amount&Dist_R.csv`

- **Project Reports:**
  - Detailed project report: `Project Report_Cab_Rental`

- **Code Files:**
  - Python Code: `Project_2.ipynb`
  - R Code: `Project_2_R`

## Project Overview

### Missing Value Analysis

- Identified missing values in the dataset and addressed them.

### Feature Engineering

- Derived new variables (`Month`, `Year`, `Time (Hrs)`, `Day`, `Day/Night`) from the `pickup_datetime` variable.
- Calculated `Distance_Km` using geographical coordinates.

### Outlier Analysis

- Filtered data based on reasonable thresholds for `passenger_count`, `fare_amount`, and `Distance_Km`.
- Conducted boxplot analysis for outliers in specific variables.

### Converted Variables

- Converted specific variables (`passenger_count`, `Month`, `Year`, `Day`, `Day/Night`) into factor variables.

### Dimensionality Reduction

- Removed variables (`pickup_datetime`, `pickup_longitude`, `pickup_latitude`, `dropoff_longitude`, `dropoff_latitude`) based on heatmap analysis.

### Dummy Variables (One Hot Encoding)

- Created dummy variables for better analysis of specific factor variables (`Month`, `Year`, `Day`, `Day/Night`, `passenger_count`).

### Machine Learning Models

- Applied Linear Regression (LR) model in Python and Random Forest in R for fare prediction.

## Usage

1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```

2. Navigate to the project directory:
   ```bash
   cd Cab-Fare-Prediction--Data-Science-Capstone-project
   ```

3. Explore the project files and reports for a detailed understanding.

Feel free to refer to the `Project Report_Cab_Rental` for an in-depth explanation of the project.


**Note:** Adjust file paths and comments as needed for your project structure.
