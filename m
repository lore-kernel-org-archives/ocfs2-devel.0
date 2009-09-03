From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  2 Sep 2009 18:06:52 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] [RFC] Adding the MAY_CREATE flag to
	->permission()
Message-ID: <1251940014-20963-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@kernel.org, viro@zeniv.linux.org.uk
Cc: hch@infradead.org

Hey,
	Ran into a fun problem in ocfs2.  ocfs2, being a cluster
filesystem, has cluster locks.  Being nice to our users, we allow
signals to interrupt the cluster locking layer if it hasn't gotten too
far yet (sleeping on local locking rather than the cluster).
	Now, system calls are only allowed to return -ERESTARTSYS if
they can be safely restarted.  In ocfs2_mknod(), which underlies
mkdir(2), mknod(2), and creat(2), we allow signals to interrupt us while
we gather our locks, but once we start changing things, there's no going
back.  Everyone else does the same thing.
	The problem is open(O_CREAT|O_EXCL).  See, ocfs2_mknod() will
successfully create the file.  Then we get back to
__open_namei_create(), which promptly calls may_open().  This is
backended by ocfs2_permission(), and it needs the cluster lock to
check the new inode's permissions.  Send a signal here, and the ocfs2
code will return -ERESTARTSYS.  (This is easily verified via
'git-checkout').  When entry.S restarts the open(O_CREAT|O_EXCL), it
gets -EEXIST.  Ouch!
	We can't naively block signals in ocfs2_permission().  The
majority of calls are not for O_CREAT|O_EXCL.  So how do we let
ocfs2_permission() know about this case?
	Christoph's suggestion was a new flag to ->permission().  I've
picked MAY_CREATE, but I'm totally open to a better name.  I'm open to a
better solution too.
	Folling this are the MAY_CREATE patch and the ocfs2 patch to
make use of it.

Joel
