Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792940080;
	b=p97ZMP402hrPXOWt944Sb2AaMnYPVS19OYxgI8jEfwusBUAtQ5NPVnNDvUJ1BPvSx+5/
	 zG40ENaKto+D7Ktl8/AZDgkvzbVfgbGqZ4k6IjYA9XXuVHA7+JmSAOMpEdDpKxg9YcceU
	 mPG8a6oFnsYktvk/5F5h6pXqF+G6vsUupnX+hjk7qkg/7gCYvSVGRt0w8StKbbd/oM+E7
	 o0xKqfeykF53Dnc2NojvQ5J90uHlqUaHZuvHdXedDxqdny8aW0YaeYWg1sSNXoMGRPd53
	 ePAaLZzO6Q+ZGVLLHAbml5S/PWekQZNjGk2l7bWIeHMd6XVSg747oWPUMGTsWPWRGCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792940080;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AoNMLsz3guDJrLtk/mnsExx2hQkyavYoRX6GgBXrn14=;
	b=UwO4w8i+A7vQH/6oLnIrrEO4kNW+qu/3l4ODCN+LKumtJ6cGFcT3+0HQi76TBU1bGpsq
	 dpRWn2YMnmS2UOmwMTHczpcziAWNK3+AJTPWszlQUk4VeOeLv+oR9IY2gtyHEmKxZynCd
	 9TgDe6LWpByshlXrOADq5HFumLh5iss66sKq/1zsA4CZb0vpbKfVH8bos4+Gi1zbK168c
	 ZH8cAAuyBchJ2lWfGHNF/VvT/vo8AhScy0vxArl9LINq9gtEVPgsDdTGyWMxe9AkOuBoD
	 SapuU/f98Aq3d8mIW2gy/E4peFlghx2Gv+BEgl/ttHh7EdkNpCpsq8k4zUEXKMkoVjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jnS1NEHN;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B234606A31B
	for <ocfs2-devel@lists.linux.dev>; Sun, 25 Oct 2026 14:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B234606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jnS1NEHN
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792940075; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AoNMLsz3guDJrLtk/mnsExx2hQkyavYoRX6GgBXrn14=;
	b=jnS1NEHNfDAthjf7/jj5y5b0Q+DvtfD2zcC+Lzp0hgGnawvBhrjiw3jKZdzgW0EgvgoUUW4YzJAGOzIQe+3FBUbp8g01KM4Mj0YLuta/uhVGxICI6e51xTAtb7Xt7osGap8LusmPtnD262Bq27tGmr93KWUWmo1MlthGF6dVyz4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDQaWzk_1792940074;
Received: from 30.251.227.55(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDQaWzk_1792940074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 25 Oct 2026 22:54:35 +0800
Message-ID: <f81c41b2-a4a0-43ef-8e68-a4da92644267@linux.alibaba.com>
Date: Sun, 25 Oct 2026 22:54:34 +0800
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
Subject: Re: [PATCH 0/6] ocfs2: fix stale xattr entry pointers and empty
 header reads
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
 <20261024103709.7ada16bbca6403787892cb5c@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261024103709.7ada16bbca6403787892cb5c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/26 1:37 AM, Andrew Morton wrote:
> On Sat, 24 Oct 2026 23:10:06 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Five defects in the ocfs2 extended attribute code, plus one robustness
>> measure that belongs with them, all on the paths that move entries
>> between a block, a bucket and an index tree.  They fall into two groups.
>>
> 
> Thanks.
> 
> The series is a little awkward - [1/6] is "no functional change" hence
> it's upstream-in-7.5-rc1 material.
> 
> The other 5 are cc:stable fixes, so they're upstream-in-7.4-rcX material.
> 
> That means splitting the series and it means upstreaming an untested
> code combination - 2-5 haven't been tested without the presence of
> [1/6].
> 
> I think I'll just cheat a bit.  I'll keep all 6 together and I'll put
> them in mm-nonmm-unstable for now.  After Linus releases 7.4-rc1 I'll
> move all 6 into mm-nonmm-hotfixes-unstable for upstreaming during the
> 7.4-rcX cycle.
> 
> I'll add 
> 
> Fixes: e39baff18b85 ("ocfs2: use the stored hash when checking xattr bucket collision")
> 
> to [1/6] just to make things look better and to reduce the risk
> associated with -stable running that untested code combination.

Keeping all six together works fine for me, thanks.

Joseph
