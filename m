From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:41 +0800
Subject: [Ocfs2-devel] [PATCH 40/41] ocfs2: Enable refcount tree support.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-40-git-send-email-tao.ma@oracle.com>
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
index 40072cd..4a4565b 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -99,7 +99,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR \
 					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
-					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS)
+					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
+					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.6.2.rc2.16.gf474c
