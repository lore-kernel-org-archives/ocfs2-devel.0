Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569442DB7A3
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779760800; cv=none; b=mzWZfBAH7bPURWRtPQVV1fY7pzyq6rw6zaeUzW2l4czY+6s7bx/BSI0spr9+i6WOs/I+E8M5ias1N8V6jUlbRzM3uGAhcghS5tex8WSZaHQe9YNQcjsXAInlP4jPFr7HKCbknE2iHygB/lKU47IU7wkU6poQzKotDwyAJ8mJRXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779760800; c=relaxed/simple;
	bh=ac6IqeqzmB/9FU+9ow5x9C6jMHjq3s5hatbrTlkUPWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDm0KZhqs3LUhr+oWh7duw/eLxhheC0n5dT93rgPQ/djKqK+zSImDOJZCaYwlMANNVSYUOHWBsXg3KGMaZfVt0WpimhCpQa0l9Tr1Yb9YNYSasqH7pHrW3eJ/xtvP3u/KvqFo9Y0cCVoVnRfZUp0X83puYkRsTlVw0E1asY5gCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jL5i71A9; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jL5i71A9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779760796; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=i7ZhAWiOUfmTiIYv781IQKXKLEg+OuzIaCnq7RgrKB8=;
	b=jL5i71A9cIqXKitN0xNJe7u8D9C41GZJDArryDD9pU3So20vIVBEFIjlyYKVhg95fSTQ+GR1lWdziv2BeUvZTewS5anMLo+ozAqYbAs8Im1Sd3plOYLa9yVv5hYMLYxJy96HzH/FuQ0v5zhkvMwfSsvWy6oU7hfnnB2HuDwPpVU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3eRPlD_1779760794;
Received: from 30.164.201.154(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3eRPlD_1779760794 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 09:59:55 +0800
Message-ID: <f4c89369-6519-40f3-adf3-b79219013432@linux.alibaba.com>
Date: Tue, 26 May 2026 09:59:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reject oversized group bitmap descriptors
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Cen <rollkingzzc@gmail.com>, ocfs2-devel@lists.linux.dev,
 zerocling0077@gmail.com, 2045gemini@gmail.com, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260524111248.1429884-1-rollkingzzc@gmail.com>
 <cb815654-3702-4aa6-a43e-8a2215e66314@linux.alibaba.com>
 <20260525131941.479295e62c0b3a4d598a495c@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525131941.479295e62c0b3a4d598a495c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 4:19 AM, Andrew Morton wrote:
> On Mon, 25 May 2026 11:49:45 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>> +	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
>>
>> This seems can use !ocfs2_is_cluster_bitmap() helper instead.
>>
> 
> Thanks.  So I'll await a v3 and shall take no action at this time?

Please pick this version.
As discussed in v2 thread, we don't want to bother the prototype change
for ocfs2_check_group_descriptor().
Sorry for the inconvenience.

Thanks,
Joseph

