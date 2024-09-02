Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B8310F1
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725258721; cv=none; b=FVCAcrttq/TXQvujG3+T8F7Wcj3CYHbudWwoT0V3iwFnSPgxM3ViJ5RM0Q76K781lVTxKeNjA/UF2IqXPo8Gs2k4dr9SSIFSdibRRZjn3pqixnE3L6PZMAkknrGLUC1Muy2Ip59kq9lmF4QzNNT/W7SjDjflYrQKAvOlX9a2JBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725258721; c=relaxed/simple;
	bh=jh2E0C06qogXBotxV66PP8rBaUueWn8QKdlv1uHqZSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvX1Cfdf7QXWdXYziOackSLBTIJxnHVHmdb4HT92tGILCDBY7P9whOS08PNz2gBHCrmOr//pROj7U4lmyhci4gXtwggQvwVbcqWHQAc6trUqcl3SEU4jQYM8bD13gR7vE3lSLE/D2bmh6at29tCD8zFlyJ6H/QVQ4PatccU9uOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lUFliWQT; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lUFliWQT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725258710; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=h6wzfGajmGxOSsimP5dv63XiolgkwklpeF/rMmyaf1c=;
	b=lUFliWQT6ChB7HndmfRHFvZAEMzlVbAv5OGSwmnP1RChkG91pylM6oWe8UlOKAKUVYHwxuVGSEFlQa9iuCnOSaGPsMImitZ44+67xhyO0PBPXeEscy4P5WkVVKp5yZebqCpK873tlAmSRlF4kL/e9Tyc2lXLp4edCeOuF6/icfg=
Received: from 30.221.129.135(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE4IAX6_1725258709)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 14:31:49 +0800
Message-ID: <742cfa1c-484c-41d4-9bbf-246a73b882e2@linux.alibaba.com>
Date: Mon, 2 Sep 2024 14:31:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: fix null-ptr-deref when journal load failed.
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, mark@fasheh.com,
 syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
References: <20240902030844.422725-1-sunjunchao2870@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240902030844.422725-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/24 11:08 AM, Julian Sun wrote:
> During the mounting process, if journal_reset() fails
> because of too short journal, then lead to
> jbd2_journal_load() fails with NULL j_sb_buffer.
> Subsequently, ocfs2_journal_shutdown() calls
> jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> ->lock_buffer(journal->j_sb_buffer), resulting in a
> null-pointer dereference error.
> 
> To resolve this issue, we should check the JBD2_LOADED flag to
> ensure the journal was properly loaded. Additionally, use journal
> instead of osb->journal directly to simplify the code.
> 
> Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
> Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>

Fixes: f6f50e28f0cb ("jbd2: Fail to load a journal if it is too short")
Cc: stable@vger.kernel.org
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/journal.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 530fba34f6d3..1bf188b6866a 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1055,7 +1055,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  	if (!igrab(inode))
>  		BUG();
>  
> -	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
> +	num_running_trans = atomic_read(&(journal->j_num_trans));
>  	trace_ocfs2_journal_shutdown(num_running_trans);
>  
>  	/* Do a commit_cache here. It will flush our journal, *and*
> @@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  		osb->commit_task = NULL;
>  	}
>  
> -	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
> +	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
>  
> -	if (ocfs2_mount_local(osb)) {
> +	if (ocfs2_mount_local(osb) &&
> +	    (journal->j_journal->j_flags & JBD2_LOADED)) {
>  		jbd2_journal_lock_updates(journal->j_journal);
>  		status = jbd2_journal_flush(journal->j_journal, 0);
>  		jbd2_journal_unlock_updates(journal->j_journal);

