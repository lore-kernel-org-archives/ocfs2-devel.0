Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7EA3C8C7C
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505069; cv=none; b=auZyy503Fg6At/nYXjuxPSOqi7T0iXVYSn6W6gul6aGJ43E6K0YFpOb6VV5ckVEaR18vaMr+a5Qlmn6tzod+pr10Nvk9H2dpETchhtPSiJWmrcix/2r0ObelsMOIANTsQ7Xn5Xk5DOu/7y9cw1VpqMOnLNBdNkEg4jv7VIctaFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505069; c=relaxed/simple;
	bh=lXJ+800PEr0sdiwa72NdYzbr2CDryhXLELpPZyE6IgI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Z+pD6fPu8FKANyN2wQ2sYcJKHU6wQH9D4vgViglzy9y1ioprwcJa5yPJeXxg+KRIeGlVLYK6YDw51myNHBVrx70itXXm9ndqvCgbJgSvkb1kwyiS9MyMtpP80maFL76VhdMFrPbiqcQkP9iAj6qx0lmmJRBoreaI7btVhCgO8xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HdUxZ+8H; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HdUxZ+8H"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788505063; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=9lRMlMVjD+fbSaYQw8Ksck7TBnDE1NV7gcB2O0CcwHQ=;
	b=HdUxZ+8Hp2+I/z/wcFdjXodwZ40ZyfrsrNvPWwYzP/Ev39YNEUlAerBXc2DcgBmlwVqYT61wUrlQNuF0lqWPJJ+NrC15XjnhOsZlGHlo2YGHpS/kfrx5J8kKNYHT+K0sCd1IIE5MGazSy2U3V59VP3yFQghQz2GJRuyXgDZEVRk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAI4rzp_1788505061;
Received: from 30.221.129.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAI4rzp_1788505061 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 14:57:42 +0800
Message-ID: <e54162e3-377e-480f-970d-d60f25db2b94@linux.alibaba.com>
Date: Fri, 4 Sep 2026 14:57:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ocfs2: possible deadlock in ocfs2_write_begin_nolock on
 v7.2-rc3
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: CJ <firefly0158@163.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 syzbot+1782a3a587bc53dc10cf@syzkaller.appspotmail.com,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <4a9f1b94.5284.1a066097387.Coremail.firefly0158@163.com>
 <900645a7-97a7-4ebf-9266-6c7e6269c3fc@linux.alibaba.com>
In-Reply-To: <900645a7-97a7-4ebf-9266-6c7e6269c3fc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

It seems has been fixed in latest kernel, please confirm.

Thanks,
Joseph

On 9/4/26 11:02 AM, Joseph Qi wrote:
> Seems you posted into a stale mail list.
> 
> +cc ocfs2-devel@lists.linux.dev
> 
> On 9/3/26 2:51 PM, CJ wrote:
>>
>>
>> Hi,
>>
>> I am reporting that possible deadlock in ocfs2_write_begin_nolock remains
>> reproducible with a migrated syzkaller reproducer on Linux 7.2-rc3. The
>> tested HEAD commit is a13c140cc289c0b7b3770bce5b3ad42ab35074aa.
>>
>> The reproducer mounts a crafted OCFS2 image and performs file and xattr
>> operations that enter the buffered write path.
>>
>> Lockdep reports a circular dependency when ocfs2_write_begin_nolock() starts
>> a transaction while the inode allocation semaphore is already held. The
>> reverse dependency is established through OCFS2 refcount-tree and xattr
>> handling.
>>
>> This looks like an inconsistent lock ordering between the inode allocation
>> semaphore and the filesystem transaction lock in the OCFS2 write path.
>>
>> This issue was previously reported at:
>>
>> https://syzkaller.appspot.com/bug?extid=1782a3a587bc53dc10cf
>>
>> Reproducer:
>>
>> syz reproducer: https://pastebin.com/raw/Ch9E7gAi
>>
>> console output: https://pastebin.com/raw/02Zj2gLb
>> kernel config: https://pastebin.com/raw/RLSmRk5j
>> Kernel:
>>
>> HEAD commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
>> git tree: torvalds/linux
>> kernel version: 7.2.0-rc3 #1 PREEMPT(full)
>> tested tag: v7.2-rc3
>>
>> Let me know if you need more details or testing.
>>
>> Best regards,
>> Xianying
> 

