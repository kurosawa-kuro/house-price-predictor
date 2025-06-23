# 🏠 House Price Predictor – MLOps学習プロジェクト

**House Price Predictor**プロジェクトへようこそ！これは機械学習パイプラインの構築と運用化をマスターするために設計された、実践的なエンドツーエンドMLOpsユースケースです。

生データから始まり、データ前処理、特徴量エンジニアリング、実験、MLflowでのモデル追跡、そして必要に応じてJupyterでの探索まで、業界標準のツールを使用しながら一連の流れを学びます。

> 🚀 **MLOpsをゼロからマスターしたい方へ**  
[School of DevOpsのMLOpsブートキャンプ](https://schoolofdevops.com)でスキルアップしましょう。

---

## 📦 プロジェクト構成

```
house-price-predictor/
├── configs/                # モデル用YAML設定ファイル
├── data/                   # 生データと処理済みデータセット
├── deployment/
│   └── mlflow/             # MLflow用Docker Compose設定
├── models/                 # 訓練済みモデルと前処理器
├── notebooks/              # 実験用Jupyterノートブック（オプション）
├── src/
│   ├── data/               # データクリーニングと前処理スクリプト
│   ├── features/           # 特徴量エンジニアリングパイプライン
│   ├── models/             # モデル訓練と評価
├── requirements.txt        # Python依存関係
└── README.md               # このファイル
```

---

## 🛠️ 学習・開発環境のセットアップ

まず、以下のツールがシステムにインストールされていることを確認してください：

- [Python 3.11](https://www.python.org/downloads/) **または** [Python 3.12](https://www.python.org/downloads/)
- [Git](https://git-scm.com/)
- [Visual Studio Code](https://code.visualstudio.com/) または他のエディタ
- [UV – Pythonパッケージ・環境管理ツール](https://github.com/astral-sh/uv)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) **または** [Podman Desktop](https://podman-desktop.io/)

---

## 🚀 環境の準備

### 前提条件の確認

1. **必要なツールがインストールされているか確認：**
   ```bash
   python3 --version  # Python 3.11以上
   git --version      # Git
   docker --version   # Docker
   ```

2. **UVのインストール確認：**
   ```bash
   uv --version
   ```
   インストールされていない場合：
   ```bash
   sudo snap install astral-uv --classic
   ```

### プロジェクトのセットアップ

1. **このリポジトリをフォーク**してください（GitHub上で）

2. **フォークしたリポジトリをクローン：**
   ```bash
   # xxxxxxをあなたのGitHubユーザー名または組織名に置き換えてください
   git clone https://github.com/xxxxxx/house-price-predictor.git
   cd house-price-predictor
   ```

3. **UVを使用してPython仮想環境をセットアップ：**
   ```bash
   # Python 3.11の場合
   uv venv --python python3.11
   # または Python 3.12の場合
   uv venv --python python3.12
   
   source .venv/bin/activate
   ```

4. **仮想環境が正しくアクティベートされたか確認：**
   ```bash
   which python
   # 出力例: /home/wsl/dev/mlops/house-price-predictor/.venv/bin/python
   
   python --version
   # 出力例: Python 3.12.3
   ```

5. **依存関係をインストール：**
   ```bash
   uv pip install -r requirements.txt
   ```

6. **インストールの確認：**
   ```bash
   python -c "import mlflow, pandas, numpy, sklearn; print('All packages installed successfully!')"
   ```

---

## ⚠️ トラブルシューティング

### Python 3.12での依存関係インストールエラー

Python 3.12を使用している場合、以下のエラーが発生する可能性があります：

#### 1. numpyビルドエラー
```
ModuleNotFoundError: No module named 'distutils'
```

**解決策：** `requirements.txt`の`numpy==1.24.3`を`numpy>=1.25.0`に変更してください。

#### 2. pyarrowビルドエラー
```
CMake Error: Could not find a package configuration file provided by "Arrow"
```

**解決策：** `requirements.txt`の末尾に`pyarrow>=14.0.0`を追加してください。

#### 3. mlflowとpyarrowのバージョン競合
```
Because mlflow==2.3.1 depends on pyarrow>=4.0.0,<12 and you require pyarrow>=14.0.0
```

**解決策：** `requirements.txt`の`mlflow==2.3.1`を`mlflow>=2.10.0`に変更してください。

### Docker関連の問題

#### 1. MLflowにアクセスできない（WSL2環境）
```
ERR_CONNECTION_REFUSED
```

**解決策：**
1. WSL2のIPアドレスを確認：`ip addr show eth0 | grep inet`
2. `http://[WSL2のIP]:5555`でアクセス（例：`http://192.168.1.131:5555`）

#### 2. Docker Composeの警告
```
WARN[0000] the attribute `version` is obsolete, it will be ignored
```

**解決策：** この警告は無視して問題ありません。新しいDocker Composeでは`version`属性は不要です。

#### 3. コンテナが起動しない
```bash
# コンテナのログを確認
docker compose logs

# コンテナを再起動
docker compose down
docker compose up -d
```

### 修正後のrequirements.txt例
```txt
# データ処理・分析
pandas==1.5.3
numpy>=1.25.0

# 機械学習
scikit-learn==1.2.2
xgboost==1.7.5

# 可視化
matplotlib==3.7.1
seaborn==0.12.2

# 実験追跡・モデル管理
mlflow>=2.10.0

# テスト
pytest==7.3.1

# API開発
fastapi==0.95.2
uvicorn==0.22.0

# その他
pyyaml>=6.0.1
joblib==1.3.1
setuptools==65.5.0
ipykernel==6.29.5
pyarrow>=14.0.0
```

---

## 📊 実験追跡用MLflowのセットアップ

実験とモデル実行を追跡するために：

```bash
cd deployment/mlflow
docker compose -f docker-compose.yaml up -d
docker compose ps
```

> 🐧 **Podmanを使用している場合：**
```bash
podman compose -f docker-compose.yaml up -d
podman compose ps
```

### WSL2環境でのMLflowアクセス

WSL2環境では、`localhost`でのアクセスに問題がある場合があります。以下の手順で確認してください：

#### 1. コンテナの状態確認
```bash
docker compose ps
```
出力例：
```
NAME                     IMAGE                          COMMAND                  SERVICE   CREATED         STATUS         PORTS
mlflow-tracking-server   ghcr.io/mlflow/mlflow:latest   "mlflow server --hos…"   mlflow    4 minutes ago   Up 4 minutes   0.0.0.0:5555->5000/tcp, [::]:5555->5000/tcp
```

#### 2. WSL2のIPアドレス確認
```bash
ip addr show eth0 | grep inet
```
出力例：
```
inet 192.168.1.131/24 brd 192.168.1.255 scope global noprefixroute eth0
```

#### 3. MLflow UIへのアクセス
以下のURLのいずれかでアクセスしてください：

**推奨方法（WSL2のIPアドレスを使用）：**
```
http://192.168.1.131:5555
```

**代替方法（localhostを使用）：**
```
http://localhost:5555
```

> ⚠️ **注意**: WSL2環境では、`localhost`でのアクセスが拒否される場合があります。その場合は、WSL2のIPアドレス（例：`192.168.1.131:5555`）を使用してください。

#### 4. トラブルシューティング

**ポートがリッスンしているか確認：**
```bash
netstat -tlnp | grep 5555
```

**コンテナを再起動する場合：**
```bash
docker compose down
docker compose up -d
```

**Docker Composeの警告について：**
```
WARN[0000] the attribute `version` is obsolete, it will be ignored
```
この警告は無視して問題ありません。Docker Composeの新しいバージョンでは`version`属性は不要です。

---

## 📒 JupyterLabの使用（オプション）

インタラクティブな環境を好む場合は、JupyterLabを起動してください：

```bash
uv python -m jupyterlab
# または
python -m jupyterlab
```

---

## 🔁 モデルワークフロー

### 🧹 ステップ1: データ処理

生の住宅データセットをクリーニングと前処理：

```bash
python src/data/run_processing.py \
  --input data/raw/house_data.csv \
  --output data/processed/cleaned_house_data.csv
```

---

### 🧠 ステップ2: 特徴量エンジニアリング

変換を適用し、特徴量を生成：

```bash
python src/features/engineer.py \
  --input data/processed/cleaned_house_data.csv \
  --output data/processed/featured_house_data.csv \
  --preprocessor models/trained/preprocessor.pkl
```

---

### 📈 ステップ3: モデリングと実験

モデルを訓練し、すべてをMLflowにログ：

```bash
python src/models/train_model.py \
  --config configs/model_config.yaml \
  --data data/processed/featured_house_data.csv \
  --models-dir models \
  --mlflow-tracking-uri http://localhost:5555
```

---

## FastAPIとStreamlitアプリケーションの構築

FastAPIとStreamlitアプリのコードは、すでに`src/api`と`streamlit_app`に用意されています。これらのアプリを構築して起動するには：

* FastAPI用のビルドのため、ソースコードのルートに`Dockerfile`を追加
* Streamlitアプリをパッケージ化・ビルドするため、`streamlit_app/Dockerfile`を追加
* 両方のアプリを起動するため、ルートパスに`docker-compose.yaml`を追加。Streamlitアプリの環境変数に`API_URL=http://fastapi:8000`を設定することを忘れずに

両方のアプリを起動すると、Streamlit Web UIにアクセスして予測を行うことができます。

また、以下のコマンドでFastAPIを直接使用して予測をテストすることもできます：

```bash
curl -X POST "http://localhost:8000/predict" \
-H "Content-Type: application/json" \
-d '{
  "sqft": 1500,
  "bedrooms": 3,
  "bathrooms": 2,
  "location": "suburban",
  "year_built": 2000,
  "condition": "fair"
}'
```

`http://localhost:8000/predict`は、実際に実行されている場所に応じて適切なエンドポイントに置き換えてください。

---

## 🧠 MLOpsについてさらに詳しく

このプロジェクトは、School of DevOpsの[**MLOpsブートキャンプ**](https://schoolofdevops.com)の一部です。そこでは以下のことを学べます：

- MLパイプラインの構築と追跡
- モデルのコンテナ化とデプロイ
- GitHub ActionsやArgo Workflowsを使用した訓練ワークフローの自動化
- 機械学習システムへのDevOpsの原則の適用

🔗 [MLOpsを始める →](https://schoolofdevops.com)

---

## 🤝 貢献

このプロジェクトをさらに良くするための貢献、課題、提案を歓迎します。お気軽にフォーク、探索、そしてプルリクエストを送ってください！

---

ハッピーラーニング！  
— **School of DevOps**チーム