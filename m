From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Feb 2014 12:05:52 +0100
Subject: [Ocfs2-devel] [PATCH 0/6 v4] ocfs2: Avoid pending orphaned inodes
Message-ID: <1393412758-9764-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  here is the fourth version of my patchset to solve deadlocks when we do not
defer dropping of inode reference from downconvert worker. I have tested the
patches (also with lockdep enabled) and they seem to work fine. I'm resending
mostly so that Andrew can pick up the latest version of the patches.

Changes since v3:
- Added more Reviewed-by tags

Changes since v2:
- Added Reviewed-by tags
- Modified special handling of downconvert thread in
  ocfs2_mark_lockres_freeing() to use generic unblocking function instead of
  opencoding it.


								Honza
