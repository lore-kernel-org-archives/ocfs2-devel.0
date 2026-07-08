Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51AC27BF93
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jul 2026 02:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783476357; cv=none; b=afnB0vR+KpVauFGg+WKaGJVUbL3cG39Oh3gzNt3OvYdHGwT3X0uEAtwZK1joNoJmK/j0gGe+XvKssaiZ13IcCuTU2av4DICupZf6vRLcpd/uTtd76kAPO21w9wn/o0m0Pc24nkBZTECK7m7aj8yoVzwZ7kzOMI3yMkcZwFv/Ldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783476357; c=relaxed/simple;
	bh=Ga2WVHiKF3yMzSy2HxgjdLsJUL/kjaDtUF1opHs0n6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=q81Ol4dfAoe8mYdRE1t1ZJ1GGWgDl2d4VXIr+GOmur7dLLq6Z/+8bpqZ4j10TWs+dOfRWvsyj8lK1ExYtZTwPBMGsyKSqOtxbXRSxwfZ4DcCNHIrvSBd4C3ooOWc9K8SnrjgKbaubxriQbJiJrFzKgB1/5R9QQYTKK/XFd6gsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Dbq12AGO; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Dbq12AGO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783476352; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=foscbhygqeGs7TU9c3z0Ysf+g/34Qq/cqBsNTaKPvKM=;
	b=Dbq12AGO6F0UvoxlWryXc7j4eCTN20Fusa/F1wqsjGRy1T49lkz0l3U3653INlLG5H1BsPyMCqWiuU8n8+q9iOkxDxFWVgeIYiqYnHUn886tU+xwxPbu3jEuRcz7vy0q5702Yzc/7NNIyeGtDxewmCgNEuJAoNDlmF84SJhBHfY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X6g2SDg_1783476351;
Received: from 30.221.144.195(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6g2SDg_1783476351 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 08 Jul 2026 10:05:51 +0800
Message-ID: <bf7f4068-6f08-4e7b-826d-877f2be4cdf7@linux.alibaba.com>
Date: Wed, 8 Jul 2026 10:05:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Async IO with newet Linux Kernel
To: Gilberto Ferreira <gilberto.nunes32@gmail.com>
References: <CAOKSTBtn2Hw5-ii4YYTcahkQDWOFzD1TVeKK0qVZ3MbauUVreQ@mail.gmail.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Heming Zhao <heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAOKSTBtn2Hw5-ii4YYTcahkQDWOFzD1TVeKK0qVZ3MbauUVreQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/8/26 12:50 AM, Gilberto Ferreira wrote:
> Hi there
> 
> I always need to change Async IO in the Proxmox VMs to threads or
> native, in order to boot the VMs when using OCFS2 with iSCSI/FC
> storages.
> Otherwise, the vm did not boot at all.
> This happens with kernel 6.8, 6.12 and 6.14.
> Now, with Proxmox VE 9, which has kernel 7 but default, I noticed that
> is no longer required to change Async IO in order to VM boot properly.
> 
> Has something changed in the recent kernels regarding ocfs2 and Async IO?
> 

So what's the dmesg when VM can't boot on kernel 6.8, 6.12 and 6.14?

Not sure if it is caused by jbd2 credits exhaustion which is fixed by:

d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")

Thanks,
Joseph
