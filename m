Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973AC31F9B7
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Jun 2026 05:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378687; cv=none; b=bWWH9+CI2sTpd7Snm8Kx+K9jTtITfuX2BsenZP4YrMi+o8c5XRDscwcYNC6JqOc9qqGwSraU9XwwCDUKcrjtjTVHTHDUl6PG37Fy9IIohqXLy9XJOkuyL43QPdNwMhElaVZM3RDJZDN6TAzdgpG4YcHrsiPg5OXZJva7Q4hCxQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378687; c=relaxed/simple;
	bh=SkEOgbB7gwWI9jDwdikT8n+oIU5YKIWaRNUAHD/Uj+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Chpx3xKAweogStoKptVQ0BHjzHkCVe/otdnJo/5+JJx060aHuOWobuKZO5xRAeT4A6onQdA1lhvksKMZTWQjixYrYuqeNI1yf0a5wQaiVFnq+tQn2k0OxMX0hTpPgijBnB6HyEE2kAujydmT9V3iQZ2tZTlEcTtJEexGzRZ/NPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z0DJNGke; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z0DJNGke"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780378680; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s2l6oaOFndq81O3ldOnhZdiCWO3jwz3y1AIN1KSvvAo=;
	b=Z0DJNGkePD3+s7YTqKAq5Twg/7YnNz/ChHJYlcVuC/cWYYZskn+k6JThgJKx5dOH35msyuo2Wu6eoN3/sQRH4Ag1S0nRRLZ/0wj2qOPk7jYhuvKxXqkxo19lhAtYohh0YKML52drS1FdcOQaC+DiJwFHCEA9WNqKM+3teKcO3eM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X43Ecx3_1780378679;
Received: from 30.221.145.10(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X43Ecx3_1780378679 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 13:38:00 +0800
Message-ID: <df399a18-1d20-446a-9ebf-91d4e3fd3330@linux.alibaba.com>
Date: Tue, 2 Jun 2026 13:37:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix race between ocfs2_control_install_private()
 and ocfs2_control_release()
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ginger <ginger.jzllee@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260601121618.1263346-1-joseph.qi@linux.alibaba.com>
 <ah5ZMguK4Pzh1DfX@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ah5ZMguK4Pzh1DfX@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/2/26 12:18 PM, Heming Zhao wrote:
> On Mon, Jun 01, 2026 at 08:16:18PM +0800, Joseph Qi wrote:
>> Move atomic_inc(&ocfs2_control_opened) and the handshake state update
>> inside ocfs2_control_lock to close a race window where
>> ocfs2_control_release() can observe ocfs2_control_opened dropping to
>> zero (resetting ocfs2_control_this_node and running_proto) while
>> ocfs2_control_install_private() is about to bump the counter and mark
>> the connection valid.
>>
>> Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
>> Reported-by: Ginger <ginger@gmail.com>
> 
> The code looks good to me, but above email address is not valid.
> The correct should be: <ginger.jzllee@gmail.com>
> 

Oops, my mistake. Thank you for pointing out this.

Thanks,
Joseph
