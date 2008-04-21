From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 21 Apr 2008 11:49:26 +0300
Subject: [Ocfs2-devel] [2.6 patch] make struct ocfs2_control_device static
Message-ID: <20080421084926.GS26897@cs181133002.pp.htv.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch makes the needlessly global struct ocfs2_control_device 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d8837f8ed79bc615105e5ca2724c3d22c9f26089 diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 7428663..b503772 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -635,7 +635,7 @@ static const struct file_operations ocfs2_control_fops = {
 	.owner   = THIS_MODULE,
 };
 
-struct miscdevice ocfs2_control_device = {
+static struct miscdevice ocfs2_control_device = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= "ocfs2_control",
 	.fops		= &ocfs2_control_fops,
