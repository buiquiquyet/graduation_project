# -----------------------------------------------------------------
# GIAI ĐOẠN 1: BUILD ỨNG DỤNG REACT (Node 20 Alpine)
# -----------------------------------------------------------------
FROM node:20-alpine AS build

# Đặt thư mục làm việc
WORKDIR /app

# Copy package.json và package-lock.json trước để cache npm install
COPY package*.json ./

# Xóa lockfile cũ nếu có lỗi nền tảng (Windows -> Linux)
RUN rm -f package-lock.json

# Cài lại dependencies trong môi trường Linux (đúng nền tảng)
RUN npm install

# Cài TypeScript toàn cục (nếu dự án cần tsc)
RUN npm install -g typescript

# Sao chép toàn bộ mã nguồn
COPY . .

COPY .env.production .env

# Thiết lập biến môi trường production
ENV NODE_ENV=production

# Build ứng dụng
RUN npm run build

# -----------------------------------------------------------------
# GIAI ĐOẠN 2: CHẠY BẰNG NGINX
# -----------------------------------------------------------------
FROM nginx:alpine

# Xóa cấu hình mặc định
RUN rm /etc/nginx/conf.d/default.conf

# ⚠️ COPY sai tên file → bạn ghi là conf.conf, Nginx sẽ không nhận
# Đúng là copy vào thư mục conf.d/ để Nginx load tự động
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy kết quả build từ stage build sang
COPY --from=build /app/dist /usr/share/nginx/html

# Mở cổng 80
EXPOSE 80

# Lệnh khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
