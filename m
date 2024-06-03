Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227F115D1
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Jun 2024 02:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717382068; cv=none; b=pXIOdn/u7WEQAyh11q9KBndXL3PzHouCcNUqrkEB9zVWUILu6zmzias5/E76dMAxKYzLcO0s2imuBNagt1Ih9bfQk3u/8pOSXcSGEZmQmu3ZfSAz4ENrZzvyMKSQF2bSfrHt7FMnBdeRQPTUtHXT/rMazac2jvdyA3H1pqKGAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717382068; c=relaxed/simple;
	bh=nVGm4SqZy2ooehr0CQLe36tqhsoi4WEnmCO9tLOWlTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0GwyNMixMLdO1/baoio/ehsf6o8uhkje4eK7j1Ew8dvVz0SSps3eAtTQnIedOqhX3jaD9uUk2qsnD7ZpBSm2ojvP0w2cju+y0OywSIirQuTf0cJxWwY/Nxp8bspDCOXzgP3stvyDhV0zJtYGmwp8zkx9iylySHVAz6D66HQCWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AMlhHjF3; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AMlhHjF3"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e95a75a90eso41268111fa.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Jun 2024 19:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717382063; x=1717986863; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O7BTe8X4TlH65ZDjpszfC4HQycMYiCvhKNIygY54tUU=;
        b=AMlhHjF3+Qw9e/2IfL5zb43L8TzVxJkZhmizmRQSoDirwzZQHpWbpiXuL9oNgyNTdv
         zucQJDFWjpFfQAG4VAh3MlWkuTptGoc1dG/7ApqhThi4woDjpa+R8b40lFJ1ukS1tP1Y
         RtqfdnVwdePZBX+dA4GX8OQmPjoMZJ8/bNgvMEBf4qGA4a8KiKj8PPlSXJGRwzcXrq7S
         IUB62BsyBl32mjioCApsxvtQX6+rVxa3JHmKY3b8Q4AxjYgQQJdigmKj0KkGsrZudZyR
         hEpeIDdrlfGkdtHWLGqhz/6flwH24HftykVdgPqG3eDbpp9xWi8FTp8OGldxFnEPAAQ2
         JKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717382063; x=1717986863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7BTe8X4TlH65ZDjpszfC4HQycMYiCvhKNIygY54tUU=;
        b=MP3Vz7o+yJ0ZQ8wQdlMtMIzWQH77E5FUefgyM2O3AP91xXgPYiWVlMGDawJUa3w8On
         q6mJ0Wg8yEcdNPm+8yIIX9sJkLz2eprb0g20Jio4WqI9VIVNELTGthpL0oPtdOrgDEgW
         MfLq0vSBZX32cqU4sY+dtnKT5Lq4fvmEksp/fjbspp1D+RDzjhogomIjEMU8fVEBxg9f
         XsUBzDEJDkjvxXnBkl+yiT7pyn0OnKAtHZVxW4Vlchd+MgPimiBsuUyGDvp9/FOdwtwi
         S9UkvJu71rfDiSkJkMnTzlR8TfkSMEPA6a8me5WkfR/AYvtr9tTJ1kYS3xCh9yvsS1LO
         2Ggw==
X-Forwarded-Encrypted: i=1; AJvYcCVnVVPt6SOiRfkOFQUxI2Tys+322LL0Hx8aFDYNf7UJJJdknav/SoBUjVrfa4XHW9bm2myyUYHHFIjc+EBEvscM8/FCyIaAnRuaY/c=
X-Gm-Message-State: AOJu0YxNozE2bp7DerJpRdYjjeEKvPhYF7vZiWFGkw8o/cDOewW65nGs
	EzLSoBegwHgays4YpnC/s1l9vS9RWGTnhsDhjMgkk0b/l4f1VGGenVkwYYEPjoI5NJ4SK0jBOKz
	U
X-Google-Smtp-Source: AGHT+IEun4VdutAtlDTQrMFzcjyCCdsGBMEYadCyS46gy85LbYtdZ40PsWkEXZKrpoqeMYCXcrSm0A==
X-Received: by 2002:a2e:91cf:0:b0:2ea:7f84:e842 with SMTP id 38308e7fff4ca-2ea951b621dmr58097661fa.40.1717382062634;
        Sun, 02 Jun 2024 19:34:22 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63237901asm53619165ad.93.2024.06.02.19.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 19:34:22 -0700 (PDT)
Message-ID: <d325a6bc-1c17-4507-aa71-041e62ae9216@suse.com>
Date: Mon, 3 Jun 2024 10:34:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: fix NULL pointer dereference in
 ocfs2_journal_dirty()
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
References: <20240530110630.3933832-1-joseph.qi@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240530110630.3933832-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 19:06, Joseph Qi wrote:
> bdev->bd_super has been removed and commit 8887b94d9322 change the usage
> from bdev->bd_super to b_assoc_map->host->i_sb. This introduces the
> following NULL pointer dereference in ocfs2_journal_dirty() since
> b_assoc_map is still not initialized.
> This can be easily reproduced by running xfstests generic/186, which
> simulate no more credits.
> 
> [  134.351592] BUG: kernel NULL pointer dereference, address: 0000000000000000
> ...
> [  134.355341] RIP: 0010:ocfs2_journal_dirty+0x14f/0x160 [ocfs2]
> ...
> [  134.365071] Call Trace:
> [  134.365312]  <TASK>
> [  134.365524]  ? __die_body+0x1e/0x60
> [  134.365868]  ? page_fault_oops+0x13d/0x4f0
> [  134.366265]  ? __pfx_bit_wait_io+0x10/0x10
> [  134.366659]  ? schedule+0x27/0xb0
> [  134.366981]  ? exc_page_fault+0x6a/0x140
> [  134.367356]  ? asm_exc_page_fault+0x26/0x30
> [  134.367762]  ? ocfs2_journal_dirty+0x14f/0x160 [ocfs2]
> [  134.368305]  ? ocfs2_journal_dirty+0x13d/0x160 [ocfs2]
> [  134.368837]  ocfs2_create_new_meta_bhs.isra.51+0x139/0x2e0 [ocfs2]
> [  134.369454]  ocfs2_grow_tree+0x688/0x8a0 [ocfs2]
> [  134.369927]  ocfs2_split_and_insert.isra.67+0x35c/0x4a0 [ocfs2]
> [  134.370521]  ocfs2_split_extent+0x314/0x4d0 [ocfs2]
> [  134.371019]  ocfs2_change_extent_flag+0x174/0x410 [ocfs2]
> [  134.371566]  ocfs2_add_refcount_flag+0x3fa/0x630 [ocfs2]
> [  134.372117]  ocfs2_reflink_remap_extent+0x21b/0x4c0 [ocfs2]
> [  134.372994]  ? inode_update_timestamps+0x4a/0x120
> [  134.373692]  ? __pfx_ocfs2_journal_access_di+0x10/0x10 [ocfs2]
> [  134.374545]  ? __pfx_ocfs2_journal_access_di+0x10/0x10 [ocfs2]
> [  134.375393]  ocfs2_reflink_remap_blocks+0xe4/0x4e0 [ocfs2]
> [  134.376197]  ocfs2_remap_file_range+0x1de/0x390 [ocfs2]
> [  134.376971]  ? security_file_permission+0x29/0x50
> [  134.377644]  vfs_clone_file_range+0xfe/0x320
> [  134.378268]  ioctl_file_clone+0x45/0xa0
> [  134.378853]  do_vfs_ioctl+0x457/0x990
> [  134.379422]  __x64_sys_ioctl+0x6e/0xd0
> [  134.379987]  do_syscall_64+0x5d/0x170
> [  134.380550]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  134.381231] RIP: 0033:0x7fa4926397cb
> [  134.381786] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01 48
> [  134.383930] RSP: 002b:00007ffc2b39f7b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  134.384854] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fa4926397cb
> [  134.385734] RDX: 00007ffc2b39f7f0 RSI: 000000004020940d RDI: 0000000000000003
> [  134.386606] RBP: 0000000000000000 R08: 00111a82a4f015bb R09: 00007fa494221000
> [  134.387476] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  134.388342] R13: 0000000000f10000 R14: 0000558e844e2ac8 R15: 0000000000f10000
> [  134.389207]  </TASK>
> 
> Fix it by only aborting transaction and journal in ocfs2_journal_dirty()
> now, and leave ocfs2_abort() later when detecting an aborted handle,
> e.g. start next transaction. Also log the handle details in this case.
> 
> Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
> Cc: stable@vger.kernel.org # 6.6+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/journal.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 604fea3a26ff..27c7683c7d3f 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -778,13 +778,15 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
>   		if (!is_handle_aborted(handle)) {
>   			journal_t *journal = handle->h_transaction->t_journal;
>   
> -			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
> -					"Aborting transaction and journal.\n");
> +			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed: "
> +			     "handle type %u started at line %u, credits %u/%u "
> +			     "errcode %d. Aborting transaction and journal.\n",
> +			     handle->h_type, handle->h_line_no,
> +			     handle->h_requested_credits,
> +			     jbd2_handle_buffer_credits(handle), status);
>   			handle->h_err = status;
>   			jbd2_journal_abort_handle(handle);
>   			jbd2_journal_abort(journal, status);
> -			ocfs2_abort(bh->b_assoc_map->host->i_sb,
> -				    "Journal already aborted.\n");
>   		}
>   	}
>   }

