
litpl
=====
A simple tool for literate programming, including a source filter for Perl.

Synopsis
--------

        #= This is some Module
            #= Introduction
                Here's some background and motivation...
            #.
            #= Building the server
                We're going to be using the L<HTTP::Server::Simple>
                    module to build a simple web interface.

                First we should import the L<HTTP::Server::Simple>
                module:
                #+ modules
                    use HTTP::Server::Simple
        #.  #.  #.
        #* Main Program
            << modules >>
            package MyModule
        #.

        # Configuring indentation
        #% lang.python.indent.width = 4
        #% lang.python.indent.type  = space
        #% lang.c.indent.width = 8
        #% lang.c.indent.type  = tab
        #% lang.main    = lang.markdown
        #% lang.alt     = lang.perl

        # Making an alias
        #&md markdown

        # Specifying a language context
        #~perl A Perl Section
            ...
        #.
        #=md A markdown section
            ...
        #.

Writing Literate Documents with Litpl
-------------------------------------

### Defining Document and Code Sections
To define a new document section use the `#=` marker followed by
a section title. Note that there must be whitespace between the marker
and title. A new code section can be defined in the same way by using
the `#~` marker.

Sections can contain other sections nested within them. Document
sections can contain any kind of section, while code sections can only
contain code sections of the same language. All sections must be
explicitly closed using the `#.` marker.

### Specifying other Language Contexts
(Not Implemented)

Multiple languages can be used for either code or document sections by
using the `#~lang` for code and `#=lang` for document sections. Note
that there cannot be any whitespace in the marker, and there must be
a whitespace following.

### Appending to Sections Defined Elsewhere
(Not Implemented)

You can use the `#+` operator to append a block to an existing section.
This can be especially useful for importing modules and declaring
functions, classes, or data structures.

        #+ structs
            struct Blah { ... };
        #.
        #+ headers
            struct Blah create_blah();
        #.

### Configuring Litpl
(Not Implemented)

...
