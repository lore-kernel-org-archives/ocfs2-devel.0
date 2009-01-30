From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 30 Jan 2009 13:42:32 -0800
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: Enable indexed directories
In-Reply-To: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
Message-ID: <1233351753-14640-7-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since the disk format is finalized, we can set this feature bit in the
supported mask.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/ocfs2_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 136f843..beaf702 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -97,7 +97,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR \
-					 | OCFS2_FEATURE_INCOMPAT_META_ECC)
+					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
+					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.5.6
