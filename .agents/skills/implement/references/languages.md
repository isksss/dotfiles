# implement language notes

## common

- 各リポジトリの既存規約、設計、依存、formatter、linter、test を最優先する。
- 言語別注意事項は補助指針とし、局所ルールや既存実装と競合する場合は局所ルールを優先する。

## Vue

- component 分割、props / emits、state 管理、composable、routing、CSR/SSR 前提を確認する。
- template と script の責務、既存 UI component、class / style 規約を尊重する。
- reactive / ref / computed / watch の使い分け、不要な deep watch、過剰な global state を避ける。
- loading、error、empty、権限差分、accessibility、responsive 崩れを確認する。
- 有効な unit / component / e2e / typecheck / lint を選ぶ。

## Java

- package boundary、layer 構成、DI、transaction、例外設計、logging、validation を確認する。
- SOLID 原則を意識し、既存設計に合う責務分割と依存方向を守る。
- Factory、Strategy、Adapter などの design pattern は既存方針と実際の複雑さに見合う場合だけ使う。
- public API、DTO / entity、nullability、Optional、collection mutability、thread safety を不用意に変えない。
- Spring 等の annotation、scope、bean lifecycle、設定値の扱いを尊重する。
- SQL / repository / service の責務を混ぜず、N+1、transaction 漏れ、例外握りつぶしを避ける。
- unit / integration test、formatter、static analysis、build を変更範囲に応じて実行する。

## TypeScript

- tsconfig、型設計、module boundary、lint、formatter、runtime validation 方針を確認する。
- `any`、過剰な type assertion、null / undefined の曖昧化、非同期エラー漏れを避ける。
- 公開型、関数 signature、API response shape、環境変数、設定値の互換性を確認する。
- type guard、schema、utility type は既存方針に合わせ、抽象化を増やしすぎない。
- typecheck、lint、unit test を優先し、未実行なら理由を示す。

## SQL

- DB 方言、migration、schema、index、constraint、naming、formatter を確認する。
- SELECT 範囲、JOIN 条件、NULL、重複行、集計粒度、timezone、文字コード、照合順序に注意する。
- migration は後方互換、lock、rollback、既存データ、default、NOT NULL、外部キー影響を確認する。
- N+1、full scan、不要な sort、巨大 update / delete、transaction 境界の誤りを避ける。
- explain、sqlfluff、既存 test、影響件数確認など可能な検証を選ぶ。

## Go

- package boundary、error handling、context、interface 方針、dependency injection、test 方針を確認する。
- `context.Context` の伝播、cancel、timeout、goroutine leak、race、shared state を確認する。
- error は握りつぶさず、wrap / sentinel / typed error の既存方針に合わせる。
- interface は利用側で小さく定義し、不要な抽象化や global state を避ける。
- gofmt / go vet / go test / race test を変更範囲に応じて選ぶ。

## Rust

- module boundary、ownership、lifetime、Result / Option、error crate、feature flag、test 方針を確認する。
- `unwrap` / `expect` / `panic` は既存方針と失敗条件が明確な場合に限定する。
- clone、allocation、borrow 回避、async boundary、Send / Sync、thread safety を確認する。
- error handling は既存の `thiserror` / `anyhow` 等の使い分けに合わせる。
- cargo fmt / clippy / test を変更範囲に応じて選ぶ。
