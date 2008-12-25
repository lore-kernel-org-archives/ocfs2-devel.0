From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:50 -0800
Subject: [Ocfs2-devel] [PATCH 35/35] ocfs2: Add xattr support checking in
	init_security
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-36-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tiger Yang <tiger.yang@oracle.com>

We must check whether ocfs2 volume support xattr in init_security,
if not support xattr and security is enable, would cause failure of mknod.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 095b0bb..e1d638a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5324,6 +5324,9 @@ int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    struct ocfs2_security_xattr_info *si)
 {
+	/* check whether ocfs2 support feature xattr */
+	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
+		return -EOPNOTSUPP;
 	return security_inode_init_security(inode, dir, &si->name, &si->value,
 					    &si->value_len);
 }
-- 
1.5.6
