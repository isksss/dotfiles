---
name: edit-excel
description: Excelファイルをdenoで編集する。ユーザーがExcelファイルの内容を編集するよう依頼したときに使う。
---

# edit-excel

このスキルは、Denoで動作する`excel.ts`スクリプトを使用して、Excelファイル（.xlsx）を編集するために使う。

## 機能概要

`excel.ts`は以下のコマンドをサポートしている：

| コマンド    | 用途                              | 形式                             |
| ----------- | --------------------------------- | -------------------------------- |
| `write-csv` | CSVファイルからセルを一括書き込み | `write-csv <xlsx> <sheet> <csv>` |
| `read`      | 特定セルの値を読み取り            | `read <xlsx> <sheet> <cell>`     |
| `dump`      | シート全体をJSON形式で出力        | `dump <xlsx> <sheet>`            |

## 使用手順

### 1. 編集内容を確認する

ユーザーの要件から、以下を確認する：

- 対象Excelファイルのパス
- シート名
- 編集するセルと値

### 2. CSVデータを準備する（write-csvの場合）

CSVファイルの形式：

```csv
A1,名前
B1,年齢
C1,有効
A2,田中,string
B2,30,number
C2,true,boolean
```

**形式：** `セル参照,値,型`

**型の種類（省略可能。デフォルト: `string`）：**

- `string` — 文字列
- `number` — 数値
- `boolean` — 真偽値（`true`または`false`）

### 3. excel.tsを実行する

#### write-csvの例

```bash
deno run -A excel.ts write-csv data.xlsx Sheet1 input.csv
```

**出力例：**

```
✓ Updated data.xlsx (3 cells written)
```

**エラーハンドリング：**

- 無効なセル参照（例：`ZZ99999`）は警告として表示され、以降の処理は継続
- 型変換エラー（例：`abc`をnumberに変換）は警告として記録
- ファイルI/Oエラーはスクリプト終了時に例外として報告

#### readの例

```bash
deno run -A excel.ts read data.xlsx Sheet1 A1
```

#### dumpの例

```bash
deno run -A excel.ts dump data.xlsx Sheet1
```

## 注意点

1. **ファイルが存在しない場合**
   - `write-csv`では新規作成される
   - `read`・`dump`では例外がスローされる

2. **シートが存在しない場合**
   - `write-csv`では新規シートが作成される
   - `read`・`dump`では例外がスローされる

3. **複雑な編集の場合**
   - 複数コマンドを組み合わせる
   - ユーザーに確認しながら進める

4. **セル参照の形式**
   - `A1`、`B2`など標準的なExcel表記で指定
   - 大文字小文字は区別されない（内部で正規化される）

5. **型変換の厳密性**
   - `boolean`は`true`/`false`（小文字で処理）のみ受け入れる
   - `number`は`parseFloat()`と同等の処理
   - 型変換失敗時は警告を出力して該当セルをスキップ
