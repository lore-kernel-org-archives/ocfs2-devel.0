From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Thu, 26 Jun 2008 20:05:47 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 0/2] configfs: Fix cleanup after
	mkdir() failure
Message-ID: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

 [ applies on top of http://lkml.org/lkml/2008/6/23/145 aka symlink() fixes ]

Hi,

This patchset fixes two kinds of bugs happening when
configfs_attach_group()/configfs_attach_item() fail and userspace races with
mkdir() or symlink().

Please read the first patch header for a detailed scenario explaining the bugs.

Louis

Summary (2):
  configfs: Prevent userspace from creating new entries under attaching
    directories
  configfs: Lock new directory inodes before removing on cleanup after
    failure

 fs/configfs/configfs_internal.h |    1 +
 fs/configfs/dir.c               |  127 +++++++++++++++++++++++++++++++--------
 fs/configfs/symlink.c           |   17 +++++-
 3 files changed, 118 insertions(+), 27 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
