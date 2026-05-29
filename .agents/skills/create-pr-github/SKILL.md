---
name: create-pr-github
description: GitHub で Pull Request を作成する。ユーザーが GitHub での PR 作成、プルリクエスト作成、現在ブランチからの Pull Request 作成を依頼したときに使う。
---

# create-pr-github

## 概要

`gh` コマンドを使用して、GitHub で Pull Request を作成するためのスキルです。ユーザーが GitHub での PR 作成を依頼したときに使用します。

このスキルは、現在の作業ブランチから「現在ブランチの派生元ブランチ」への PR 作成を既定とし、必要に応じてマージ先を変更して実行します。

## 手順

### 1. 現在のブランチを確認する

- `git branch --show-current` を実行して、現在のブランチ名を取得します。
- ブランチ名をユーザーに報告します。
- ブランチ名が取得できない場合は、エラーをユーザーに報告し、Pull Request の作成を中止します。
- ブランチ名が `main`、`master`、`develop` などの主要なブランチである場合は、Pull Request の作成を中止し、ユーザーに警告します。

実行例:

```sh
git branch --show-current
```

### 2. 未コミットの内容がないか確認する

- `git status --short` を実行して、未コミットの変更がないか確認します。
- 変更がある場合は、ユーザーに報告し、Pull Request の作成を中止します。
- 変更がない場合は、次のステップに進みます。

実行例:

```sh
git status --short
```

加えて、PR 本文生成に使うコミット履歴を確認します。

```sh
BASE_BRANCH="$(git reflog show --format='%gs' "$(git branch --show-current)" | sed -n 's/^branch: Created from //p' | head -n1)"
git log --oneline "origin/${BASE_BRANCH}..HEAD"
```

- `BASE_BRANCH` が取得できない、または `HEAD` になる場合は、派生元を自動判定できないためユーザーに確認します。
- `origin/${BASE_BRANCH}..HEAD` が空の場合は、PR に含める変更がないため作成を中止します。

### 3. Pull Request テンプレートを確認する

PR 本文を作成する前に、リポジトリ内の Pull Request テンプレートを探索します。

```sh
find . -path './.git' -prune -o \
  \( -path './.github/pull_request_template.md' \
  -o -path './.github/PULL_REQUEST_TEMPLATE.md' \
  -o -path './.github/PULL_REQUEST_TEMPLATE/*.md' \
  -o -path './docs/pull_request_template.md' \
  -o -path './docs/PULL_REQUEST_TEMPLATE.md' \) \
  -print
```

- テンプレートが 1 つだけ見つかった場合は、そのテンプレートの見出し、チェック項目、記入欄に従って PR 本文を作成します。
- テンプレートが複数見つかった場合は、ファイル名と内容から用途が明らかなものだけ選びます。判断できない場合は、どのテンプレートを使うかユーザーに確認します。
- テンプレート内のコメント、チェックリスト、注意書きは削除せず、必要な欄を今回の変更内容で埋めます。
- テンプレート内に記入例、サンプル、Example、例示用の項目がある場合は、PR 本文に残さず削除します。
  - `例:`、`記入例:`、`Example:` などのラベル付き本文は、今回の変更内容で置き換えるか削除します。
  - チェックリストや注意書きが例示専用でない場合は削除せず、必要に応じてチェック状態や内容だけ更新します。
- 該当しない項目がある場合は、テンプレートの意図を崩さない範囲で `なし`、`該当なし`、または未チェック項目として残します。
- テンプレートがない場合のみ、次の既定本文テンプレートを使います。

```md
## 概要

- （変更の要点を 1-3 行で記述）

## 変更内容

- （主要変更1）
- （主要変更2）

## コミット

- <hash> <message>
- <hash> <message>
```

### 4. Pull Request を作成する

- `gh` が利用可能か確認します。

```sh
command -v gh >/dev/null 2>&1
```

- 未ログイン時は `gh auth status` で状態確認し、必要ならユーザーにログインを依頼します。

```sh
gh auth status
```

- 現在ブランチがリモートに push 済みか確認します。

```sh
git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
```

- upstream がない場合は、現在ブランチを push します。

```sh
git push -u origin "$(git branch --show-current)"
```

- タイトルは「全コミット履歴の共通テーマを要約した prefix + 要約」にします。
  - prefix は `[add]`、`[fix]`、`[update]`、`[remove]`、`[refactor]`、`[docs]`、`[test]`、`[chore]`、`[perf]`、`[ci]` から選びます。
  - タイトルは `origin/${BASE_BRANCH}..HEAD` の全コミットメッセージを読み、変更全体を 1 行で要約して作成します。
- 本文は PR テンプレートがある場合はテンプレート優先、ない場合は既定本文テンプレートで作成します。
- PR を作成します（既定のマージ先は `BASE_BRANCH`）。

```sh
gh pr create \
  --base "${BASE_BRANCH}" \
  --head "$(git branch --show-current)" \
  --title "[update] （要約）" \
  --body "（生成した本文）"
```

- ユーザーからマージ先ブランチ指定がある場合は `--base` をその値に変更します。
- ユーザーから draft 指定がある場合は `--draft` を追加します。

### 5. Pull Request の URL をユーザーに報告する

- `gh pr create` の出力に含まれる URL を抽出して報告します。
- 必要に応じて、作成された PR の確認として次を実行します。

```sh
gh pr view --web
```

## 注意事項

- Pull Request の作成には、ユーザーが `gh` コマンドを使用して GitHub にアクセスできる環境が必要です。
- ブランチ名が主要なブランチである場合は、Pull Request の作成を中止し、ユーザーに警告します。
- 未コミットの変更がある場合は、Pull Request の作成を中止し、ユーザーに報告します。
- Pull Request は、現在のブランチから派生元ブランチへのマージを前提とします。派生元を自動判定できない場合は、必ずユーザーにマージ先を確認してください。
- `gh` 未導入・未認証・権限不足で失敗した場合は、エラー内容をそのまま共有し、認証または権限設定後に再実行します。
