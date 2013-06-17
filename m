From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 17 Jun 2013 09:08:24 -0500
Subject: [Ocfs2-devel] [PATCH] Add bits_wanted while calculating credits in
 ocfs2_calc_extend_credits
Message-ID: <20130617140824.GA8554@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While adding extends to a file, the credits are calculated incorrectly
and if the requested clusters is more than one (or more because we used 
a conservative limit) then we run out of journal credits and we hit
an assert in journalling code.

The function parameter bits_wanted variable was not used at all.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

--- 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index a3385b6..7d927cd 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -538,7 +538,7 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
 
 	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
-	       ocfs2_quota_trans_credits(sb);
+	       ocfs2_quota_trans_credits(sb) + bits_wanted;
 }
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
