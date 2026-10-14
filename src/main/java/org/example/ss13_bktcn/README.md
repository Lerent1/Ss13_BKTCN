# Campus Hub – Docker Deployment

## 1. Thông tin sinh viên

- **Họ và tên:** Nguyen Tuan Minh
- **Lớp:** CNTT4
- **Tên project:** Ss13_BKTCN

## 2. Giới thiệu

Project sử dụng Spring Boot và Gradle, được đóng gói và chạy bằng Docker. Docker Compose được sử dụng để quản lý backend và cơ sở dữ liệu MySQL.

Các thành phần chính:

- **Backend:** Ứng dụng Spring Boot chạy trên cổng `8080`.
- **MySQL:** Cơ sở dữ liệu chạy trong Docker container.
- **Dockerfile:** Đóng gói ứng dụng thành Docker image theo phương pháp multi-stage build.
- **Docker Compose:** Khởi động và quản lý các dịch vụ backend và MySQL.

## 3. Công nghệ sử dụng

- Java 21
- Spring Boot
- Gradle
- Docker
- Docker Compose
- MySQL 8.4

## 4. Cấu trúc project

```text
Ss13_BKTCN/
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── gradle/
├── build.gradle
├── gradlew
├── gradlew.bat
├── Dockerfile
├── .dockerignore
├── compose.yml
└── README.md
```

## 5. Cấu hình ứng dụng

Backend sử dụng các biến môi trường để cấu hình kết nối cơ sở dữ liệu:

| Biến môi trường | Giá trị khi chạy bằng Compose |
|---|---|
| `SPRING_DATASOURCE_URL` | `jdbc:mysql://mysql:3306/campus_hub` |
| `SPRING_DATASOURCE_USERNAME` | `root` |
| `SPRING_DATASOURCE_PASSWORD` | Lấy từ `MYSQL_ROOT_PASSWORD` |

Trong Docker Compose, backend kết nối đến MySQL thông qua hostname `mysql` và cổng nội bộ `3306`.

MySQL được ánh xạ ra máy tính cá nhân qua cổng `3307`.

## 6. Kiểm tra Gradle

Mở PowerShell tại thư mục project và chạy:

```powershell
.\gradlew.bat clean test
```

Lệnh này thực hiện làm sạch thư mục build và chạy các bài kiểm thử.

Để build file JAR:

```powershell
.\gradlew.bat clean bootJar
```

## 7. Build Docker image

Kiểm tra phiên bản Docker:

```powershell
docker --version
docker compose version
docker info
```

Kiểm tra cấu hình Docker Compose:

```powershell
docker compose -f compose.yml config
```

Build image:

```powershell
docker compose -f compose.yml build
```

Dockerfile sử dụng multi-stage build để build ứng dụng bằng Gradle và chạy ứng dụng bằng Java Runtime Environment 21.

## 8. Khởi động ứng dụng

Khởi động backend và MySQL:

```powershell
docker compose -f compose.yml up -d
```

Kiểm tra các container:

```powershell
docker compose -f compose.yml ps
```

Xem log backend:

```powershell
docker compose -f compose.yml logs --tail=100 backend
```

Xem log MySQL:

```powershell
docker compose -f compose.yml logs --tail=100 mysql
```

## 9. Kiểm tra Health Check

Sau khi backend khởi động thành công, chạy:

```powershell
curl.exe -i http://localhost:8080/actuator/health
```

Kết quả mong đợi:

- HTTP status: `200 OK`
- Nội dung phản hồi có trạng thái `UP`.

Ví dụ:

```json
{
  "status": "UP"
}
```

Nếu endpoint không hoạt động, kiểm tra dependency Spring Boot Actuator, cấu hình endpoint và log backend.

## 10. Dừng ứng dụng

Dừng các container:

```powershell
docker compose -f compose.yml down
```

Nếu cần xóa cả volume chứa dữ liệu MySQL, sử dụng:

```powershell
docker compose -f compose.yml down -v
```

**Lưu ý:** Lệnh `down -v` sẽ xóa volume do Compose quản lý và có thể làm mất dữ liệu cơ sở dữ liệu.

## 11. Ảnh minh chứng

Bổ sung ảnh chụp màn hình thực tế sau khi hoàn thành:

1. **Gradle Test:** Kết quả `BUILD SUCCESSFUL` sau khi chạy kiểm thử.
2. **Docker Containers:** Kết quả `docker compose -f compose.yml ps`, thể hiện trạng thái các container.
3. **Health Check:** Kết quả truy cập `http://localhost:8080/actuator/health` trả về HTTP `200 OK` và trạng thái `UP`.

Lưu ảnh vào thư mục `screenshots/` và chèn ảnh vào README, ví dụ:

```markdown
![Gradle Test](screenshots/gradle-test.png)

![Docker Containers](screenshots/docker-containers.png)

![Health Check](screenshots/health-check.png)
```

## 12. Kết luận

Project được chuẩn bị để đóng gói và triển khai ứng dụng Spring Boot cùng MySQL bằng Docker Compose. Các bước kiểm thử, build image, khởi động container và kiểm tra Health Check cần được thực hiện để xác nhận ứng dụng hoạt động đúng.

