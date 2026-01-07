set -euo pipefail
FILE="$1"

case "$FILE" in
	/tmp/** ) exit 0 ;;
	*.m4a) ;;
	*) exit 0 ;;
esac

LRC="${FILE%.m4a}.lrc"

[ -f "$LRC" ] && exit 0

LYRICS="$(exiftool -s3 -Lyrics "$FILE")" 
[ -z "$LYRICS" ] && exit 0

if ! printf '%s\n' "$LYRICS" | grep -Eq '^\[[0-9]{2}:[0-9]{2}\.[0-9]{2}\]'; then
	exit 0
fi

printf '%s\n' "$LYRICS" | sed -E 's/\[([0-9]{2}:[0-9]{2}\.[0-9]{2})\]/\n[\1]/g' | sed '1{/^$/d;}' > "$LRC"
