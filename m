From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 30 May 2008 17:36:41 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: move hb_ctl into stack glue
Message-ID: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have determined that ocfs2 can only leave a cluster group safely in
put_super(7).  The presence of bind mounts, rbind mounts, and shared
subtrees make tracking mountpoints impossible in userspace.

To solve this, we move the ocfs2_hb_ctl call out of o2cb and into the
generic stack glue code.  ocfs2_hb_ctl will always be called for all
cluster stacks.  This should be compatible with old and new tools - o2cb
behavior doesn't change.

The code is also available on the 'hbctl-path' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=hbctl-path
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git hbctl-path
