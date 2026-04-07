Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3B1F09AD
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 03:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775531096; cv=none; b=RSoCi2/Uuojnb+hUACI4aNnGkpqX1HDY2mIP1KiqKdNH8cPMynrfEnpeLqLYf0YnFtTju3Xz+brIT5kYH+6XfXr22US3FNvbGJLUSz0hotkwWGjKGmA2w+cFReoGM/AukX9m/Fpb//5SHS37+AcxdkI30WQhJSVEjG+dmvz13ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775531096; c=relaxed/simple;
	bh=KVHvgth163PjwXzrH29b8EJp7NWU9UQMSM7Xe0x6viA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eEzY2u/2QWhpVpXCgt67L7kJVeFpKg2Pcasx9iMB25znQ1kCQonFRpJBHaE9s/Qi3UY0tvo44IVO7FAUW9fFXWLz+8SKt/gJ0hbO3w0HxcgUileBJ2XQtTeo+xQ+L/db8y8gcSXyZ/Pisni6IFJZJKvJPoNLLubXQB3mbgksSmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NxvKzMN9; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NxvKzMN9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775531085; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2pqgqiB1Q1RNQioIPNf7KMbnuATrSA2ZLXjpJ34rVpg=;
	b=NxvKzMN9OAuh+DvtIIlHgD/VXst90IK+zxOwK/5W6UGAHPV/X8mo2x4HhEXZUbGpWgxOwUdjuK0T3HUGyvYSIxRICU9OZdWpSNRGhRNP1FK/kuh5Fbl/YWIHGthltWD1c0TP1LAFkmVKaVgmbfhlC2z+ncSJ+daZsDToTt6TNP8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X0aH0aR_1775531084;
Received: from 30.221.145.153(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0aH0aR_1775531084 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 11:04:45 +0800
Message-ID: <f863f63e-3872-4a70-ab29-174a2e408232@linux.alibaba.com>
Date: Tue, 7 Apr 2026 11:04:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, jack@suse.cz,
 glass.su@suse.com
References: <20260402134328.27334-1-heming.zhao@suse.com>
 <20260402134328.27334-2-heming.zhao@suse.com>
 <20260403123239.5e49f98fc752b24cf309f453@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260403123239.5e49f98fc752b24cf309f453@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/4/26 3:32 AM, Andrew Morton wrote:
> On Thu,  2 Apr 2026 21:43:27 +0800 Heming Zhao <heming.zhao@suse.com> wrote:
> 
>> During ocfs2 dio operations, JBD2 may report warnings via following
>> call trace:
>> ocfs2_dio_end_io_write
>>  ocfs2_mark_extent_written
>>   ocfs2_change_extent_flag
>>    ocfs2_split_extent
>>     ocfs2_try_to_merge_extent
>>      ocfs2_extend_rotate_transaction
>>       ocfs2_extend_trans
>>        jbd2__journal_restart
>>         start_this_handle
>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
>>
>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
>> handle extents in a batch of transaction.
>>
>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
>> only be removed from the orphan list after the extent tree update is complete.
>> This ensures that if a crash occurs in the middle of extent tree updates, we
>> won't leave stale blocks beyond EOF.
>>
>> This patch also changes the logic for updating the inode size and removing
>> orphan, making it similar to ext4_dio_write_end_io(). Both operations are
>> performed only when everything looks good.
>>
>> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
>> suggestions.
> 
> AI review has a question:
> 	https://sashiko.dev/#/patchset/20260402134328.27334-2-heming.zhao@suse.com

There are two paths to recover:
1. During next write to the same file, ocfs2_add_inode_to_orphan() will
manually recover it first.
2. During next mount or node recover, ocfs2_recover_orphans() will also
do the same recovery operations (truncate + delete from orphan).

So I think it is false positive report.

Thanks,
Joseph
