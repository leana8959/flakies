compile:
	typst compile main.typ

sioyek: compile
	sioyek main.pdf &
	typst watch main.typ

skim: compile
	open -a /Applications/Skim.app main.pdf
	typst watch main.typ
