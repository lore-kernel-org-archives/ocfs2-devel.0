From: Gang He <ghe@suse.com>
Date: Fri, 17 Jul 2020 10:37:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix remounting needed after setfacl
	command
Message-ID: <20200717023751.9922-1-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

When use setfacl command to change a file's acl, the user cannot
get the latest acl information from the file via getfacl command,
until remounting the file system.
e.g.
setfacl -m u:ivan:rw /ocfs2/ivan
getfacl /ocfs2/ivan
getfacl: Removing leading '/' from absolute path names
file: ocfs2/ivan
owner: root
group: root
user::rw-
group::r--
mask::r--
other::r--

The latest acl record("u:ivan:rw") cannot be returned via getfacl
command until remounting.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/acl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index bb981ec76456..7b07f5df3a29 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -256,6 +256,8 @@ static int ocfs2_set_acl(handle_t *handle,
 		ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
 
 	kfree(value);
+	if (!ret)
+		set_cached_acl(inode, type, acl);
 
 	return ret;
 }
-- 
2.12.3
