From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Nov 2012 12:17:52 +0100
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add freeze protection to
	ocfs2_file_splice_write()
In-Reply-To: <1352719072-32274-1-git-send-email-jack@suse.cz>
References: <1352719072-32274-1-git-send-email-jack@suse.cz>
Message-ID: <1352719072-32274-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, dchinner@redhat.com, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

ocfs2_file_splice_write() was missed when adding freeze protection to all
write paths. Fix that.

CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 93ef34d..9907243 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2486,6 +2486,9 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 			out->f_path.dentry->d_name.len,
 			out->f_path.dentry->d_name.name, len);
 
+	if (!sb_start_file_write(out))
+		return -EAGAIN;
+
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
 
@@ -2527,6 +2530,7 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
+	sb_end_write(inode->i_sb);
 
 	return ret;
 }
-- 
1.7.1
