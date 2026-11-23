Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430932;
	b=Jms9UE1ismCwX9eshCR23mVLLSN7Bze/S+hyWt8Cj6Vd2xb//rdEPHDI9nHDwQBvUFo7
	 UYg1Arsqqepw7S5jXoIkuaiIssHAef2WGmulSh31o9Ym+1vD/RshgntVaTjCHeWXMURNu
	 RFhGxdhfWUJNeuPTKyuiekFCHhbNP66iE0kTT/E4Rk5/5uH5v5xgFi713DWKipY3wHq96
	 npf0GzTS+CRMH9j62Wg+iAKCDKaXLgYIuOPzVf3qvB2OGeIdlV9+WgXwqyqnfnJzs/Aa/
	 vHkedQkN2qqIImrXltVezRB8RCAvrZQA7w1aUPYDfiTAu8+CPY1fKmvoC3ewNsxhARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430932;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=YA1xcvENssYl+lpJjqGf2E/8z4fK4t/nBmjo3N4n8g4=;
	b=fHqqRvyNcCFWJvnC+2d5dbuIHn4F8bhOlaMAMQSDoXzj4ug7otttx8vNvhvLiY8+YLPj
	 X59FOdK5keEa/nUFbIrdnLa0vEnMAjyaHd1Usa6Mwo1ckXf/myE41sG2JuJGI+8rCkp6Q
	 fx267nJMA0F7nWkr8FLiwjz0SWo6J394eOgymKbI6AifAcKUrSSSktDh9iOpCWhmojWj+
	 XGiPre0FDDiWw49VkVkuo+6gQHO8LEYyPjp4y3cMnBACdf+Orium0CpW8zs9ovuvWZ1fI
	 /rR6KIVM8DzRNiluj1ejZ5THkppWLXFhORV1sLamNZFaRHq7lA2kxz8sRr0MBmqpSew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gt1NgZpB;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD71606A692
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 10:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD71606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gt1NgZpB
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795430927; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YA1xcvENssYl+lpJjqGf2E/8z4fK4t/nBmjo3N4n8g4=;
	b=gt1NgZpBswJzq3243wr3FsKge/6bqMLzppmsGQEHCsLaC2ZPKgSx1kBv1v5k0guXeCWdHpnBkTIEoMkRJf0Lt1XSIyTC0hyb1og2Hwug4OuHG1xs+IwH4tzy0CioctwP8SNMgSb5uQXneh6dmVAR9MaPXTH3PooVI+GeWSZdMak=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XFHkyA._1795430926;
Received: from 30.221.131.81(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFHkyA._1795430926 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:48:46 +0800
Message-ID: <0a00183f-a770-4645-abe2-3a1acb34e46c@linux.alibaba.com>
Date: Mon, 23 Nov 2026 18:48:45 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: don't destroy the jbd2 journal under
 journal_shutdown_sem
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, Cen Zhang <zzzccc427@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com
References: <20261123091933.42057-1-ngocthang2710.1999@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261123091933.42057-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
It has been fixed in thread:
https://lore.kernel.org/ocfs2-devel/f946ba25-6454-4831-9d0a-83fc58721ee2@linux.alibaba.com/T/#t

On 11/23/26 5:19 PM, Nguyen Ngoc Thang wrote:
> ocfs2_journal_shutdown() holds journal_shutdown_sem for write across
> jbd2_journal_destroy(), which frees the journal's shrinker and takes
> shrinker_mutex. ocfs2_clear_inode() takes the same rwsem for read and
> can run from reclaim via super_cache_scan(). Lockdep reports the cycle:
> 
>   journal_shutdown_sem -> shrinker_mutex -> fs_reclaim
>     -> journal_shutdown_sem
> 
> The write side only has to keep the journal alive while
> ocfs2_clear_inode() calls jbd2_journal_release_jbd_inode(). The journal

It also blocks ocfs2_clear_inode() from returning, which is what keeps the
inode alive while destroy walks transaction->t_inode_list.

Once the write side is dropped before destroy, ocfs2_clear_inode() takes the
read side successfully, sees j_journal == NULL, skips the release, letting
evict() free the inode while journal_submit_data_buffers() is mid-walk with
JI_COMMIT_RUNNING set on that jinode. ocfs2_journal_submit_inode_data_buffers()
then dereferences jinode->i_vfs_inode->i_mapping on freed memory.

Thanks,
Joseph

> has been flushed by then, so inodes cleaned up afterwards have nothing to
> release. Detach j_journal under the rwsem and destroy it outside, and
> make ocfs2_clear_inode() skip the release once j_journal is gone. The
> lock now only covers pointer updates and the final kfree().
> 
> Reported-by: syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
> Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
> Tested in QEMU (x86_64, syzbot config) with the syzbot C reproducer:
> without this patch lockdep reports the circular dependency on the first
> run; with it, 9 runs (3 boots x 3) are clean, debug_locks stays 1 and
> journal_shutdown_sem no longer has shrinker_mutex or fs_reclaim among
> its forward dependencies in /proc/lockdep.
> 
>  fs/ocfs2/inode.c   |  7 ++++---
>  fs/ocfs2/journal.c | 17 ++++++++++-------
>  2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index e225a96d37535..8a26964472521 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1320,11 +1320,12 @@ static void ocfs2_clear_inode(struct inode *inode)
>  	/*
>  	 * ip_jinode is used to track txns against this inode. The journal is
>  	 * flushed before it is shut down, so an inode cleaned up after that
> -	 * has nothing left to release. Hold the shutdown lock so a journal
> -	 * found here stays allocated until the release has finished.
> +	 * has nothing left to release; shutdown detaches j_journal first.
> +	 * Hold the shutdown lock so a journal found here stays allocated
> +	 * until the release has finished.
>  	 */
>  	down_read(&osb->journal_shutdown_sem);
> -	if (osb->journal)
> +	if (osb->journal && osb->journal->j_journal)
>  		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>  					       &oi->ip_jinode);
>  	up_read(&osb->journal_shutdown_sem);
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 9c4a48887c9a3..2529138918bc1 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1064,6 +1064,7 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
>  void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  {
>  	struct ocfs2_journal *journal = NULL;
> +	journal_t *j_journal;
>  	int status = 0;
>  	struct inode *inode = NULL;
>  	int num_running_trans = 0;
> @@ -1076,10 +1077,8 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  
>  	inode = journal->j_inode;
>  
> -	if (journal->j_state != OCFS2_JOURNAL_LOADED) {
> -		down_write(&osb->journal_shutdown_sem);
> +	if (journal->j_state != OCFS2_JOURNAL_LOADED)
>  		goto free;
> -	}
>  
>  	/* need to inc inode use count - jbd2_journal_destroy will iput. */
>  	if (!igrab(inode))
> @@ -1116,13 +1115,17 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  	}
>  
>  	/*
> -	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
> -	 * the journal is destroyed and freed.
> +	 * The journal is flushed, so ocfs2_clear_inode() has nothing left to
> +	 * release. Detach it under the lock but destroy it outside: freeing
> +	 * its shrinker must not nest in a lock that reclaim takes.
>  	 */
>  	down_write(&osb->journal_shutdown_sem);
> +	j_journal = journal->j_journal;
> +	journal->j_journal = NULL;
> +	up_write(&osb->journal_shutdown_sem);
>  
>  	/* Shutdown the kernel journal system */
> -	if (!jbd2_journal_destroy(journal->j_journal) && !status) {
> +	if (!jbd2_journal_destroy(j_journal) && !status) {
>  		/*
>  		 * Do not toggle if flush was unsuccessful otherwise
>  		 * will leave dirty metadata in a "clean" journal
> @@ -1131,7 +1134,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  		if (status < 0)
>  			mlog_errno(status);
>  	}
> -	journal->j_journal = NULL;
>  
>  	OCFS2_I(inode)->ip_open_count--;
>  
> @@ -1144,6 +1146,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  	journal->j_state = OCFS2_JOURNAL_FREE;
>  
>  free:
> +	down_write(&osb->journal_shutdown_sem);
>  	/* Serialize the removal with ocfs2_ci_fully_checkpointed(). */
>  	spin_lock(&trans_inc_lock);
>  	osb->journal = NULL;

