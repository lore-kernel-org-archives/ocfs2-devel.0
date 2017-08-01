From: Jan Kara <jack@suse.cz>
Date: Tue,  1 Aug 2017 16:12:50 +0200
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: Fix clearing of SGID when
	inheriting ACLs
Message-ID: <20170801141252.19675-1-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi Andrew,

can you please merge these two patches? The first is a small cleanup,
the second fixes actual bug when SGID on directory is wrongly cleared
when inheriting ACLs from parent directory (see changelog of the second
patch for details). Thanks!

							Honza
