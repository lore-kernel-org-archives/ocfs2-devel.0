From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:55 -0800
Subject: [Ocfs2-devel] [PATCH 18/18] ocfs2: Enable metadata checksums.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-19-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add OCFS2_FEATURE_INCOMPAT_META_ECC to the list of supported features.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 4e20f50..95b231f 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -92,7 +92,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
-					 | OCFS2_FEATURE_INCOMPAT_XATTR)
+					 | OCFS2_FEATURE_INCOMPAT_XATTR \
+					 | OCFS2_FEATURE_INCOMPAT_META_ECC)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.5.6.5
