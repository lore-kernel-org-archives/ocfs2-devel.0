From: Gustavo A. R. Silva <gustavo@embeddedor.com>
Date: Mon, 9 Mar 2020 15:20:16 -0500
Subject: [Ocfs2-devel] [PATCH][next] ocfs2: dlm: Replace zero-length array
 with flexible-array member
Message-ID: <20200309202016.GA8210@embeddedor>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!OVOYL_CouISa5L1Lw-20EEFQntw6cKMx-j8UdY4z78uYgzKBUFcfpn50GaurvbV5v7YiUA$ 
[2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!OVOYL_CouISa5L1Lw-20EEFQntw6cKMx-j8UdY4z78uYgzKBUFcfpn50GaurvbXs8Eh8eg$ 
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0463dce65bb2..c8a444622faa 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -564,7 +564,7 @@ struct dlm_migratable_lockres
 	// 48 bytes
 	u8 lvb[DLM_LVB_LEN];
 	// 112 bytes
-	struct dlm_migratable_lock ml[0];  // 16 bytes each, begins at byte 112
+	struct dlm_migratable_lock ml[];  // 16 bytes each, begins at byte 112
 };
 #define DLM_MIG_LOCKRES_MAX_LEN  \
 	(sizeof(struct dlm_migratable_lockres) + \
@@ -601,7 +601,7 @@ struct dlm_convert_lock
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_CONVERT_LOCK_MAX_LEN  (sizeof(struct dlm_convert_lock)+DLM_LVB_LEN)
 
@@ -616,7 +616,7 @@ struct dlm_unlock_lock
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_UNLOCK_LOCK_MAX_LEN  (sizeof(struct dlm_unlock_lock)+DLM_LVB_LEN)
 
@@ -632,7 +632,7 @@ struct dlm_proxy_ast
 
 	u8 name[O2NM_MAX_NAME_LEN];
 
-	s8 lvb[0];
+	s8 lvb[];
 };
 #define DLM_PROXY_AST_MAX_LEN  (sizeof(struct dlm_proxy_ast)+DLM_LVB_LEN)
 
-- 
2.25.0
