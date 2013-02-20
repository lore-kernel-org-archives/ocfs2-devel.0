From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 20 Feb 2013 11:59:24 +0800
Subject: [Ocfs2-devel] [RFC PATCH 2/3] fiemap: document update
Message-ID: <51244A1C.7050504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

Update fiemap document to add FIEMAP_FLAG_COW support.

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
 Documentation/filesystems/fiemap.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index 1b805a0..8942d3f 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -58,6 +58,9 @@ If this flag is set, the kernel will sync the file before mapping extents.
 If this flag is set, the extents returned will describe the inodes
 extended attribute lookup tree, instead of its data tree.
 
+* FIEMAP_FLAG_COW
+If this flag is set, the kernel will only return the extents which are in
+copy-on-write state.
 
 Extent Mapping
 --------------
-- 
1.7.9.5
