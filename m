From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:13 2008
Subject: [Ocfs2-devel] [PATCH 22/30] ocfs2: Use generic_file_llseek
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-23-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

From: Jan Kara <jack@suse.cz>

We should use generic_file_llseek() and not default_llseek() so that
s_maxbytes gets properly checked when seeking.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index caefd57..6ebc9f9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2233,6 +2233,7 @@ const struct inode_operations ocfs2_special_file_iops = {
 };
 
 const struct file_operations ocfs2_fops = {
+	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.mmap		= ocfs2_mmap,
@@ -2251,6 +2252,7 @@ const struct file_operations ocfs2_fops = {
 };
 
 const struct file_operations ocfs2_dops = {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
-- 
1.5.3.6
