From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Feb 2014 16:18:25 +0100
Subject: [Ocfs2-devel] [PATCH 0/6 v2] ocfs2: Avoid pending orphaned inodes
Message-ID: <1392909511-2933-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello,

  here is a second version of my patchset to solve a deadlocks when we do not
defer dropping of inode reference from downconvert worker. I have tested the
patches (also with lockdep enabled) and they seem to work fine. Comments are
welcome!

								Honza
