From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:21 2007
Subject: [Ocfs2-devel] [PATCH 05/15] ocfs2: Pass raw u64 to filldir
Message-ID: <200709192012.l8JKCGhF012172@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

filldir_t can take this, so don't turn de->inode into a 32 bit value. Right
now this doesn't make a difference since no ocfs2 inodes overflow that, but
it could be a nasty surprise later on if some kernel code is calling
ocfs2_dir_foreach_blk() and expecting real inode numbers back...

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d1f92fd..dbfa6f6 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -512,7 +512,7 @@ revalidate:
 				error = filldir(priv, de->name,
 						de->name_len,
 						*f_pos,
-						ino_from_blkno(sb, le64_to_cpu(de->inode)),
+						le64_to_cpu(de->inode),
 						d_type);
 				if (error)
 					break;
-- 
1.5.0.6
