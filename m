Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804654A19
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 May 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716425973; cv=none; b=iQ80DcKzJqYtSMvZa0sbq71LhfNfifwBux9O7PlepRn4YOVw5bhVDezWhaW/aHFsJUdrDEyl3mgiRTN1OnFLRjKFTb0GmX1ZH34pHO1rJXu+Kq1ukCo96CznLebdf5x/QVtfB15/+SwSUF2DwRHD0z0IXFR50wsaCW9jAs58dso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716425973; c=relaxed/simple;
	bh=L7CuOwPQ4FNgZ1yrceUKOf/K/a53gN3SkJ0n6DCzt98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cv/+TKM/CTvLL1Xz+6ukMQtbZDf++H5VPmj3kl1CqlGhSr7rmcP0sLAJjMEfSEQt3neOJ87mg392ci2nn1/tLEyYu+i/ccpFpkGpqaElq12dxLDvSIGZs4m4N4TNCiWjJdL/Z1o9Dl4DCzIOarlE3IKYnM0y66zHkubMjIWv8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=v7KO5/ye; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="v7KO5/ye"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716425962; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4u6GUWG/C+XrlEAPqSOIbwebkQSYSfmRmPEnZMtz/8Q=;
	b=v7KO5/yevxLxM9OPVCiYJ9S0lrd+eIzS1TSgGyGbK9IdPQ63lrlgaCnku514YpGkZoscns1i/cjJxm/7g84YHb4A50qvYP2LsyGjnaTPVyr7gvIqi/uEcfNkh1AkAJaCf4JBdom5MHKDuUDJn+aMG050xe1w90ZGw0EQn4zvW18=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W70dpJO_1716425960;
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W70dpJO_1716425960)
          by smtp.aliyun-inc.com;
          Thu, 23 May 2024 08:59:22 +0800
Message-ID: <54a18865-83b2-4d1c-8e23-2537c1869e18@linux.alibaba.com>
Date: Thu, 23 May 2024 08:59:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 1/2] ocfs2: add bounds checking to
 ocfs2_xattr_find_entry()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ferry Meng <mengferry@linux.alibaba.com>, lei lu <llfamsec@gmail.com>,
 ocfs2-devel@lists.linux.dev
References: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
 <20240522151512.e4ea8f2cd23037520cacc6d7@linux-foundation.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240522151512.e4ea8f2cd23037520cacc6d7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/24 6:15 AM, Andrew Morton wrote:
> On Mon, 20 May 2024 10:40:23 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> From: Ferry Meng <mengferry@linux.alibaba.com>
>>
>> From: Ferry Meng <mengferry@linux.alibaba.com>
>>
>> Add a paranoia check to make sure it doesn't stray beyond valid memory
>> region containing ocfs2 xattr entries when scanning for a match.
>> It will prevent out-of-bound access in case of crafted images.
>>
>> Reported-by: lei lu <llfamsec@gmail.com>
>> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> This should have had your signed-off-by, as you were on the patch
> delivery path.  Documentation/process/submitting-patches.rst,
> "Developer's Certificate of Origin 1.1".  I have made that change to
> the mm.git copies of these two patches.

Got it. Thanks for your time.
