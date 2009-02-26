From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:14:58 +0100
Subject: [Ocfs2-devel] [PATCH 0/7] OCFS2 locking fixes and lockdep
	annotations
In-Reply-To: <y>
References: <y>
Message-ID: <1235679305-3920-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  Hi,

  the first four patches in this series fix locking problems in OCFS2 quota code (three of
them can lead to potential deadlocks). The fifth patch reorders ip_alloc_sem for directories
to be acquired before localalloc locks. Mark would you please merge these?
  The last two patches implement lockdep annotations for OCFS2 cluster locks. We annotate all
the cluster locks except for special ones like open lock or local quota file lock - these are
not held by any particular process and thus lockdep cannot properly track them. I can still hit
some lockdep warnings with it (I'll report them separately) but I think the patch is already in
a decent state and I don't expect major changes. Please consider merging these lockdep patches.
  Happy testing. As always, comments are welcome.

										Honza
