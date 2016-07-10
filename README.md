# dotfiles
My configuration files for zsh, vim, git, and emacs. (I'm not a regular emacs user, so this
the emacs config could probably use some tweaking.)

Clone the repository and run install.sh to set up dotfile symlinks (warning: this will clobber
your existing dotfiles!) and auto-download any zsh vim plugins necessary. The zsh plugins will
be placed under ~/dev/external/.

On Windows, you can use the provided python script to create symlinks. But any other setup,
such as downloading plugins, will have to be done manually. I rarely code anything on Windows
these days.
