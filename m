From: Jan Kara <jack@suse.cz>
Date: Fri, 13 Feb 2009 00:38:17 +0100
Subject: [Ocfs2-devel] Deadlock in rename path
Message-ID: <20090212233816.GA3525@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  I've been looking at ocfs2_rename() and I think there are two possible
deadlocks:
  1) ocfs2_double_lock() locks directories in the inode number order. But
for a directory structure like:
   d1
  /  \
 f1  d2
    /
   f2

if you do 'mv f1 f2' and in parallel do something like 'rmdir d2' then
ocfs2_double_lock() can try locking directories in order 'd2','d1' but
ocfs2_rmdir() tries locking directories in order 'd1', 'd2' -> deadlock.
The solution could be to mimic VFS behavior in lock_rename() and check
whether one of the directories is not parent of the other one and lock
in appropriate order. But the problem with this is that we don't have
directory dentries in ocfs2_rename(). Hopefully obtaining them via i_dentry
should be possible but I'm not completely certain about interactions with
bind mounts etc...
  2) ocfs2_rename() also first locks old_inode (to unlink it) and then
new_inode (to create new link to it). Now in the directory structure where
are files 'a' and 'b' linked to two directories 'd1' and 'd2', there can be
two renames racing against each other. One does 'mv d1/a d1/b' the other
does 'mv d2/b d2/a'. Again, they try to obtain locks for file inodes in
different order resulting in deadlock. The question is how to solve this
one. I would introduce double lock function similar as for directories.
It is nasty but it should work fine. What do you think?

								Honza
