Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8D3273FC
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 02:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725243651; cv=none; b=RPOP0NXjL69z13FiPKoD+VaNGL7yNbz5IfGULhXwreFnj6Wf38n4gnNCmeRlvEEVaPaIeFbbjbb2XXBZgLykfECz82wNg0YpBsTwoI3Va7zie5aLcHBsK8y3tK1QFT/JBvzaZRs7QKzj9cSulBtPU9VG/KOE+2qAoczo3KJFXqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725243651; c=relaxed/simple;
	bh=44VO/gO90/rcJmDutFagKFNRsueeIYthkugvlRj+Vww=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ILk3Vk6V4BmKLyrq6v9vci8l5L/DSYf4alXCt4kuektvXFmA6H6wFegX6IG/i/9sy0kqWWedzxBB+tYqID+KlYBylarUGbxkdBpHbzJ4mTVANcIuEQq23s+QLa2TV6b4tQOfyYYmYRmT17bfku6KzC9i2w3k4KFCACfQHggTM3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SuveVGPB; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SuveVGPB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725243640; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ABiXjq8frTJLa6cOJxztaG8PEGA0s7qXwsKdZ5eveMg=;
	b=SuveVGPB2EF+o3wzAnKIS2J2aGkdAwIN8E5kaJGWBbLgZHgj8TAiLCE6iwYuXF6AkNTqxehjRHHtXmVoJzvpa6gsBFQ4QthE8UG4Bwz5WMweZn9Qm+bklHWklS4o/tSUJUJGy45VPuND++X/nZx2EJValKwD8B/Viy7vqH4IFZY=
Received: from 30.221.129.135(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE1-7SY_1725243638)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 10:20:39 +0800
Message-ID: <18e9dbe0-afe5-48d1-9788-6b13617aff50@linux.alibaba.com>
Date: Mon, 2 Sep 2024 10:20:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
To: Heming Zhao <heming.zhao@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lizhi Xu
 <lizhi.xu@windriver.com>, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
 <20240821091459.681136-1-lizhi.xu@windriver.com>
 <25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
 <20240821143911.cec82fac50c08947523da2e6@linux-foundation.org>
 <20240901175402.816203db096c2e9e49d75363@linux-foundation.org>
 <b716d079-1725-4a89-8998-e0c88b8ea7c5@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <b716d079-1725-4a89-8998-e0c88b8ea7c5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/2/24 9:03 AM, Heming Zhao wrote:
> On 9/2/24 08:54, Andrew Morton wrote:
>> On Wed, 21 Aug 2024 14:39:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> OK I think I found the correct patches - v3 of [1/2] and v4 of [2/2].
>>>
>>> For clarity can we please have a full resend of both patches?
>>>
>>> And let's please have a [0/n] cover letter which describes the problems
>>> which are being addressed and which also briefly describes how they
>>> were addressed.
>>>
>>> Also, it appears that both of these fixes should be backported into
>>> -stable kernels.  So let's please try to identify when these bugs were
>>> introduced and to add a suitable Fixes: to the individual changelogs.
>>>
>>
>> Again, can we please have a full resend of these two patches with the
>> above issues addressed?  Particularly the identification of the Fixes:
>> targets.
>>
>> Thanks.
> 
> Hello Andrew & Joseph,
> 
> If Lizhi still doesn't respond by this Friday, I will send his latest patch set again.
> 
I'll do that, thanks.

Joseph

