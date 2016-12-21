From: Gang He <ghe@suse.com>
Date: Wed, 21 Dec 2016 16:20:57 +0800
Subject: [Ocfs2-devel] [PATCH v2 0/4] ocfs2: use kobject for online file
	check
Message-ID: <1482308461-12964-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Use embedded kobject mechanism for online file check feature,
this will avoid to use a global list to save/search per-device
online file check related data. The changed code is based on 
Goldwyn Rodrigues's patches and ext4 fs code, there is not 
any new features added, except some very small fixes during 
this code refactoring. Second, the code change does not affect
the underlying file check code.
Thank Goldwyn very much.

Compare with first version, split the code change into four
patches, make sure each patch will not bring ocfs2 kernel 
modules compiling errors.


Gang He (4):
  ocfs2: move some definitions to header file
  ocfs2: fix some small problems
  ocfs2: add kobject for online file check
  ocfs2: add duplicative ino number check

 fs/ocfs2/filecheck.c | 357 ++++++++++++++++++++-------------------------------
 fs/ocfs2/filecheck.h |  29 ++++-
 fs/ocfs2/ocfs2.h     |   8 ++
 fs/ocfs2/super.c     |  27 +++-
 4 files changed, 194 insertions(+), 227 deletions(-)

-- 
1.8.5.6
