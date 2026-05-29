Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339B535E1CE
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 May 2026 11:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780052584; cv=none; b=hS7H1ztY3yG0qUCY8mnkhEgpN653MV+SgBLx1KmjMWlwRlaGZZ5cF5TatEv0Zp+cAZxeQbKmETvWksPRbBeNfjXd8SDyEHg4tmapwxsF3HdHF57QOBLmftSc96/eB5U0k9ZzaZkRhY9KUFon9TpjTu+GTLAfvyRkBKOZLhV3V0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780052584; c=relaxed/simple;
	bh=Zg07wUUiaw5MB68VxCPUOhXiEzDJ3QwacocSZK/Nu+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=augmGj3qQP2PdNc13AH57AT+mQFHRjSOzSUfJ+PG+3c0VrA0cLfqNPO1pe7pmd21XVbz/zezat4qj7lFk+wq27Sa1C6FB/TdjUXG0xQTvLzWHVONw3qHCrIAfn11t0bFpK88OH3dEphdQVTYNizLC1/nvTU48ZNDDZyF7r6DlrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nd8rP0oh; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nd8rP0oh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780052571; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=62TFP56IZv89Vok0JF/JClL+ir+J2z9xpdPb9QvOlLk=;
	b=Nd8rP0oh0OieiFqhz2fiWXIRtdMWhFRLq8UYkMiwKr47t5RGhbkjGdCTCFY3VwrG9TMZYzRAzNCdPG96gBU4Cn4HHTDsWL3j7HTOH2nswT8/t9zOj7i+whJBFAdTIn8ANU56Yqh1lgfJwg0d3pyjtnFQVuQ4I7Vm+pTdiauB30s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3p9Zif_1780052570;
Received: from 30.221.145.52(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3p9Zif_1780052570 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 19:02:50 +0800
Message-ID: <55ae3448-2873-422e-85e1-f35a038df75c@linux.alibaba.com>
Date: Fri, 29 May 2026 19:02:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix buffer head management in ocfs2_read_blocks()
To: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>,
 Changwei Ge <ge.changwei@h3c.com>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
References: <20260529094128.494293-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260529094128.494293-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/29/26 5:41 PM, Dmitry Antipov wrote:
> In 'ocfs2_read_blocks()', caller should't assume that buffer head
> returned by 'sb_getblk()' is exclusively owned and so 'put_bh()'
> always drops b_count from 1 to 0. If it is not so, buffer head
> remains on hold and likely to be returned by the next call to
> 'sb_getblk()' unchanged - that is, with BH_Uptodate bit set even
> if it has failed validation previously, thus allowing to insert
> that buffer head into OCFS2 metadata cache and submit it to upper
> layers. To avoid such a scenario, BH_Uptodate should be cleared
> immediately after 'validate()' callback has detected some data
> inconsistency.
> 
> Reported-by: syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
> Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> After introducing the series started with 775c17386a6fd ("ocfs2:
> validate dx_root extent list fields during block read"), reproducer
> from https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
> has started to trigger KASAN use-after-free again, and this patch
> should fix this as well.
> ---
>  fs/ocfs2/buffer_head_io.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 701d27d908d4..6114299b121e 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -350,8 +350,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  						wait_on_buffer(bh);
>  					put_bh(bh);
>  					bhs[i] = NULL;
> -				} else if (bh && buffer_uptodate(bh)) {
> -					clear_buffer_uptodate(bh);
>  				}
>  				continue;
>  			}
> @@ -380,8 +378,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  				BUG_ON(buffer_jbd(bh));
>  				clear_buffer_needs_validate(bh);
>  				status = validate(sb, bh);
> -				if (status)
> +				if (status) {
> +					if (buffer_uptodate(bh))
> +						clear_buffer_uptodate(bh);
>  					goto read_failure;
> +				}
>  			}
>  		}
>  

