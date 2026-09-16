Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1CE3C5522
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544999; cv=none; b=AgcfvlwLBm+JqePue4X9lLQNsZTvTsyEy89kYzYl/1WslVUa2E9GUFSCdxeZZvUatKWBhhXVg6D4CxpWQr60fdyHG3oUeY5DfBqdCLhPFmgoXXDTI16Fvo02Ppf/rk3PlowfWNJUuKr4g3XW1df3cj7J41IW8gMQMEWbCHZx028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544999; c=relaxed/simple;
	bh=VC01o4Bs/psfiDdR+JJbj4W6tqdQfjnbM9/8A7RB2hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGASOMZn6smTNGPRqg8459LT33K7Xo3iBKujrAtj37UkN6Am1EJR4/pVUQOb/Ij/Z0WYtVHC0nBnZcgTlGUip48uRMyzVn2grIIBnyPB9AJGub1kJYFSlR8lOFi3CYYAIkQn+Op0+2Rsvf6kR/XA8DfmJVS+Un93CU6z00sZOOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ECqHbOMd; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ECqHbOMd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789544984; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Dl2GDDJCkEG6SKosJakzt26lKSBH8U9pIS/WYC2v5MY=;
	b=ECqHbOMdxNuDRgNYWfh1ysvy683VNenBbm44IKoHjLaKOoNBer6Iy6Fdxk9IdZIQ0cPptjWUNkUNbl81wrQ2S2lB+5JO1X1JTuis8gloLfdHlxLkyvqm0hd2JK51iIrPMosRoiAECfcXqEzXix5qNtSrCQYcBaq96hqQas3N0zA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XB4BRZv_1789544982;
Received: from 30.221.129.239(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB4BRZv_1789544982 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 15:49:43 +0800
Message-ID: <efd02e48-64ab-40ff-99d6-9ab971f0e956@linux.alibaba.com>
Date: Wed, 16 Sep 2026 15:49:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
To: Daniel Borkmann <daniel@iogearbox.net>, alexei.starovoitov@gmail.com
Cc: brauner@kernel.org, dwindsor@gmail.com, john.fastabend@gmail.com,
 memxor@gmail.com, kpsingh@kernel.org, matt@bobrowski.net,
 bpf@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>,
 ocfs2-devel@lists.linux.dev
References: <20260915150739.284189-1-daniel@iogearbox.net>
 <20260915150739.284189-2-daniel@iogearbox.net>
 <4eba77a2-a66f-438d-a769-40398564304f@linux.alibaba.com>
 <814e1ffd-fc08-40f6-b3ac-b002d2ac08cc@iogearbox.net>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <814e1ffd-fc08-40f6-b3ac-b002d2ac08cc@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/16/26 3:37 PM, Daniel Borkmann wrote:
> Hi Joseph,
> 
> On 9/16/26 9:28 AM, Joseph Qi wrote:
>> Hi,
>> I have reworked security xattrs in local, which addresses a review
>> comments from sashiko.
>>
>> The fix will allocate an array in ocfs2_initxattrs(), copy the names
>> and values, account for all of them in the credit calculations, and
>> write each one in ocfs2_init_security_set().
>>
>> It seems if with it, your patch is no longer needed. I'll send out
>> later.
> 
> Ah perfect! I guess this means you'd be routing this rework via your
> tree, we'll just drop this fix on our side, and eventually both sides
> would meet at Linus' tree? If so, that sounds fine to me and would avoid
> a merge conflict.
> 

Yes, I think so. It will go to mm-tree first and then linux-next.
I'll cc you as well when send out the patch.

Thanks,
Joseph

