Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795399684;
	b=nGdO4rkwCTPQ8jzSsQXjOVydKNarzCEmkedA3tabJD/ba+Gjlsyx/b38XELkOY6pdEG4
	 ShvMqre42jsZikf8IlzWJZ/bpryhjt7W9bhVtc82m0ddivwaNSyhUH3KBigEevGuhesk2
	 bETzYrt2MNvPaXYnlYMBva540m3fpTdnbQ264DXpSSRZPhgTY8IPDgwDtR+nIxw2XJ7Cl
	 +gWNOLpUTilZB91S6ytUBh715sue/N8I7qnAkL7o+Wr0V13d3T5dSCOKjmvPib5tZk9yl
	 A+8MyJm+7C35vM92JqlYxXANELAOpr/bwP2XSjIMBBQLKyIDQ83Wf2OcVwajOHA95pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795399684;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vifc/nvcf7Fn3/+2cr/DDCfl/xiPeiFARORVmMSZoFw=;
	b=IXgQCQ+VKaO7Iwznb6ajlAAuv8j9x6EaDN1ryv4eoGJVri1Eyme72UFQdfsb14lQIB85
	 BABcI/OV9o112z5CpiB5c3APPkjkNDv9SahgMdApOXit+yA2WjKvczmyKSfNb1Io1BwGM
	 XuMb34Q7kjcQ3/Hkj4NIJ1m3So0ukvPsr59jNfiVeQ/TA1JKmFVnk9JeX2bkAXKCEXfMc
	 WNEqlKZinJ/pEimyMC7YcE0tteQG2zzEe9iXI26XasIZrdzaTlpGX7vLdAyxMllKPVzWC
	 By0Kjuze0K5oqAoPOr2C4yPAunUJN59QOWJ0r3zBhfaOLoBMDCZNNNSfw3BXT7kPBIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LgV1CBIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60110606A31A;
	Mon, 23 Nov 2026 02:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LgV1CBIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A681F000C6;
	Mon, 23 Nov 2026 02:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795399684;
	bh=vifc/nvcf7Fn3/+2cr/DDCfl/xiPeiFARORVmMSZoFw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LgV1CBIOc8zMBVZfv+jK//i11sGqp7sch3pYDdb2i2Jl3PWkGdCqeEnOwL1BVVNNh
	 wBR9WHlJMii6nOkeuIU6meHX3Nb6AZ10E7qXvImrYrTSxd6ymZbvdOD3FRu+8Q3qLr
	 +mrLuXgkCrD75+0MfG0hJj2fIKIssrjgw5TRyYgI=
Date: Sun, 22 Nov 2026 18:08:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
 syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com, Cen Zhang
 <zzzccc427@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>, Theodore Ts'o
 <tytso@mit.edu>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: unregister the JBD2 shrinker before journal
 shutdown
Message-Id: <20261122180802.682f887a35850f7a6f362db5@linux-foundation.org>
In-Reply-To: <731d0ec6-d610-4e09-a01f-1d4733410853@linux.alibaba.com>
References: <920f7558ba0e4458b74cfb107e9dd77f.1@linux-foundation.org>
	<731d0ec6-d610-4e09-a01f-1d4733410853@linux.alibaba.com>
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

On Mon, 23 Nov 2026 09:56:36 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> > --- a/fs/ocfs2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
> > +++ a/fs/ocfs2/journal.c
> > @@ -1119,6 +1119,7 @@ void ocfs2_journal_shutdown(struct ocfs2
> >  	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
> >  	 * the journal is destroyed and freed.
> >  	 */
> > +	jbd2_journal_unregister_shrinker(journal->j_journal);
> 
> The comment above just explains why down_write() is taken, and the new
> jbd2_journal_unregister_shrinker() call is outside the exclusion the
> comment describes.
> So it seems we'd better move the new call above the comment, or carry a
> short note that it must stay outside journal_shutdown_sem.
> 

Thanks,  this?

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

Link: https://lore.kernel.org/6b0257ca.6ccd1e40.868ea.001a.GAE@google.com
Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261122093400.b726ecddf154f493dec1c892@linux-foundation.org
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
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
@@ -1115,6 +1115,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 			mlog_errno(status);
 	}
 
+	jbd2_journal_unregister_shrinker(journal->j_journal);
 	/*
 	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
 	 * the journal is destroyed and freed.
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

