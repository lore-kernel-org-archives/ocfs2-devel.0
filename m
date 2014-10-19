From: Richard Weinberger <richard@nod.at>
Date: Sun, 19 Oct 2014 12:39:44 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix d_splice_alias() return code
	checking
In-Reply-To: <1413715184-30196-1-git-send-email-richard@nod.at>
References: <1413715184-30196-1-git-send-email-richard@nod.at>
Message-ID: <1413715184-30196-2-git-send-email-richard@nod.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
Currently the code checks not for ERR_PTR and my oops in
ocfs2_dentry_attach_lock().
Fix this by using IS_ERR_OR_NULL().

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 8add6f1..b931e04 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -158,7 +158,7 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (ret)
+		if (!IS_ERR_OR_NULL(ret))
 			dentry = ret;
 
 		status = ocfs2_dentry_attach_lock(dentry, inode,
-- 
2.1.0
