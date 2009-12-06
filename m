From: Coly Li <coly.li@suse.de>
Date: Sun, 06 Dec 2009 22:38:53 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: replace u8 by __u8 in ocfs2_fs.h
Message-ID: <4B1BC1FD.90803@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch replaces date type 'u8' with '__u8', which follows the coding style of ocfs2_fs.h, and portable to user space
for ocfs2-tools.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e9431e4..1a1a679 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1202,7 +1202,7 @@ struct ocfs2_local_disk_dqinfo {
 /* Header of one chunk of a quota file */
 struct ocfs2_local_disk_chunk {
 	__le32 dqc_free;	/* Number of free entries in the bitmap */
-	u8 dqc_bitmap[0];	/* Bitmap of entries in the corresponding
+	__u8 dqc_bitmap[0];	/* Bitmap of entries in the corresponding
 				 * chunk of quota file */
 };
-- 
Coly Li
SuSE Labs
