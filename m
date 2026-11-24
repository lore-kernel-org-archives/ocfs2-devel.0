Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513675;
	b=lVo+SksgLD7nZ59DBcn9S3G7IN7fnA55Asiu5fPrXLlbaO0ZWfMqWdj1m/EI95DWENju
	 i5bM2ySLkCOQQg3crEGUjhVCsAaZhkV8vFxyoxRPoCpfDix3QGE4tu+BHRAQ/I9WSHelI
	 blCcdOu4YBDsxcZp9n9yNOrgVVDzflooAIUix+ffsVr/QzkJfSaEhs7cMKzU4O2KzEm+Q
	 MeC5zS+Uswzu97KAFLoKP5M1viu7BWKsBJXxdHf8LU/zHnmULR3QloDIbptFInLBkOSzH
	 TLJ+hMUsU3ryyAhMPk1tDiqndnzME+ijPzrlNjsmpWWlLl/td7gdhn0v817kpqsL3sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513675;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9UxDeIk67xuNdpXj+qBcspkYjPnMBMjpN0hb31P3JSM=;
	b=nkzpioBMf+3fAz6jElXU3+KsRVgrSQFi0K0Mu3Npx+YnU53DoucmuZjAKr5dSEkRpMUR
	 KpOeJfK7t3c45sWS4ahxmZaDyl4tbynvQqF5Ywg8Rc35TWCPFwx84++Qx/z1DXBrHJoVY
	 GXzgYHd8hL4Hq6BLVnGIoVgD9UKLoOJxitclFMsUxYoE71I4hveQJWrTvCTUuNgy1/YHR
	 S6nxYIUeC9LHa+HVxHmOlh8ci0Fcs3E5DMKjtnWgxul7VzalIP77FyzxZWlz43gon4x80
	 u7T/1qJerkWamkmtQrdvNu4sl/9QwHrcayNMwyAwUYdPEjcY74aTGwhvkStzUarHd8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="Th/igziV";
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB0606CF00
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 09:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66FB0606CF00
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Th/igziV
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795513667; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9UxDeIk67xuNdpXj+qBcspkYjPnMBMjpN0hb31P3JSM=;
	b=Th/igziVNXG4pbVRbmCRjhzHeAesbLMOhdUAyW8BjP43LiLjWr5Jt30acqy9cuGM1rA8z8GXObnMRlCZr/LVkG+av5qDWZpwDL1O9jQwUlGGdWAnw6qGj60pc4gKFuvMTuZ5ho1kL82O6gBQLYtgBp3xBZXTPeFroarKpJWbX5I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XFO828g_1795513666;
Received: from 30.221.129.142(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFO828g_1795513666 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 17:47:46 +0800
Message-ID: <e76e18a1-6506-4dd0-a920-59d4d42cea2f@linux.alibaba.com>
Date: Tue, 24 Nov 2026 17:47:45 +0800
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
Subject: Re: [RFC PATCH v10 2/3] ocfs2: switch DIO read path from buffer_head
 to iomap
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
 hch@lst.de
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261124045501.10281-1-heming.zhao@suse.com>
 <20261124045501.10281-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261124045501.10281-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/24/26 12:54 PM, Heming Zhao wrote:
> Migrates the DIO read path from the legacy buffer_head infrastructure
> to the modern and more efficient iomap framework.
> 
> Under the current code, ocfs2 holds a cluster lock during DIO via
> ocfs2_iocb_set_rw_locked(), and releases the cluster lock in
> ocfs2_dio_end_io() via ocfs2_iocb_clear_rw_locked(). The lock level is
> stashed in iocb->private.
> 
> However, iomap DIO owns that field (it stores a bio there for polled I/O
> and unconditionally clears it before calling ->end_io). Any side-channel
> state packed into iocb->private is corrupted, which trips the end_io
> lock-state check.
> 
> Instead, encode the unlock level by passing distinct iomap_dio_ops methods
> e.g.: ocfs2_iomap_dio_ops_r_pr ocfs2_iomap_dio_ops_w_pr for PRMODE or
> ocfs2_iomap_dio_ops_w_ex for EXMODE. Also note that the ops_w_{pr|ex} are
> defined in the next patch.
> 
> Additionally, the *_iter() functions use the split __iomap_dio_rw() +
> iomap_dio_complete() API so they can determine unambiguously, from the
> return value, whether the completion handler already dropped the lock
> (real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
> (no I/O issued, or buffered fallback).
> 
> The new function ocfs2_iomap_begin() performs a similar role to
> ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
> call, ocfs2_iomap_begin() can handle multiple blocks at once.
> 
> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
