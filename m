Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C854A4EEE
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 09:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068670; cv=none; b=tQ6PrKo979alpqFyew/fKB05GCNkzcy8P/wZtU1Do9eocCtbFEhxzTQYpSMTL1SiYC1ipk+xGwNEPxwIwcqyi1qjFlxmtm4eTiVPQQMT72GrJwyXMg8LDK5RVQoeXB5sKAzFX3zvXBB+L+v7wDFf/WNF+iReMfzK4P5s3vJWuu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068670; c=relaxed/simple;
	bh=rtsiP8kDc3o0j/nyufMKtmZ2cTOYlHhrZzsWss0eXDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hbd5L09lz9o17zNVPoGADUyrwI5B4nwn3v+GUrIEu59hG+KRmRd9Px6fTxJ6JTVw7bXUXWIHLIN0f+kN6ACE+QF2kFXDV5tc4T3+NVUX2JpX2Kt9jx8pbbhIkAwxx2gPfHCjUF2f+ZEBsGlzEgRmlx6j2gjmksWCW91jbn2FB6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=n8hFLrrP; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="n8hFLrrP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790068664; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zTTjGnYxlGp4uhyjHHQTGKd1EAon2yyy5nOkCWYnFGA=;
	b=n8hFLrrPdGxr3WpCiZUaeMnb9/J+B4me1GGsbUCHwuLtLgv3zKVbsavru0XvjPlXEILD1YrsWcRAc31db/r7rEcdRQKdfYoxa2LK3OAqJbularGPky+d9OG53i6qZ0YXta2JwdmQKPVbBpkg1/xVaEGpU1WasOLdgGbBdQU1llQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XBTGbzA_1790068663;
Received: from 30.221.129.227(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBTGbzA_1790068663 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 17:17:43 +0800
Message-ID: <226c8e43-c943-409d-ae6e-f2f05de6643f@linux.alibaba.com>
Date: Tue, 22 Sep 2026 17:17:42 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ocfs2: assertion failure in _ocfs2_free_suballoc_bits on a
 crafted image
To: CJ <firefly0158@163.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org
References: <6a202941.4a55.1a0c7aeef7d.Coremail.firefly0158@163.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <6a202941.4a55.1a0c7aeef7d.Coremail.firefly0158@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Out-of-date ocfs2-devel maillist, resend to ocfs2-devel@lists.linux.dev.

Joseph

On 9/22/26 1:55 PM, CJ wrote:
> 
> Hi,
> 
> 
> 
> I am reporting an issue triggered by a syzkaller reproducer on Linux
> 7.3.0-rc2. The issue is reproducible with HEAD commit
> df2908090cda368b01ff43709f51890076c56157.
> 
> 
> The reproducer mounts a crafted ocfs2 image with commit= options and then
> removes a directory, which makes ocfs2 evict the inode and release its
> suballocator bits.
> 
> 
> While freeing the bits, _ocfs2_free_suballoc_bits() reads the group
> descriptor for the target group and checks that the range it is about to
> clear fits within the group's declared bit count. The check fails and
> BUG_ON() terminates the kernel. The call path is ocfs2_evict_inode() ->
> ocfs2_wipe_inode() -> ocfs2_remove_inode() -> ocfs2_free_dinode() ->
> _ocfs2_free_suballoc_bits(), reached from vfs_rmdir() in the unlinkat
> syscall context.
> 
> 
> This looks like the on-disk group descriptor and the suballocator chain
> disagreeing about the size of the group, so the release range computed from
> the chain falls outside it. Since the image is untrusted input, reporting
> the inconsistency as a filesystem error instead of an assertion would keep
> the kernel alive. I have not determined which of the two metadata sources
> carries the inconsistent value.
> 
> 
> This failure was reported earlier against the linux-6.1 longterm series at
> https://syzkaller.appspot.com/bug?extid=3b664d98a77a329be77e, and the
> reproducer below is the one from that report. It still reproduces on the
> tested mainline kernel.
> 
> 
> Reproducer:
> 
> 
> syz reproducer:   https://pastebin.com/raw/9vVANXgZ
> console output:  https://pastebin.com/raw/AZMvqBm0
> kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=6a5cbd268406bf43
> 
> 
> Kernel:
> 
> 
> HEAD commit: df2908090cda368b01ff43709f51890076c56157
> git tree: mainline
> kernel version: 7.3.0-rc2
> tested tag: v7.3-rc2 (annotated tag object 5e036ce12de91c6fd674dad33b169c6150be2a7a)
> 
> 
> Let me know if you need more details or testing.
> 
> 
> Best regards,
> Changjian Liu 

