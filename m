Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795368845;
	b=ytCDsCAaYT3QLhj8xuX32G97dpavxvagqozje5d9qGVjo9gKLpbI0duInVB7f8akh5/H
	 6DDMl0me33U7NFt0Y9POu6fWOwNjmvEwunRwHxftNgYiZXJ0zplszTgQ+Lec2svjKUxfC
	 y7Bb0BOMXuFNCihxqfSH4s8q5ajeDvwW3MNd6TOKoU9e8tj9BqTFgWpxL3/otePBfEHB/
	 cc44Ji46SAc7tvYveznM5yvd/IJfY81LLG7gXmVtaoM4G8E8POI3+Zphhc9tNI1B/cuqf
	 vl24P4IfSmQY9XPD7nAXi7uVyNfTZpHNHpGk3+v95H5eTXJq+5v8SQNn8SXo8Iqfmbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795368845;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=XRMu6c/q4DDc2TZ7MmRIaOeTNkt4vLYxjxQz26tk6vo=;
	b=eOcBSBozrHyPWovJEmFRg7UP2LLDe+IH5e1PHNO/4weRW3rf4pAvCSEeg+sviPDOgljy
	 Bl1IbEUWfGV1wuZmlbAcgmMcB1F7bZyMPCTE5W07Hf6BfCgVkG3Z7rQadE5JonxsHOrcg
	 Y23PgnpY0gnixBqIQapZF59b7aq6kv+4ods3dDE0NFKkAYHmuqFH28zy/fbHUPcyaAnzz
	 svLlUmZ5Rw9LypUkpM+PO+1wQThLZGn/yPSbCBW6+hVGLctlg1NWRpGdfytHKv8/7LdGd
	 hxwi0fGI2o7NTKohT/8ElHn+DLjEUX7K+/VvfzzgYkcQAKPOHi/Pr9b7QHP4yUuW3Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88F5606A334
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 17:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D88F5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4dab94dc3e7so6317345b6e.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 09:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795368844; x=1795973644;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XRMu6c/q4DDc2TZ7MmRIaOeTNkt4vLYxjxQz26tk6vo=;
        b=bdvLhzXwk0qv6v9TVltncJznUo+54VSn/CVeFjzCPMDQzJLuHRSTzTkDiHV0pRX0AW
         lfZ7PGk/k8/GQIB+tM+zP5EcdzuJtdhYifP0NxTh6IFIenHGCAZa0xys4pPZad+fjmL5
         OoOWHiURTX+E7waUG09301y8r4oKzSkYYx2kpUGI2h6h18hLbeb2E93pcayzgUefL9XU
         8ZBh+XTMuOq0knpvFhg3E29Dm9J/eL1rhHqlZHwt1lJA6qKlAu79zXYfQhVbsEP4XFbf
         l1oTimgCaGy2wTqmPjCUbHDpz+hORzW3AdJfSl32R5JCu0CsCjChO6WfM2Bgh9mI/L2K
         Hr5w==
X-Forwarded-Encrypted: i=1; AL+hErE81vaB1WBu96uHmEtoM6rqnFg0hxv6faUEwXF0JOwwwB62173hG7YKEH7yfEZZQmqMXhAeEQjPWGjXQg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+GsQqdWAJPv84uLGNVbl2Pbql9QIhx3blqVgUs4VUGVkzsPcke
	RVoCbvOZT1RUcb/hVu4CvtBzYoDEAPcdZ3lVkSU8KAVsdYgvpEiCVRoqt3mtlabv5NWFPwR+DPr
	4j3jmNfMWLvnsKIibP1Tbzq2gGv9tgkelfR389hDTgm6krHtEosIW/Fa8WzM=
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:508f:b0:4c4:c7cc:f8ee with SMTP id
 5614622812f47-57a0a20af5fmr11375830b6e.13.1795368843894; Sun, 22 Nov 2026
 09:34:03 -0800 (PST)
Date: Sun, 22 Nov 2026 09:34:03 -0800
In-Reply-To: <20261122093400.b726ecddf154f493dec1c892@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b03278b.a895ff1b.3d141e.00be.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in shrinker_free
From: syzbot <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org
Cc: akpm@linux-foundation.org, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"

> On Sat, 21 Nov 2026 18:47:38 -0800 syzbot <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com> wrote:
>
>> syzbot has found a reproducer for the following issue on:
>> 
>> HEAD commit:    f802b6558eb8 Merge tag 'xfs-fixes-7.4-rc4' of git://git.ke..
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> console output: https://syzkaller.appspot.com/x/log.txt?x=141d98e9580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3cc6a7ee2d24d208
>> dashboard link: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
>> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10918a03580000
>> 
>> The issue was bisected by AI to:
>> 
>> commit f277230d002d03ed98b814b735f9d3d01b42020a
>> Author: Cen Zhang <zzzccc427@gmail.com>
>> Date:   Fri Oct 30 04:48:56 2026 +0000
>> 
>>     ocfs2: serialize inode journal access with shutdown
>
> #syz test

Patch testing via #syz test is temporarily disabled.
See https://github.com/google/syzkaller/issues/8122 for details.

>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: ocfs2: unregister the JBD2 shrinker before journal shutdown
> Date: Sat, 21 Nov 2026 19:34:56 -0800
>
> sysbot reports a lockdep cycle through shrinker_mutex, filesystem reclaim
> and osb->journal_shutdown_sem.  Unmount holds the superblock's s_umount
> exclusively, while the OCFS2 reclaim path must first get its read side
> with super_trylock_shared().  That excludes the two paths for the same
> superblock; the report does not establish a runtime deadlock.  Still, the
> lock ordering is visible to lockdep and produces the warning.
>
> The write side of journal_shutdown_sem must cover all of
> jbd2_journal_destroy(): ocfs2_clear_inode() can otherwise release a JBD2
> inode through a journal that is being destroyed.  Move only the JBD2
> shrinker unregister operation before taking the semaphore. 
> shrinker_free() waits for active shrinker users, so the journal and its
> checkpoint counter remain alive while they finish.  A successfully
> initialized JBD2 journal always has a checkpoint counter.  Destroy it
> after unregistering the shrinker, whether unregistering happened here or
> before taking the OCFS2 semaphore.  The semaphore continues to protect
> JBD2 destruction, removal of osb->journal and freeing the OCFS2 journal.
>
> The userspace-visible result is removal of this lockdep warning during
> OCFS2 unmount; the report does not demonstrate a hung unmount.
>
> Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
> Link: https://lore.kernel.org/6b0257ca.6ccd1e40.868ea.001a.GAE@google.com
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Cen Zhang <zzzccc427@gmail.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Heming Zhao <heming.zhao@suse.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>
> ---
> Tested with CONFIG_PROVE_LOCKING=y in x86-64 QEMU guests. A omitted
> this patch; B added it alone. OCFS2 and JBD2 were built in.
>
> Syzbot's C reproducer mounted a local OCFS2 image, accessed 200 files,
> exercised reclaim and unmounted it. A reproduced the reported circular
> locking warning: shrinker_free() ran from jbd2_journal_destroy() while
> ocfs2_journal_shutdown() held journal_shutdown_sem. The unmount
> completed; this test did not show a runtime deadlock.
>
> B completed the same sequence without a warning. Three further
> mount/reclaim/unmount cycles on B also completed without warnings.
> An ext4 read/write/unmount control passed on both kernels.
>
> Both builds needed the same temporary correction for an unrelated
> mm/util.c compile error in another queued patch. The correction was
> removed after testing. The test did not force an active JBD2 shrinker
> callback to overlap unmount or exercise failed-mount cleanup.
>
>  fs/jbd2/journal.c    |   17 +++++++++++++----
>  fs/ocfs2/journal.c   |    1 +
>  include/linux/jbd2.h |    1 +
>  3 files changed, 15 insertions(+), 4 deletions(-)
>
> --- a/fs/jbd2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
> +++ a/fs/jbd2/journal.c
> @@ -75,6 +75,7 @@ EXPORT_SYMBOL(jbd2_journal_check_availab
>  EXPORT_SYMBOL(jbd2_journal_set_features);
>  EXPORT_SYMBOL(jbd2_journal_load);
>  EXPORT_SYMBOL(jbd2_journal_destroy);
> +EXPORT_SYMBOL(jbd2_journal_unregister_shrinker);
>  EXPORT_SYMBOL(jbd2_journal_abort);
>  EXPORT_SYMBOL(jbd2_journal_errno);
>  EXPORT_SYMBOL(jbd2_journal_ack_err);
> @@ -2100,6 +2101,16 @@ int jbd2_journal_load(journal_t *journal
>  	return 0;
>  }
>  
> +void jbd2_journal_unregister_shrinker(journal_t *journal)
> +{
> +	struct shrinker *shrinker = journal->j_shrinker;
> +
> +	if (!shrinker)
> +		return;
> +	journal->j_shrinker = NULL;
> +	shrinker_free(shrinker);
> +}
> +
>  /**
>   * jbd2_journal_destroy() - Release a journal_t structure.
>   * @journal: Journal to act on.
> @@ -2173,10 +2184,8 @@ int jbd2_journal_destroy(journal_t *jour
>  		brelse(journal->j_sb_buffer);
>  	}
>  
> -	if (journal->j_shrinker) {
> -		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
> -		shrinker_free(journal->j_shrinker);
> -	}
> +	jbd2_journal_unregister_shrinker(journal);
> +	percpu_counter_destroy(&journal->j_checkpoint_jh_count);
>  	if (journal->j_proc_entry)
>  		jbd2_stats_proc_exit(journal);
>  	iput(journal->j_inode);
> --- a/fs/ocfs2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
> +++ a/fs/ocfs2/journal.c
> @@ -1119,6 +1119,7 @@ void ocfs2_journal_shutdown(struct ocfs2
>  	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
>  	 * the journal is destroyed and freed.
>  	 */
> +	jbd2_journal_unregister_shrinker(journal->j_journal);
>  	down_write(&osb->journal_shutdown_sem);
>  
>  	/* Shutdown the kernel journal system */
> --- a/include/linux/jbd2.h~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
> +++ a/include/linux/jbd2.h
> @@ -1566,6 +1566,7 @@ extern void	   jbd2_journal_clear_featur
>  		   (journal_t *, unsigned long, unsigned long, unsigned long);
>  extern int	   jbd2_journal_load       (journal_t *journal);
>  extern int	   jbd2_journal_destroy    (journal_t *);
> +extern void	   jbd2_journal_unregister_shrinker(journal_t *);
>  extern int	   jbd2_journal_recover    (journal_t *journal);
>  extern int	   jbd2_journal_wipe       (journal_t *, int);
>  extern int	   jbd2_journal_skip_recovery	(journal_t *);
> _
>
