Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AEC381C2
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 02:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724035956; cv=none; b=KWkA6kRTvc8Agu5t0UMLst+GKMB7anshqW5vcoZyJVxhTaoAqnw84qliZyIC/zk5BLc/0oyzXEbEnddTxv2EMvcd9uqVnkiZOFurhTcC9HIpVGG5l59kzHD+Mp1zYP23h7wIgRWh5b+CnMHJPlZs8lKa7EuTF/hQXO6PI4Y7FCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724035956; c=relaxed/simple;
	bh=eEkswAzufigPSZfVkrwT5ivSD7I6YVY7iquJw7A13b8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUCVHNvbfvnguy/wjqMq4gAyeIZYWc+OBwYpjA7JyTnZxgohNxYeP9qL971w/cSPeHtNhPjwcYzzJEvnX40/TbMWHUDb9Jy6FUdvTA9r/nzOrcXvlNwL9WeiaT8x1H6cwpNEMwqBGb5RXOQQPA6MOU+0TPMT0onFdYqEnZkQWVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PGoA75MN; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PGoA75MN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724035950; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZEEFnbOI9qdPAaeqWnQy/0ifprCsB9eWCuD8eWBWn5A=;
	b=PGoA75MNWDkThSdDDuC8dsD44748E1sT5NQ5Ye+Ns11Sc+E0EVZpuc4Nk5F+IfexRCiyIRiunziYLaKnmZdFqIv+r+7Sd498lpoj08o3Kgu/A3XPLwo51Uvfq0cpGO6ap6X8lBrjKx1M7BKE7WfMTmNmEfhY5gowRx/OBcqrK5E=
Received: from 30.221.129.125(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WD5AEFf_1724035949)
          by smtp.aliyun-inc.com;
          Mon, 19 Aug 2024 10:52:29 +0800
Message-ID: <e5fb0013-ea4e-4da7-89e5-6b2b0879ecc9@linux.alibaba.com>
Date: Mon, 19 Aug 2024 10:52:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix shift-out-of-bounds UBSAN bug in
 ocfs2_verify_volume()
To: Heming Zhao <heming.zhao@suse.com>, qasdev <qasdev00@gmail.com>,
 mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <Zr9XJJlZ+RzkLK/M@hostname>
 <cbd30b80-d213-4997-b447-10e455f20196@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <cbd30b80-d213-4997-b447-10e455f20196@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/18/24 7:43 PM, Heming Zhao wrote:
> On 8/16/24 21:41, qasdev wrote:
>>  From ad1ca2fd2ecf4eb7ec2c76fcbbf34639f0ad87ca Mon Sep 17 00:00:00 2001
>> From: Qasim Ijaz <qasdev00@gmail.com>
>> Date: Fri, 16 Aug 2024 02:30:25 +0100
>> Subject: [PATCH] ocfs2: Fix shift-out-of-bounds UBSAN bug in
>>   ocfs2_verify_volume()
>>

The above should be eliminated from patch body. 

>> This patch addresses a shift-out-of-bounds error in the
>> ocfs2_verify_volume() function, identified by UBSAN. The bug was triggered
>> by an invalid s_clustersize_bits value (e.g., 1548), which caused the
>> expression "1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits)"
>> to exceed the limits of a 32-bit integer,
>> leading to an out-of-bounds shift.
>>
>> Reported-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
>> Closes: https://syzkaller.appspot.com/bug?extid=f3fff775402751ebb471
>> Tested-by: syzbot <syzbot+f3fff775402751ebb471@syzkaller.appspotmail.com>
>> Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
>> ---
>>   fs/ocfs2/super.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index afee70125ae3..1e43cdca7f40 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2357,8 +2357,12 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
>>                    (unsigned long long)bh->b_blocknr);
>>           } else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
>>                   le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
>> -            mlog(ML_ERROR, "bad cluster size found: %u\n",
>> -                 1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>> +            if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 32)
>> +                mlog(ML_ERROR, "bad cluster size found: %u\n",
>> +                     1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
>> +            else
>> +                mlog(ML_ERROR, "invalid cluster size bit value: %u\n",
>> +                     le32_to_cpu(di->id2.i_super.s_clustersize_bits));
> 
> I prefer to use concise code to fix the error.
> Do you like below code?
> -        mlog(ML_ERROR, "bad cluster size found: %u\n",
> -                 1 << le32_to_cpu(di->id2.i_super.s_clustersize_bits));
> +        mlog(ML_ERROR, "bad cluster size bit found: %u\n",
> +                 le32_to_cpu(di->id2.i_super.s_clustersize_bits));
> 

Agree. qasdev, Could you please update and send v2?

Thanks,
Joseph
