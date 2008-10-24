From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:17 +0200
Subject: [Ocfs2-devel] [PATCH 24/29] ocfs2: Mark system files as not subject
	to quota accounting
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861041463-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark system files as not subject to quota accounting. This prevents
possible recursions into quota code and thus deadlocks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index da3a360..738b63f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -284,8 +284,10 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
 
-	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL))
+	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SYSTEM_FILE;
+		inode->i_flags |= S_NOQUOTA;
+	}
 
 	if (fe->i_flags & cpu_to_le32(OCFS2_LOCAL_ALLOC_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
-- 
1.5.2.4
