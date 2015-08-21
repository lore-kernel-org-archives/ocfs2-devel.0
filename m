From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:40:54 -0700
Subject: [Ocfs2-devel] [patch 02/24] ocfs2: trusted xattr missing
	CAP_SYS_ADMIN check
Message-ID: <55d79ae6.1iW/Ws1GFj2upvUh%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: ocfs2: trusted xattr missing CAP_SYS_ADMIN check

The trusted extended attributes are only visible to the process which hvae
CAP_SYS_ADMIN capability but the check is missing in ocfs2 xattr_handler
trusted list.  The check is important because this will be used for
implementing mechanisms in the userspace for which other ordinary
processes should not have access to.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Taesoo kim <taesoo@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-trusted-xattr-missing-cap_sys_admin-check fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-trusted-xattr-missing-cap_sys_admin-check
+++ a/fs/ocfs2/xattr.c
@@ -7334,6 +7334,9 @@ static size_t ocfs2_xattr_trusted_list(s
 	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
+
 	if (list && total_len <= list_size) {
 		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
 		memcpy(list + prefix_len, name, name_len);
_
