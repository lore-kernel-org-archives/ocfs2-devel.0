Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A06C13210D
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 02:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724034743; cv=none; b=oJlpn09hyEcPc3ssbkkZdtvxuBHfI1gSCjHBScTthO/2e/6zMIOHSeV1RK/7IWDzTUpO3LbXoq7fuCnEmThjrFQRwQrfx/oeA2gPeHrKFHxZCMprK163yAO2VKKcMOXbmZx+7/ayYFphbO4hcnzfsXSLJA245RKGh0HfoG08qSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724034743; c=relaxed/simple;
	bh=e/L163iB+tJBzzpzCLDsO7eBBnphz6ZOhzOoOXFig3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPqooSHKBAmpt+HVhW6ZtAS9Nk8L/h6WdBlWNZ8WO5yB+eFHZ5Fch1l8GaZbWRVaEXZcXIz5l1p40s7KHKqVw6p/GqgaH8O/H4C2RgcQhZQznIYfc7PARsjW0GVSqDllT9MiNx9BzPcOxwWVnk+rucL7i5WtXmLjwkZGfcM9GPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=OXGaW2Wg; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="OXGaW2Wg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724034731; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zFYkYgLjRE203ldskhSlIkQAKM1xCUDqTaYzPVl/xrs=;
	b=OXGaW2WgqcmWI+RlofaE/BFmOYNaJgpG3P/TJVLdBuTJ9G8BUoEgW/EBxKt+4ma9RGrHcM7qHLin7t+YKSsQ70jBjTt0j0rV9dkId+7YRcnToSNMJgDdZjymsnT/o/Jm8UxTJGxTI343DGBJgz7MiCc7bGEWcE+c2A5XPSAcW80=
Received: from 30.221.129.125(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WD4rAok_1724034730)
          by smtp.aliyun-inc.com;
          Mon, 19 Aug 2024 10:32:11 +0800
Message-ID: <333c0334-112e-4ac2-9ec2-c81fe73458bc@linux.alibaba.com>
Date: Mon, 19 Aug 2024 10:32:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix unexpected zeroing of virtual disk
To: Heming Zhao <heming.zhao@suse.com>, Chi Zhiling <chizhiling@163.com>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 starzhangzsd@gmail.com, Chi Zhiling <chizhiling@kylinos.cn>,
 Shida Zhang <zhangshida@kylinos.cn>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20240815092141.1223238-1-chizhiling@163.com>
 <432954d5-3b8e-42f7-8c06-1a489281129e@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <432954d5-3b8e-42f7-8c06-1a489281129e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

BTW, ocfs2 hasn't been tested thoroughly under 64k page, so I'm afraid
there are other bugs when running ocfs2 under 64k page.

On 8/18/24 6:31 PM, Heming Zhao wrote:
> On 8/15/24 17:21, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> In a guest virtual machine, we found that there is unexpected data
>> zeroing problem detected occassionly:
>>
>> XFS (vdb): Mounting V5 Filesystem
>> XFS (vdb): Ending clean mount
>> XFS (vdb): Metadata CRC error detected at xfs_refcountbt_read_verify+0x2c/0xf0, xfs_refcountbt block 0x200028
>> XFS (vdb): Unmount and run xfs_repair
>> XFS (vdb): First 128 bytes of corrupted metadata buffer:
>> 00000000e0cd2f5e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000cafd57f5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000d0298d7d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000f0698484: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000adb789a7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 000000005292b878: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000885b4700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> 00000000fd4b4df7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> XFS (vdb): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x200028 len 8 error 74
>> XFS (vdb): Error -117 recovering leftover CoW allocations.
>> XFS (vdb): xfs_do_force_shutdown(0x8) called from line 994 of file fs/xfs/xfs_mount.c.  Return address = 000000003a53523a
>> XFS (vdb): Corruption of in-memory data detected.  Shutting down filesystem
>> XFS (vdb): Please umount the filesystem and rectify the problem(s)
>>
>> It turns out that the root cause is from the physical host machine.
>> More specifically, it is caused by the ocfs2.
>>
>> when the page_size is 64k, the block should advance by 16 each time
>> instead of 1.
>> This will lead to a wrong mapping from the page to the disk, which
>> will zero some adjacent part of the disk.
>>
>> Suggested-by: Shida Zhang <zhangshida@kylinos.cn>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   fs/ocfs2/aops.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index d6c985cc6353..1fea43c33b6b 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1187,7 +1187,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
>>             /* This is the direct io target page. */
>>           if (wc->w_pages[i] == NULL) {
>> -            p_blkno++;
>> +            p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
>>               continue;
>>           }
>>   
> 
> Looks good to me.
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
