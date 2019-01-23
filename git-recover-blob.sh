for d in .git/objects/*; do
 dirhash=$(basename $d)
	if [[ "$dirhash" == "pack" || "$dirhash" == "info" ]]; then
		continue;
	fi
	#echo $dirhash;
	for object in .git/objects/$dirhash/*; do
		# echo $object;
		object_hash=$(basename $object)
		sha1=${dirhash}${object_hash}
		# echo $sha1;
		git cat-file -p $sha1 > /Users/jpons/git-rescue/tmp
	 filetype=$(file -b -I /Users/jpons/git-rescue/tmp | cut -d ';' -f1)
	 case $filetype in 
	 	"application/octet-stream")
		 ext="bin"
		;;
			"application/pdf")
			ext="pdf"
			;;
			"application/vnd.ms-fontobject")
			ext="eot"
			;;
			"application/vnd.ms-opentype")
				ext="otf"
				;;
			"application/x-font-ttf")
				ext="ttf"
				;;
				"application/zip")
				ext="zip"
				;;
			"image/jpeg")
			ext="jpeg"
			;;
			"image/png")
			ext="png"
			;;
			"image/svg")
			ext="svg"
			;;
			"image/svg+xml")
			ext="svg.xml"
			;;
			"image/x-icon")
			ext="ico"
			;;
			"inode/x-empty")
			ext="txt"
			;;
			"text/html")
			ext="html"
			;;
			"text/plain")
			ext="txt"
			;;
			"text/troff")
			ext="scss"
			;;
			"text/x-asm")
			ext="scss"
			;;
			"text/x-java")
			ext="ts"
			;;
			"text/x-php")
			ext="php"
			;;
			"text/x-shellscript")
			ext="sh"
			;;
			"text/xml")
			ext="xml"
			;;
		esac
	 filename="${sha1}.$ext"
	 # mkdir -p /Users/jpons/git-rescue/$dirhash
	 #git cat-file -p $sha1 > /Users/jpons/git-rescue/$filename
	 git cat-file -t $sha1
	done

done
