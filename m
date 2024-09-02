Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8BBA34
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 01:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240781; cv=none; b=lKf4uNKaYhtJk+SQYpj+2ocz4VqW/pOUZCyolM2zYD4RaKvJ8cDHN7X463p+d32gie+XMJEsobzZUO1R3mTR7zi3OkIHEqk1g6La36HJM2v9mFnvTbeDAH+9m8z12zgJvlKXFlUUGeU3FIKyFJZceZwFel7lHa1rrJmYOtf/hmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240781; c=relaxed/simple;
	bh=Jacoy7d8kVCAhDZz9TUpWUlvRSBq8NGEkkA76CbXDtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSPmH4GQRH8q3TJ9SDIqyfmzFBRVQyw14XOMBhllsKtbL3Vm0bb6BHSmV2osjVMsTqnN6mtCKYE1C4bFIH2BoWaW62KY5pUEbLqjo/1baYSM/I9aQttej/h2DesbpBCRT/SvuTDr5MFI4aHusO/wFhxicBrvC2mqBFkXgF9i9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oxX+RGgt; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oxX+RGgt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725240769; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pVwvQynDqGl8fIXf6dcBy+Wuy2Th6SN0Jwyb7iNQftg=;
	b=oxX+RGgtIFUKNaIO7P3cq2XhHea1oc17R1J6fU8lGuVLGovZbMI3VBphiWHh0qkmXX6F7ksR0nzTKHAyvfK+RkCBitCyDW12SQq3d2/IDvZ7YK6+dWQObFvAz0I/3aWtcaipBnFmyj5diSzS3lyqqpaW5gRucb8dNNQDvs36bgM=
Received: from 30.221.129.135(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE0ePki_1725240768)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 09:32:49 +0800
Message-ID: <f08b8440-5df5-45cb-9ec2-43601b9aadda@linux.alibaba.com>
Date: Mon, 2 Sep 2024 09:32:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix null-ptr-deref when journal load failed.
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev,
 syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org, mark@fasheh.com
References: <20240830110853.101060-1-sunjunchao2870@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240830110853.101060-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/30/24 7:08 PM, Julian Sun wrote:
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
> ensure the journal was properly loaded. Additionly, refine
> code to make it cleaner.

s/Additionly/Additionally

Additionally, use journal instead of osb->journal directly to simplify
the code.

> 
> Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
> Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/journal.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 530fba34f6d3..ff2a6538b46e 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  		osb->commit_task = NULL;
>  	}
>  
> -	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
> +	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
> 
Please do the same change for the above one:

num_running_trans = atomic_read(&(journal->j_num_trans));

> -	if (ocfs2_mount_local(osb)) {
> +	if (ocfs2_mount_local(osb) &&
> +	   (journal->j_journal->j_flags & JBD2_LOADED)) {
Align it to the right place, please.

Thanks,
Joseph
>  		jbd2_journal_lock_updates(journal->j_journal);
>  		status = jbd2_journal_flush(journal->j_journal, 0);
>  		jbd2_journal_unlock_updates(journal->j_journal);

