From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 22 Dec 2014 22:01:26 +0100
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: remove unnecessary else
	in ocfs2_set_acl()
Message-ID: <1419282086-11340-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

else is unnecessary after return

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/acl.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 7e8282d..c58a1bc 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -245,16 +245,14 @@ int ocfs2_set_acl(handle_t *handle,
 			ret = posix_acl_equiv_mode(acl, &mode);
 			if (ret < 0)
 				return ret;
-			else {
-				if (ret == 0)
-					acl = NULL;
 
-				ret = ocfs2_acl_set_mode(inode, di_bh,
-							 handle, mode);
-				if (ret)
-					return ret;
+			if (ret == 0)
+				acl = NULL;
 
-			}
+			ret = ocfs2_acl_set_mode(inode, di_bh,
+						 handle, mode);
+			if (ret)
+				return ret;
 		}
 		break;
 	case ACL_TYPE_DEFAULT:
-- 
1.9.1
