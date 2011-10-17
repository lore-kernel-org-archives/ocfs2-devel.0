From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Mon, 17 Oct 2011 16:47:17 -0700 (PDT)
Subject: [Ocfs2-devel] [PATCH] ocfs2: send correct UUID to cleancache
	initialization
Message-ID: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, Steven Whitehouse <swhiteho@redhat.com>, Sunil Mushran <sunil.mushran@oracle.com>

ocfs2: Fix cleancache initialization call to correctly pass uuid

As reported by Steven Whitehouse in https://lkml.org/lkml/2011/5/27/221 
the ocfs2 volume UUID is incorrectly passed to cleancache.
As a result, shared-ephemeral tmem pools will not actually
be created; instead they will be private (unshared) which
misses out on a major benefit of tmem.

Reported-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2374,7 +2374,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto bail;
 	}
-	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
+	cleancache_init_shared_fs((char *)&di->id2.i_super.s_uuid, sb);
 
 bail:
 	return status;
