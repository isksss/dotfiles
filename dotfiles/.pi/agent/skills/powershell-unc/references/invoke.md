# PowerShell の呼び出し

`command -v powershell.exe` と `$PSVersionTable.PSVersion` で実行環境を確認する。Linux版の `pwsh` ではWindowsのUNCアクセスを代替できない。実行不可・権限不足なら停止し、資格情報や管理者権限を勝手に追加しない。

BashとPowerShellの二重展開を避けるため、引用付きheredocをUTF-16LEのBase64に変換して渡す。例のパスは対象に置き換える。PowerShellの単一引用符内の `'` は `''` にする。ユーザー入力を実行コードとして連結せず、`Invoke-Expression` も使わない。

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

すべての呼び出しにこのエラー処理を付け、終了コードを確認する。パス指定は `-LiteralPath` とUNC絶対パスを使い、空白・日本語・角括弧をリテラルとして扱う。ExecutionPolicyの変更は不要。

## ローカルコピーの取得

- `mktemp -d` で作業領域を作り、`wslpath -w` でWindowsから見えるパスにする。PowerShellからアクセス不可ならWindows側の一時領域を使い、`wslpath -u` でpi用のパスを得る。
- `Copy-Item -LiteralPath $path -Destination $local` でバイトをそのままコピーし、ローカルを `read` で読む。秘密情報を含む全文は出力しない。読み取り依頼では共有への書き込みや編集用テストを行わない。
