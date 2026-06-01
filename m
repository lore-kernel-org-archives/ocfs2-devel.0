Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69576380FDF
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 06:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296675; cv=none; b=oaXEn8jCsQOvJ/VUStAGLoT9Gc0eBBAhBzQtSYQUy+B//iLi6uuG2pkKriQ1ir2Aul0woBL9ME8p6GwRdx3g+0QxyrBxxFveJfPa2Qouc9tQ2F9FvFYYJcF6+J/TQJPNoH3KMhmpoEO3WDMUrCnHA4uakMHro/rStCJ8IsgtThM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296675; c=relaxed/simple;
	bh=3gnkIqDgyH+ynOjStYwfViURO+BmnCTihcdVHMDkmII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TpYHQpr6IpkD50o02AlE/QFhlbYAo5PBkbMnQHy2uwAL6gi5jo1jEnjJqXev/GKKM4D6MaK8cfu89w9O9+tS02a9OTb1tjZK/SPTuKLzjC7J7C6qgn8o2KU6WVAeVMgTK1SDDdnN83OqPnayCYWOFDq1I7XJeuzkiKa/AFxj+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rmXSsrs4; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rmXSsrs4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780296658; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HQz7X9qGCkY3jlvJdIyc9rwIiW2F/tkRtNFML505bo8=;
	b=rmXSsrs4FLOpWmVc+hr5dOfZhBXxVdxMA/xgqjH4BA5Bgcf50/ZKelU4W0Djp0MHkG0z4SJ6fIKNU3eB6bT23mrffBJtLek9aF3vd+IG25LjUzU+u/MYRQeSIkXsKdvYXhI09RAJ3I/q8sIk17ai0h9enGVpHurQXGnPbr7l11o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X3yK7nn_1780296656;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3yK7nn_1780296656 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 14:50:57 +0800
Message-ID: <48b50de9-0047-416f-b09d-6e2e0fdeb70d@linux.alibaba.com>
Date: Mon, 1 Jun 2026 14:50:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Farhad Alemi <farhad.alemi@berkeley.edu>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260531131645.3650299-1-joseph.qi@linux.alibaba.com>
 <ahz8oSUC5GXrJM_b@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ahz8oSUC5GXrJM_b@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/1/26 11:32 AM, Heming Zhao wrote:
> On Sun, May 31, 2026 at 09:16:45PM +0800, Joseph Qi wrote:
>> During unmount, ocfs2_journal_shutdown() frees the journal and sets
>> osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
>> ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
>> -> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
>> NULL pointer dereference.
>>
>> Fix this by adding a NULL check for osb->journal in
>> ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
>> fully flushed and destroyed during shutdown, so there is nothing to
>> checkpoint.
>>
>> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
>> Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
>> ---
>>  fs/ocfs2/journal.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>> index 6397170f302f..f8b3b2a3d630 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
>>  	if (ocfs2_mount_local(osb))
>>  		return;
>>  
>> +	if (!osb->journal)
>> +		return;
>> +
> 
> In my view, the code is correct for this bug.
> However, the if condition is insufficient if ocfs2_journal_shutdown() sets
> "journal = NULL" immediately after this line.
> 
During unmount, journal shutdown happens before final inode eviction is 
triggered by generic_shutdown_super() -> evict_inodes(). That means they
run sequentially in the unmount path (same thread context).

Thanks,
Joseph

