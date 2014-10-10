From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Oct 2014 16:23:44 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] ext3: Don't check quota format when there
	are no quota files
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Message-ID: <1412951028-4085-40-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>, reiserfs-devel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

CC: stable at vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

I'm going to queue this patch unless someone objects.

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 622e88249024..2c42e739e3d1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1354,13 +1354,6 @@ set_qf_format:
 					"not specified.");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext3_msg(sb, KERN_ERR, "error: journaled quota format "
-					"specified with no journaling "
-					"enabled.");
-			return 0;
-		}
 	}
 #endif
 	return 1;
-- 
1.8.1.4
