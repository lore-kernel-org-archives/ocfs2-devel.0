Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340C2076A8
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079663; cv=none; b=HjpTRsLX5F+f/R13KEf6n+3tt/hXXbRXUsasbJz5K2ejUG5rqw2QYMRZ3Jj2C+TQbNQTIYdBDqgTDdOZRnmj2tHTLibp89NtBSTcPi7ex7pzYakffeSjF27X6C9dFyA6CoeB7whe7ZkJyXGGszpv7tt8uCIN4EyhP7zNyJy9PTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079663; c=relaxed/simple;
	bh=gY+6WWtPwsCHLipGdXnc1Da0sB/CldWSjMb/9TdeQKY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=afI2OybG8W/A2MEELyw1o0S5J8zkQi+JnFyRCKrm3rZd925IWvl+bbMRjQf3iUzn3NOnkgPEcSoSYbvQNf/lrCOJwTB0uIpQrGpklM6oecwSsIumIt1bGX0JoT2irJGK1gHvH7+0GEIPkLvNDB66SMSLawit9CbbskQaTgI9Tqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ezV2Eiaf; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ezV2Eiaf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729079658; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=f87hNWeuvH4lhjVT/Nxwn1wxSO5iwJsRdkqFkDnRmhk=;
	b=ezV2EiafZ4Uw7FrDEQP1j4wYwJzviJA9CIWwJEhiAeyTIedu4lKyFty8e1lfn63UdofSji62JZDYEWo/SNhxRF8pzB/rRWvRWvuY+927NYVvcIQlEl/tGRx3tQXH6NKV1yHhwGl0WeSGacqwvQAMyYkhcgP0is3/1SQcOj7buc8=
Received: from 30.221.129.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHHRiMh_1729079657 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Oct 2024 19:54:17 +0800
Message-ID: <5620dcea-3c3b-424f-b24c-bd574fb8ecea@linux.alibaba.com>
Date: Wed, 16 Oct 2024 19:54:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] ocfs2: pass u64 to ocfs2_truncate_inline maybe
 overflow
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Edward Adam Davis <eadavis@qq.com>, akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, l@damenly.org, linux-kernel@vger.kernel.org,
 mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <21d7a0d6-faac-4914-8907-1d7d983953f2@linux.alibaba.com>
 <tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com>
 <f34f1b3e-7b31-49ab-ad32-ad63d8194c5f@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <f34f1b3e-7b31-49ab-ad32-ad63d8194c5f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/24 7:47 PM, Joseph Qi wrote:
> 
> 
> On 10/16/24 7:43 PM, Edward Adam Davis wrote:
>> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
>> There are two reasons for this: first, the parameter value passed is greater
>> than ocfs2_max_inline_data_with_xattr, second, the start and end parameters
>> of ocfs2_truncate_inline are "unsigned int".
>>
>> So, we need to add a sanity check for byte_start and byte_len right before
>> ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
>> than ocfs2_max_inline_data_with_xattr return -EINVAL.
>>
>> Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> 
> Looks fine.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 

Fixes: 1afc32b95233 ("ocfs2: Write support for inline data")
Cc: <stable@vger.kernel.org>

>> ---
>> V1 -> V2: move sanity check to ocfs2_remove_inode_range
>> V2 -> V3: use ocfs2_max_inline_data_with_xattr return value replace UINT_MAX
>> V3 -> V4: rename variable, modify return value and comments
>>
>>  fs/ocfs2/file.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index ad131a2fc58e..47121ee4b4df 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1784,6 +1784,14 @@ int ocfs2_remove_inode_range(struct inode *inode,
>>  		return 0;
>>  
>>  	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>> +		int id_count = ocfs2_max_inline_data_with_xattr(inode->i_sb, di);
>> +
>> +		if (byte_start > id_count || byte_start + byte_len > id_count) {
>> +			ret = -EINVAL;
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>>  		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
>>  					    byte_start + byte_len, 0);
>>  		if (ret) {
> 

