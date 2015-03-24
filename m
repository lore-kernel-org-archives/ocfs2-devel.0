From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Date: Tue, 24 Mar 2015 11:46:32 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2: trusted xattr missing CAP_SYS_ADMIN
	check
Message-ID: <1427211992-9803-1-git-send-email-sanidhya.gatech@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu, csong84@gatech.edu, Sanidhya Kashyap <sanidhya.gatech@gmail.com>

The trusted extended attributes are only visible to the process which hvae
CAP_SYS_ADMIN capability but the check is missing in ocfs2 xattr_handler
trusted list. The check is important because this will be used for implementing
mechanisms in the userspace for which other ordinary processes should not
have access to.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
---
 fs/ocfs2/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 85b190d..71a6551 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7326,6 +7326,9 @@ static size_t ocfs2_xattr_trusted_list(struct dentry *dentry, char *list,
 	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
+
 	if (list && total_len <= list_size) {
 		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
 		memcpy(list + prefix_len, name, name_len);
-- 
2.1.0
