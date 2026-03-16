Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7965A299944
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651278; cv=none; b=ga5S3OSzXC0a0uAgVxcpDBmuzNF5DT4kxftZb05LgYln59miGKCfS1MAqkJaHI/Peg5u1dEy1crjmeN10WGBMKb78Ee8+rYiLXWWWQ7V8ZRd6h4lR1GyjdvN6S27zX04YME255Kw4+YbCOxvbY5jwtRkrNPprlwogFEXcBSY9Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651278; c=relaxed/simple;
	bh=25BWmn8vxwkogKKrcKSFbEP1n21luwGKDEFjpjGwceg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QxsUbfjCsXfXddfHZGSCzNXFLczXsqOoaoKV3rd/F9LDaDQ1WjEM2hNH9vIETIXCJY7CK2p0z66n7PGYT9plpye5UW7QA2zuFVSNEVPk1qcHrXvO+hLSNjGkclX0/8xI0m1lFWSYC6yKIYY9jH6ASs/mJ9+0N+9QTgjyhuWkLxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zbb47k9s; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zbb47k9s"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773651267; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QTYKu8qef6OUmc9LDLnvS0NDPtNj7ibgYB4xMOgUO2M=;
	b=Zbb47k9s2noTff6Bn1avibQr4kYdPVAkqr2CJm4fl9VHGIYThuJrU4ZmniszdDxg2M7EoBFumDis3tHhTCy3kSOANZyZpfKUoClKGmXkGqCAwiQtI1TETS8+YfqgrAjpFTYJWwYumVyZivoAjNJTe7O0/fJtMvqC9rxRO9BMygk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.1hs04_1773651266;
Received: from 30.221.129.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.1hs04_1773651266 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 16:54:26 +0800
Message-ID: <56a5f4eb-05de-4463-b37c-b7b70873b389@linux.alibaba.com>
Date: Mon, 16 Mar 2026 16:54:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: dlm: validate bit index in refmap helpers
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, klaudia@vidocsecurity.com,
 dawid@vidocsecurity.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260313214254.2594762-1-qguanni@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260313214254.2594762-1-qguanni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/14/26 5:42 AM, Jenny Guanni Qu wrote:
> dlm_lockres_set_refmap_bit() and dlm_lockres_clear_refmap_bit() pass
> the bit parameter directly to set_bit()/clear_bit() on res->refmap
> without checking that it is within O2NM_MAX_NODES. Since refmap is
> sized for exactly O2NM_MAX_NODES bits, an out-of-range value causes
> an out-of-bounds write past the bitmap.
> 
> The bit value originates from request->node_idx in network message
> handlers such as dlm_master_request_handler(), which do not validate
> node_idx before calling set_refmap_bit. In contrast,
> dlm_deref_lockres_handler() already checks node_idx >= O2NM_MAX_NODES.
> 
> Add bounds checks in both refmap helpers to prevent OOB writes from
> any caller.
> 
> The OOB write pattern was confirmed with KASAN using a test module
> that calls set_bit() with an out-of-range index on a kmalloc'd bitmap
> matching the refmap layout.
> 

Do you have a real reproducer to trigger this OOB access?

Thanks,
Joseph
