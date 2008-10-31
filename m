From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:12 +0100
Subject: [Ocfs2-devel] [PATCH 22/27] ocfs2: Mark system files as not subject
	to quota accounting
In-Reply-To: <12254351591416-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
	<12254351583984-git-send-email-jack@suse.cz>
	<12254351582475-git-send-email-jack@suse.cz>
	<12254351583997-git-send-email-jack@suse.cz>
	<122543515838-git-send-email-jack@suse.cz>
	<1225435158192-git-send-email-jack@suse.cz>
	<1225435158807-git-send-email-jack@suse.cz>
	<1225435159130-git-send-email-jack@suse.cz>
	<12254351592930-git-send-email-jack@suse.cz>
	<12254351592095-git-send-email-jack@suse.cz>
	<12254351592812-git-send-email-jack@suse.cz>
	<12254351592495-git-send-email-jack@suse.cz>
	<12254351591416-git-send-email-jack@suse.cz>
Message-ID: <12254351593189-git-send-email-jack@suse.cz>
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
index c80489d..e14b7ef 100644
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
