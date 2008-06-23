From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Mon, 23 Jun 2008 14:16:16 +0200
Subject: [Ocfs2-devel] [PATCH 0/2]v2 configfs: symlink() fixes
Message-ID: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
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
rmdir() fail in the symlink's parent and in the symlink's target as well. This
behavior is fixed with the next patch.

Changelog:
  - fix error code when symlink's target is being removed
  - re-implemented the weird(?) behavior fix in a way that does not temporarily
    instantiate the new symlink in the VFS.

Summary:
  configfs: Fix symlink() to a removing item
  configfs: Fix failing symlink() making rmdir() fail

 fs/configfs/configfs_internal.h |    1 +
 fs/configfs/dir.c               |   24 +++++++++++++++++-------
 fs/configfs/symlink.c           |   14 +++++++++++++-
 3 files changed, 31 insertions(+), 8 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
