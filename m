From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:03 -0800
Subject: [Ocfs2-devel] [PATCH 22/56] ocfs2: Mark system files as not subject
	to quota accounting
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-23-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Mark system files as not subject to quota accounting. This prevents
possible recursions into quota code and thus deadlocks.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ec25d99..50dbc48 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -275,8 +275,10 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
 
-	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL))
+	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SYSTEM_FILE;
+		inode->i_flags |= S_NOQUOTA;
+	}
 
 	if (fe->i_flags & cpu_to_le32(OCFS2_LOCAL_ALLOC_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
-- 
1.5.6
