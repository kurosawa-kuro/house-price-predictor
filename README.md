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

#### 4. バイナリ互換性エラー（numpy/pandas/scikit-learn）
```
ValueError: numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject
```

**解決策：** 以下のコマンドでパッケージを再インストールしてください：
```bash
# 仮想環境がアクティベートされていることを確認
source .venv/bin/activate

# パッケージを再インストール
uv pip install --force-reinstall --no-cache-dir numpy pandas scikit-learn
```

#### 5. pipコマンドが見つからない
```
which pip
# 出力: /usr/bin/pip (システムのpip)
```

**解決策：** `uv`を使用してパッケージをインストールしてください：
```bash
uv pip install [パッケージ名]
```

### モデル訓練時のエラー

#### 1. 設定ファイルが見つからない
```
FileNotFoundError: [Errno 2] No such file or directory: 'configs/model_config.yaml'
```

**解決策：** `configs`ディレクトリと設定ファイルを作成してください：
```bash
mkdir -p configs
```

#### 2. 設定ファイルのキーエラー
```
KeyError: 'name'
KeyError: 'target_variable'
KeyError: 'best_model'
```

**解決策：** `configs/model_config.yaml`に必要なキーを追加してください：
```yaml
name: "house_price_prediction"

model:
  name: "house_price_prediction"
  type: "random_forest"
  target_variable: "price"
  best_model: "RandomForest"
  parameters:
    n_estimators: 100
    max_depth: 10
    min_samples_split: 2
    min_samples_leaf: 1
    random_state: 42
```

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

### MLflow関連の警告

#### 1. モデルシグネチャの警告
```
WARNING mlflow.models.model: Model logged without a signature and input example
```

**解決策：** この警告は動作に影響しません。本格運用時には`input_example`パラメータを追加することを推奨します。

#### 2. 非推奨パラメータの警告
```
WARNING mlflow.models.model: `artifact_path` is deprecated. Please use `name` instead.
```

**解決策：** この警告は動作に影響しません。将来のバージョンで修正される予定です。

#### 3. モデルバージョンの重複
```
Registered model 'house_price_prediction' already exists. Creating a new version
```

**解決策：** これは正常な動作です。同じモデル名で複数回実行すると新しいバージョンが作成されます。

### JupyterLab関連の問題

#### 1. JupyterLabがインストールされていない
```
No module named jupyterlab
```

**解決策：** JupyterLabをインストールしてください：
```bash
uv pip install jupyterlab
```

#### 2. 仮想環境がアクティベートされていない
```
Command 'python' not found
```

**解決策：** 仮想環境をアクティベートしてください：
```bash
source .venv/bin/activate
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
jupyterlab>=4.0.0
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
# プロジェクトのルートディレクトリにいることを確認
cd /path/to/house-price-predictor

# 仮想環境がアクティベートされていることを確認
source .venv/bin/activate

# JupyterLabを起動
python -m jupyterlab
```

> ⚠️ **注意**: `uv python -m jupyterlab`は正しくありません。`uv python`はPythonの管理用コマンドです。JupyterLabを起動するには`python -m jupyterlab`を使用してください。

起動後、ブラウザで表示されるURL（通常は`http://localhost:8888`）にアクセスしてください。

---

## 🔁 モデルワークフロー

### 🧹 ステップ1: データ処理

生の住宅データセットをクリーニングと前処理：

```bash
python src/data/run_processing.py \
  --input data/raw/house_data.csv \
  --output data/processed/cleaned_house_data.csv
```

**期待される出力例：**
```
2025-06-24 06:52:02,179 - data-processor - INFO - Loading data from data/raw/house_data.csv
2025-06-24 06:52:02,181 - data-processor - INFO - Loaded data with shape: (84, 7)
2025-06-24 06:52:02,181 - data-processor - INFO - Cleaning dataset
2025-06-24 06:52:02,183 - data-processor - INFO - Found 7 outliers in price column
2025-06-24 06:52:02,183 - data-processor - INFO - Removed outliers. New dataset shape: (77, 7)
2025-06-24 06:52:02,186 - data-processor - INFO - Saved processed data to data/processed/cleaned_house_data.csv
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

**期待される出力例：**
```
2025-06-24 06:55:07,608 - feature-engineering - INFO - Loading data from data/processed/cleaned_house_data.csv
2025-06-24 06:55:07,610 - feature-engineering - INFO - Creating new features
2025-06-24 06:55:07,611 - feature-engineering - INFO - Created 'house_age' feature
2025-06-24 06:55:07,611 - feature-engineering - INFO - Created 'price_per_sqft' feature
2025-06-24 06:55:07,611 - feature-engineering - INFO - Created 'bed_bath_ratio' feature
2025-06-24 06:55:07,612 - feature-engineering - INFO - Created featured dataset with shape: (77, 10)
2025-06-24 06:55:07,612 - feature-engineering - INFO - Creating preprocessor pipeline
2025-06-24 06:55:07,618 - feature-engineering - INFO - Fitted the preprocessor and transformed the features
2025-06-24 06:55:07,619 - feature-engineering - INFO - Saved preprocessor to models/trained/preprocessor.pkl
2025-06-24 06:55:07,621 - feature-engineering - INFO - Saved fully preprocessed data to data/processed/featured_house_data.csv
```

---

### 📈 ステップ3: モデリングと実験

モデルを訓練し、すべてをMLflowにログ：

```bash
python src/models/train_model.py \
  --config configs/model_config.yaml \
  --data data/processed/featured_house_data.csv \
  --models-dir models \
  --mlflow-tracking-uri http://192.168.1.131:5555
```

**期待される出力例：**
```
2025-06-24 07:02:09,052 - INFO - Training model: RandomForest
2025-06-24 07:02:10,699 - INFO - Registering model to MLflow Model Registry...
2025-06-24 07:02:10,997 - INFO - Saved trained model to: models/trained/house_price_prediction.pkl
2025-06-24 07:02:10,997 - INFO - Final MAE: 13977.50, R²: 0.9882
🏃 View run final_training at: http://192.168.1.131:5555/#/experiments/1/runs/f0f4aa121cc5405f93fcc03e77962b89
🧪 View experiment at: http://192.168.1.131:5555/#/experiments/1
```

**注意点：**
- WSL2環境では、MLflowのURLを`http://192.168.1.131:5555`のようにWSL2のIPアドレスに変更してください
- 初回実行時は`configs/model_config.yaml`ファイルが必要です（詳細はトラブルシューティングを参照）
- 警告メッセージが表示される場合がありますが、動作に影響はありません

---

### 📊 結果の確認

#### MLflow UIでの確認
1. ブラウザでMLflow UIにアクセス（例：`http://192.168.1.131:5555`）
2. 実験一覧から「house_price_prediction」を選択
3. 実行履歴、メトリクス、モデルバージョンを確認

#### 生成されたファイル
- `data/processed/cleaned_house_data.csv`: クリーニング済みデータ
- `data/processed/featured_house_data.csv`: 特徴量エンジニアリング済みデータ
- `models/trained/preprocessor.pkl`: 前処理器
- `models/trained/house_price_prediction.pkl`: 訓練済みモデル

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