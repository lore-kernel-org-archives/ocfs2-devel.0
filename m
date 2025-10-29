Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FEA2D24BF
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761731566; cv=none; b=fiOnIjIkysSBV+Os1Ac4sm3xZBx4yC1IWO1RkPofE+WiopPYTPTx99PaIRK7aBrWxuhe+q7GITDHpUN7zkiEaUVtHuKwYF/jojYkjnLwOnHjivCQ4bjz/6XJ6K9kRURHOVtJs0RRDh0kRXJgw+WdIHV1bEHJiFh5F5l09gtorUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761731566; c=relaxed/simple;
	bh=cFwnsbXtX7WtMLHN4cBtEtF/fhclWxYy8pErzhjLqZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQEkmCSiEB0x9fWuzp/LD4mOmYu9XUExrk32s4Rh8Sec2nMNwDkecfkSOwsEw9QukdYjBEE7ZSQ5rMisfb3nNzoCBxYkhRCHgowNczc2VsXQCYrleV1h+W/9cti5tdvT5sdox6dpb5+S5VhRnxUTFICtPKTojzmvCQ36mHSKOU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ugCx+BqS; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ugCx+BqS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761731555; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q0Arv01Dbi3oSO347h0htWykW6X4mBEh6A65V9Iclzg=;
	b=ugCx+BqSC/HiJjebmfA8n8bb/eL4Ke/PafnjjgTwP0dJWiCZUvfW1uhnWm1JKkWeXqr+fSqGiOf1a/Izq+NyxSBtzJb/na3odRf3rqwboAWFhns26AvZwI4Q1CVyLHZIXTN9ImmyY08VZkNHTkMpKCicP/tqxAf1urkUbRUmGgo=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrFOp5Y_1761731554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Oct 2025 17:52:34 +0800
Message-ID: <6059d13c-0b9d-490b-b631-27f0c8a3b3d6@linux.alibaba.com>
Date: Wed, 29 Oct 2025 17:52:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Dmitry Antipov <dmantipov@yandex.ru>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <CADhLXY5pOn-URoQs10X6R_WHFJG64AFOPNQaoHPbH_7r_8OG_A@mail.gmail.com>
 <2c84781d-d022-4fa9-92e6-68cf2642381e@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2c84781d-d022-4fa9-92e6-68cf2642381e@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/29 14:54, Dmitry Antipov wrote:
> On 10/29/25 9:26 AM, Deepanshu Kartikey wrote:
>> Hi Dmitry,
>>
>> Thanks for combining the patches! The series looks good overall.  One
>> suggestion: Would it be possible to display both the corrupted and
>> expected values in the error message?
>> Like: "Invalid dinode %llu: bits per cluster %u, expected %u\n" . This
>> would help administrators understand what the correct value should be,
>> which is especially useful during fsck operations. Everything else
>> looks great!
> 
> Well, since the messages issued by ocfs2_validate_inode_block() are quite
> brief, I just fit it into common style, and would prefer to leave the final
> decision to the maintainer.

Seems fine, the expected bpc can simply gotten using ocfs2 tools.

Joseph

