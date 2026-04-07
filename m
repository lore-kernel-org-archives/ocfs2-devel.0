Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D310D2A1B2
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775525258; cv=none; b=K94zPF1UYW17xo13QC2Yy7kgFWnANARnWeElb4MH7aZBp7xtvmxI+S1ztdRpYdFw5Ht0q/Kd4aX2phCVHGEnpAvpDHsj+AfV8wwTp4lkEflc1pTO7SHvUkfp28WmJmp9erhM6fa58msgqFoicLsY2w3tmRkKfXEAp4ntJYODxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775525258; c=relaxed/simple;
	bh=0mwxc1k1ANdj8M1/rDBwRCipRM4Y27qK7IvOR75VohY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTpUJT/LAZZYqsf3NnqU0xFoYoAzGN+QchrVyGcUdGXMP1xRhN0r721BJuQetFSTdPAa5wwhTmFWmUuZIbT9tYyQphRyqW9E9CPvNV8twiwxLbUyVfnmbM9qMyRcTDaGX8tSgSdTvmhKNbWx4q2cD/aljG8R2Rubvs3krFC+vgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Q4YJFD2u; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Q4YJFD2u"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775525247; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qJ8I0/N8QGRyDIyU30ELRQCQvpqCsa0nH4ECSX+PqWQ=;
	b=Q4YJFD2usYlGNEwCDD1RwXr31vPBysolpGI1ZwbXGBciCSbJiv58BZ9nCZSe4KjjiTw9juASpsXEg8vIlszBijp2WY3uCbVXH5PHn19vfbd4TSWtwFJNtSv+xCqdE1ww4QT0L/reu1DjYVgl6B2MlLeHrlp/AKJgs9SN4UgnFhw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0a0r6I_1775525246;
Received: from 30.221.145.153(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0a0r6I_1775525246 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 09:27:26 +0800
Message-ID: <a09fdf81-6a28-4b56-a76f-8fa5025f0ddc@linux.alibaba.com>
Date: Tue, 7 Apr 2026 09:27:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>
 <20260403122846.daf61b872e045baee9470f3a@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260403122846.daf61b872e045baee9470f3a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/4/26 3:28 AM, Andrew Morton wrote:
> On Fri,  3 Apr 2026 14:38:30 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> KASAN reports a use-after-free write of 4086 bytes in
>> ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
>> copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted
>> on a loop device. The actual bug is an out-of-bounds write past the
>> inode block buffer, not a true use-after-free. The write overflows into
>> an adjacent freed page, which KASAN reports as UAF.
>>
>> The root cause is that ocfs2_try_to_write_inline_data trusts the
>> on-disk id_count field to determine whether a write fits in inline
>> data. On a corrupted filesystem, id_count can exceed the physical
>> maximum inline data capacity, causing writes to overflow the inode
>> block buffer.
>>
>> Call trace (crash path):
>>
>>    vfs_copy_file_range (fs/read_write.c:1634)
>>      do_splice_direct
>>        splice_direct_to_actor
>>          iter_file_splice_write
>>            ocfs2_file_write_iter
>>              generic_perform_write
>>                ocfs2_write_end
>>                  ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
>>                    ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
>>                      memcpy_from_folio     <-- KASAN: write OOB
>>
>> So add id_count upper bound check in ocfs2_validate_inode_block() to
>> alongside the existing i_size check to fix it.
> 
> AI review had a question:
> 	https://sashiko.dev/#/patchset/20260403063830.3662739-1-joseph.qi@linux.alibaba.com

Sashiko worries about it can't handle the case OCFS2_INLINE_DATA_FL not set.
I think it is a seprated case.

Thanks,
Joseph

