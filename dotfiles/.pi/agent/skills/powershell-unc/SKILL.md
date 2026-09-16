---
name: powershell-unc
description: WSL から Windows の UNC パスのファイルを読み取り・編集するときに使う。
compatibility: WSL、Windows PowerShell（powershell.exe）、対象共有へのWindowsユーザーのアクセス権が必要。
---

# PowerShell UNC

UNCへのアクセスだけをWindows PowerShellに任せ、読み取り・編集はローカルコピーに対するpiのread/editを使う。共有のマウントやドライブ割り当ては不要。

## 必要な手順

- **読み取り・編集共通**：[呼び出し方法](references/invoke.md) を読む。
- **編集する場合だけ**：[編集・書き戻し](references/edit.md) をコピー前に読む。文字コード保持、競合検出、バックアップ、再取得の検証を省略しない。

依頼された範囲だけを操作し、権限・資格情報・ACL・ExecutionPolicyを勝手に変更しない。

## 完了と報告

対象、結果、検証できなかった事項を短く報告する。編集時は変更内容とバックアップ先も示す。
不要になったローカル一時ファイルは自分が作ったものだけ削除し、復旧用バックアップは残す。
