Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB3819067C
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 May 2026 01:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780018106; cv=none; b=TPiuzXtZYMG08uSCF3BZicNodETynMhub7aZB2tUHAQBqRuGWnc9i3ciSufa6B3TZ3eop72x/aIKmNAHF1xIJpIZ2OMTw12igGmCCx4z7OI8O6KqP795aIhopkIy+5nwbCS/wiZm7toeHHqqcVx/C/TWX9Wucj5xgzi/M1kQsms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780018106; c=relaxed/simple;
	bh=msV+P4Ih/8vBrCiDMdlC7i6IaLzwC/uoqJ+hdpc0R8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Br79LZjGXEZ6NxhtLq5bmPQDVyQIWK6gMe5KA3/U1Ud/RO2DkZA9y/kjXbEWjgaaYGwJjAFInotbWnm7TsT3Rd8+dmoAlxiE/EcJCG6L4f80aBxF0oSKxBVljfluYNYwsY34oD1TcDU3O2fMiwCU+xh3E8oQWr86Suz0KRfYcXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LrolSOI6; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LrolSOI6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780018094; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ltc2q8PPO4QgHGK27F6NTQvBzBkTgqSV27V5NxmN4K0=;
	b=LrolSOI6yojW+W9qORnRRBVsBnO35/qr8eUpILXlVBXmLf2BFqu00VStwF0t62FM2JQkvPiQPsxD6L4GYOtySekotky3gBcm2wywf4THRVSgql6M16c9YNqQclmCNOOdS3qo0zc/9U56hC7RrjH1VYtUi3YlOKbN82iA6BT/bbc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X3nu3TB_1780018093;
Received: from 30.221.145.52(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3nu3TB_1780018093 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 09:28:13 +0800
Message-ID: <f9ab7556-2045-4403-9fa7-88077798ab66@linux.alibaba.com>
Date: Fri, 29 May 2026 09:28:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
 <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
 <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
 <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
 <e2032b0aeb857bc8f0c73bbd85a7917d94fd9005.camel@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <e2032b0aeb857bc8f0c73bbd85a7917d94fd9005.camel@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/28/26 10:42 PM, Dmitry Antipov wrote:
> On Wed, 2026-05-27 at 15:52 +0800, Joseph Qi wrote:
> 
>> ocfs2_validate_dx_root() returns -EROFS
>> ocfs2_read_blocks() goto read_failure → put_bh, bhs[0]=NULL, return -EROFS
>> ocfs2_read_block() returns -EROFS
>> ocfs2_read_dx_root() returns -EROFS
>> ocfs2_find_entry_dx() goto out, returns -EROFS
>>
>> On a second read of the same block, ocfs2_buffer_uptodate(ci, bh)
>> returns false (block was never added to the ocfs2 metadata cache because
>> the first read failed), so the block is re-read from disk and
>> re-validated — failing again.
>>
>> Am I missing something?
> 
> It seems that I've got the point. In ocfs2_read_blocks(), it's wrong
> to assume that non-NULL BH returned by sb_getblk() is exclusively
> owned by the caller and so put_bh() always drops b_count from 1 to 0.
> If it is not so, BH remains on hold and likely to be returned by the
> next call to sb_getblk() unchanged - that is, with BH_Uptodate bit set
> even if it has failed validation previously. So BH_Uptodate should be
> cleared immediately after validate() callback has detected some data
> inconsistency, regardless of what may happens next with that BH:
> 

It makes sense. Thanks to figure this out.
Could you please send a formal patch to fix this issue?

Thanks,
Joseph

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
> Dmitry

