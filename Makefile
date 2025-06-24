# ML Model CI/CD Makefile
# 開発者体験向上のための便利コマンド集

.PHONY: help install test lint format clean train pipeline release setup-dev check-model status

# デフォルトターゲット
help:
	@echo "🏠 House Price Prediction ML Pipeline"
	@echo ""
	@echo "利用可能なコマンド:"
	@echo "  install    - 依存関係をインストール"
	@echo "  test       - テストを実行"
	@echo "  lint       - コード品質チェック"
	@echo "  format     - コードフォーマット"
	@echo "  clean      - 一時ファイルを削除"
	@echo "  train      - モデルを訓練"
	@echo "  pipeline   - 全パイプラインを実行"
	@echo "  release    - リリース用タグを作成"
	@echo "  check-model - モデル性能確認"
	@echo "  status     - パイプライン状態確認"
	@echo ""

# 依存関係インストール
install:
	@echo "📦 依存関係をインストール中..."
	pip install -r requirements.txt
	@echo "✅ インストール完了"

# テスト実行
test:
	@echo "🧪 テストを実行中..."
	pytest tests/ -v --cov=src --cov-report=html
	@echo "✅ テスト完了"

# コード品質チェック
lint:
	@echo "🔍 コード品質チェック中..."
	flake8 src/ tests/ train_pipeline.py --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 src/ tests/ train_pipeline.py --count --exit-zero --max-complexity=10 --max-line-length=88 --statistics
	mypy src/ --ignore-missing-imports
	bandit -r src/ --severity-level high
	@echo "✅ コード品質チェック完了"

# コードフォーマット
format:
	@echo "🎨 コードフォーマット中..."
	black src/ tests/ train_pipeline.py
	isort src/ tests/ train_pipeline.py
	@echo "✅ フォーマット完了"

# 一時ファイル削除
clean:
	@echo "🧹 一時ファイルを削除中..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf .pytest_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	@echo "✅ クリーンアップ完了"

# モデル訓練
train:
	@echo "🎯 モデル訓練中..."
	python train_pipeline.py
	@echo "✅ モデル訓練完了"

# 全パイプライン実行
pipeline: clean install lint test train
	@echo "🚀 全パイプライン実行完了"

# リリース用タグ作成
release:
	@echo "🏷️ リリース用タグを作成中..."
	@read -p "バージョン番号を入力してください (例: v1.0.0): " version; \
	git tag -a $$version -m "Release $$version"; \
	git push origin $$version; \
	echo "✅ リリースタグ $$version を作成しました"

# 開発環境セットアップ
setup-dev: install
	@echo "🔧 開発環境セットアップ中..."
	pre-commit install
	@echo "✅ 開発環境セットアップ完了"

# モデル性能確認
check-model:
	@echo "📊 モデル性能確認中..."
	@python -c "import joblib; import pandas as pd; model = joblib.load('models/trained/house_price_prediction.pkl'); preprocessor = joblib.load('models/trained/preprocessor.pkl'); print('✅ モデル読み込み成功'); sample_data = pd.DataFrame({'sqft': [1500], 'bedrooms': [3], 'bathrooms': [2], 'year_built': [2010], 'location': ['Suburban'], 'condition': ['Good']}); X_transformed = preprocessor.transform(sample_data); prediction = model.predict(X_transformed); print(f'📈 サンプル予測結果: \$${prediction[0]:,.2f}')"
	@echo "✅ モデル性能確認完了"

# パイプライン状態確認
status:
	@echo "📋 パイプライン状態確認中..."
	@echo "📁 必要なファイル:"
	@ls -la configs/model_config.yaml 2>/dev/null || echo "❌ configs/model_config.yaml が見つかりません"
	@ls -la data/raw/house_data.csv 2>/dev/null || echo "❌ data/raw/house_data.csv が見つかりません"
	@ls -la models/trained/house_price_prediction.pkl 2>/dev/null || echo "❌ 学習済みモデルが見つかりません"
	@ls -la models/trained/preprocessor.pkl 2>/dev/null || echo "❌ 前処理器が見つかりません"
	@echo "✅ 状態確認完了" 