From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:11 -0800
Subject: [Ocfs2-devel] [PATCH 06/15] ocfs2: truncate outstanding block after
	direct io failure
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Dmitri Monakhov <dmonakhov@openvz.org>

Mainline commit c435400140d24fbcb3da6b1e006be831f9056cb6

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/file.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2871b45..0c8e03a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2170,6 +2170,13 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
+			/*
+			 * direct write may have instantiated a few
+			 * blocks outside i_size. Trim these off again.
+			 * Don't need i_size_read because we hold i_mutex.
+			 */
+			if (*ppos + count > inode->i_size)
+				vmtruncate(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
-- 
1.5.6.3
