From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Wed, 21 Jun 2017 14:18:27 -0400
Subject: [Ocfs2-devel] [PATCH v2 07/10] ocfs2: define integrity_read method
In-Reply-To: <1498069110-10009-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1498069110-10009-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <1498069110-10009-8-git-send-email-zohar@linux.vnet.ibm.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Define an ->integrity_read file operation method to read data for
integrity hash collection.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 fs/ocfs2/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bfeb647459d9..2832a7c92acd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2536,6 +2536,7 @@ const struct file_operations ocfs2_fops = {
 	.fallocate	= ocfs2_fallocate,
 	.clone_file_range = ocfs2_file_clone_range,
 	.dedupe_file_range = ocfs2_file_dedupe_range,
+	.integrity_read	= ocfs2_file_read_iter,
 };
 
 const struct file_operations ocfs2_dops = {
-- 
2.7.4
