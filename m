From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Jul 2009 19:14:19 +0200
Subject: [Ocfs2-devel] [PATCH 4/9] Write out quota info changes on
	ocfs2_close()
In-Reply-To: <1248974064-29462-1-git-send-email-jack@suse.cz>
References: <1248974064-29462-1-git-send-email-jack@suse.cz>
Message-ID: <1248974064-29462-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We don't write out change of information in quota file header on each change,
we rather cache it in ocfs2_filesys structure. So write out all the
information when ocfs2_close() is called.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 libocfs2/closefs.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/libocfs2/closefs.c b/libocfs2/closefs.c
index 54411da..290bfd1 100644
--- a/libocfs2/closefs.c
+++ b/libocfs2/closefs.c
@@ -39,6 +39,7 @@ errcode_t ocfs2_flush(ocfs2_filesys *fs)
 errcode_t ocfs2_close(ocfs2_filesys *fs)
 {
 	errcode_t ret;
+	int type;
 
 	if (fs->fs_flags & OCFS2_FLAG_DIRTY) {
 		ret = ocfs2_flush(fs);
@@ -46,6 +47,17 @@ errcode_t ocfs2_close(ocfs2_filesys *fs)
 			return ret;
 	}
 
+	for (type = 0; type < MAXQUOTAS; type++)
+		if (fs->qinfo[type].flags & OCFS2_QF_INFO_DIRTY) {
+			ret = ocfs2_write_global_quota_info(fs, type);
+			if (ret)
+				return ret;
+			ret = ocfs2_write_cached_inode(fs,
+						fs->qinfo[type].qi_inode);
+			if (ret)
+				return ret;
+		}
+
 	ocfs2_freefs(fs);
 	return 0;
 }
-- 
1.6.0.2
