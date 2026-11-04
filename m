Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778204;
	b=yLBIL8NfT45wmPagM9IVcLHDsg1YGZfnGfeqY1rRVm8/ekvLDxO9gDCe44mwuS0o8lBa
	 xg6TVfESz9g7GvTzfTNtXd/ogc/rfdP8CUYu47CLi8gA5UgDqn9me4mi8n7hu4It8cYi9
	 NJZcnTtvZ5wrHwkoTT/Nq+KQlCSYQDWb6ipF6HlswyPvXtInguyNjVBrBtxgJqadEMqF6
	 1KjiAhNzaXKf/VqlkehNiP/Q9gTjlfXf/hLYnM3aFZp9vB2D1a6UNbYIYkdsWsSYAejcl
	 vv+/RKLd+02+hfwZ5rJ4/9dtr+cztHDWE7F5mT1L+vgtmIRPaHHS7O1pRNQ2pfT/eeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778204;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=5hKduYDZmO0ZyDw+yuFcDnroE1QUbUuaD9pBPMc9eNA=;
	b=aDyHnskA2w9ECKM/9hwb+IEiYHLKR9pHGzijQ54MibpjW9pPgDkikfaF8TJMCaxyp1EY
	 ZNAjPC2LEe5qrL+UygwRyamj2cUJM07Iy2ftogECN5ygxwiiPwaC6Wqvm3X7mwvCHWTT0
	 nQjx6qYn2DQeymQWEr4UIrFU3PgkFzLlOuDIjkqCE1ISMgQ1NQODHjIUZ/YatYLdhMDMr
	 DP0KBWUIkxeIoUQLwwca5Pkg87PGdUZ91DXA1Xu7PkFugW3T5/kU9MEb9/v6R/B1CjYp8
	 vCAeAe7msNEnqqE3PYa63cJRgDhENSnYL2cA0RtPdSuYCfZdCpw1IESxFvTE2EeuuEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gufJ0ed+;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2D3606A326
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 07:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB2D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gufJ0ed+
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793778195; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5hKduYDZmO0ZyDw+yuFcDnroE1QUbUuaD9pBPMc9eNA=;
	b=gufJ0ed+6izILNwH+wOjcNVDEBEenS+oR4oCOjInVkz6mmEG1umJElBQMXXLaomIEkG11dCWMteoSqZX4sjochw42lggftJUgmnsiz8023K7w3h6wYfHRkeYiaMfqPcoaGA6a2a1mZPs4a8oDcvfjRcHhoHbJNp+nkiiy4FYsr4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE56Yqe_1793778193;
Received: from 30.221.129.178(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE56Yqe_1793778193 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 15:43:14 +0800
Message-ID: <f6f848f6-9fc5-4847-95f9-77efc215a61c@linux.alibaba.com>
Date: Wed, 4 Nov 2026 15:43:13 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate xattr bucket count against extent size
To: Jiale Yao <yaojiale02@163.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261028050229.124718-1-yaojiale02@163.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261028050229.124718-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/26 1:02 PM, Jiale Yao wrote:
> The first xattr bucket stores the number of valid buckets in its extent.
> Lookup and iteration trust this on-disk value even when it exceeds the
> number of buckets covered by the extent record. A corrupted value can
> therefore make them read blocks beyond the extent.
> 
> Validate the count against the extent cluster count before using it.
> Reject zero as well because every xattr extent contains at least its first
> bucket.
> 

Please describe the user effect of this issue.

Thanks,
Joseph
