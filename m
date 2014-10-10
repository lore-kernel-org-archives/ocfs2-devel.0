From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Oct 2014 16:23:29 +0200
Subject: [Ocfs2-devel] [PATCH 1/2] printk: Debug patch1
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Message-ID: <1412951028-4085-25-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6962ed..a39f4129f848 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1718,7 +1718,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-	lockdep_on();
 	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
@@ -1738,6 +1737,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (console_trylock_for_printk())
 		console_unlock();
 	preempt_enable();
+	local_irq_save(flags);
+	lockdep_on();
+	local_irq_restore(flags);
 
 	return printed_len;
 }
-- 
1.8.1.4
