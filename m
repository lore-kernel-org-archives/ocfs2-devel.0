From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 20:36:23 -0800
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: prohibit refcounted swapfiles
In-Reply-To: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
References: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
Message-ID: <147987578305.2678.8076695687794888694.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

The swapfile mechanism calls bmap once to find all the swap file
mappings, which means that we cannot properly support CoW remapping.
Therefore, error out if the swap code tries to call bmap on a
refcounted file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/aops.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c5c5b97..4d037db 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -464,6 +464,15 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 	trace_ocfs2_bmap((unsigned long long)OCFS2_I(inode)->ip_blkno,
 			 (unsigned long long)block);
 
+	/*
+	 * The swap code (ab-)uses ->bmap to get a block mapping and then
+	 * bypasse? the file system for actual I/O.  We really can't allow
+	 * that on refcounted inodes, so we have to skip out here.  And yes,
+	 * 0 is the magic code for a bmap error..
+	 */
+	if (ocfs2_is_refcount_inode(inode))
+		return 0;
+
 	/* We don't need to lock journal system files, since they aren't
 	 * accessed concurrently from multiple nodes.
 	 */
