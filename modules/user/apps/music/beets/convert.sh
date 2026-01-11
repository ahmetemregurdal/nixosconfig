set -euo pipefail

convert() {
	FILE="$1"
	case "$FILE" in
		*.flac) ;;
		*) exit 0 ;;
	esac
	DEST="${FILE%.flac}.m4a"

	[ -f "$DEST" ] && exit 0

	ffmpeg -nostdin -loglevel error -i "$FILE" -map_metadata 0 -vn -c:a aac -q:a 6 -movflags +faststart "$DEST"
	rm "$FILE"
}

export -f convert

parallel -j16 --bar --eta convert ::: "$@"
