From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:51 +0800
Subject: [Ocfs2-devel] [PATCH 39/39] ocfs2: Enable refcount tree support.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-39-git-send-email-tao.ma@oracle.com>
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
index 04adaf9..a4c6015 100644
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
