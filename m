From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 17 Mar 2010 13:17:26 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] Ocfs2 allocation reservations
In-Reply-To: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
Message-ID: <20100317201726.GD11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 16, 2010 at 11:59:09PM -0700, Mark Fasheh wrote:
> Changes from the last patch set:
> - added a check for overlapping reservations in ocfs2_resv_insert()
> - cleaned up the comments in ocfs2_cannibalize_resv()
> - the check for reservation past bitmap end in ocfs2_check_resmap() is more
>   strict now.
> - removed the unused m_search_start member of ocfs2_reservation_map
> - optimized __ocfs2_resv_find_window() to ignore regions that are too small
>   for the current alloc
> - major cleanup of ocfs2_resmap_claimed_bits()
> - added a set of BUG_ON's to in ocfs2_resmap_claimed_bits() to check that
>   the passed allocation range is within the window.
> - fixed ocfs2_local_alloc_find_clear_bits() to return actual bits allocated
> - add a check for a null data_ac in ocfs2_write_begin_nolock()
> 
> I also added a fifth patch, "ocfs2: remove ocfs2_local_alloc_in_range()".
> I could spin this as it's own patch to go upstream earlier if we want.

Attached is a very small follow-up patch to turn off some of the expensive
debug checks I placed in the code.
	--Mark

From: Mark Fasheh <mfasheh@suse.com>

[PATCH] ocfs2: turn off expensive reservations debugging by default

They can still be turned back on by enabling the "expensive checks" config
option for Ocfs2.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/reservations.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index ecffb1c..97f8b25 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -41,9 +41,6 @@
 #define OCFS2_CHECK_RESERVATIONS
 #endif
 
-#define OCFS2_CHECK_RESERVATIONS
-
-
 DEFINE_SPINLOCK(resv_lock);
 
 #define	OCFS2_MIN_RESV_WINDOW_BITS	8
-- 
1.6.4.2
