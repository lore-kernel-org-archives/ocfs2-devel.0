From: Gang He <ghe@suse.com>
Date: Thu, 28 Dec 2017 18:07:42 +0800
Subject: [Ocfs2-devel] [PATCH v3 0/3] ocfs2: add nowait aio support
Message-ID: <1514455665-16325-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

As you know, VFS layer has introduced non-block aio
flag IOCB_NOWAIT, which informs kernel to bail out
if an AIO request will block for reasons such as file
allocations, or a writeback triggered, or would block
while allocating requests while performing direct I/O.
Subsequent, pwritev2/preadv2 also can leverage this
part kernel code.
So far, ext4/xfs/btrfs have supported this feature,
I'd like to add the related code for ocfs2 file system.

Compare with v2, do some modification in ocfs2_overwrite_io()
function for OCFS2_INLINE_DATA_FL case.
Compare with v1, some changes are as below,
use osb pointer in ocfs2_try_rw_lock() function,
modify ocfs2_overwrite_io() function to make all error
value can be returned to the upper code,
move invoking ocfs2_overwrite_io() function from
ocfs2_file_write_iter() to ocfs2_prepare_inode_for_write(),
this change can combine acquiring the related locks.

Gang He (3):
  ocfs2: add ocfs2_try_rw_lock and ocfs2_try_inode_lock
  ocfs2: add ocfs2_overwrite_io function
  ocfs2: nowait aio support

 fs/ocfs2/dir.c         |  2 +-
 fs/ocfs2/dlmglue.c     | 41 +++++++++++++++++++---
 fs/ocfs2/dlmglue.h     |  6 +++-
 fs/ocfs2/extent_map.c  | 45 ++++++++++++++++++++++++
 fs/ocfs2/extent_map.h  |  3 ++
 fs/ocfs2/file.c        | 95 +++++++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/mmap.c        |  2 +-
 fs/ocfs2/ocfs2_trace.h | 10 +++---
 8 files changed, 172 insertions(+), 32 deletions(-)

-- 
1.8.5.6
