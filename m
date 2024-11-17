Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B4718D63A
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 12:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731846641; cv=none; b=io3wbqS8XAJOFp/ZZACc+T9HL361G+x7TqK+Pf8XOnetsyp87t+H+kVtVP32qY6yIrkXjVRs5T7aWErN6MIDgH72GJOKHIm4ljh6gKwm6kK/IFWS2O2f5XZbF0gvtBbpU2vXMtpxVk8yjs603yS9lSqe6zAmi5D7LZfpHJxQDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731846641; c=relaxed/simple;
	bh=PU7Mhc4QfIRaRXSxWJOQnRVsxdB61TboTHrYgbmxAag=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Wsjlh9dGmlpHHm9NaH3ZjAbvfUwC0KR8z/A7K498WcZ8nvwmjfHHDESpltOsz9H5g3UoUydymuvlZEnIYNG2Uj8euI2p0cnZPxDCTCVuidW+/CNR1SJ1sVSR5Ubt+hpsvgf2TRz053akMW9dFG2WjuepkwKeRb0rTMiK/36ztcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VTsWyjjp; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VTsWyjjp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731846631; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0uM7hB+QgOqsw8eKbPpEFv7cDpaoyQJO7P9vnJovadg=;
	b=VTsWyjjpqS0bBn5MM9oTiOfB4h4KQsp2jv82j9kUoffEB+sJIst4hGQUFxrnsWgUyubASWRBCPOl36sFiDoY5R9TWNxs4vtadTjg+//J1droF1842Ufv0grMvtkCo7yBcGvgV11K562qj2Yub4JP5bcH+W8MqxzIRWSySqJxImI=
Received: from 30.0.179.31(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJZMiR7_1731846629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 17 Nov 2024 20:30:30 +0800
Message-ID: <6a9c30d7-dce1-4323-bd48-0bef8084d5ea@linux.alibaba.com>
Date: Sun, 17 Nov 2024 20:30:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: replace deprecated simple_strtol with kstrtol
To: Daniel Yang <danielyangkang@gmail.com>, akpm <akpm@linux-foundation.org>
References: <20241115080018.5372-1-danielyangkang@gmail.com>
Content-Language: en-US
Cc: "open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)"
 <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241115080018.5372-1-danielyangkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/24 4:00 PM, Daniel Yang wrote:
> The function simple_strtol ignores overflows and has an awkward
> interface for error checking. Replace with the recommended kstrtol
> function leads to clearer error checking and safer conversions.
> 
> Signed-off-by: Daniel Yang <danielyangkang@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v1->v2: reuse ret and remove blank line
> 
>  fs/ocfs2/cluster/heartbeat.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 4b9f45d70..18333aa19 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
>   */
>  
> +#include "linux/kstrtox.h"
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/jiffies.h>
> @@ -1777,8 +1778,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	if (o2nm_this_node() == O2NM_MAX_NODES)
>  		goto out;
>  
> -	fd = simple_strtol(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> +	ret = kstrtol(p, 0, &fd);
> +	if (ret < 0)
>  		goto out;
>  
>  	if (fd < 0 || fd >= INT_MAX)

