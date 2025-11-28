Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE32D592D
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764313096; cv=none; b=fqTyBmRYnJkCCaNsyIPHtdvjLlfg6Mf0KqwN2FFYeDEL5IEEDA3IWXSSLo2GjRfihHPrkcESjnX2OBmC+tG1mOlAzOF8yT3IcA4RqVF1vbqIRRRp1Lew7UQaPHLeMNKFSIR4K1AcVNKu8vAQWw7DT2G1iKZwI79FNAq2GsJBCFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764313096; c=relaxed/simple;
	bh=HLOK579ef+FaW8sWMbAzVh/1XuAIFYGEH1mBSxW9Ykg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmLnRiQxQXuISvrmWFVjuxS+rXuZyQQ3lxIw/QZiAgvzL/3Bpg7djMM+nuki95UP65op/gcgdMjXlnoyldjZNewIy7Mds6RiS0eusxMlwTm3JejI+z7LLVEOLpf3A7CIA5wbAMN2ju/ZTuv6lsQ1orXke7BrsSFQ2q+FJWOn50A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hR9lXZpR; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hR9lXZpR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764313084; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x9WzKD7CVDGTaxSaUxDiO7SriHD1Cja8CXfG3MYkrSw=;
	b=hR9lXZpRZGx5FF/bP/vZWAlsLifUMtPDEqZGiJ/5o6qWB3PfiQkAOXEAPAmlqbp32TOXTtBlmT+mTsBDbX1rogHJSrE4ysy4CR3MlabuQpYu32ciOs+UwpsMKN+NjpagjypQdbNdErpDGV21I4/BYZRirz+e8fpByVIvmCBmz9w=
Received: from 30.221.128.157(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtannmi_1764313083 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Nov 2025 14:58:03 +0800
Message-ID: <d7906e3e-a62b-40ba-8861-27a353fdca4c@linux.alibaba.com>
Date: Fri, 28 Nov 2025 14:58:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: validate inline xattr size and entry count in
 ocfs2_xattr_ibody_list
To: Heming Zhao <heming.zhao@suse.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
References: <20251120041145.33176-1-kartikey406@gmail.com>
 <2frdco53wk4kj5x6wpfsaqm5qswvsgqa72ex7qsp3zuppltsoh@bvt2zaom5w2t>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2frdco53wk4kj5x6wpfsaqm5qswvsgqa72ex7qsp3zuppltsoh@bvt2zaom5w2t>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/20 14:49, Heming Zhao wrote:
> On Thu, Nov 20, 2025 at 09:41:45AM +0530, Deepanshu Kartikey wrote:
>> Add comprehensive validation of inline xattr metadata in
>> ocfs2_xattr_ibody_list() to prevent out-of-bounds access and
>> use-after-free bugs when processing corrupted inline xattrs.
>>
>> The patch adds two critical validations:
>>
>> 1. Validates i_xattr_inline_size before use:
>>    - Ensures it does not exceed block size
>>    - Ensures it is at least large enough for xattr header
>>    - Prevents pointer arithmetic with corrupted size values that could
>>      point outside the inode block
>>
>> 2. Validates xattr entry count (xh_count):
>>    - Calculates maximum entries that can fit in the inline space
>>    - Rejects counts that exceed this limit
>>    - Prevents out-of-bounds array access in subsequent code
>>
>> Without these checks, a corrupted filesystem with invalid inline xattr
>> metadata can cause the code to access memory beyond the allocated space.
>> For example:
>> - A corrupted i_xattr_inline_size of 0 would cause header pointer
>>   calculation to point past the end of the block
>> - A corrupted xh_count of 22 with inline_size of 256 would cause
>>   array access 7 entries beyond the 15 that actually fit (the syzbot
>>   reproducer used xh_count of 20041), leading to use-after-free when
>>   accessing freed memory pages
>>
>> The validation uses the correct inline_size (from di->i_xattr_inline_size)
>> rather than block size, ensuring accurate bounds checking for inline
>> xattrs specifically.
>>
>> Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
>> Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
>> Suggested-by: Heming Zhao <heming.zhao@suse.com>
>> Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
>> Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/ [v2]
>> Link: https://lore.kernel.org/all/20251117114224.12948-1-kartikey406@gmail.com/ [v3]
>> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> LGTM
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>> Changes in v4:
>>  - Corrected commit message example: max entries is 15, not 7
>>    (pointed out by Heming Zhao)
>>
>> Changes in v3:
>>  - Moved validation from ocfs2_xattr_list_entries() to
>>    ocfs2_xattr_ibody_list() to use correct inline size calculation
>>    (suggested by Heming Zhao)
>>  - Added validation of i_xattr_inline_size before use
>>  - Added validation of xattr entry count against inline space
>>  - Changed return value to -EFSCORRUPTED for consistency
>> ---
>>  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++++--
>>  1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index d70a20d29e3e..98fd4f3f2d2d 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -971,13 +971,39 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
>>  	struct ocfs2_xattr_header *header = NULL;
>>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>  	int ret = 0;
>> +	u16 xattr_count;
>> +	size_t max_entries;
>> +	u16 inline_size;
>>  
>>  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
>>  		return ret;
>>  
>> +	inline_size = le16_to_cpu(di->i_xattr_inline_size);
>> +
>> +	/* Validate inline size is reasonable */
>> +	if (inline_size > inode->i_sb->s_blocksize ||
>> +	    inline_size < sizeof(struct ocfs2_xattr_header)) {
>> +		ocfs2_error(inode->i_sb,
>> +			    "Invalid xattr inline size %u in inode %llu\n",
>> +			    inline_size,
>> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>>  	header = (struct ocfs2_xattr_header *)
>> -		 ((void *)di + inode->i_sb->s_blocksize -
>> -		 le16_to_cpu(di->i_xattr_inline_size));
>> +		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
>> +
>> +	xattr_count = le16_to_cpu(header->xh_count);
>> +	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
>> +		       sizeof(struct ocfs2_xattr_entry);
>> +
>> +	if (xattr_count > max_entries) {
>> +		ocfs2_error(inode->i_sb,
>> +			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
>> +			    xattr_count, max_entries,
>> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
>> +		return -EFSCORRUPTED;
>> +	}
>>  
>>  	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
>>  
>> -- 
>> 2.43.0
>>

