From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:11 +0800
Subject: [Ocfs2-devel] [PATCH 0/8] ocfs2: fix ocfs2 direct io code patch to
	support sparse file and data ordering semantics
Message-ID: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The idea is to use buffer io(more precisely use the interface
ocfs2_write_begin_nolock & ocfs2_write_end_nolock) to do the zero work beyond
block size. And clear UNWRITTEN flag until direct io data has been written to
disk, which can prevent data corruption when system crashed during direct write.

And we will also archive a better performance:
eg. dd direct write new file with block size 4KB:
before this patch:
2.5 MB/s
after this patch:
66.4 MB/s

----------------------------------------------------------------
Ryan Ding (8):
      ocfs2: add ocfs2_write_type_t type to identify the caller of write
      ocfs2: use c_new to indicate newly allocated extents
      ocfs2: test target page before change it
      ocfs2: do not change i_size in write_end for direct io
      ocfs2: return the physical address in ocfs2_write_cluster
      ocfs2: record UNWRITTEN extents when populate write desc
      ocfs2: fix sparse file & data ordering issue in direct io. 
      ocfs2: code clean up for direct io

 fs/ocfs2/aops.c        | 1118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
 fs/ocfs2/aops.h        |   11 +-
 fs/ocfs2/file.c        |  138 +---------------------
 fs/ocfs2/inode.c       |    3 +
 fs/ocfs2/inode.h       |    3 + 
 fs/ocfs2/mmap.c        |    4 +-
 fs/ocfs2/ocfs2_trace.h |   16 +-- 
 fs/ocfs2/super.c       |    1 +
 8 files changed, 568 insertions(+), 726 deletions(-)
