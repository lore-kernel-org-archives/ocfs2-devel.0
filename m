Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA279460
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 03:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789529231; cv=none; b=OQ5jTt9x/JEnOZkZsbWeQbP3qwNs69NdzBsp9cZio3tVlRG7nfjFHVlw0yqmCAsIaMm+Mg4PFryd/IIAeHV+68msKwDvZAZ8998EzcQveI2jzDJVs9Y0IyCcpz0HAeT7nbeVCUO/KXcxLrLEnJDFub0XH1mebDSVFihF8uXjfUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789529231; c=relaxed/simple;
	bh=Kh3XwrS3CQnyVxW33YNVvOHD5NisuhE/sa1UnsdNthY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DPhJNcU7Buzoxnkorx7vxr9VrZax7VkQPEEXx60THw11689cJg0Ysa1Lh9ySrJz2M1SBrjsQDZRr7339D5wQ41wLma+bJ8G2Hb5u/O2nS+7cvDy3TJ7U4BEZO3y2hRcEEHXPY68ORCdsM5H1uoHb45LPov+4DDbSYBgD0hKzxNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=or0zOlkx; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="or0zOlkx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789529225; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JXKEFfEdVysD7VLIlHwy3Q83p/7A1AIJEpgip/Zwb2Q=;
	b=or0zOlkx6Nde3lsoPPSejvbrnW7oN0EdMd0XfJY6rxp3ryxRpRRzR+O/rzX+DdJ3LLuakA+qqGzKWzmEquA6I/MAR6SQCpCBNi/6R0tL0E4hLIkJ38Ea1Nig7t7sBhs4iITaScAAhF4HCEc2wz1G0mBoAqfsjhmR7KfQ43/QjgI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XB3cjV._1789529224;
Received: from 30.221.129.239(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB3cjV._1789529224 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 11:27:05 +0800
Message-ID: <304d93d0-9ac3-48bc-a75c-eba1c0ca96e7@linux.alibaba.com>
Date: Wed, 16 Sep 2026 11:27:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: update xattr count before moving bucket entries
To: Su Yue <glass.su@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260916024750.9450-1-glass.su@suse.com> <aqoJuNSmtQO1nihQ@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aqoJuNSmtQO1nihQ@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/16/26 11:15 AM, Heming Zhao wrote:
> On Wed, Sep 16, 2026 at 10:47:50AM +0800, Su Yue wrote:
>> Since commit 2f26f58df041 ("ocfs2: annotate flexible array members
>> with __counted_by_le()"), the xh_entries array is annotated with
>> __counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
>> bounds. When inserting an entry into a bucket, ocfs2_xa_bucket_add_entry()
>> shifts existing entries before incrementing xh_count.
>> The destination therefore extends one entry past the bounds described
>> by the old count.
>>
>> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
>> ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
>> while adding an extended attribute:
>>
>> [  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
>> [  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
>> [  150.160496] RIP: 0010:__fortify_report+0x40/0x50
>> [  150.164031] Call Trace:
>> [  150.164141]  <TASK>
>> [  150.164232]  __fortify_panic+0x9/0xb
>> [  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
>> [  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]
>>
>> Increment xh_count before memmove() so the destination bounds include
>> the new entry. Keep the local count unchanged to calculate the insertion
>> position and move length from the original number of entries. The caller
>> has already checked that there is enough space for the new entry.
>>
>> Signed-off-by: Su Yue <glass.su@suse.com>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
