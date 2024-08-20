Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370D134D1
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116369; cv=none; b=XpUzFpf7SgRmZuYTfXmSCLDtFzpKV7cFJs7XmghaPMJdcq3GYJ1Dv7YWMcYjh462QTJJTB1oEUvqJh8LchSFEq8F0ehbIMQqU2PACHHGhwSYhAibZ8bpRhE1xVcTklVgrKP4eFD69bvVGCuPITsCHhJQyNQryET+mpL6IoBxevo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116369; c=relaxed/simple;
	bh=WwQoy1W42BcBNh9BniFKEqko+jEknkzHc1M1T0KFG8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYWIcCYfoIHGR9VFonoemh20/MJYeEta56xBxfO5vpA9GXYJWE8TkXBis825XltE3IJKNVJGBmU1b0gXOv9olDUph4YgCf9H18LIK1urQ2J4YV2LJgFVOlBPR4iCKqVPNp3nXZeIT8LjBpFo/0tNdmF+b1Gd4hu5XSrq47nuRyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CbQxP36Q; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CbQxP36Q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724116364; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=V55tWFOs2j/7hQOblUxqoNa9+AFP1aq2zN62h7AYCVM=;
	b=CbQxP36QbP+mzZAdv4AAHk5JlwlzFRSVnvycnHGbI/wkYg2WJJwsY8H/WkfMYyj4P0dRvj/caopNblEJRJkICMnHfvBFE8+wD0spiGlvlDHSVNCtFuW6iF73EOHqbdOPCQVSLqC+Y0nxfgOg+g584G5Gv+1TqLJ2nn7iJYpECL4=
Received: from 30.221.128.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDGQC6S_1724116361)
          by smtp.aliyun-inc.com;
          Tue, 20 Aug 2024 09:12:42 +0800
Message-ID: <d10a4f92-00f7-48a7-b6fd-e0fa5e8e3013@linux.alibaba.com>
Date: Tue, 20 Aug 2024 09:12:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: Fix shift-out-of-bounds UBSAN bug in
 ocfs2_verify_volume()
To: qasdev <qasdev00@gmail.com>, Heming Zhao <heming.zhao@suse.com>,
 mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <Zr9XJJlZ+RzkLK/M@hostname>
 <cbd30b80-d213-4997-b447-10e455f20196@suse.com>
 <e5fb0013-ea4e-4da7-89e5-6b2b0879ecc9@linux.alibaba.com>
 <ZsPrbmbnAgGRgqLw@hostname>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ZsPrbmbnAgGRgqLw@hostname>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/20/24 9:03 AM, qasdev wrote:
> On Mon, Aug 19, 2024 at 10:52:29AM +0800, Joseph Qi wrote:
>>
>>
>> On 8/18/24 7:43 PM, Heming Zhao wrote:
>>> On 8/16/24 21:41, qasdev wrote:
>>>>  From ad1ca2fd2ecf4eb7ec2c76fcbbf34639f0ad87ca Mon Sep 17 00:00:00 2001
>>>> From: Qasim Ijaz <qasdev00@gmail.com>
>>>> Date: Fri, 16 Aug 2024 02:30:25 +0100
>>>> Subject: [PATCH] ocfs2: Fix shift-out-of-bounds UBSAN bug in
>>>>   ocfs2_verify_volume()
>>>>
>>
>> The above should be eliminated from patch body. 
>>
>>>> This patch addresses a shift-out-of-bounds error in the
>>>> ocfs2_verify_volume() function, identified by UBSAN. The bug was triggered
>>>> by an invalid s_clustersize_bits value (e.g., 1548), which caused the
>>>> expression "1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits)"
>>>> to exceed the limits of a 32-bit integer,
>>>> leading to an out-of-bounds shift.
>>>>
>>>> Reported-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
>>>> Closes: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
>>>> Tested-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
>>>> Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
>>>> ---
>>>>   fs/ocfs2/super.c | 8 ++++++--
>>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>>> index afee70125ae3..1e43cdca7f40 100644
>>>> --- a/fs/ocfs2/super.c
>>>> +++ b/fs/ocfs2/super.c
>>>> @@ -2357,8 +2357,12 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
>>>>                    (unsigned long long)bh->b_blocknr);
>>>>           } else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
>>>>                   le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
>>>> -            mlog(ML_ERROR, "bad cluster size found: %u\n",
>>>> -                 1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>>>> +            if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 32)
>>>> +                mlog(ML_ERROR, "bad cluster size found: %u\n",
>>>> +                     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>>>> +            else
>>>> +                mlog(ML_ERROR, "invalid cluster size bit value: %u\n",
>>>> +                     le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>>>
>>> I prefer to use concise code to fix the error.
>>> Do you like below code?
>>> -        mlog(ML_ERROR, "bad cluster size found: %u\n",
>>> -                 1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>>> +        mlog(ML_ERROR, "bad cluster size bit found: %u\n",
>>> +                 le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>>>
>>
>> Agree. qasdev, Could you please update and send v2?
>>
>> Thanks,
>> Joseph
> 
> Thanks for the feedback. After considering the input, I've refined the patch 
> to make it more concise. I've updated the patch and included it below:
> 
Hi, please send v2 as a standalone thread.

Thanks,
Joseph
