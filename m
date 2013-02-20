From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 20 Feb 2013 11:59:22 +0800
Subject: [Ocfs2-devel] [RFC PATCH 1/3] fiemap: Introduce FIEMAP_FLAG_COW
 flag to map shared extents
Message-ID: <51244A1A.7060105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

Introduce a new flag FIEMAP_FLAG_COW to fiemap ioctl(2) interface.

If this flag is set, the kernel will only return the mapped extents
which are in copy-on-write state.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jan Kara <jack@suse.de>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>

---
 include/uapi/linux/fiemap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
index d830747..693dff4 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -40,8 +40,10 @@ struct fiemap {
 
 #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
 #define FIEMAP_FLAG_XATTR	0x00000002 /* map extended attribute tree */
+#define FIEMAP_FLAG_COW		0x00000004 /* map copy-on-write extents */
 
-#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR | \
+				 FIEMAP_FLAG_COW)
 
 #define FIEMAP_EXTENT_LAST		0x00000001 /* Last extent in file. */
 #define FIEMAP_EXTENT_UNKNOWN		0x00000002 /* Data location unknown. */
-- 
1.7.9.5
