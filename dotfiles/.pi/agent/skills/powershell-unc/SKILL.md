---
name: powershell-unc
description: WSL上のpiからWindows PowerShell経由でUNCパス（\\server\share\file）のファイルを読み取り・編集する。Windows共有やUNCパスの編集を依頼されたときに使う。
compatibility: WSL、Windows PowerShell（powershell.exe）、対象共有へのWindowsユーザーのアクセス権が必要。
---

# PowerShell UNC

UNCへのアクセスだけをWindows PowerShellに任せ、編集はローカルコピーに対してpiのread/editを使う。共有のマウントやドライブ割り当ては不要。

## 呼び出し

`command -v powershell.exe` と `$PSVersionTable.PSVersion` で実行環境を確認する。Linux版の`pwsh`ではWindowsのUNCアクセスを代替できない。実行不可・権限不足なら停止し、資格情報や管理者権限を勝手に追加しない。

BashとPowerShellの二重展開を避けるため、引用付きheredocをUTF-16LEのBase64に変換して渡す。例のパスは対象に置き換える。PowerShellの単一引用符内の`'`は`''`にする。ユーザー入力を実行コードとして連結せず、`Invoke-Expression`も使わない。

```bash
encoded=$(iconv -f UTF-8 -t UTF-16LE <<'PS' | base64 -w0
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
try {
    $path = '\\server\share\folder\file.txt'
    Get-Item -LiteralPath $path | Select-Object FullName, Length, LastWriteTimeUtc
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
PS
)
powershell.exe -NoLogo -NoProfile -NonInteractive -EncodedCommand "$encoded"
```

すべての呼び出しにこのエラー処理を付け、終了コードを確認する。PowerShellのパス指定は`-LiteralPath`を使い、空白・日本語・角括弧を含む名前もリテラルとして扱う。UNCをカレントディレクトリにせず絶対パスを使う。ExecutionPolicyの変更は不要。

## 編集手順

1. 対象ファイルと変更範囲を確定する。秘密情報を含む全文を出力しない。バイナリやOffice文書はテキスト編集しない。
2. `mktemp -d`で作業領域を作り、`wslpath -w`でWindowsから見えるパスにする。PowerShellからアクセスできるか確認する。不可ならWindows側の一時領域を使い、`wslpath -u`でpi用のパスを得る。
3. `Get-FileHash -LiteralPath $path -Algorithm SHA256`で元のハッシュを取得し、`Copy-Item -LiteralPath $path -Destination $local`でバイトをそのままコピーする。コピー元・コピー先のハッシュを再確認し、不一致なら編集に進まない。ローカルの原本も別に保持する。
4. BOM、文字コード、改行（CRLF/LF）、末尾改行を確認する。read/editで扱えるUTF-8ならそのまま編集する。それ以外は文字コードを確定してから作業コピーだけUTF-8へ変換し、編集後に元の形式へ戻す。推測で変換せず、不明なら確認する。変換エラーは停止させ、置換文字による欠損を許さない。
5. ローカル原本との差分と対象に応じた構文チェックを確認する。内容以外の文字コード・BOM・改行も維持できていることを検証する。変更なしなら書き戻さない。
6. 書き戻す直前にUNC側のSHA256が取得時と一致することを確認する。不一致なら上書きせず、最新版との差分を取り直す。同時更新の可能性がある場合は書き込み停止や適切なロックを確保する。ハッシュ比較だけでは比較後の競合を防げない。
7. 元ファイルのバックアップを一意な名前で作り、原本とハッシュが一致することを確認してから、`Copy-Item -LiteralPath $local -Destination $path`で書き戻す。バックアップも同じ機密情報なので、保存先のアクセス権を確認し、無断で公開範囲を広げない。バックアップ不可なら停止する。
8. UNC側を再取得し、編集済みコピーとのSHA256一致と必要な内容・構文チェックを行う。失敗したら成功扱いにせず、バックアップ先と状態を報告する。他者の更新を上書きし得る自動復元はしない。

`Copy-Item`による上書きは原子的ではなく、通信切断時には途中の状態が残り得る。原子的更新や無停止が必要な対象はこの手順で書き戻さず、共有先が保証する更新方式を確認する。読み取り専用属性やACLを勝手に変更しない。

PowerShell 5.1の`Set-Content`・`Out-File`・`>`は既定エンコーディングや改行を変えるため、ファイルの書き戻しには使わない。

## 検証と報告

初回は許可された作業領域に使い捨てファイルを作り、日本語・空白・`[ ]`を含む名前とCRLF/BOMを使って、コピー・編集・書き戻し・再取得を確認する。本番共有へのテストファイル作成を勝手に行わない。

変更対象、変更内容、検証結果、バックアップ先を短く報告する。共有での実検証ができなければ明記する。不要になったローカル一時ファイルは自分が作ったものだけ削除し、復旧用バックアップは保存先を報告して残す。
