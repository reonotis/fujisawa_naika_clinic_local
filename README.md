# fujisawa_naika_clinic ローカル開発環境

[fujisawa_naika_clinic](https://github.com/reonotis/fujisawa_naika_clinic) (Laravel 11 / PHP 8.3) 用の Docker 環境です。nginx + PHP-FPM 構成で、`fujisawa_naika_clinic_src/` にアプリ本体を clone します（`fujisawa_naika_clinic_src/` はこのリポジトリの管理対象外）。

## 構成

| コンテナ | 役割 | ホスト側ポート |
|---|---|---|
| web | Nginx | http://localhost:8002 |
| app | PHP-FPM 8.3 + Laravel | (内部のみ) |
| db | MySQL 8.0 | localhost:3308 |
| phpmyadmin | DB管理画面 | http://localhost:8082 |
| mailpit | メール確認 | http://localhost:8027 (SMTP: 1027) |
| node | Vite (profile: tools) | http://localhost:5174 |

ポートは標準(8000/8080/8025/1025/3306)から +2 ずらしています（new_balance_v2 は +1、HP は 8000 系）。変更はルートの `.env` で行えます。

> Vite の dev サーバーのみ、`fujisawa_naika_clinic_src/vite.config.js` が 5174 を前提としているため 5174 固定です。

## セットアップ

```bash
git clone https://github.com/reonotis/fujisawa_naika_clinic.git fujisawa_naika_clinic_src
cp .env.example .env
docker compose up -d --build
docker compose exec app composer install
docker compose exec app cp .env.example .env
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate
```

`fujisawa_naika_clinic_src/.env` は以下に変更してください（コンテナ間通信は内部ポートを使います）。

```
APP_URL=http://localhost:8002
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
```

## フロントエンド (Vite)

```bash
docker compose run --rm node npm install
docker compose run --rm node npm run build
docker compose run --rm --service-ports node npm run dev
```

## よく使うコマンド

```bash
docker compose exec app bash
docker compose exec app php artisan <command>
docker compose logs -f app
docker compose down
```
