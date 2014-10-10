From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Oct 2014 16:23:37 +0200
Subject: [Ocfs2-devel] [PATCH] udf: Print error when inode is loaded
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Message-ID: <1412951028-4085-33-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5401fc33f5cc..479875155d77 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -962,7 +962,7 @@ struct inode *udf_find_metadata_inode_efe(struct super_block *sb,
 	metadata_fe = udf_iget(sb, &addr);
 
 	if (IS_ERR(metadata_fe)) {
-		udf_warn(sb, "metadata inode efe not found\n");
+		udf_warn(sb, "metadata inode efe not found: %d\n", PTR_ERR(metadata_fe));
 		return metadata_fe;
 	}
 	if (UDF_I(metadata_fe)->i_alloc_type != ICBTAG_FLAG_AD_SHORT) {
-- 
1.8.1.4
