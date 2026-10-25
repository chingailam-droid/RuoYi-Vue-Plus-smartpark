# 智慧园区后端基线

GitHub 默认分支是 `6.X`。根 `pom.xml` 的 `revision` 为 **6.0.0**（Spring Boot 4.1.1，JDK 21）。当前默认线不是 5.x。`5.X` 分支为上游 5.6.2（JDK 17，Spring Boot 3.5.16），只作保留。

官方文档：<https://plus-doc.dromara.org/#/ruoyi-vue-plus/home>

## 运行要求

- JDK 21（编译 `release` 为 21；README 另标注 JDK 25）
- Maven 3.9，使用仓库内 `./mvnw`（3.9.12）
- MySQL 8，驱动 `com.mysql.cj.jdbc.Driver`
- Redis 6 及以上（客户端 Redisson）
- MinIO，S3 兼容。连接信息在表 `sys_oss_config`，不在 yml 里写口令

打包：

```bash
./mvnw -B -pl ruoyi-admin -am clean package -DskipTests
```

## 园区环境

示例文件：`ruoyi-admin/src/main/resources/application-smartpark.yml.example`。只含占位符 `${MYSQL_USERNAME}`、`${MYSQL_PASSWORD}`、`${REDIS_PASSWORD}`、`${MINIO_ACCESS_KEY}`、`${MINIO_SECRET_KEY}`。

| 项 | 值 |
| --- | --- |
| MySQL | `114.67.125.174:13309`，库名 `ry-smartpark` |
| Redis | `114.67.125.174:13379`，`database` 为 `11` |
| MinIO | `114.67.125.174:13090`，bucket `smartpark` |
| 本地后端 | `8081` |

本地 `dev` / `prod` 与 Docker Compose 已改到同一库名、Redis 索引和后端端口。Nginx 监听 80，上游为 `8081` 与 `8082`。

## 演示账号

以 `script/sql/ry_vue.sql` 的 `sys_user` 为准，并与口令哈希核对：

- `admin` / `admin123`
- `test`、`test1` / `666666`（昵称中写明的数据权限演示账号）

参数 `sys.user.initPassword` 为 `123456`，只用于新建用户，不是上述登录口令。
