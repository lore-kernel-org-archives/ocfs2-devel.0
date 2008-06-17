From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Tue, 17 Jun 2008 19:37:20 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 0/3] configfs: symlink() fixes
Message-ID: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

[ applies on top of the previously submitted rename() vs rmdir() deadlock fix ]

Hi,

The following patchset fixes incorrect symlinks to dead items in configfs, which
are forbidden by specification.

The first patch actually prevents such dangling symlinks from being created, but
introduces a weird(?) behavior where a failing symlink() can make a racing
rmdir() fail in the symlink's parent and in the symlink's target as well. The
next patches prevent this behavior using a similar idea as for the mkdir() vs
rmdir() case previously submitted.

Summary:
  configfs: Fix symlink() to a removing item
  configfs: Rename CONFIGFS_USET_IN_MKDIR to CONFIGFS_USET_ATTACHING
  configfs: Fix failing symlink() making rmdir() fail

 fs/configfs/configfs_internal.h |    2 +-
 fs/configfs/dir.c               |   20 ++++++++++----------
 fs/configfs/symlink.c           |   33 +++++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 15 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
