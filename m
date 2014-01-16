From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Jan 2014 23:28:44 +0100
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2: Avoid pending orphaned inodes
Message-ID: <1389911329-25523-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  this is how I would imagine we can solve a deadlock with quotas after we do
not defer dropping inode reference from downconvert worker. The patches are
just compile tested so be careful. Goldwyn, do you have any ocfs2 test cluster
where I can test these patches?

								Honza
