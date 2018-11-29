panpdf readme

## What is panpdf?

`panpdf` is a command line tool for converting Markdown dialect files to CSS styled HTML or PDF. This lets you keep code highlighting, and makes the markdown look *like markdown* - and not like LaTeX (which is often great but not always ideal).

It has two steps:  
- `panhtml`: Creates a standalone HTML with custom CSS, using [pandoc](pandoc.org) and some shell scripting.  
- `panpdf`: Creates a PDF formatted by the CSS. Not yet implemented, but planned for macOS using AppleScript and Safari's `save as PDF` functionality.

Running `panpdf` will eventually perform both of the steps if necessary.

There are other software which do the same thing - search online for `Markdown to PDF` and you'll find alternatives! :)

## Usage example

This is how the [html file in example_output](example_output/README.html) was made.  
```bash
eves@eves-mbp:~/Documents/Programming/panpdf$ panhtml README.md && 
if [[ "$?" == "0" ]]; then
    printf "it worked! \\n";
    open README.html; 
fi
panpdf: converting panpdf readme
it worked! 
```

## Snippets for the example output

Just so a bit more is displayed in the example output, here's:  

* a blockquote,  
* some LaTeX ,  
* and some `c` code.  

>This is a blockquote  
> :)

$$\text{This is a linear parametrization:} $$
$$ z = \theta^{*\top} \phi $$

```c
// A c program
#define SOME_MACRO "some macro"
int main(int argc, char *argv[]) {
    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            foo(argv[i]);
        }
    }
    return bar();
}
```

## Credit & References

* github.com/simonlc's [Markdown-CSS](https://github.com/simonlc/Markdown-CSS)  

* [Pandoc](pandoc.org)  