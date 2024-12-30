Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE13622611
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735523869; cv=none; b=YVYcfxqyFxIsgHoR37vqpgVfC+9W5WSKoJK7gaty7VPpR05+0gnApQhBeLTn4ef/5mDXj8tuiMBJI8wVYhtj7a3XGtPoFgVOcCHnCZyDy+RU2F7EwYBPBm1BbTosXvdP/MVNirWrcNFq7BKmbuX3V2ak7PkpBktKZk373443MsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735523869; c=relaxed/simple;
	bh=Ul83KNzJzx3in51FGkQCkLdK4B/cczJ8NuvIR4BZiuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTt4XKUG7LNIUGpnIepNClMkJe3IjtAWnfplPnZHqoALaJCWSRJT70p4GCNlfWKK/IjKAo0koxw/86ZaRlkM6/Na1X7E5HSbkfgntO9VquxQbJR4RG5Opa8NG+p4oezFF0mmqyrWTcsEtdvr8jzB+1vpab7JvDakesam6wCvccI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QVT3KCfe; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QVT3KCfe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735523858; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v3fE39W7EIXD5rqVGnrW7lwTUmq11ZgIHh6chag5fj4=;
	b=QVT3KCfeEmxwmbXdu6GoBzCkVszEv80csIT5ZgtRhCNvEWAQEmaWnApqiwx7UCsohsg7I56ufia18EHIPMi0TwY5hsNGYQp7t/jS/C0zfZ5vGHzn/ef0u3+83aLKX6s1l7Khi3/+c2v/ckp5XRc5gMRr4jndX8AYYOZ9PM8NSi8=
Received: from 30.221.129.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMRUSLj_1735523856 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Dec 2024 09:57:37 +0800
Message-ID: <83d4d0d4-c702-49c1-bc7b-45d207f8208e@linux.alibaba.com>
Date: Mon, 30 Dec 2024 09:57:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: uncache inode after ocfs2_search_dirblock() search
 failure
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
References: <20241227130717.144988-1-dmantipov@yandex.ru>
 <844e9f34-1ef8-49ef-9f42-54fdeeefc18d@linux.alibaba.com>
 <e62a8e43-015a-4b3d-a018-641ecde36962@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <e62a8e43-015a-4b3d-a018-641ecde36962@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024/12/29 00:33, Dmitry Antipov wrote:
> On 12/28/24 3:27 PM, Joseph Qi wrote:
> 
>> Hi, don't see the relationship between above logic and the triggered
>> bug.
>> Could you please elobrate more how it happens?
> 
> As triggered by the syzbot's reproducer, the problem is initiated by
> 'mknodat()'...
> 
> -> mknodat()
>  ...
>  -> filename_create()
>   ...
>   -> ocfs2_lookup()
>    -> ocfs2_find_files_on_disk()
>     -> ocfs2_find_entry()
>      -> ocfs2_find_entry_id()
>       ...
>       -> ocfs2_read_inode_block()
>        -> ocfs2_read_blocks()
>         -> ocfs2_set_buffer_uptodate()    ;; [1] Buffer head is now cached
>       ...
>       if (found == 1)
>               return di_bh;               ;; Buffer head will be used
>       /* Hmm..... */                      ;; [2]
>       brelse(di_bh);                      ;; [3] Buffer head is now unused
> 
> ...with followed 'ioctl()':
> 
> -> ioctl(..., OCFS2_IOC_GROUP_ADD, ...)
>  -> ocfs2_ioctl()
>   -> ocfs2_group_add()
>    -> ocfs2_read_blocks_sync()
>     -> ocfs2_set_new_buffer_uptodate()    ;; OOPS [4]

This is a group bh, but the above bh in ocfs2_find_entry() seems not.

> 
> OOPS at [4] happens becase the corresponding buffer head is not actually
> "new". It was "new" at [1] but was not exprunged from the inode cache
> before 'brelse()' at [3]. I.e. OCFS2 cache has an inconsistent view of
> the data provided by the block layer, and it is expected that adding
> 'ocfs2_remove_from_cache()' at [2] should fix this problem.
> 

Even if found, the returned di_bh will also be brelsed in
ocfs2_free_dir_lookup_result() without removing from cache.
So if it is the case, it seems that it will also BUG when found.

Thanks,
Joseph


