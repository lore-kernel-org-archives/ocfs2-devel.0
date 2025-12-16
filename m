Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F96336EFB;
	Tue, 16 Dec 2025 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765868151; cv=none; b=bNaRQyxQ9ECx4OxU2Bn+zW4hf5guzEddnlEbzoRbj9r+ydqocPQwAeVqU29a9MSkLNWWD219rnPHyfKjEFuQxWnBdPU7IHiMer/bbCgCBeH6YrG80M0s0A8lZoSRtH6NuGS93IsDeEheeBDr6xEeTaCP5hnuNOsRbLstMtmxxnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765868151; c=relaxed/simple;
	bh=0xt2uzYWQ/4qYyLaOLNvwMkno4ZlAa8RT19Ve2TLW0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSLrM5ZCHBfmN1PDcz4AmyQlmSnNuFVR9+SJj48sE3rF85Yi1oby2mWCdixVvgpqbLuxJ+bl37W7mvwam3tmmKn7ARZIA9bYWNu5vPd/SrqfOeq4VZ7C6fkCsfNtR9Iyhj1y8SP5x5+HDik1IXBwaewK+12SEEgqPG39iRBHhWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p/w4rQuP; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p/w4rQuP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765868143; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xh1sE9Qgb1IQvB3nnj1p0fV+nq9iZSsWXlykxiCdDjw=;
	b=p/w4rQuPyWozspPT1yXeLpje6X7KZH3VMBx3WrE/Tld9uSc53NoWNvy6zb9Z1GeFjPC5oqnjaeHqJ+QSCJMcFWHJ7Fp9PpphPu41Xki+ritZmpe4egIJxow2vKNhCgnpK6boMRfxcNpJ+/5tdCM7HH2zKlwLA6b8jzKPFi1sEdk=
Received: from 30.221.145.65(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuyIho7_1765868140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 14:55:41 +0800
Message-ID: <61fdf05b-de83-4009-b70f-56b0bd5f7741@linux.alibaba.com>
Date: Tue, 16 Dec 2025 14:55:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: Add validate function for slot map blocks
To: Heming Zhao <heming.zhao@suse.com>,
 Prithvi Tambewagh <activprithvi@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20251215184600.13147-1-activprithvi@gmail.com>
 <wcvwgkjd63d2taeghkojxtunk2p2gz7xtynyihgznosgpmye57@bcgd6mbyausn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <wcvwgkjd63d2taeghkojxtunk2p2gz7xtynyihgznosgpmye57@bcgd6mbyausn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/16 10:50, Heming Zhao wrote:
> On Tue, Dec 16, 2025 at 12:15:57AM +0530, Prithvi Tambewagh wrote:
>> When the filesystem is being mounted, the kernel panics while the data
>> regarding slot map allocation to the local node, is being written to the
>> disk. This occurs because the value of slot map buffer head block
>> number, which should have been greater than or equal to
>> `OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
>> of disk metadata corruption. This triggers
>> BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
>> causing the kernel to panic.
>>
>> This is fixed by introducing function ocfs2_validate_slot_map_block() to
>> validate slot map blocks. It first checks if the buffer head passed to it
>> is up to date and valid, else it panics the kernel at that point itself.
>> Further, it contains an if condition block, which checks if `bh->b_blocknr`
>> is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if yes, then ocfs2_error is
>> called, which prints the error log, for debugging purposes, and the return
>> value of ocfs2_error() is returned. If the if condition is false, value 0
>> is returned by ocfs2_validate_slot_map_block().
>>
>> This function is used as validate function in calls to ocfs2_read_blocks()
>> in ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers().
>>
>> Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
>> Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> 
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>> v3->v4:
>>  - Remove if condition in ocfs2_validate_slot_map_block() which checks if 
>>    `rc` is zero
>>  - Update commit log message 
>>
>> v3 link: https://lore.kernel.org/ocfs2-devel/tagu2npibmto5bgonhorg5krbvqho4zxsv5pulvgbtp53aobas@6qk4twoysbnz/T/#m6f357a93c9426c3d2f0c2d18d71f4c54601089ec
>>
>> v2->v3:
>>  - Create new function ocfs2_validate_slot_map_block() to validate block 
>>    number of slot map blocks, to be greater then or equal to 
>>    OCFS2_SUPER_BLOCK_BLKNO
>>  - Use ocfs2_validate_slot_map_block() in calls to ocfs2_read_blocks() in
>>    ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers()
>>  - In addition to using previously formulated if block in 
>>    ocfs2_validate_slot_map_block(), also check if the buffer head passed 
>>    in this function is up to date; if not, then kernel panics at that point
>>  - Update title of patch to 'ocfs2: Add validate function for slot map blocks'
>>
>> v2 link: https://lore.kernel.org/ocfs2-devel/nwkfpkm2wlajswykywnpt4sc6gdkesakw2sw7etuw2u2w23hul@6oby33bscwdw/T/#m39bc7dbb208e09a78e0913905c6dfdfd666f3a05
>>
>> v1->v2:
>>  - Remove usage of le16_to_cpu() from ocfs2_error()
>>  - Cast bh->b_blocknr to unsigned long long
>>  - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
>>  - Fix Sparse warnings reported in v1 by kernel test robot
>>  - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
>>    'ocfs2: fix kernel BUG in ocfs2_write_block'
>>
>> v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/#mba4a0b092d8c5ba5b390b5d6a5c3ec7bc6caa6ae
>>
>>  fs/ocfs2/slot_map.c | 27 +++++++++++++++++++++++++--
>>  1 file changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
>> index e544c704b583..ea4a68abc25b 100644
>> --- a/fs/ocfs2/slot_map.c
>> +++ b/fs/ocfs2/slot_map.c
>> @@ -44,6 +44,9 @@ struct ocfs2_slot_info {
>>  static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
>>  				    unsigned int node_num);
>>  
>> +static int ocfs2_validate_slot_map_block(struct super_block *sb,
>> +					  struct buffer_head *bh);
>> +
>>  static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
>>  				  int slot_num)
>>  {
>> @@ -132,7 +135,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
>>  	 * this is not true, the read of -1 (UINT64_MAX) will fail.
>>  	 */
>>  	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
>> -				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
>> +				si->si_bh, OCFS2_BH_IGNORE_CACHE,
>> +				ocfs2_validate_slot_map_block);
>>  	if (ret == 0) {
>>  		spin_lock(&osb->osb_lock);
>>  		ocfs2_update_slot_info(si);
>> @@ -332,6 +336,24 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
>>  	return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
>>  }
>>  
>> +static int ocfs2_validate_slot_map_block(struct super_block *sb,
>> +					  struct buffer_head *bh)
>> +{
>> +	int rc;
>> +
>> +	BUG_ON(!buffer_uptodate(bh));
>> +
>> +	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
>> +		rc = ocfs2_error(sb,
>> +				 "Invalid Slot Map Buffer Head "
>> +				 "Block Number : %llu, Should be >= %d",
>> +				 (unsigned long long)bh->b_blocknr,
>> +				 OCFS2_SUPER_BLOCK_BLKNO);
>> +		return rc;
>> +	}
>> +	return 0;
>> +}
>> +
>>  static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
>>  				  struct ocfs2_slot_info *si)
>>  {
>> @@ -383,7 +405,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
>>  
>>  		bh = NULL;  /* Acquire a fresh bh */
>>  		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
>> -					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
>> +					   1, &bh, OCFS2_BH_IGNORE_CACHE,
>> +					   ocfs2_validate_slot_map_block);
>>  		if (status < 0) {
>>  			mlog_errno(status);
>>  			goto bail;
>>
>> base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
>> -- 
>> 2.43.0
>>

