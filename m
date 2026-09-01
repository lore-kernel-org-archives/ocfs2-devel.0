Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C72189F43
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 01:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788224915; cv=none; b=pgdA0DjzmAp1cCbEEHPewmlQIrbmNwS7MUiGGfByYhlsaovAkvsm2IcRnNUCD7aVhDDn9nCrEfN59FryIz4bIifwBBE24iiVRdKTvQLHOE7BzYbCaq1GwPK3JOBX7593Y65EM3J1YV1puBUZqnc9fT6cHZsmkyr+BL+d/0QDp/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788224915; c=relaxed/simple;
	bh=MJNLhpQhJGkeIF1WwTDDw3hEE3CKHIwQNpVbb5x81kI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKO2PvN488Tte0DFtPBYcdbHbiukgUWE6bxgl1DXJ1UukvrEAhA4JDRtwJgmKb1t/f5Jk+Ig9M7P5cJoS7SReUrGyqfAVUoqu5gG17IJqy0LShFvwqfSpASjXvVtyR/6uwIvjekDk/psrLzlzE43Z01dphCfE603H7gUE4kvB+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UMzoHXRx; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UMzoHXRx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788224908; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FakrPrqir8gfCjpOedoFPimPDGsbRAUjqSeFGI41yOA=;
	b=UMzoHXRxf+uyjT/CBG70koBBNun9tYlG0px4NDoAjcyveC3B9kROoQ/CuSYzp08JGpq5Fx+Hf1wksJ/fXiykWSHhtLuUopxd2XvaKJWoIcetP6bl/MJYtcHzAnKhxcCostqlPNi7weYO5yXBX2zipXaejUyy1SgZDOLl+Qivs8c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA0Vqsa_1788224906;
Received: from 30.221.129.88(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA0Vqsa_1788224906 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 09:08:26 +0800
Message-ID: <fdd373d2-0c70-4a64-b2da-50f2dac194b1@linux.alibaba.com>
Date: Tue, 1 Sep 2026 09:08:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to
 system inodes
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-2-joseph.qi@linux.alibaba.com> <apWJLyCNwqfdiRQb@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <apWJLyCNwqfdiRQb@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/31/26 10:02 PM, Heming Zhao wrote:
> On Mon, Aug 31, 2026 at 02:28:45PM +0800, Joseph Qi wrote:
>> ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
>> OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
>> mkfs.ocfs2 are allocated from the global allocator and thus
>> legitimately carry this value; regular inodes are always allocated
>> from a per-slot suballocator and hence must have a valid slot.
>>
>> If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
>> ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
>> and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
>> when the inode is deleted.  This can be triggered by an unprivileged
>> user unlinking such a corrupted file.
>>
>> Reject OCFS2_INVALID_SLOT for non-system dinodes during validation,
>> while still accepting it for system inodes.
>>
>> Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Thanks, sashiko has some review comments, I'll fix them and send v2 later.

Joseph

>> ---
>>  fs/ocfs2/inode.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 180107a11046..eda50f13ffb5 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1520,8 +1520,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>  		goto bail;
>>  	}
>>  
>> -	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
>> -	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
>> +	/*
>> +	 * Only system inodes created by mkfs.ocfs2 are allocated from the
>> +	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
>> +	 * Regular inodes are always allocated from a per-slot suballocator.
>> +	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
>> +	 * deleting it would pass the slot to get_local_system_inode() via
>> +	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
>> +	 */
>> +	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
>> +		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
>> +			rc = ocfs2_error(sb,
>> +					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
>> +					 (unsigned long long)bh->b_blocknr,
>> +					 le16_to_cpu(di->i_suballoc_slot));
>> +			goto bail;
>> +		}
>> +	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
>>  		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
>>  				 (unsigned long long)bh->b_blocknr,
>>  				 le16_to_cpu(di->i_suballoc_slot));
>> -- 
>> 2.39.3
>>

