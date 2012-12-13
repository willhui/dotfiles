import os
import ctypes

ERROR_FILE_NOT_FOUND = 2

# The symlink itself is called the "source", and the file it
# points to is called the "target."
#
#            target          | source        | directory?  
# =========================================================
dotfiles = [('vim',          '.vim',          True),
            ('vimrc',        '.vimrc',        False),
            ('emacs.d',      '.emacs.d',      True),
            ('emacs',        '.emacs',        False),
            ('gitconfig',    '.gitconfig',    False),
            ('gitignore',    '.gitignore',    False),
            ('bash_profile', '.bash_profile', False),
            ('bashrc',       '.bashrc',       False),
            ('zshrc',        '.zshrc',        False),
            ('inputrc',      '.inputrc',      False)]

# Sadly, Gvim for Windows breaks convention.
if os.name == 'nt':
    dotfiles.append(('vim', 'vimfiles', True))

def symlink(target, src, is_dir):
    try:
        os.symlink(src, target)
        return True

    except AttributeError, e:
        # os.symlink is not available on Windows.

        kdll = ctypes.windll.LoadLibrary("kernel32.dll")
        if not kdll:
            print 'Failed to symlink', target, '=>', src
            print '    >> LoadLibrary:', ctypes.WinError(error)

        delete_fn = kdll.RemoveDirectoryA if is_dir else kdll.DeleteFileA
        if not delete_fn(src):
            error = kdll.GetLastError()
            if error != ERROR_FILE_NOT_FOUND:
                print 'Warning: Failed to delete existing symlink.'
                print '    >>', ctypes.WinError(error)

        if kdll.CreateSymbolicLinkA(src, target, int(is_dir)) == 0:
            error = kdll.GetLastError()
            print 'Failed to symlink', target, '=>', src
            print '    >> CreateSymbolicLink:', ctypes.WinError(error)
            return False
        else:
            return True

    except Exception, e:
        print 'Failed to symlink', target, '=>', src
        print '    >> Reason:', e
        return False

def main():
    cwd = os.path.dirname(os.path.abspath(__file__))
    home = os.getenv('HOME')

    if home is None:
        print 'Please set the HOME environment variable.'
        return

    error = False

    for target, src, is_dir in dotfiles:
        abs_target = os.path.join(cwd, target)
        abs_src = os.path.join(home, src)

        if not symlink(abs_target, abs_src, is_dir):
            error = True

    if error:
        print 'Done, with errors.'
    else:
        print 'Dotfiles installed.'

if __name__ == "__main__":
    main()
