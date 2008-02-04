From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb  4 11:08:25 2008
Subject: [Ocfs2-devel] [PATCH 1/2] sysfs: Allow removal of symlinks in the
	sysfs root
In-Reply-To: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
References: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1202152062-28370-2-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>

Allow callers of sysfs_remove_link() to pass a NULL kobj, in which case
sysfs_root will be used as the parent directory. This allows us to tear down
top level symlinks created via sysfs_create_link(), which already has
similar handling of a NULL parent object.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/sysfs/symlink.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 5f66c44..817f596 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -87,7 +87,14 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 void sysfs_remove_link(struct kobject * kobj, const char * name)
 {
-	sysfs_hash_and_remove(kobj->sd, name);
+	struct sysfs_dirent *parent_sd = NULL;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	sysfs_hash_and_remove(parent_sd, name);
 }
 
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
-- 
1.5.3.6
