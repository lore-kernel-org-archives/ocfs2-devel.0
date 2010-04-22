From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:31 +0800
Subject: [Ocfs2-devel] [PATCH 17/17] ocfs2: enable discontig block group
	support.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-17-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index b5b3cb7..28a8618 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -100,7 +100,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_XATTR \
 					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
 					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
-					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE)
+					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
+					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.5.5
