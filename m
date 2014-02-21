From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Feb 2014 10:44:58 +0100
Subject: [Ocfs2-devel] [PATCH 0/6 v3] ocfs2: Avoid pending orphaned inodes
Message-ID: <1392975904-16944-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  here is the third version of my patchset to solve deadlocks when we do not
defer dropping of inode reference from downconvert worker. I have tested the
patches (also with lockdep enabled) and they seem to work fine. Comments are
welcome!

Changes since v2:
- Added Reviewed-by tags
- Modified special handling of downconvert thread in
  ocfs2_mark_lockres_freeing() to use generic unblocking function instead of
  opencoding it.


								Honza
