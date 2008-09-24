From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:01:02 -0700
Subject: [Ocfs2-devel] [PATCH 21/39] ocfs2: fix printk format warnings
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-22-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>

This patch fixes the following build warnings:

fs/ocfs2/xattr.c: In function 'ocfs2_half_xattr_bucket':
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_set_entry_in_bucket':
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 090449f..1b349c7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3264,7 +3264,8 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	xe = &xh->xh_entries[start];
 	len = sizeof(struct ocfs2_xattr_entry) * (count - start);
 	mlog(0, "mv xattr entry len %d from %d to %d\n", len,
-	     (char *)xe - (char *)xh, (char *)xh->xh_entries - (char *)xh);
+	     (int)((char *)xe - (char *)xh),
+	     (int)((char *)xh->xh_entries - (char *)xh));
 	memmove((char *)xh->xh_entries, (char *)xe, len);
 	xe = &xh->xh_entries[count - start];
 	len = sizeof(struct ocfs2_xattr_entry) * start;
@@ -4073,8 +4074,8 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog(0, "Set xattr entry len = %d index = %d in bucket %llu\n",
-	     xi->value_len, xi->name_index,
+	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
+	     (unsigned long)xi->value_len, xi->name_index,
 	     (unsigned long long)xs->bucket.bhs[0]->b_blocknr);
 
 	if (!xs->bucket.bhs[1]) {
-- 
1.5.4.5
