From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Aug 2010 16:24:25 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix metaecc error messages
Message-ID: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Like tools, the checksum validate function now prints the values in hex.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/blockcheck.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index ec6d123..c7ee03c 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -439,7 +439,7 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 
 	ocfs2_blockcheck_inc_failure(stats);
 	mlog(ML_ERROR,
-	     "CRC32 failed: stored: %u, computed %u.  Applying ECC.\n",
+	     "CRC32 failed: stored: 0x%x, computed 0x%x. Applying ECC.\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
 
 	/* Ok, try ECC fixups */
@@ -453,7 +453,7 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 		goto out;
 	}
 
-	mlog(ML_ERROR, "Fixed CRC32 failed: stored: %u, computed %u\n",
+	mlog(ML_ERROR, "Fixed CRC32 failed: stored: 0x%x, computed 0x%x\n",
 	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
 
 	rc = -EIO;
-- 
1.7.0.4
