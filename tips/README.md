# terraform-tips

## 概要

* Terraform の特定サービスに依らない共通的な Sample/Tips 群。
* terraform 実行環境 Docker 付き。


## Docker 実行方法

### 起動
```bash
# Docker イメージをビルド。
# 初回実行、および Dockerfile/docker-compose.yaml に変更がある場合のみ。
docker-compose build

# Dockerコンテナ起動 & ログイン
docker-compose run --rm terraform

# --- 以降の手順は Docker コンテナ内 ---
```

### 実行

```bash
# ディレクトリ移動
cd <各Sampleディレクトリ>

# terraform 初期化
terraform init

# terraform 構成ファイルの検証（文法や論理構成の正しさ）
terraform validate

# 更新内容の確認
terraform plan

# 更新実行
terraform apply

# 更新実行（途中の確認をスキップしたい場合）
terraform apply -auto-approve

# 管理化にあるリソースを全削除
terraform destroy [-auto-approve]

```


### 終了
```bash
# Dockerコンテナからログアウト
exit
```