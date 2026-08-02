Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AD3C1F
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 13:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785675785; cv=none; b=lFjC22p0ThKQEBS3T5ZoSOEoU93MgA+mwaYOe13rI/hTwhwJLY7cpcflxJoKsLrRJgsgAsSHCGWtXetu1Tkh6MkFNkSNvdd78GC08IH5La50w2BKKM8oQIEnurZnvTnYAMguSjlJdmzmjxVGF2P6v1G0/nmUVKsMLq0vukAoMCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785675785; c=relaxed/simple;
	bh=7TnVOu6FJZkZAyxu+ydEsTNvO5oiGeGPWEvs5xM91Zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zu9PQgCscsljlWJ14nlrjcK+Le4SMngEFAoYjPbm/SRrbnxShWSnwXjycCTfbBQQI05A+oqf5FF7rgcTXXqnkCTuxe0scESxZsn3tmE5sc7EZoN2ksiqx4ApnkbGK4YLiMzWQLmyrVoT+EgsT90WTym4SU9tuUj+3BhU5Co1W/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ULC1VFJ5; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ULC1VFJ5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785675777; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fCdqR1aO7jZUBpBzrTvcmdEj9NegZ5WpaEIDqbe32yg=;
	b=ULC1VFJ5WmJO8NAZgCXDnMRq8BBOHzb7iaWs1vVFnhNFOIXTBnXvMNXxpjmfUUZ3v6s/8bwzKGsMGQvyurx2rzcPjvkQZxYC28m1nFt11CLDVmEB+k0POw9u3n3kh2CG4pmcf18PGsfkZISRK6cLeMtpHM57Yygw/OJWJ+CPB3o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X8C3KUP_1785675776;
Received: from 30.41.82.155(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8C3KUP_1785675776 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 02 Aug 2026 21:02:57 +0800
Message-ID: <63e491c4-46b0-4ae9-84c3-b21cde14b222@linux.alibaba.com>
Date: Sun, 2 Aug 2026 21:02:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in reflink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260731113425.4130293-1-joseph.qi@linux.alibaba.com>
 <20260731112136.803da03ad3dd3ed119e88262@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260731112136.803da03ad3dd3ed119e88262@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/1/26 2:21 AM, Andrew Morton wrote:
> On Fri, 31 Jul 2026 19:34:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Lockdep reports a possible deadlock involving ip_alloc_sem,
>> j_trans_barrier, and ip_xattr_sem:
>>
> 
> Cool.
> 
> Sashiko said a couple of things:
> 	https://sashiko.dev/#/patchset/20260731113425.4130293-1-joseph.qi@linux.alibaba.com
> 

Thanks, I'll take a deep look for the sashiko review comments.

>> Fix by swapping the lock order in both functions to acquire
>> ip_alloc_sem before ip_xattr_sem, consistent with the rest of the
>> codebase.
>>
>> Fixes: 09bf27a00020 ("ocfs2: Implement ocfs2_reflink.")
>> Fixes: 8b2c0dba5159 ("ocfs2: Call refcount tree remove process properly.")
> 
> Should we backport this into -stable kernels?
> 
Yes, I think it deserves.
Sorry for missing the cc stable tag.

Thanks,
Joseph

