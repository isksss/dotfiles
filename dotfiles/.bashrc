case ":${PATH}:" in
	*":${HOME}/.local/bin:"*) ;;
	*) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac

if command -v mise >/dev/null 2>&1; then
	eval "$(mise activate bash)"
fi

if [[ -r /proc/sys/kernel/osrelease ]] && grep -qi microsoft /proc/sys/kernel/osrelease && command -v ssh.exe >/dev/null 2>&1; then
	alias ssh="ssh.exe"
fi
