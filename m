From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sun, 26 Jun 2011 05:56:42 -0000
Subject: [Ocfs2-devel] [PATCH resend 0/6] use little-endian bitops properly
Message-ID: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, reiserfs-devel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

All patches in this patch set were sent before. Individual patches
improve little-endian bitops usage in several places.

Akinobu Mita (6):
  ext4: use proper little-endian bitops
  dm: use use proper little-endian bitops
  md: use proper little-endian bitops
  reiserfs: use proper little-endian bitops
  reiserfs: use hweight_long()
  ocfs2: avoid unaligned access to dqc_bitmap

 drivers/md/bitmap.c         |    4 +-
 drivers/md/dm-log.c         |    9 +++----
 fs/ext4/ext4.h              |    7 +++--
 fs/ext4/ialloc.c            |    4 +-
 fs/ocfs2/ocfs2.h            |   47 +++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c      |   10 ++++----
 fs/reiserfs/bitmap.c        |    8 +-----
 fs/reiserfs/resize.c        |    6 ++--
 include/linux/reiserfs_fs.h |    2 +
 9 files changed, 71 insertions(+), 26 deletions(-)

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4 at vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel at redhat.com
Cc: NeilBrown <neilb@suse.de>
Cc: linux-raid at vger.kernel.org
Cc: reiserfs-devel at vger.kernel.org
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel at oss.oracle.com

-- 
1.7.4.4
