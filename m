From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 27 Jun 2008 13:10:25 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH] configfs: Fix open directory making
	rmdir() fail
Message-ID: <1214565025-2646-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

When checking for user-created elements under an item to be removed by rmdir(),
configfs_detach_prep() counts fake configfs_dirents created by dir_open() as
user-created and fails when finding one. It is however perfectly valid to remove
a directory that is open.

Simply make configfs_detach_prep() skip fake configfs_dirent, like it already
does for attributes, and like detach_groups() does.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 2c873fd..e721fd5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -379,7 +379,8 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 
 	ret = 0;
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & CONFIGFS_NOT_PINNED)
+		if (!sd->s_element ||
+		    (sd->s_type & CONFIGFS_NOT_PINNED))
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
 			/* Abort if racing with mkdir() */
-- 
1.5.5.3
