From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Dec 12 10:16:43 2006
Subject: [Ocfs2-devel] [git patches] ocfs2 updates
Message-ID: <20061212181637.GF6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@osdl.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Linus,

A few more patches to push upstream before 2.6.20-rc1. This set includes:

* Some patches to make ocfs2 network timeout values user-adjustable. The
  values are set / read via the configfs interface and are validated against
  other nodes when they initiate a connection.

* A "local mount" patch which gives ocfs2 the ability to act as a local file
  system (no cluster configuration needed, no dlm locking, etc).

* Various cleanups - a documentation update, and a sync of ocfs2_fs.h
  between kernel and user tools.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |    3 
 fs/ocfs2/cluster/nodemanager.c      |  192 +++++++++++++++++++++++++++++++++---
 fs/ocfs2/cluster/nodemanager.h      |   17 +++
 fs/ocfs2/cluster/tcp.c              |  152 ++++++++++++++++++++++++----
 fs/ocfs2/cluster/tcp.h              |    8 +
 fs/ocfs2/cluster/tcp_internal.h     |   15 +-
 fs/ocfs2/dlmglue.c                  |   79 +++++++++++---
 fs/ocfs2/heartbeat.c                |    9 +
 fs/ocfs2/inode.c                    |    3 
 fs/ocfs2/journal.c                  |   46 ++++++--
 fs/ocfs2/journal.h                  |    5 
 fs/ocfs2/mmap.c                     |    6 -
 fs/ocfs2/namei.c                    |    8 -
 fs/ocfs2/ocfs2.h                    |    5 
 fs/ocfs2/ocfs2_fs.h                 |   14 ++
 fs/ocfs2/super.c                    |   90 ++++++++++++----
 fs/ocfs2/vote.c                     |    3 
 17 files changed, 549 insertions(+), 106 deletions(-)

Andrew Beekhof:
      [patch 1/3] OCFS2 - Expose struct o2nm_cluster
      [patch 3/3] OCFS2 Configurable timeouts - Protocol changes

Jeff Mahoney:
      [patch 2/3] OCFS2 Configurable timeouts

Mark Fasheh:
      ocfs2: Synchronize feature incompat flags in ocfs2_fs.h

Sunil Mushran:
      ocfs2: local mounts

Tiger Yang:
      ocfs2: update mount option documentation


Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
