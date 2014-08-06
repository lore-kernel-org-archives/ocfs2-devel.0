From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 6 Aug 2014 15:04:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: race between umount and
 unfinished remastering during recovery
In-Reply-To: <53E2A56C.3090207@oracle.com>
References: <1405630840-7071-1-git-send-email-tariq.x.saeed@oracle.com>
	<53E2A56C.3090207@oracle.com>
Message-ID: <20140806150441.ff5112f1a8e1a172519e432e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 06 Aug 2014 15:00:12 -0700 Tariq Saeed <tariq.x.saeed@oracle.com> wrote:

> Hi Andrew,
> This patch was submitted  on Jul 17. Is it in the review queue or has it 
> been reviewed and a decision made?

ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch
is in my to-send-to-Linus-today pile.

That pile is pretty small :(

ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch

Most of the OCFS2 patches in -mm need more review/ack/test/etc,
methinks.
