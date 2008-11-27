From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:13 -0800
Subject: [Ocfs2-devel] [PATCH 0/13] More xattr bucket consolidation
Message-ID: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are still places in xattr.c that refer to individual buffer_heads
rather than the ocfs2_xattr_bucket structure.  This series tries to
close all of those.  It also reduces some of the buffer_head games we
play.

While doing this work, I think I've learned some more about the xattr
code.  So I've tried to add some breadcrumbs behind me.

Tao, can we review this quickly?  I'd like to get it into merge_window
ASAP, so Tristan can test it and make sure I didn't break anything.

The patches are on top of merge_window as of today, and are available in
my repo at

git://oss.oracle.com/git/jlbec/linux-2.6.git xattr-buckets-2

Joel
