From: Christoph Hellwig <hch@lst.de>
Date: Fri Jun 18 05:06:34 2004
Subject: [Ocfs2-devel] [PATCH] another blocknumber printk messup
Message-ID: <20040618100630.GA10633@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/super.c
===================================================================
--- src/super.c	(revision 1146)
+++ src/super.c	(working copy)
@@ -1790,8 +1790,9 @@
 				       OCFS2_MINOR_REV_LEVEL);
 		} else if (bh->b_blocknr != le64_to_cpu(di->i_blkno)) {
 			LOG_ERROR_ARGS("bad block number on superblock: "
-				       "found %llu, should be %lu\n",
-				       le64_to_cpu(di->i_blkno), bh->b_blocknr);
+				       "found %llu, should be %llu\n",
+				       le64_to_cpu(di->i_blkno),
+				       (unsigned long long)bh->b_blocknr);
 		} else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
 			    le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
 			LOG_ERROR_ARGS("bad cluster size found: %u\n",
