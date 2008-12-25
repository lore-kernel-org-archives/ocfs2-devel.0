From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:35 -0800
Subject: [Ocfs2-devel] [PATCH 20/35] ocfs2: Validate superblock with
	checksum and ecc.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-21-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

The superblock is read via a raw call.  Validate it after we find it
from its signature.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/super.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bc43138..a79e67b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -52,6 +52,7 @@
 #include "ocfs1_fs_compat.h"
 
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dlmglue.h"
 #include "export.h"
 #include "extent_map.h"
@@ -1982,6 +1983,15 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 
 	if (memcmp(di->i_signature, OCFS2_SUPER_BLOCK_SIGNATURE,
 		   strlen(OCFS2_SUPER_BLOCK_SIGNATURE)) == 0) {
+		/* We have to do a raw check of the feature here */
+		if (le32_to_cpu(di->id2.i_super.s_feature_incompat) &
+		    OCFS2_FEATURE_INCOMPAT_META_ECC) {
+			status = ocfs2_block_check_validate(bh->b_data,
+							    bh->b_size,
+							    &di->i_check);
+			if (status)
+				goto out;
+		}
 		status = -EINVAL;
 		if ((1 << le32_to_cpu(di->id2.i_super.s_blocksize_bits)) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
@@ -2023,6 +2033,7 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 		}
 	}
 
+out:
 	mlog_exit(status);
 	return status;
 }
-- 
1.5.6
