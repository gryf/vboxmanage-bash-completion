VBoxManage bash completion script
=================================

This version of the completion was initially based on Sebastian T. Hafner
script. However, in some point of time I've decided to rewrite it almost from
scratch.

Current version of script was written and tested against VBoxManage in version
4.3.28, and supports all commands (in some extent ;)).


Installation
============

Either source the file::

    $ . /path/to/this/repo/VBoxManage

or add it to a proper place depending on your distribution. Ususal place would
be:

* ~/bash-completion.d/
* /usr/local/etc/bash-completion.d/
* /etc/bash_completion.d/
* etc.

It's also okay to copy it into some directory, and place proper line in
``.profile`` or ``.bashrc``::

    source /some/directory/VBoxManage

License
=======

This software is licensed under 3-clause BSD license. See LICENSE file for
details.
