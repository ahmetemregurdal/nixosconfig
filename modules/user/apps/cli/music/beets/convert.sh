set -euo pipefail

for FILE in "$@"; do
	case "$FILE" in
		*.flac) ;;
		*) exit 0 ;;
	esac

	DEST="${FILE%.flac}.m4a"

	[ -f "$DEST" ] && exit 0

	ffmpeg -i "$FILE" -map_metadata 0 -vn -c:a aac -q:a 6 -movflags +faststart "$DEST"
	rm "$FILE"
done
