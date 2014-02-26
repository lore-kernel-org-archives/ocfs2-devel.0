From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Feb 2014 17:49:27 +0100
Subject: [Ocfs2-devel] [PATCH 0/6 v5] ocfs2: Avoid pending orphaned inodes
Message-ID: <1393433373-28767-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  sorry for a quick resend but I have found out the v4 I've sent earlier today
doesn't even compile. Not sure what I was testing when preparing v3 submission
but now I made sure I've really built what I'm sending :). So Andrew please
pickup this version instead. Thanks!

Changes since v4:
- added missing prototype & remove unused label from patch 5/6

Changes since v3:
- Added more Reviewed-by tags

Changes since v2:
- Added Reviewed-by tags
- Modified special handling of downconvert thread in
  ocfs2_mark_lockres_freeing() to use generic unblocking function instead of
  opencoding it.


								Honza
