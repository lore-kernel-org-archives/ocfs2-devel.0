Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E463306752
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 12:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315749; cv=none; b=YnfQOlBAcnKcUYcvapSEG0uQs25T3W45SvF4SESDDbd0sqWsopBCAFWlxKheckXSPOUtlBm6LHa1hOqP2KJnY03DXgQ7ABPyDUsqIaoiFNSdJU5Gmh/MxjRp+xdU4V13ABfoxReLCYT/v3iB0Li8/KSKWGwceWYMvFC9hwVCKsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315749; c=relaxed/simple;
	bh=SQO/4HZn/1CiEgn8BRIjlfZmocSemxqWAHB/yibBGGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=oN9Fg+z37B5f2ySsG0ZBScu9W3uFliapxiG2fAPiR+UNjXYyLFA0wIgUqVNQUlvpvwn/+SP16SUFkmy8FBM2fXUHN2thIflLhXHL1VH8KcHPS+9Tf8Mwk1vj4xC2xuyDO3BIRypbHj2GfinwU9qIkNX0v6MkIe05jjAcnp4IyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZDdKDrmX; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZDdKDrmX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780315738; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EKwpKXjwzV6UmvqL60oz044Di1MmnS40sQ95MxY8qfA=;
	b=ZDdKDrmXtvBWycWnHDRwXNFH+XvRBXFB76ycAXPSfEoMxyYQyqYWV8+GIrnM/duJvhshY0NJGw0c3D3LK3pZlx2de+03dumwFxN2oOK8vlZ/THk/e7Eg2eWFpI+6scSb15G581XpHNCjzIxQdT3UensESNSl/dnGEaeVkZb/hQw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X4.HjJS_1780315735;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4.HjJS_1780315735 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 20:08:55 +0800
Message-ID: <af66a30f-304d-4d29-919b-e7465b0229f7@linux.alibaba.com>
Date: Mon, 1 Jun 2026 20:08:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] Potential atomicity bug in fs/ocfs2/stack_user.c,
 between ocfs2_control_release() and ocfs2_control_install_private()
To: Ginger <ginger.jzllee@gmail.com>
References: <CAGp+u1bveavhtNyW3eCRcDdPCy6-2e5ZyC4bhTtE83n_VW8kQw@mail.gmail.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAGp+u1bveavhtNyW3eCRcDdPCy6-2e5ZyC4bhTtE83n_VW8kQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In normal o2cb operation a single ocfs2_controld daemon holds one fd, so
two concurrent valid opens are atypical.
But nothing in the code enforces single-open, so the race is genuinely
reachable.
I'll send a patch to fix it. Thanks.

On 6/1/26 5:18 PM, Ginger wrote:
> Dear Linux kernel maintainers,
> 
> My research-based static analyzer found a potential atomicity bug
> within the 'fs/ocfs2' subsystem, more specifically, in
> 'fs/ocfs2/stack_user.c'.
> 
> This potential issue is present as of git commit
> eb3f4b7426cfd2b79d65b7d37155480b32259a11 of the mainline kernel.
> 
> Potential concurrent triggering executions:
> T0:
> ocfs2_control_release
>      --> mutex_lock(&ocfs2_control_lock);
>      --> atomic_dec_and_test(&ocfs2_control_opened)
>      --> mutex_unlock(&ocfs2_control_lock);
> 
> T1:
> ocfs2_control_install_private
>     --> mutex_unlock(&ocfs2_control_lock);
>     --> atomic_inc(&ocfs2_control_opened);
> 
> The atomic_inc to 'ocfs2_control_opened' in 'ocfs2_control_install_private'
> is not protected by 'ocfs2_control_lock'.
> Therefore, it might be possible for T0 to clear ocfs2's global state after
> 'atomic_dec_and_test' gets zeroed atomic values, while T1 blindly increments
> the atomic value.
> 
> Please kindly check at your convenience. Thank you for your time and
> consideration.
> 
> Best regards,
> Ginger

