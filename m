Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795745477;
	b=b/l8fwKhi0nWFx8+864u+dItuTLzqmDRxKBU4ReLTIDpZh7pdVpVKNen/ABKivUJ66lK
	 IJAw7entD6aBsUOPr01QzftITN2lPXkSxCw/1r3g+HunnWYd06wWXfF4IKvp/cUj7pAvv
	 Sx7vlEnhlwgbHzFnK9wtE9IMx+GPbqwAO7y4S0rRyKSWTjBqS/XeHHB1e+c+007dnkz4r
	 jVJJZAxY+zoum74QrbTyxvcrt/5d3ljDPFfbmPZO/LR8F9XuwiQkX/KCrjS4DnhQxiYlX
	 myFJ5Nfe6NQ4FTyDz0a8vDJJ51rbDPWBOXdBYNLnv2y7Vay7d9YSHjtNIu+btVRjNZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795745477;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=v17ApoUxmw4oIX3ib06cnHIG0pCYFw3usTIw/BBMT1Y=;
	b=3LhTSNzITywLHVsbpENH/Pk1ZsWxNX+lrQaD2VjosUgD/fpXdRge5bln6gajfJjRvblB
	 qoBG+0JB3GiEH40XP27agE9KcfvCFLXbSj/APwayA++tNzxZROE3WI9/k18QX78Rl2+yk
	 Kcl+YpIhVV+Cc27dU+IpLg3NXyFI91xcvg+yXymi2kXvsWHMzDvvBNWrZ/Lp3PVuD3g5C
	 nXMmwDbdoEQ0IdGHitekR2oXT+xqvbaReaJkMuyzR5JY08elJ90cM2XDRlXaq5T+VFB7W
	 nM/4q9TpJIJfvfAZUuVz5DYV+U4SHC1Fn0258hGScw3dHivk23Mgg6R6M1ow5yC7GdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gsFzv1Ve;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13CF606A329;
	Fri, 27 Nov 2026 02:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B13CF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gsFzv1Ve
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795745468; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v17ApoUxmw4oIX3ib06cnHIG0pCYFw3usTIw/BBMT1Y=;
	b=gsFzv1VeXpO4jUifX7Tl6BexXZZMKUv2MyMakYlVlKr8fFfZgUdr45xCsqasyZsLql+Qquds/onBgxl3tRERgorVlC6+QMzqJhXIoR3hvdfkJcqYyC9vl9b4lU7vrF/YHiPyuddYezFbNOQjFF3okTEHt5FTCBvPznDCFLXlBvI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XFWG7vK_1795745466;
Received: from 30.222.32.233(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFWG7vK_1795745466 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Nov 2026 10:11:07 +0800
Message-ID: <843bc832-5731-4f06-835c-9594c53a4cd1@linux.alibaba.com>
Date: Fri, 27 Nov 2026 10:11:05 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v12 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: Heming Zhao <heming.zhao@suse.com>, sashiko-reviews@lists.linux.dev
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20261125154626.22335-1-heming.zhao@suse.com>
 <20261125154626.22335-4-heming.zhao@suse.com>
 <sashiko-outbox-233793@kernel.org>
 <a9224bf6-9d1b-4fdd-9980-a70c39b11b57@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <a9224bf6-9d1b-4fdd-9980-a70c39b11b57@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/26/26 11:07 PM, Heming Zhao wrote:
> On 11/26/26 01:05, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 11 potential
>> issues to consider:
>> - [High] ocfs2: missing fsync tid and i_blocks update in
>>    ocfs2_dio_end_io_write()
>> - [High] ocfs2: buffered and mmap writes do not wait in
>>    ocfs2_unwritten_check()
>> - [High] ocfs2: ocfs2_dio_cleanup_range() fails on zeroed folios past
>>    i_size
>> - [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() for
>>    uncommitted metadata
>> - [High] ocfs2: orphan entry and block leak on failed or short DIO write
>> - [Medium] ocfs2: overestimated metadata reservation in
>>    ocfs2_write_begin_nolock() for DIO
>> - [Medium] ocfs2: per-cluster multi-MB allocation thrashing on ENOSPC in
>>    ocfs2_dio_wr_map_blocks()
>> - [Medium] ocfs2: per-cluster w_desc kvcalloc, ip_lock scans, and
>>    duplicate lookups in DIO
>> - [Medium] ocfs2: preallocated extents truncated in
>>    ocfs2_dio_clear_orphan_locked()
>> - [Medium] ocfs2: stale inode state after lock drop in
>>    ocfs2_dio_upgrade_rw_lock()
>> - [Medium] ocfs2: ocfs2_should_use_dio() forces buffered I/O for
>>    sub-page DIO overwrites
>> -- 
>>
> 
> It feels like the more code I modified, the more issues I introduced.
> Furthermore, Sashko has started reporting performance issues.
>  

I'll take a look this weekend.
And then we discuss and come to an agreement which could be left in this
series.

Thanks,
Joseph
 

