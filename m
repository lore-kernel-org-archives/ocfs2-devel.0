From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 2 Sep 2020 20:52:25 -0700
Subject: [Ocfs2-devel] Broken O_{D,}SYNC behavior with FICLONE*?
Message-ID: <20200903035225.GJ6090@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2 list <ocfs2-devel@oss.oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>

Hi,

I have a question for everyone-- do FICLONE and FICLONERANGE count as a
"write operation" for the purposes of reasoning about O_SYNC and
O_DSYNC?  In other words, is it supposed to be the case that
(paraphrasing the open(2) manpage) "By the time ioctl(FICLONE) returns,
the output data and associated file metadata have been transferred to
the underlying hardware (i.e., as though each ioctl(FICLONE) was
followed by a call to fsync(2))."?

If I open a file with O_SYNC, call FICLONE to reflink some data blocks
into that file, and hit the reset button as soon as the ioctl call
returns, should I expect that I will always see the new file contents in
that file after the system comes back up?  Or am I required to fsync()
the file despite O_SYNC being set?

The reason I ask is that (a) reflinking can definitely change the file
contents which seems like a write operation; and (b) we wrote a test to
examine the copy_file_range() semantics wrt O_SYNC and discovered that
an unaligned c_f_r through the splice code does indeed honor the
documented O_SYNC semantics, but a block-aligned c_f_r that uses reflink
does *not* honor this.

So, that's inconsistent behavior and I want to know if remap_file_range
is broken or if we all just don't care about O_SYNC for these fancy
IO accelerators?

I tend to think reflink is broken on XFS, but I converted that O_SYNC
test into a fstest and discovered that none of XFS, btrfs, or ocfs2
actually force the fs to persist metadata changes after reflinking into
an O_SYNC file.  The manpages for the clone ioctls and copy_file_range
don't explicitly declare those calls to be "write operations".

FWIW I repeated the analysis with a file that had FS_XFLAG_SYNC or
FS_SYNC_FL set on the inode but O_SYNC was not set on the fd, and
observed the same results.

--D
