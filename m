From: Gang He <ghe@suse.com>
Date: Mon, 29 Feb 2016 13:17:57 +0800
Subject: [Ocfs2-devel] [PATCH v4 0/5] Add online file check feature
Message-ID: <1456723082-13838-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

When there are errors in the ocfs2 filesystem,
they are usually accompanied by the inode number which caused the error.
This inode number would be the input to fixing the file.
One of these options could be considered:
A file in the sys filesytem which would accept inode numbers.
This could be used to communication back what has to be fixed or is fixed.
You could write:
$# echo "<inode>" > /sys/fs/ocfs2/devname/filecheck/check
or
$# echo "<inode>" > /sys/fs/ocfs2/devname/filecheck/fix

Compare with third version, I add buffer_jbd() check in inode block fix/writing
dirty buffer back, make unsigned short type to unsigned int type for members
in ocfs2_filecheck_entry struct, add feature document in this patch set.
Compare with second version, I re-design filecheck sysfs interfaces, there
are three sysfs files(check, fix and set) under filecheck directory(see above),
sysfs will accept only one argument <inode>. Second, I adjust some code in
ocfs2_filecheck_repair_inode_block() function according to upstream feedback,
we cannot just add VALID_FL flag back as a inode block fix, then we will not
fix this field corruption currently until having a complete solution.
Compare with first version, I use strncasecmp instead of double strncmp
functions. Second, update the source file contribution vendor.

Gang He (5):
  ocfs2: export ocfs2_kset for online file check
  ocfs2: sysfile interfaces for online file check
  ocfs2: create/remove sysfile for online file check
  ocfs2: check/fix inode block for online file check
  ocfs2: add feature document for online file check

 .../filesystems/ocfs2-online-filecheck.txt         |  94 ++++
 fs/ocfs2/Makefile                                  |   3 +-
 fs/ocfs2/filecheck.c                               | 606 +++++++++++++++++++++
 fs/ocfs2/filecheck.h                               |  49 ++
 fs/ocfs2/inode.c                                   | 225 +++++++-
 fs/ocfs2/inode.h                                   |   3 +
 fs/ocfs2/ocfs2_trace.h                             |   2 +
 fs/ocfs2/stackglue.c                               |   3 +-
 fs/ocfs2/stackglue.h                               |   2 +
 fs/ocfs2/super.c                                   |   5 +
 10 files changed, 981 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/filesystems/ocfs2-online-filecheck.txt
 create mode 100644 fs/ocfs2/filecheck.c
 create mode 100644 fs/ocfs2/filecheck.h

-- 
2.1.2
