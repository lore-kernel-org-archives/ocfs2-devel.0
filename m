Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A7C329C5D
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761791641; cv=none; b=miUuQ0mH9oPHCJ7zOup8DDKh5D1yNWqUOSM3hDv9wLWo1aK3sXH9/kt9aDvkYRskRfgDDD7l3VxbwU8/7SIdXtJrp1oROXWJf0diOzOH0Fv1Q/+jTKn7/NnwPFiWhpSkFcLMCn+tbADVOpbfS7/MqWRN5k1lVZrGr/Ipk/aIhzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761791641; c=relaxed/simple;
	bh=0Z0tjyZlu50Xve0yTqO2Tko/L2EJtgvoMg6vm/SbWAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rkY3aBeXMH6Op5N2Y6wO+ytGlcN7JQIXhZLxsZJG8j+NOqWT2PToZbBivS9UIO8UCm3CUTSHqDf5szi2S698KRSPDvk39A1OcI30JGqMZ5XR2GqIUfIJLT1n2NoQD0x7zACadsh5FVd0/AxYyAubrzjSyl/tnAiz6fL2k1xBuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GsjN9aZl; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GsjN9aZl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761791636; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gWr9MX6zeWxnXFdixnR8zkjDilh5Rg42nBIiYpODGsc=;
	b=GsjN9aZlPEHgs22h/xzKdUJiTCVloXMbPJLL7zN6h2IxA/Lp17LE+rSnXUrXmvI4sAa5hNQUFq3EeBqghP9OHBPunker2mZLG9ZjMRQHi6totBGifejIdr7jeOBRuMyNgZVtz7rWGuNX/OcICCZvXpVNfa1tLTg2UyfX5ccF4Ug=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrI61uG_1761791635 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Oct 2025 10:33:55 +0800
Message-ID: <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
Date: Thu, 30 Oct 2025 10:33:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Deepanshu Kartikey <kartikey406@gmail.com>,
 Heming Zhao <heming.zhao@suse.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/30 10:11, Deepanshu Kartikey wrote:
> Hi Heming,
> 
> Thank you for the detailed explanation! I understand the issue now.
> 
> cl_bpc stores "bits per cluster" (the log2 of cluster size in bytes),
> not "blocks per cluster".
> 
> The bug in the validation code is: u16 bpc = 1 <<
> (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
> 
> This calculates "blocks per cluster" (e.g., 4 for 4KB clusters with
> 1KB blocks), but cl_bpc on disk stores "bits" (e.g., 12 for 4KB
> clusters).
> 
> The correct validation should be: if (le16_to_cpu(cl->cl_bpc) !=
> OCFS2_SB(sb)->s_clustersize_bits)
> 

This is not correct. In mkfs:

if (rec->flags & OCFS2_CHAIN_FL) {
	......
	di->id2.i_chain.cl_bpc = s->cluster_size / s->blocksize;
	...
}

So could you please do more investigation?

Joseph


