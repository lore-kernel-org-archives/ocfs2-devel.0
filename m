Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A7F101DE
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734191221; cv=none; b=hJd+Fc3SJWGcETIf/Cvaz+TGF8i7lU+OoqZJO/ztXAIsIQ4OtiF46mrGAbGqy2NR2pFHJSft/+U35FLcMAH3cHmIQqZouGsfs5EQLQR0PdAhCCMIgQS5BxXsdlRvxY20SSHDx1uRvFkK36oCV9a587R9+5yIGeffvYTSPxmdPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734191221; c=relaxed/simple;
	bh=9wp1FAnf3rOfLUTTnS1odN4HcYGeWJ2bH8HRCnbh0Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hSgSshoXf1z6NgNq5B7IrUVhpIsV4Z6f2Bb1lw+NxMDcCu430N05tCcbA7n2oRa3v6cOxEziXevWNj+Y6fU4cOQOM7FnMZzwgeH/m5ipLx2mfO9pwmXc8xMnfcFLWXzR7DsbjuweoFrctSU84tKlBs9IIpxGy++HufVmfudjmVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BIzERG1Y; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BIzERG1Y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734191215; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cJTTbuOFnrqfBHRBwLu9EaGJMW5WwP+NTd8fwCGpKac=;
	b=BIzERG1YvGCCzvMj1hzu8dtnInjoDT2KJmcGB3Naf0S+HQho8szka7oyjpxv3uucKVh8WEB/7Eym2TbswRuW9jw60Ysjq+ZXep9mQNBSnqGmLpYAq3rZAkap04Io7Ps1x0UkqLGnF+0iBfCa94Tio8Y9DBBPD2xlWWkJfrr8n0M=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRsCEs_1734191214 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 23:46:55 +0800
Message-ID: <b1221c73-0080-4818-bfa7-4ebb76490684@linux.alibaba.com>
Date: Sat, 14 Dec 2024 23:46:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] ocfs2: Use a folio in ocfs2_zero_new_buffers()
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm <akpm@linux-foundation.org>, Mark Tinguely
 <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-5-willy@infradead.org>
 <bc0eecab-bb1c-45c7-b1fa-504bb56a8b06@linux.alibaba.com>
 <Z12lGy7V8MX72lBF@casper.infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <Z12lGy7V8MX72lBF@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/14 23:32, Matthew Wilcox wrote:
> On Sat, Dec 14, 2024 at 10:01:20PM +0800, Joseph Qi wrote:
>>> -static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
>>> +static void ocfs2_zero_new_buffers(struct folio *folio, size_t from, size_t to)
>>
>> Don't see why we have to change 'unsigned' to 'size_t'.
> 
> This is just part of the folio conversion process.  Three reasons:
> 
> 1. size_t is an indication to the human reader that this is a count of the
> number of bytes in memory, as opposed to anything else that an 'unsigned
> int' might be.
> 
> 2. Prepares us for folios which are larger than 2GB in size.  Yes, not
> likely to be something that ocfs2 ever supports, but on arm64 with a
> 16KiB page size, hugetlbfs at the PUD level has folios which are 64GB in
> size.  So we need to use size_t within the mm & vfs, and we should
> continue that into filesystems.
> 
> 3. It's actually more efficient.  The CPU has to insert a lot of
> zero-extend instructions when calling core code which is using size_t.

Thanks for the explanation.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
