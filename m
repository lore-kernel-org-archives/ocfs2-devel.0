From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 13 Sep 2010 14:00:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: update ctime when changing the file's
	permission by setfacl
Message-ID: <1284357623-3113-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In commit 30e2bab, ext3 fixed it. So change it accordingly in ocfs2.

Steps to reproduce:
# touch aaa
# stat -c %Z aaa
1283760364
# setfacl -m  'u::x,g::x,o::x' aaa
# stat -c %Z aaa
1283760364

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/acl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index a76e0aa..3919150 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -209,7 +209,10 @@ static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
 	}
 
 	inode->i_mode = new_mode;
+	inode->i_ctime = CURRENT_TIME;
 	di->i_mode = cpu_to_le16(inode->i_mode);
+	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
-- 
1.7.1.GIT
