Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C980536D
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 May 2024 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715737328; cv=none; b=l++142TjiDthvH0oY/NyMPc74zcXH26POkY2D/0ksThOeWRZh9Gu7eQziUMNDeCE7zgC6aMfGF9EYl0yf8qMvJPCPy9hF/I37yCfihUeGplU6eDBC3Wr4Eo281A9jCwvxsr+2ofx05WFvx1+OYd8OisYNNlduzBrXiWBtObt9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715737328; c=relaxed/simple;
	bh=+7ufY8Eh3yKQZRn/oII5wMOBwJYMSKfn59DkwfrpTjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uC9kdDb2l3QaRK2FqpWuGaG7h6LOF+36kalTY0kguVyyayJkpOey0qHTuMbRF1es7fP1LtWigPglOzo3mI9FpSoIeXFoM53mrmgRwAEdIk2139CxBBVz+91W8tInFcfwsQCHB39TWksZaZoh6TRqBmuYGlBmmX0URVHBFv9tKg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZLhWc3UY; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZLhWc3UY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715737323; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MoGvUB//1XQgGOaROPYbkMQ1FRGXCS8xvgRucH9e5PI=;
	b=ZLhWc3UY0orcYd/vCjpK7wQjMsRcjMpJM8JXNixwckvDnZTJEZmV27OBxNCp2GqYI/LU1Y/lFmtyIjE6pDGM1RwPTcxZt9O7KVd6DSu43XQw0TSaK/ASIJebl56Dg7eZLn+FOlvZ9XANI35q43dBvmquMDtyIJfHejCDfkdl1DQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0W6WC1GB_1715737320;
Received: from 30.221.128.222(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6WC1GB_1715737320)
          by smtp.aliyun-inc.com;
          Wed, 15 May 2024 09:42:02 +0800
Message-ID: <228d5e29-935c-46ca-b554-e3f4dff5fe09@linux.alibaba.com>
Date: Wed, 15 May 2024 09:42:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: An out-of-bound in OCFS2
To: lei lu <llfamsec@gmail.com>, Linus Torvalds <torvalds@linuxfoundation.org>
Cc: security@kernel.org, ocfs2-devel@lists.linux.dev,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Ferry Meng <mengferry@linux.alibaba.com>
References: <CAEBF3_bBSrQTXSPvk1C+TB4ye+tmkLCXpou6ig+34iNv4yXpSA@mail.gmail.com>
 <CAHk-=wgrV_hb1ZuvxvhRF8=5R5SxeNUkpA7NVg2-7HcM1TKQaw@mail.gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAHk-=wgrV_hb1ZuvxvhRF8=5R5SxeNUkpA7NVg2-7HcM1TKQaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for reporting this issue.
I'll take a look at it.

Cc ocfs2-devel@lists.linux.dev as well.

Thanks,
Joseph

On 5/15/24 2:09 AM, Linus Torvalds wrote:
> On Tue, 14 May 2024 at 10:28, lei lu <llfamsec@gmail.com> wrote:
>>
>> I found an out-of-bound in OCFS2 file system.
>>
>> There is a lack of verification for ocfs2_xattr_entry.xe_name_offset.
>>
>> PoC:
>> 1) xh_entries.xe_name_offset: 0xffff
>>     ocfs2_xattr_header.xd_count: 0xa (10)
>>     ocfs2_xattr_header.xh_num_buckets: 0x0 (0)
>>     ocfs2_xattr_header.xh_entries[0].xe_name_offset: 0xffff (65535)
>>     ocfs2_xattr_header.xh_entries[0].xe_name_len: 0x5 (5)
>>     ocfs2_xattr_header.xh_entries[0].name:
>>     ocfs2_xattr_header.xh_entries[0].xe_type: 1
>>
>> KASAN report: [..]
> 
> I have forwarded the original to ocfs2 people who are also cc'd here as well.
> 
> Please keep everybody on the participants list for any questions or
> further info on this,
> 
>                 Linus
