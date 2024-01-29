compile:
	typst compile main.typ

sioyek: compile
	sioyek main.pdf &
	typst watch main.typ

skim: compile
	open -a /Applications/Skim.app main.pdf
	typst watch main.typ

fix: compile
	gs \
		-o main_patched.pdf \
		-sDEVICE=pdfwrite \
		-dPDFSETTINGS=/prepress \
		main.pdf
