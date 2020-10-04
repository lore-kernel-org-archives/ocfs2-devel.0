From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:21 +0100
Subject: [Ocfs2-devel] [PATCH 0/7] Fix a pile of 4GB file problems on 32-bit
Message-ID: <20201004180428.14494-1-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com

I caught a bug in my own code where I forgot to cast to loff_t before
shifting.  So I thought I'd grep around and see if I could find any
other occurrences.  I found a few that were clearly bugs, and they're
fixed below.  There are other places where we don't cast, and I think
they're OK.  For example, some places we have a 'nr_pages' being shifted
by PAGE_SHIFT, and that's probably OK because it's probably a single I/O.

Also, I didn't touch AFFS or ROMFS or some other filesystems which
probably have never seen a 4GB file in their lives.  Might be worth
fixing to be sure nobody copies bad code from them, but not worth cc'ing
stable for.

I didn't look for SECTOR_SHIFT or SECTOR_SIZE (or bare 9/512), just
PAGE_SIZE and PAGE_SHIFT.

I can't find a GCC warning to enable for this pattern, so I filed
https://urldefense.com/v3/__https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97287__;!!GqivPVa7Brio!JmJRfLO1W1WY_UNpWJIfK5J2F0viNTrZ3l7xIrCKzl03yThvlPmVBeZHbHY6hZu2IJ2u7Q$ 

Matthew Wilcox (Oracle) (7):
  9P: Cast to loff_t before multiplying
  buffer: Promote to unsigned long long before shifting
  ceph: Promote to unsigned long long before shifting
  ocfs2: Promote to unsigned long long before shifting
  btrfs: Promote to unsigned long long before shifting
  btrfs: Promote to unsigned long long before shifting
  btrfs: Promote to unsigned long long before multiplying

 fs/9p/vfs_file.c  |  4 ++--
 fs/btrfs/ioctl.c  |  6 +++---
 fs/btrfs/raid56.c |  2 +-
 fs/btrfs/scrub.c  | 25 ++++++++++++++++---------
 fs/buffer.c       |  2 +-
 fs/ceph/addr.c    |  2 +-
 fs/ocfs2/alloc.c  |  2 +-
 7 files changed, 25 insertions(+), 18 deletions(-)

-- 
2.28.0
