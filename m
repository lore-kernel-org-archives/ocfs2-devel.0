Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D2213A86C
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 08:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762677506; cv=none; b=rhkDNqGRid3yq9wt6qG7JDNLblbvYL9NJE25DVUZfg2m2OQZA+U7wE9JO+OxyEWLBDjr4EpYCX1pt6KXRaGzu3jNxI3Cl+8Y1o995Ld4hGIYoSiDkMbMTkB5IKL6rcQt+/SD7xAOSWzs5T2YCQeOQc0edvI6/0z3AUle1PinW/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762677506; c=relaxed/simple;
	bh=lGIKVE4bepmume7jm+PwS5YnTC5uxcinRbzElPr3IHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cyKEJ4c9rsrRk1MWsGwgUwjuo3R6fPueCiXY6sxIWqIttVd/acMMEcH9KDK8Ir2Ny/03Dl9e4OfGWyf2frUP5ITAawLcq6dof+SuH5/LpZhLxoMI60wBcfbq9QZhY1OBDdDuNYd+1Nphekexj7xqIiCZ1DMJUI654FHGHkQd3EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cwQA5PzI; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cwQA5PzI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762677492; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ca2ahu63SkqU2NASmmw1gO61qV4hzY3/H4khEKnk6PI=;
	b=cwQA5PzIjSqNYy7NwbjkcVnaC59GSPMtGRHsgl8pJ2BXsm7DXQLHpuMFgxKJTj/vvXPO5mI4wz5cLfHLVeXKtOiy3WPaycDxcO3ROQEEAS4/LE85al7nPcbV0Gjb0HAukGowosFzLxCuO3f+KIY0liJt4I4kvlm04PNJqawCCiI=
Received: from 30.41.143.132(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wrxqcyt_1762677491 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 09 Nov 2025 16:38:12 +0800
Message-ID: <4c791da9-3bea-4cab-a41b-a3e1919e8e1e@linux.alibaba.com>
Date: Sun, 9 Nov 2025 16:38:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: arm build error
To: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
References: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

In which mm tree branch?

On 2025/11/9 13:23, Andrew Morton wrote:
> 
> Is anyone else seeing this?  Current mm.git, arm allmodconfig;
> 
> 
> In file included from ./include/linux/string.h:382,
>                  from ./include/linux/bitmap.h:13,
>                  from ./include/linux/cpumask.h:12,
>                  from ./include/linux/smp.h:13,
>                  from ./include/linux/lockdep.h:14,
>                  from ./include/linux/spinlock.h:63,
>                  from ./include/linux/wait.h:9,
>                  from ./include/linux/wait_bit.h:8,
>                  from ./include/linux/fs.h:7,
>                  from fs/ocfs2/xattr.c:13:
> In function 'fortify_memset_chk',
>     inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
> ./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   480 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> Callsite is
> 
> 				memset(last, 0,
> 				       sizeof(struct ocfs2_xattr_entry));
> 

