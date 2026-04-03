Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0F6371D0A
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 07:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775199832; cv=none; b=EX9LezClA2pdg8Z8iPB9+6T8Ni5qQpQh3X29FsDXG+GsfuUOXSC75asfukik5qYyA6Fdndk5aVU17fDVTIUhi2BI424GNvR+ViycG7/zmyX6fzyza9/E7ZkKoj2p4YVrM+mXCQMBSH+031mjFft5H3cTeYynaeFJ9t/jG2rPveQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775199832; c=relaxed/simple;
	bh=Oidd+cyZzg6AJ6y8fCnHIwhCsw8toaeUzrKcjzs2woE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DzUjLgFPgHgjqcW82XCYpL/ymCaE4B4yOH4oqpvlsY/OLM9KI/AbixI1sjYiKd/GegwsJE6ljjklt22iyyQsUDUKbeumnGbdI4kupj+uQnFroq0vHy5R5tbKWlWG99354VpDijNv6M8cUz+lCP3gXSZdPEu3REWbncam0znPPFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LvEctBT5; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LvEctBT5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775199826; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kwBeA1e8UrzjcAxhMkww1P1kwb/r9Ifg2d6GD4DLVUw=;
	b=LvEctBT5MCkG3DphMsPU0O/gOE0dy3edrV+EaY8erY0sxvyzsw2NMUVzG+361hLcZrHEylLarfeo3k/N3LqS4kq8mmFliMDTp75aLPmEBErh2GNEx2kG78SWQ1lxSfbQ2pQOy6o5pjVGqL5mSjYb20koKDBsMynFUCM02gok8vU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0JPoJW_1775199824;
Received: from 30.221.145.18(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JPoJW_1775199824 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 15:03:44 +0800
Message-ID: <124f7c66-4138-42af-8c03-7f27817fa30e@linux.alibaba.com>
Date: Fri, 3 Apr 2026 15:03:43 +0800
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
 <20260402234815.1c0070c4e379c6c244314949@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260402234815.1c0070c4e379c6c244314949@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/3/26 2:48 PM, Andrew Morton wrote:
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
> Thanks.
> 
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1505,6 +1505,16 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>  			goto bail;
>>  		}
>>  
>> +		if (le16_to_cpu(data->id_count) >
>> +		    ocfs2_max_inline_data_with_xattr(sb, di)) {
>> +			rc = ocfs2_error(sb,
>> +					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
>> +					 (unsigned long long)bh->b_blocknr,
>> +					 le16_to_cpu(data->id_count),
>> +					 ocfs2_max_inline_data_with_xattr(sb, di));
>> +			goto bail;
>> +		}
>> +
>>  		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
>>  			rc = ocfs2_error(sb,
>>  					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
> 
> Even though the surrounding code is from 2025 (1524af3685b35), I think
> this bug predates 1524af3685b35?
> 
> If so, I expect the -stable people will have trouble backporting this. 
> If so, they'll report it and shall ask for a reworked version.

This seems blame to a very old commit (perhaps 1afc32b95233?), since it
was designed to trust the on-disk block.
So I don't add a fixes tag for it.

Thanks,
Joseph

