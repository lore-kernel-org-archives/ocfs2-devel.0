Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB312745C
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159357; cv=none; b=FjcFlxOprXUxFj/rx6fvBHkzLHs2cD/qtE6D+fbR2AlWEQZ172SX15kdprtwXRBKPAKQKMjKDzIuA63j1k8r3kzl99ri0pZkmeyUyIq+YaaxKf2KFHey5lc1dioFY2Blgxt/SgEWzWuRKSPqza9vJVb83VYXdrwZEULRrkY3vnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159357; c=relaxed/simple;
	bh=wOkh6+AdoB9A4E9pq4GHwsKXjYezM6RzhVCLB3iB0hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYJNCoISN+s2kfZxFOVZZ2EtU1bnBXsM04aUvq5nbjRmg9EX/idlwgRWEfrkOibkgAbchhNEFi8aGsx1PRtZmEi4VsyLRIPO+N3dthKc0Ykohxubj7cHhtO/N2XIkShvj/WDyqUY5BT15vYlvYnhaI8mIFjbGTF8Kc+uaoG/58o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LT9sedmA; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LT9sedmA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724159349; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n49gPeUUINkGgbxl9NwKj9bWuhu5XK/BeaCMGdkYnN0=;
	b=LT9sedmAg2dnmNNdlLUhXDO5BNUNJunTkPcBZ85h90P5fGNFbWfyTFwhpNoAnBUXLA9G4Eqdzee8g1hzTg8vk7DnIrA1qgAKhfRprHlAQl8r1sma8MEHxH8XaEXD9L0pvkjmIa3o9mmYAOJLpCrzoSfKJRdmW5J0slNeHv3/KoI=
Received: from 30.221.128.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDIj7JC_1724159033)
          by smtp.aliyun-inc.com;
          Tue, 20 Aug 2024 21:03:54 +0800
Message-ID: <26da607a-530d-4dc1-9040-bf56b406b98f@linux.alibaba.com>
Date: Tue, 20 Aug 2024 21:03:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix null-ptr-deref when journal load failed.
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: jlbec@evilplan.org, mark@fasheh.com,
 syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
References: <20240819131120.746077-1-sunjunchao2870@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240819131120.746077-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/19/24 9:11 PM, Julian Sun wrote:
> During the mounting process, if the jbd2_journal_load()
> call fails, it will internally invoke journal_reset()
> ->journal_fail_superblock(), which sets journal->j_sb_buffer

This description is not right.
journal_reset() fails because of too short journal, then lead to
jbd2_journal_load() fails with NULL j_sb_buffer.

> to NULL. Subsequently, ocfs2_journal_shutdown() calls
> jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> ->lock_buffer(journal->j_sb_buffer), resulting in a
> null-pointer dereference error.
> 
> To resolve this issue, a new state OCFS2_JOURNAL_INITED
> has been introduced to replace the previous functionality
> of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> is only set when ocfs2_journal_load() is successful.

Or set OCFS2_JOURNAL_LOADED only after JBD2_LOADED?

Thanks,
Joseph

> The jbd2_journal_flush() function is allowed to be called
> only when this flag is set. The logic here is that if the
> journal has even not been successfully loaded, there is
> no need to flush the journal.
> 
> Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
> Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/journal.c | 9 ++++++---
>  fs/ocfs2/journal.h | 1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 530fba34f6d3..6f837296048f 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  
>  	ocfs2_set_journal_params(osb);
>  
> -	journal->j_state = OCFS2_JOURNAL_LOADED;
> +	journal->j_state = OCFS2_JOURNAL_INITED;
>  
>  	status = 0;
>  done:
> @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  	int status = 0;
>  	struct inode *inode = NULL;
>  	int num_running_trans = 0;
> +	enum ocfs2_journal_state state;
>  
>  	BUG_ON(!osb);
>  
> @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  		goto done;
>  
>  	inode = journal->j_inode;
> +	state = journal->j_state;
>  
> -	if (journal->j_state != OCFS2_JOURNAL_LOADED)
> +	if (state != OCFS2_JOURNAL_INITED)
>  		goto done;
>  
>  	/* need to inc inode use count - jbd2_journal_destroy will iput. */
> @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  
>  	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
>  
> -	if (ocfs2_mount_local(osb)) {
> +	if (ocfs2_mount_local(osb) && state == OCFS2_JOURNAL_LOADED) {
>  		jbd2_journal_lock_updates(journal->j_journal);
>  		status = jbd2_journal_flush(journal->j_journal, 0);
>  		jbd2_journal_unlock_updates(journal->j_journal);
> @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
>  		}
>  	} else
>  		osb->commit_task = NULL;
> +	journal->j_state = OCFS2_JOURNAL_LOADED;
>  
>  done:
>  	return status;
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index e3c3a35dc5e0..a80f76a8fa0e 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -15,6 +15,7 @@
>  
>  enum ocfs2_journal_state {
>  	OCFS2_JOURNAL_FREE = 0,
> +	OCFS2_JOURNAL_INITED,
>  	OCFS2_JOURNAL_LOADED,
>  	OCFS2_JOURNAL_IN_SHUTDOWN,
>  };
