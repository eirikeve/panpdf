panpdf readme

## What is panpdf?

`panpdf` is a command line tool for converting Markdown dialect files to CSS styled HTML or PDF. This lets you keep code highlighting, and makes the markdown look *like markdown* - and not like LaTeX (which is often great but not always ideal).

It has two steps:  
- `panhtml`: Creates a standalone HTML with custom CSS, using [pandoc](pandoc.org) and some shell scripting. The CSS is embedded in the HTML since I've had issues embedding local CSS in the HTML files in other ways. (Pull requests welcome!!)  
- `panpdf`: Creates a PDF formatted by the CSS. Not yet implemented, but planned for macOS using AppleScript and Safari's `save as PDF` functionality.

Running `panpdf` will eventually perform both of the steps if necessary.

There are other software which do the same thing - search online for `Markdown to PDF` and you'll find alternatives! :)

## Installation

`panpdf` has these dependencies:  

* UNIX-like OS (possibly only macOS for PDF generation when it's implemented - depending on how I do it)
* [Pandoc](pandoc.org) must be installed

For a basic installation, run:
```
sudo ./install.sh
```
The scripts + CSS will then be installed in `/usr/local/panpdf/`, and symlinks for `panpdf`, `panhtml` will be added to `/usr/local/bin/`. `sudo` might be required due to folder creation in `/usr/local/` (it was for me atleast).

If you want, go ahead and modify the `config` file to choose your own install directory or CSS source URL. The config is interpreted as a shell script (`. config`), so don't modify the variable names. (I'm planning on adding a script to automate changing the config, eventually.)

The default CSS used is [this one](https://github.com/eirikeve/Markdown-CSS), which is a print-friendly version of [github.com/simonlc's Markdown-CSS](https://github.com/simonlc/Markdown-CSS).

After the installation, `panhtml` should be usable. `panpdf` currently doesn't work (it's not finished).



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

**Note: For the example output html file to be displayed correctly, you'll need to download it (since github shows it as plaintext).**


## Bugs?

Theres probably a lot of bugs. Feel free to open an issue or a pull request if you encounter one.


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