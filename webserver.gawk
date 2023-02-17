#! /usr/bin/gawk -f

function Header(){
	header = "HTTP/1.1 200 OK\n" \
	"Connection: close\n\n"
	return header
}

function Top(title){
	top = "<html>" \
	"<head>" \
	"<title>" \
	title \
	"</title>" \
	"</head>" \
	"<body>"
	return top
}

function Bottom(){
	return "</body></html>"
}

BEGIN {
	http_root = "root"
	server = "/inet/tcp/4000/0/0"
	while ( 1 ) {
		server |& getline 
		if ( $2 == "/" )
			display_index()
		else
			display_site($2)
	}
}

function display_index () {
	ls_cmd = "ls -1 " http_root
	print Header() |& server
	print Top("Startseite") |& server
	while ( ( ls_cmd | getline ) > 0 ){
		linkline = "<p><a href=\"" $0 "\">" $0 "</a></p>" 
		print linkline |& server
	}		
	print Bottom() |& server
	close(ls_cmd)
	close(server)
}

function display_site (adresse) {
	file = http_root adresse
	cat_cmd = "cat " file
	print Header() |& server
	while ( ( cat_cmd | getline ) > 0 )
		print |& server
	close( cat_cmd )
	close(server)
}


