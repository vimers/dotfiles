# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.core.loader import CommandLoader

class mkcd(Command):

    def execute(self):
        from os.path import join, expanduser, lexists
        from os import makedirs
        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)
            self.fm.cd(dirname)
        else:
            self.fm.notify("file/directory exists!", bad=True)

class compress(Command):
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]
        descr = "compressing files in: "+os.path.basename(parts[1])
        obj = CommandLoader(args=['apack']+au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr, read=True)
        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, _):
        extensions = ['.zip', '.tar.gz', '.rar', '.7z']
        return [
                'compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extensions]

class extracthere(Command):
    def execute(self):
        copied_files = tuple(self.fm.copy_buffer)
        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)

        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr, read=True)
        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)
