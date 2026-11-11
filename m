Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794360674;
	b=05ScZNd++Q0MUvkiLaHdMdmCn9XxtXDPjY91YREbkkMM+OhurGdQXrY/i3P+nEovZrOT
	 8UWKO8oqB0dGYy84l+7Dy7J957ND51NK+oLoccaY8ADEhNsMN5/q0SaRd5X5lpfE7vHD8
	 qKRMf3DQC9gg8R+NZGwml5/cOZrKeh8f/Hah7ZYIgDC1nYwc3CctP0jcJS/jMTXneWhKx
	 i8msuhfRMajq+VpJE9082u3XDoMvnXnet5Ls7XyA2ctoBlvr5Kc5WFxogbuvIF4NeZU5f
	 CNJOMI6jiOM+UP9y9aVvNQSbwSBf1j6hkkuJ0Yzw6KSm8Nu1rGfUh1VBWLBNpErp7hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794360674;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fz7Db6YPpucPps2P9eFgAPZMsl4Z2nZBpO1+iQqdPhM=;
	b=ELGsmB4t2R5jUhlWgmUEU/XV7APZKOdzVoGBF1LISKnFouQMKxXMCkYcK+fbp866jaix
	 sduFIo3E74taHr2Tm7KsypPSrWfPenI2WyT9MbLThT3nPsqDAH9PhN7JlxrWDf3+7whwY
	 6+nzJH4/C6Vu9cWlRiSAo6DYiHySV5o+KrVzL0cwR6oEV29GudIWPz79do/ceHbPbxCGe
	 qHRa5b7UVbY0bI+WY9i5ydA3FcCLnZC5Ikytt8mFroCNilMo/nCM0SwvjrTzgk9dIdQUw
	 8qOLtz/0FMH6Mpwcb1iajsilkRIktBQW1BfbE9kQbnwyhg/2mPYU3q7qyNrQqki+l4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mq7w0PoV;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DAB606A320;
	Wed, 11 Nov 2026 01:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7DAB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mq7w0PoV
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794360664; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fz7Db6YPpucPps2P9eFgAPZMsl4Z2nZBpO1+iQqdPhM=;
	b=mq7w0PoVXCwu1IX5ivmHA8As80sOmn10inPCZOG+QhlYp6qb0mg+dgSd17z1pXOsln4JJ09DELsc+5awHi3JyuM1vG3mkZkxNGxXiVtr8wj0fz65Fmeo+JddfxQeZaPB2cDKH76kna5eWQAcDs3+9zCCKwZ7z1M/3EU9JhzwAZ0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEX6F-L_1794360662;
Received: from 30.221.145.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEX6F-L_1794360662 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 09:31:03 +0800
Message-ID: <f6cdf5d0-9468-48cb-9bfb-0cc41b46c7fe@linux.alibaba.com>
Date: Wed, 11 Nov 2026 09:31:01 +0800
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
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>,
 ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
 <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
 <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/11/26 5:52 AM, Christian Brauner wrote:
> On Fri, Oct 30, 2026 at 10:58:52AM +0800, Joseph Qi wrote:
>> ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
>> sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
>> fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:
> 
>> So it seems we should test sb_flags_mask as well?
> 
> No, that's a generic bug. I fixed that in reconfigure_super() with
> "super: keep the read-only state if a reconfiguration doesn't change it".
> That is in vfs-7.5.super (cf. [1]). This series depends on that work.
> 
> If SB_RDONLY isn't in sb_flags_mask it fills in the current read-only
> state. So ocfs2_reconfigure() sees SB_RDONLY and stays read-only. ocfs2
> is one of the 23 filesystems listed there that only look at
> fc->sb_flags.
> 

Now it looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>> The same falls out of a legacy remount whose flags omit MS_RDONLY.
> 
> No, do_remount() always passes MS_RMT_MASK which includes MS_RDONLY. A
> remount without MS_RDONLY asks for read-write.
> 
> Thanks for the review!
> 
> [1]: https://lore.kernel.org/r/20261011-work-super-fixes-core-v1-11-c727176c5b53@kernel.org


