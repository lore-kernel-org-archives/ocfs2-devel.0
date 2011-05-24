From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 17:51:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach local-mounted ocfs2 to
	handle unwritten_extents correctly.
Message-ID: <1306230713-26922-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Oops, local-mounted of 'ocfs2_fops_no_plocks' is just missing the support
of unwritten_extents/punching-hole due to no func pointer was given correctly
to '.follocate' field.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 89659d6..b1e35a3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2670,6 +2670,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.flock		= ocfs2_flock,
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+	.fallocate	= ocfs2_fallocate,
 };
 
 const struct file_operations ocfs2_dops_no_plocks = {
-- 
1.5.5
