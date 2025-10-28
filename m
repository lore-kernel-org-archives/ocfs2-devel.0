Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D7020F08C
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 05:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761630697; cv=none; b=JAk3CBKtBeXZaSCqOtTTEBsneZXgkgwP5dsNqzzj/3CKGvcq9ASLQW9OEzgNyLMopY34umU8MBv1Sjw/MZuB+mJq4Bln6Xs1QzkqYE7VkQNi5indZNbvvl7/2a3FTIDBpsmvRvnxj+aaTB+CG6tSfyvNBsz1sEqAE5+2X2iAEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761630697; c=relaxed/simple;
	bh=e1fam2Ne2ZjjxOEsbUStz/rmPPNei35wLRJ0DsQmLfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtxQdJDy9U8Eei0qePjT6gqSOj1/+s0AE5aNf3UFqZ1oqIBvSZJrwEQs8NnUma1puiVF153HM8F0rQZlLDL5aIJJQP9zm7Au/PySPN28TDwHMMwPj5v0VD124qLCOxRCx8vyDFhUmwIAannhg3xYp5XIKreWs1AzsTX8OmyLpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J435IuXU; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J435IuXU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761630686; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oeWMBZUWLtd+ufJm/UKsPOK1NABI+bQigjrSNtLmH/I=;
	b=J435IuXU5EHucyJFk9k39z32Q3qlaj+fz0NFKg6QjrHhn8UkzWeaWxSoaKG7pFZXNqUZQI2n8VswrPz+qsQDbG/aVE11pMK9BSWsAKk2y7UhIG2pmhkJKWA87MD1x64wby7Dt+Wr0Xn0KJRhdABAe/Or3VNmVx4ZPp31HrXpZGs=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrAwvGn_1761630685 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Oct 2025 13:51:25 +0800
Message-ID: <d475a54e-2f15-4235-a21f-9d217a1a9126@linux.alibaba.com>
Date: Tue, 28 Oct 2025 13:51:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with
 ocfs2_check_chain_list()
To: Heming Zhao <heming.zhao@suse.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
 syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
References: <20251027125654.312153-1-dmantipov@yandex.ru>
 <9e9f5ed7-5c37-462c-9970-3da7dd957e4e@linux.alibaba.com>
 <nxmdosp26qotev63tpeq43njfobyxpes3v4zhpb6jhmerpjhpn@ba4ylsi6nctq>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <nxmdosp26qotev63tpeq43njfobyxpes3v4zhpb6jhmerpjhpn@ba4ylsi6nctq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/28 12:08, Heming Zhao wrote:
> On Tue, Oct 28, 2025 at 09:53:06AM +0800, Joseph Qi wrote:
>> Hi,
>> It seems that these checks can also been moved into ocfs2_validate_inode_block()?
>>
>> Thanks,
>> Joseph
> 
> The patch checks 'block group' not 'inode block', the signatures are
> different: OCFS2_GROUP_DESC_SIGNATURE vs. OCFS2_INODE_SIGNATURE.
> In my view, current code is correct.
> 

But it checks chain list, right?

Joseph
