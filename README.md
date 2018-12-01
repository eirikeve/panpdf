panpdf readme

## What is panpdf?

`panpdf` is a command line tool for converting Markdown dialect files to CSS styled HTML or PDF. This lets you keep code highlighting, and makes the markdown look *like markdown* - and not like LaTeX (which is often great but not always ideal).

It has two steps:  
- `panhtml`: Creates a standalone HTML with custom CSS, using `pandoc` and some shell scripting. The CSS is embedded in the HTML since I've had issues embedding local CSS in the HTML files in other ways. (Pull requests welcome!!)  
- `panpdf`: Creates a PDF formatted by the CSS. Currently implemented using `cupsfilter`. If necessary, first converts the input to HTML.

There are other software which do the same thing - search online for `Markdown to PDF` and you'll find alternatives! :)  
However, I tried several of these tools but couldn't get them to work reliably. So - I decided to make `panpdf`.

## How does the output look?

Since everything is formatted with CSS, it can look any way you want it to. Check out the [example_output folder](example_output/README.pdf)!

## Installation

`panpdf` has these dependencies:  

* UNIX-like OS
* [pandoc](https://pandoc.org) must be installed
* [cupsfilter](https://www.cups.org/) must be installed

For a basic installation, run:
```
sudo ./install.sh
```
The scripts + CSS will then be installed in `/usr/local/panpdf/`, and symlinks for `panpdf`, `panhtml` will be added to `/usr/local/bin/`. `sudo` might be required due to folder creation in `/usr/local/` (it was for me atleast).

If you want, go ahead and modify the `config` file to choose your own install directory or CSS source URL. The config is interpreted as a shell script (`. config`), so don't modify the variable names. (I'm planning on adding a script to automate changing the config, eventually.)

The default CSS used is [this one](https://github.com/eirikeve/Markdown-CSS), which is a print-friendly version of [github.com/simonlc's Markdown-CSS](https://github.com/simonlc/Markdown-CSS).

After the installation, `panhtml` and `panpdf` should be usable.


## Usage example

This is how the [pdf file in example_output](example_output/README.pdf) was made.  
```bash
eves@eves-mbp $ panpdf README.md && open README.pdf
```

This is how the [html file in example_output](example_output/README.html) was made.  
```bash
eves@eves-mbp $ panhtml README.md && open README.html
```

**Note: For the example output html file to be displayed correctly, you'll need to download it (since github shows it as plaintext).**


## Bugs?

There's probably a lot of bugs. Feel free to open an issue if you encounter one. Pull requests are also very welcome!

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
* [CUPS](https://www.cups.org/)  
* [Pandoc](https://pandoc.org)  