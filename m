From: Gang He <ghe@suse.com>
Date: Fri, 21 Aug 2015 15:43:16 +0800
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: add file extent block online check
Message-ID: <1440143000-24956-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Besides inode block online check, add file extent block online
check this time, we will add more kinds of meta block online
check/repair in the future.

Gang He (4):
  ocfs2: update filecheck copyright
  ocfs2: add errno and macro definitions
  ocfs2: filecheck validate_extent_block function
  ocfs2: add file extent block check

 fs/ocfs2/alloc.c       | 116 +++++++++++++++++++++++
 fs/ocfs2/alloc.h       |   4 +
 fs/ocfs2/filecheck.c   | 253 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/filecheck.h   |   3 +-
 fs/ocfs2/journal.h     |   3 +
 fs/ocfs2/ocfs2_trace.h |  24 +++++
 6 files changed, 393 insertions(+), 10 deletions(-)

-- 
2.1.2
