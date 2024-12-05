Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B9DBA20
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733397121; cv=none; b=M2z5QGBNoLF8PmVjEXWSQi1PCX5/VScXhHq4LpSYp8Lp1/8PlbhbbxzTj/k9S2OI79DCA+t+cL9BK+Yu8XdZJSTXOAXkXFNBpkCL5WZ60smybkPyw+UNp3R9Nv2vVTlsSuDRqKT9ttA9bLKjgaHnEZDahsTalaySjU90+a7Ccd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733397121; c=relaxed/simple;
	bh=lUKfioYAkvaoKoTSkStAl0SHLf0+pW3lNXmWoxjyugc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Zb5KpUP2JJMoN7ikOSVSJh+//EyPigqbT2fPI8wkPsc/SVUIUa3FEoNhDyM+z8No5scbgjmNs2oh9aLgY4/fjwyu1sJOlqFQjajEBhe84kIr0REChGilwiufm3iztKDBncKvP3mhQs+JKPhu+QwJGlTB0MpI81BXZ89sG+yOsKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dHz900pX; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dHz900pX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733397111; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=hZc6AVZr9zOtvJEiLwmhPlHJW+MSKsJTeDkXJPJfHNY=;
	b=dHz900pXBRr/psSzzueZj4WtVDfWCF9/wrjK/aAuq4KqiTFwLTj7QCj8AQhJzrVJGpb3oxvtviTiIj7lx374dwK6/rLtW0MDHe/gbyIYEpWTwPII8gGGI+UI3HPOf0OVy2D+dJP8KGBwO2DgULS3xSmrakrCKWF5KW4uGjehL6M=
Received: from 30.221.131.123(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKt17b6_1733397110 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Dec 2024 19:11:51 +0800
Message-ID: <e30b2754-0d1f-4796-8690-1ad4a6192f44@linux.alibaba.com>
Date: Thu, 5 Dec 2024 19:11:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: fix the space leak in LA when releasing LA
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
References: <20241205104835.18223-1-heming.zhao@suse.com>
 <20241205104835.18223-3-heming.zhao@suse.com>
 <2a72a270-e551-4529-b900-c955cd378ef8@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <2a72a270-e551-4529-b900-c955cd378ef8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/24 7:10 PM, Joseph Qi wrote:
> 
> 
> On 12/5/24 6:48 PM, Heming Zhao wrote:
>> Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
>> introduced an issue, the ocfs2_sync_local_to_main() ignores the last
>> contiguous free bits, which causes an OCFS2 volume to lose the last free
>> clusters of LA window during the release routine.
>>
>> Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
>> when unmounting an ocfs2 volume") was reverted, this commit is a
>> replacement fix for commit dfe6c5692fb5.
>>
>> Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Cc: <stable@vger.kernel.org> # 6.10+
>> ---
>>  fs/ocfs2/localalloc.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index 5df34561c551..d1aa04a5af1b 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>>  	start = count = 0;
>>  	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
>>  
>> -	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
>> -	       left) {
>> -		if (bit_off == start) {
>> +	while (1) {
>> +		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
>> +		if ((bit_off < left) && (bit_off == start)) {
>>  			count++;
>>  			start++;
>>  			continue;
>> @@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>>  			}
>>  		}
>>  
>> +		if (bit_off >= left)
>> +			break;
>>  		count = 1;
>>  		start = bit_off + 1;
>>  	}
> 

