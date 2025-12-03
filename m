Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB2F233711
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 05:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764740892; cv=none; b=dUO/VT/XOGQs2cZkrKdfpuJm5ip8CAgNF5Fg77L6J6sTn/qjJL3qn3iLC3j6yAuGJ+UVcAaC6i3FLENsOmoKrm0CRvIYuO5WkDxXncQFjKy42LnNM3B+gNKY/Ib/dKa1J8kj67zmsReD0b4inch7qnyCU790q/QrAqZvQaQx9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764740892; c=relaxed/simple;
	bh=0CeTztsxPPjjhcEYz1x2vogYc/PvwfE5yaE1Ir5ySjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qRj+iZAMBG0xxwAvQmoybfDTi+XDCiGyYBcUnj0RTkZEnF6UmYX82dk/WB8wOOEoqaHE1UiqnEWbwyyiZqtLqk6gCsw6gBz+Fh53hvkngsiAp8omgrI0xSKhsC/fconsLZZ5qaEniDNXWtM+9JlEbnXO2kBlQgb5UvhlvNsz95g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Vmy/6Nqk; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Vmy/6Nqk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764740878; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LWe2s/JDbKDVFgxWFAijGDTOmZVmEd26vPA30uKX5vc=;
	b=Vmy/6NqkbUC64CIG8j7+uqfwcXkZZaZhE8TRZp4+d51TdHpK3/h629ELU9Eo0pkRya3fzZzcwQ1xWA3g009exlXK57wh1R3SA+XElHamXLun4f3Bq6mMCMVLHryzD/6cw6G3OLNfQiSXOtBsKGmxvfz98T3dEC6KLQGamKEg0/c=
Received: from 30.221.128.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wu-1T2Q_1764740877 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 13:47:57 +0800
Message-ID: <ac62854d-58ff-41be-bf81-6cf783cbdcb8@linux.alibaba.com>
Date: Wed, 3 Dec 2025 13:47:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] ocfs2: Avoid -Wflex-array-member-not-at-end warning
To: Heming Zhao <heming.zhao@suse.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aRKm_7aN7Smc3J5L@kspp>
 <7vsq3tvjuv3ppiot3lgithyp76r4jbbssoiiuni6zvj5pajsov@nketwax66jss>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <7vsq3tvjuv3ppiot3lgithyp76r4jbbssoiiuni6zvj5pajsov@nketwax66jss>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/17 13:32, Heming Zhao wrote:
> On Tue, Nov 11, 2025 at 12:01:19PM +0900, Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Use the new TRAILING_OVERLAP() helper to fix the following warning:
>>
>> fs/ocfs2/xattr.c:52:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
>>
>> This helper creates a union between a flexible-array member (FAM) and a
>> set of MEMBERS that would otherwise follow it.
>>
>> This overlays the trailing MEMBER struct ocfs2_extent_rec er; onto the
>> FAM struct ocfs2_xattr_value_root::xr_list.l_recs[], while keeping the
>> FAM and the start of MEMBER aligned.
>>
>> The static_assert() ensures this alignment remains, and it's
>> intentionally placed inmediately after the related structure --no
>> blank line in between.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>  fs/ocfs2/xattr.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index d70a20d29e3e..09069defd7e1 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -49,9 +49,13 @@
>>  #include "ocfs2_trace.h"
>>  
>>  struct ocfs2_xattr_def_value_root {
>> -	struct ocfs2_xattr_value_root	xv;
>> -	struct ocfs2_extent_rec		er;
>> +	/* Must be last as it ends in a flexible-array member. */
>> +	TRAILING_OVERLAP(struct ocfs2_xattr_value_root, xv, xr_list.l_recs,
>> +		struct ocfs2_extent_rec		er;
>> +	);
>>  };
>> +static_assert(offsetof(struct ocfs2_xattr_def_value_root, xv.xr_list.l_recs) ==
>> +	      offsetof(struct ocfs2_xattr_def_value_root, er));
>>  
>>  struct ocfs2_xattr_bucket {
>>  	/* The inode these xattrs are associated with */
>> -- 
>> 2.43.0
>>
>>

