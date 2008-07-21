From: Julia Lawall <julia@diku.dk>
Date: Mon, 21 Jul 2008 09:59:15 +0200 (CEST)
Subject: [Ocfs2-devel] [PATCH 7/7] fs/ocfs2/file.c: Release mutex in error
	handling code
Message-ID: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/fs/ocfs2/file.c b/fs/ocfs2/file.c
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1766,8 +1766,8 @@ out_inode_unlock:
 out_rw_unlock:
 	ocfs2_rw_unlock(inode, 1);
 
-	mutex_unlock(&inode->i_mutex);
 out:
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
