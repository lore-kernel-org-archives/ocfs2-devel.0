From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Oct 2014 16:23:48 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] printk: Debug patch 2
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Message-ID: <1412951028-4085-44-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a39f4129f848..00a9ad5c2708 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1718,17 +1718,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-	local_irq_restore(flags);
-
-	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
-		return printed_len;
-
 	/*
 	 * Disable preemption to avoid being preempted while holding
 	 * console_sem which would prevent anyone from printing to console
 	 */
 	preempt_disable();
+	local_irq_restore(flags);
+
+	/* If called from the scheduler, we can not call up(). */
+	if (in_sched) {
+		preempt_enable();
+		return printed_len;
+	}
+
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-- 
1.8.1.4
