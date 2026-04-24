# 📊 HR Employee Attrition & Root Cause Analysis

## 🎯 Project Overview
Employee turnover is a major cost for any organization. This project analyzes a dataset of 1,470 employees to identify the root causes of attrition and define the "flight-risk persona." 

By combining **SQL** for data processing and **Power BI** for visualization, this analysis moves beyond overall metrics to pinpoint localized hotspots (like the Sales department) and uncover the hidden impact of operational factors (like Overtime) on employee retention.

## 🛠️ Tools & Technologies
- **Data Manipulation & Querying:** SQL Server
- **Data Visualization:** Power BI
- **Data Source:** CSV

## 📂 Project Structure
```text
HR-Attrition-Analysis/
├── data/
│   ├── HR_Data_Raw.csv             # Raw dataset
│   └── HR_Data_Dictionary.xlsx     # Full data dictionary
├── HR-Analysis.sql                 # SQL scripts for data cleaning & metrics calculation
├── HR_Analysis_Dashboard.pbix      # Interactive Power BI file
├── HR_Analysis_Dashboard.pdf       # Exported dashboard for quick preview
└── README.md                       # Project documentation
```
## 📖 Key Data Dictionary (Core Variables)

| Feature | Data Type | Description / Values | Role in Analysis |
| :--- | :--- | :--- | :--- |
| **`Attrition`** | **Target** | Yes (Left) / No (Stayed) | The core target metric being tracked and analyzed. |
| **`Age`** | Numerical | Actual age of the employee | Highlighted the high vulnerability of staff under 25. |
| **`Department`** | Categorical | Sales, R&D, HR | Used to identify the highest-risk department. |
| **`JobLevel`** | Ordinal | 1 (Entry) to 5 (Director) | Showed that Entry-level staff quit the most. |
| **`JobRole`** | Categorical | Sales Rep, Lab Technician, etc. | Used to define the specific high-risk persona. |
| **`MonthlyIncome`** | Numerical | Monthly salary | Confirmed low pay as a contributing factor to attrition. |
| **`OverTime`** | Categorical | Yes / No | **Identified as the primary root cause of burnout.** |
| **`WorkLifeBalance`** | Ordinal | 1 (Bad) to 4 (Best) | Correlated with OverTime to show the "Toxic Combo". |
| **`JobSatisfaction`** | Ordinal | 1 (Low) to 4 (Very High) | Proved that even highly satisfied employees leave if overworked. |

## 💡 Key Findings & Actionable Insights
- The Overall Picture: The company faces a 16.12% attrition rate (237 employees lost).
- The Hotspot: The bleeding is concentrated in the Sales Department (~20% attrition rate), specifically among Entry-Level staff.
- The High-Risk Persona: The typical leaver is a Young Sales Representative (Under 25) with low income.
- The Root Cause (The Toxic Combo): Overtime is the silent killer. It triples the quit rate across the board. Even employees who reported a "Good" Work-Life Balance or "Very High" Job Satisfaction saw their attrition rates jump to 40% and 25% respectively when forced to work overtime.

## 🚀 Recommendations for HR
- Immediate Action: Audit and restrict overtime hours for the young Sales Representative group. Redistribute workload to prevent burnout.
- Long-term Strategy: Review the base compensation structure for entry-level sales roles, as passion and satisfaction cannot compensate for physical exhaustion and low pay.

## 📸 Dashboard Snapshot

**Page 1: The Problem & Hotspots**
<img width="1326" height="768" alt="image" src="https://github.com/user-attachments/assets/bf11d621-b2e7-4737-a569-493d4525ffe3" />

**Page 2: The Flight-Risk Persona**
<img width="1324" height="764" alt="image" src="https://github.com/user-attachments/assets/74cd651a-b0ac-4299-b77d-a786f46380dc" />

**Page 3: Root Cause Analysis**
<img width="1324" height="766" alt="image" src="https://github.com/user-attachments/assets/bce2ec95-17ab-4e25-9b3a-56c5c407ff3c" />
