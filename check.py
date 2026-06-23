import pandas as pd

# Đọc file
import pandas as pd

df = pd.read_excel(r"C:\Users\Admin\Downloads\Final_Project\VietDist_Analytics_Project\VietDist_DataSouces\SRC10_promotion_program.xlsx")

print(df.head())
print(df.shape)
# =========================
# 1. CHECK NULL
# =========================

# Đếm số lượng null mỗi cột
null_count = df.isnull().sum()

print("NULL COUNT:")
print(null_count)

# Chỉ lấy các cột có null
print("\nCOLUMNS HAVING NULL:")
print(null_count[null_count > 0])


# =========================
# 2. CHECK DUPLICATE
# =========================

# Check duplicate toàn bộ row
duplicate_count = df.duplicated().sum()

print("\nDUPLICATE ROW COUNT:")
print(duplicate_count)

print(df.info())


