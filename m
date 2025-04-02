Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B791237186
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Apr 2025 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743592096; cv=none; b=aratgkzg8cM3fyE5gvbwP4td0nivlIqdqTagGP47g69/ba6U26aGot4BHq682zsIFzJng1Pl6ArGcGEwzsZb1q6AQMp44HSEGXhJNVBPXhYdDYZpOUoP356QTTZnF+XLK3fmwKxlBIAOZmM4fJqOrlm+qvgSk+VztVs8sRf4rMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743592096; c=relaxed/simple;
	bh=M81yu4liBwkl7B/Y0hqCGiAulIRawSJvpFkpAdlw+N8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJrY+R8rczyOAth+STmSIdR0RzXLjDMS8ZHVR6dmGraChhXJHpPiH22XH3RpbuRI4lZKkGknI7wxnyKa1QgEsFYTgZLmGINflpZ+vhuVgbWMj7JV0QMB7YuEn0aV64l/M5pV4Pm2AA/g/+kCf6+wcPVJBqx8zBTi1AGR5hUZESg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V+xseo+S; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V+xseo+S"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743592085; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=muLtkfFFefyFEPB3DEk9Hh5ZgQTjjqfqGfHXUmJ1tQ4=;
	b=V+xseo+S4Jun8Y2ispp5+xGWO1Bztlqt708A3roDDXsHFVSwU+Z3qZgaXHflTrNmxe5AwDia7Dy0lV2ETI1S72jkoHkoQtIU1Qbjnz5V2u9tpSBDMv99khWDh5O6PrlvN1gddjUc+i36pEp4GWYXbj2EV4F1yl26clCJVaMPw9E=
Received: from 30.221.144.168(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WUKH.Fv_1743592084 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Apr 2025 19:08:04 +0800
Message-ID: <86bebfd8-899e-45cc-af24-fa9a14f56ebb@linux.alibaba.com>
Date: Wed, 2 Apr 2025 19:08:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fixing global bitmap allocating failure for
 discontig type
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 Heming Zhao <heming.zhao@suse.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250401142623.31223-1-heming.zhao@suse.com>
 <ca2d7fd7-c856-4187-a15a-699334fb280d@linux.alibaba.com>
 <DS7PR10MB4878B3A94101F706090A6CC5F7AF2@DS7PR10MB4878.namprd10.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <DS7PR10MB4878B3A94101F706090A6CC5F7AF2@DS7PR10MB4878.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks, I'll add you as "Tested-by".

On 2025/4/2 18:43, Gautham Ananthakrishna wrote:
> This patch also works fine.
> 
> Thanks,
> Gautham.
> ________________________________
> From: Joseph Qi <joseph.qi@linux.alibaba.com>
> Sent: Wednesday, April 2, 2025 7:02 AM
> To: Heming Zhao <heming.zhao@suse.com>; Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Cc: ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.linux.dev>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH v2] ocfs2: fixing global bitmap allocating failure for discontig type
> 
> 
> 
> On 2025/4/1 22:26, Heming Zhao wrote:
>> The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
>> fragmentation is high") introduced a regression. In the discontiguous
>> extent allocation case, ocfs2_cluster_group_search() is comparing with
>> the wrong target length, which causes allocation failure.
>>
>> Call stack:
>> ocfs2_mkdir()
>>  ocfs2_reserve_new_inode()
>>   ocfs2_reserve_suballoc_bits()
>>    ocfs2_block_group_alloc()
>>     ocfs2_block_group_alloc_discontig()
>>      __ocfs2_claim_clusters()
>>       ocfs2_claim_suballoc_bits()
>>        ocfs2_search_chain()
>>         ocfs2_cluster_group_search()
>>
>> Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
>> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> Looks fine.
> Gautham, could you please verify this version? Thanks.
> 
> Joseph
> 
>> ---
>> v1 -> v2: OCFS2_AC_USE_MAIN_DISCONTIG type requires separate handling,
>>           with all other types proceeding as before.
>> ---
>>  fs/ocfs2/suballoc.c | 10 ++++++++--
>>  fs/ocfs2/suballoc.h |  1 +
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index f7b483f0de2a..fde75f2af37a 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>>
>>        bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
>>                                               ac, cl);
>> -     if (PTR_ERR(bg_bh) == -ENOSPC)
>> +     if (PTR_ERR(bg_bh) == -ENOSPC) {
>> +             ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
>>                bg_bh = ocfs2_block_group_alloc_discontig(handle,
>>                                                          alloc_inode,
>>                                                          ac, cl);
>> +     }
>>        if (IS_ERR(bg_bh)) {
>>                status = PTR_ERR(bg_bh);
>>                bg_bh = NULL;
>> @@ -2365,7 +2367,8 @@ int __ocfs2_claim_clusters(handle_t *handle,
>>        BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
>>
>>        BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
>> -            && ac->ac_which != OCFS2_AC_USE_MAIN);
>> +            && ac->ac_which != OCFS2_AC_USE_MAIN
>> +            && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
>>
>>        if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
>>                WARN_ON(min_clusters > 1);
>> @@ -2429,6 +2432,9 @@ int ocfs2_claim_clusters(handle_t *handle,
>>  {
>>        unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
>>
>> +     if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
>> +             bits_wanted = min_clusters;
>> +
>>        return __ocfs2_claim_clusters(handle, ac, min_clusters,
>>                                      bits_wanted, cluster_start, num_clusters);
>>  }
>> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
>> index b481b834857d..bcf2ed4a8631 100644
>> --- a/fs/ocfs2/suballoc.h
>> +++ b/fs/ocfs2/suballoc.h
>> @@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
>>  #define OCFS2_AC_USE_MAIN  2
>>  #define OCFS2_AC_USE_INODE 3
>>  #define OCFS2_AC_USE_META  4
>> +#define OCFS2_AC_USE_MAIN_DISCONTIG  5
>>        u32    ac_which;
>>
>>        /* these are used by the chain search */
> 
> 

