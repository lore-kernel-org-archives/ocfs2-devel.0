From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 20 Feb 2013 11:59:17 +0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
Message-ID: <51244A15.2060508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

Hello,

We have the user requests to show the real disk usage for OCFS2/Btrfs with
reflinked/cloned files.  AFAICS, integrate the existing fiemap interface to du(1) is
fine to solve this issue because OCFS2 can return an extent in FIEMAP_EXTENT_SHARED
state which is used to indicate the extent is reflinked, and Btrfs can be improved
in the similar approach in the future.

Now another issue is regarding the performance when call fiemap ioctl(2) against a
large file(like virtual disk images).  Assuming we created a 20Gb reflinked file,
the first 19Gb has been written(COWed), and the left 1Gb is still in shared status,
the user space has to call fiemap for multiple times to fetch the ending shared extents,
that is not good if the target disk have many reflinked files in such situations.

I'd like to introduce a new flag FIEMAP_FLAG_COW to the fiemap interface, if this flag is
set, the kernel space will only return the mapped extents in shared state, as a result, we
can reduce the overheads for calling fiemap again an again.

Test program to verify the FIEMAP_FLAG_COW flag:
https://github.com/pibroch/fiemap_cow/blob/master/cow_test.c

Create reflink file on OCFS2:
https://github.com/pibroch/fiemap_cow/blob/master/ocfs2_reflink.c


Any comments are appreciated, thanks!

-Jeff
