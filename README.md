
# 🧹 SQL Data Cleaning Project - Layoffs Dataset

This project focuses on cleaning and preparing a real-world dataset using **MySQL** for analysis. It follows standard data cleaning steps such as removing duplicates, handling null values, standardizing formats, and correcting inconsistencies.

---

## 📁 Dataset

- **Source**: [Layoffs 2022 Dataset - Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Description**: A dataset containing records of layoffs across various companies, industries, and countries during 2020–2023.

---

## 🛠️ Tools Used

- **SQL (MySQL)**
- MySQL Workbench or any SQL-compatible interface

---

## 📌 Cleaning Objectives

1. **Create a working (staging) table**
2. **Remove duplicate records**
3. **Standardize text fields (industry, country, etc.)**
4. **Fix formatting issues (e.g., date format)**
5. **Handle and impute null values where possible**
6. **Drop irrelevant rows/columns**

---

## 🧾 Steps and Key SQL Operations

### 1️⃣ Create a Staging Table
To preserve the original raw data:
```sql
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
```

---

### 2️⃣ Remove Duplicates
- Identify duplicates using `ROW_NUMBER() OVER (...)`
- Remove rows where `row_num > 1`

```sql
DELETE FROM layoffs_staging2
WHERE row_num >= 2;
```

---

### 3️⃣ Standardize and Fix Data

#### 🏢 Fix inconsistent `industry` entries:
- Replace empty strings with `NULL`
- Fill null values based on company name (self-join)
- Standardize categories (e.g., Crypto → Crypto)

```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('CryptoCurrency', 'Crypto Currency');
```

#### 🌍 Fix country name:
```sql
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);
```

#### 📅 Convert date format:
```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
```

---

### 4️⃣ Handle Nulls
- Kept `NULL`s in `total_laid_off`, `percentage_laid_off`, and `funds_raised_millions` for later analysis.
- Deleted rows where both `total_laid_off` and `percentage_laid_off` are `NULL`.

```sql
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
```

---

### 5️⃣ Final Cleanup
- Dropped the helper `row_num` column:
```sql
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
```

---

## ✅ Final Output

A clean, reliable dataset ready for:
- **Exploratory Data Analysis (EDA)**
- **Dashboard building (e.g., Tableau, Power BI)**
- **Reporting and storytelling**

---

## 🧠 Skills Demonstrated

- Data cleaning using advanced SQL techniques
- Window functions (`ROW_NUMBER`)
- Conditional updates with `JOIN`s
- Handling nulls and missing values
- Data type conversions
- Best practices in maintaining data integrity

---

## 📌 Project Status

✔️ Completed  
📝 Ready for EDA, visualization, and insights

---

## 🧳 Ideal For

- Data Analyst Portfolio  
- Interview showcase for SQL proficiency  
- Step before integrating into a BI tool

---

## 🧩 Next Steps (Optional)

- Visualize layoffs by country/industry over time  
- Analyze trends across company stages or funding  
- Integrate with external economic indicators

---

## 📬 Contact

Feel free to connect or ask questions:

- [LinkedIn](www.linkedin.com/in/komal-kushwaha-47a0b7231)
- [Email](mailto:komalkushwaha1476@gmail.com)
