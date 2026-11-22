Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795368842;
	b=0TXsPf1Sf77V1xzx3XvSOT+aZVKFvfguHe8foxcun2YfWGvQ7zqP36Gzi9xQwvZF7b5J
	 cIlp0lt8P7SX2h5HpswsPOY2ZzBxGJcQmzRKY5AWfIsZpUThlFey21Q1slEz1+ZBkrV3b
	 hY2fr5Ekf4vwzKilmjtY0KFfaenQXvGLEykJqdwRhqv7xncBlUqIirn/wDy+lND2HeHO/
	 u1SRCBE5W8vZPAKF2i+KXKyvIwNoSE2RKHwieBJIOr+q6OynIFzGpqpE3OimAm8LT+w/F
	 k2a0J0p9i3e3MNRHNo0bsotCLy6SVmUs/LDcgt07Ug5+uGw/dtqwX04ZjDwQL5IKLhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795368842;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XWnVSfSExq5MyZwecuVJFn6QnpHkUPdEUEl9atXATPE=;
	b=MkLDzIvZkcL+iKs/2IQVS15JaSGBzXsj8TKiJnMpvHzLX6U1+JiahUKunQnXnQgUUGM6
	 c3QLm4KawEQCZHWflUsT7zc7eOxPDCZQRAus9t9Db0qSsEVvLvY3eHtakEYpYgzf91AfB
	 XYUna/7Cx/Fs5mE4D5Dd0w/zXxZFAArFN5pg8fg4i42+CRY303to1ZO+CLrkCM/o4npcj
	 BlKQ1hvogryF4qDyK53FUJeIH2dH/yVWucJMdPF/GPOv/jSJPZc1H3BKSoWASN8QEiWQH
	 jVk9WvANyvraf/YATHV4DfiKO+vZRq49yliYDb/lq0uFMSWQ7YOHvWolJVhjo0hAeKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lDRvUtNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A0606A320;
	Sun, 22 Nov 2026 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lDRvUtNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6746D1F000C6;
	Sun, 22 Nov 2026 17:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795368841;
	bh=XWnVSfSExq5MyZwecuVJFn6QnpHkUPdEUEl9atXATPE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lDRvUtNmFyLxBJaqt31nIeuOZphWp5s9y/xLwIyUsJzMobBm86z+onHMNWXcerfBd
	 vuIYiGP5sE6v4kCI9pJ48EBxnD8yOs72taYaTv+Bu18jP3RCT7AjnWzJh7NnEHQqfg
	 2FV6QItq0raHeExsRANnGX9Tb73Y1HLfdk5CVrRY=
Date: Sun, 22 Nov 2026 09:34:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
Cc: heming.zhao@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com, zzzccc427@gmail.com
Subject: Re: [syzbot] [ocfs2?] possible deadlock in shrinker_free
Message-Id: <20261122093400.b726ecddf154f493dec1c892@linux-foundation.org>
In-Reply-To: <6b0257ca.6ccd1e40.868ea.001a.GAE@google.com>
References: <6b007186.91c4c7f9.2424d6.0003.GAE@google.com>
	<6b0257ca.6ccd1e40.868ea.001a.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Nov 2026 18:47:38 -0800 syzbot <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f802b6558eb8 Merge tag 'xfs-fixes-7.4-rc4' of git://git.ke..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> console output: https://syzkaller.appspot.com/x/log.txt?x=141d98e9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3cc6a7ee2d24d208
> dashboard link: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10918a03580000
> 
> The issue was bisected by AI to:
> 
> commit f277230d002d03ed98b814b735f9d3d01b42020a
> Author: Cen Zhang <zzzccc427@gmail.com>
> Date:   Fri Oct 30 04:48:56 2026 +0000
> 
>     ocfs2: serialize inode journal access with shutdown

#syz test

From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2: unregister the JBD2 shrinker before journal shutdown
Date: Sat, 21 Nov 2026 19:34:56 -0800

sysbot reports a lockdep cycle through shrinker_mutex, filesystem reclaim
and osb->journal_shutdown_sem.  Unmount holds the superblock's s_umount
exclusively, while the OCFS2 reclaim path must first get its read side
with super_trylock_shared().  That excludes the two paths for the same
superblock; the report does not establish a runtime deadlock.  Still, the
lock ordering is visible to lockdep and produces the warning.

The write side of journal_shutdown_sem must cover all of
jbd2_journal_destroy(): ocfs2_clear_inode() can otherwise release a JBD2
inode through a journal that is being destroyed.  Move only the JBD2
shrinker unregister operation before taking the semaphore. 
shrinker_free() waits for active shrinker users, so the journal and its
checkpoint counter remain alive while they finish.  A successfully
initialized JBD2 journal always has a checkpoint counter.  Destroy it
after unregistering the shrinker, whether unregistering happened here or
before taking the OCFS2 semaphore.  The semaphore continues to protect
JBD2 destruction, removal of osb->journal and freeing the OCFS2 journal.

The userspace-visible result is removal of this lockdep warning during
OCFS2 unmount; the report does not demonstrate a hung unmount.

Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
Link: https://lore.kernel.org/6b0257ca.6ccd1e40.868ea.001a.GAE@google.com
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
---
Tested with CONFIG_PROVE_LOCKING=y in x86-64 QEMU guests. A omitted
this patch; B added it alone. OCFS2 and JBD2 were built in.

Syzbot's C reproducer mounted a local OCFS2 image, accessed 200 files,
exercised reclaim and unmounted it. A reproduced the reported circular
locking warning: shrinker_free() ran from jbd2_journal_destroy() while
ocfs2_journal_shutdown() held journal_shutdown_sem. The unmount
completed; this test did not show a runtime deadlock.

B completed the same sequence without a warning. Three further
mount/reclaim/unmount cycles on B also completed without warnings.
An ext4 read/write/unmount control passed on both kernels.

Both builds needed the same temporary correction for an unrelated
mm/util.c compile error in another queued patch. The correction was
removed after testing. The test did not force an active JBD2 shrinker
callback to overlap unmount or exercise failed-mount cleanup.

 fs/jbd2/journal.c    |   17 +++++++++++++----
 fs/ocfs2/journal.c   |    1 +
 include/linux/jbd2.h |    1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

--- a/fs/jbd2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/fs/jbd2/journal.c
@@ -75,6 +75,7 @@ EXPORT_SYMBOL(jbd2_journal_check_availab
 EXPORT_SYMBOL(jbd2_journal_set_features);
 EXPORT_SYMBOL(jbd2_journal_load);
 EXPORT_SYMBOL(jbd2_journal_destroy);
+EXPORT_SYMBOL(jbd2_journal_unregister_shrinker);
 EXPORT_SYMBOL(jbd2_journal_abort);
 EXPORT_SYMBOL(jbd2_journal_errno);
 EXPORT_SYMBOL(jbd2_journal_ack_err);
@@ -2100,6 +2101,16 @@ int jbd2_journal_load(journal_t *journal
 	return 0;
 }
 
+void jbd2_journal_unregister_shrinker(journal_t *journal)
+{
+	struct shrinker *shrinker = journal->j_shrinker;
+
+	if (!shrinker)
+		return;
+	journal->j_shrinker = NULL;
+	shrinker_free(shrinker);
+}
+
 /**
  * jbd2_journal_destroy() - Release a journal_t structure.
  * @journal: Journal to act on.
@@ -2173,10 +2184,8 @@ int jbd2_journal_destroy(journal_t *jour
 		brelse(journal->j_sb_buffer);
 	}
 
-	if (journal->j_shrinker) {
-		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
-		shrinker_free(journal->j_shrinker);
-	}
+	jbd2_journal_unregister_shrinker(journal);
+	percpu_counter_destroy(&journal->j_checkpoint_jh_count);
 	if (journal->j_proc_entry)
 		jbd2_stats_proc_exit(journal);
 	iput(journal->j_inode);
--- a/fs/ocfs2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/fs/ocfs2/journal.c
@@ -1119,6 +1119,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
 	 * the journal is destroyed and freed.
 	 */
+	jbd2_journal_unregister_shrinker(journal->j_journal);
 	down_write(&osb->journal_shutdown_sem);
 
 	/* Shutdown the kernel journal system */
--- a/include/linux/jbd2.h~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/include/linux/jbd2.h
@@ -1566,6 +1566,7 @@ extern void	   jbd2_journal_clear_featur
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern int	   jbd2_journal_load       (journal_t *journal);
 extern int	   jbd2_journal_destroy    (journal_t *);
+extern void	   jbd2_journal_unregister_shrinker(journal_t *);
 extern int	   jbd2_journal_recover    (journal_t *journal);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
_

