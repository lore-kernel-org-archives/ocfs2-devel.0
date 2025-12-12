Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E162E542A
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 04:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765514987; cv=none; b=qKkR76dkz+0r3T0/9k65MdNTMoWf+tvz9gjwup9wCQs7feWdprVCu17U0Vd1Q7ojgFIyPVcB1gO62IU4zBii1PNALDgIb+4PU9F0QR6Le5Mq9T0gpOyFyP2DPwC0ZYteR2jemoyHWLK2xUnoqC6ZqNgBqIEEEKsKcv+WxdVr4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765514987; c=relaxed/simple;
	bh=f+589vYQgYSdCKjUpCT+5kPhJlM3cU24mzWD6Gb+ywc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WL9YlEy4JufMOYr++kL4afPuVshypPIhmg4iOwC3eHEZqqbgsZCzqCI9aqVHYnmsFW+Hy3KGlQFkl4EtuMxqi0k/JtASBrZHN9XxItOaeVGwsRn6oCTaxUbFrSz326U0OU6JbIWNB71GtZXNO+XZfvJQQH1zyN6QTsDGIVljrvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yTE3JOoH; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yTE3JOoH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765514975; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n44X9PZ2y6rUvnqezePfcaEOX9F2DNKd6PwRJyr1+8M=;
	b=yTE3JOoHN1GmF6GIS6DzAJ2jAwtGMSLeQM0jrwXx8ak+H6rdBKhggBlySmdezu/2d+b2Nvs/hlwYWA0M80Ps6MquQ6R3Sd8rDyqyWDJccRdVE9SfYQLiJVuzgRAhtSJM2Fa+qJ4H75E+gWR92Ajst9LwV+1slDnxtUw4xFaj7d0=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wuczm.z_1765514973 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 12:49:34 +0800
Message-ID: <5561c14a-9aaa-43b7-95f9-8428a2364f09@linux.alibaba.com>
Date: Fri, 12 Dec 2025 12:49:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN
 boundary checks
To: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Deepanshu Kartikey <kartikey406@gmail.com>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
References: <lhnx6meceuvndkxjpxaapwkiqvlp6recho77b4yjirznjn62jr@fu5gq2gsg2yu>
 <20251211155949.774485-1-dmantipov@yandex.ru>
 <4ttnx34q3ispjgdeoezr4tuxbuezs6qhzpocidc6sdbrf6feeh@i65rsj2nv5tb>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <4ttnx34q3ispjgdeoezr4tuxbuezs6qhzpocidc6sdbrf6feeh@i65rsj2nv5tb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 11:21, Heming Zhao wrote:
> On Thu, Dec 11, 2025 at 06:59:49PM +0300, Dmitry Antipov wrote:
>> After introducing 2f26f58df041 ("ocfs2: annotate flexible array members
>> with __counted_by_le()"), syzbot has reported the following issue:
>>
>> UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
>> index 2 is out of range for type 'struct ocfs2_xattr_entry[]
>> __counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
>> ...
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>>  ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
>>  __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
>>  ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
>>  ...
>>
>> To address this issue, 'xh_entries[]' member removal should be performed
>> before actually changing 'xh_count', thus making sure that all array
>> accesses matches the boundary checks performed by UBSAN.
>>
>> Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>> v2: adjust commit metadata per Heming's notices
>> ---
>>  fs/ocfs2/xattr.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index dc1761e84814..de99276d12f0 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -1941,8 +1941,7 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>>  	ocfs2_xa_wipe_namevalue(loc);
>>  	loc->xl_entry = NULL;
>>  
>> -	le16_add_cpu(&xh->xh_count, -1);
>> -	count = le16_to_cpu(xh->xh_count);
>> +	count = le16_to_cpu(xh->xh_count) - 1;
>>  
>>  	/*
>>  	 * Only zero out the entry if there are more remaining.  This is
>> @@ -1957,6 +1956,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>>  		memset(&xh->xh_entries[count], 0,
>>  		       sizeof(struct ocfs2_xattr_entry));
>>  	}
>> +
>> +	xh->xh_count = cpu_to_le16(count);
>>  }
>>  
>>  /*
>> -- 
>> 2.52.0
>>

