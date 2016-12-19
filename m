From: Gang He <ghe@suse.com>
Date: Mon, 19 Dec 2016 17:21:25 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: use kobject for online file check
Message-ID: <1482139287-19040-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Use embedded kobject mechanism for online file check feature,
this will avoid to use a global list to save/search per-device online file
check related data. The changed code is based on Goldwyn Rodrigues's patches
and ext4 fs code, there is not any new features added, except some very small
fixes during this code refactoring. Second, the code change does not affect
the underlying file check code. 
Thank Goldwyn very much.



Gang He (2):
  ocfs2: add kobject for online file check
  ocfs2: embed kobject in ocfs2_super structure

 fs/ocfs2/filecheck.c | 360 ++++++++++++++++++++-------------------------------
 fs/ocfs2/filecheck.h |  29 ++++-
 fs/ocfs2/ocfs2.h     |   8 ++
 fs/ocfs2/super.c     |  27 +++-
 4 files changed, 196 insertions(+), 228 deletions(-)

-- 
1.8.5.6
