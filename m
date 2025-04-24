Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC3A70838
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745456273; cv=none; b=JNRON8RNYWCTjeZqtOKh/IL4XpH3DB5y81tqjxT5+1brtDSqrWLOB8A4cnnQnm4UPUmKooPX1oq8PfkLFxyPHI2fdUmuDDIsp/nQ0oWdJ7egJ0MroU3E3ftxKpC+HPHmnaops+C/GBBhZba532z3n1EtcbabF1ie8hCf76h3vHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745456273; c=relaxed/simple;
	bh=33AhOF/csKUTrt9UWmsPBZbHyjGABE/TO5GXXNEI8yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2fvEWHv7B1/U2B08P4JhsDKBT+hHQd7YbdoYX9XjVN4yzTYYV2GJzAOE2dlb+16QWrCitKyv3yx+R6Hu++MVIO7hzFKFMM7UZGoMyG9b9FhaIKKAMY/vNZh26fGvDUVPV3uGfO72+bWt4cAdoLCNzUawjl/QlSd/qVTGtETQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=unfKOR9h; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="unfKOR9h"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1745456266; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nrmJiuaDqK+xRzPodoqlJ9NbO2ovRRHze9J0i+AXMSg=;
	b=unfKOR9hnxYw3JghF0kOWQpnXwg2AYdl29yLSGsrG7XfN0+ayQ/yKzuREoNCZauylsmvPgKWcJwgueQvgGF6HHA9CY2spl4RS/mef9rpaHmJ3rfHdegz+mi19iKxDGeWBxuZ10B+g2kgTRfTj/v+ImKRv0Vc9eXfSAiyQ1YDL/A=
Received: from 30.221.144.173(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WXwDE2x_1745456262 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Apr 2025 08:57:42 +0800
Message-ID: <65f0265e-bcc4-48a5-9e8b-cc3aab13dde0@linux.alibaba.com>
Date: Thu, 24 Apr 2025 08:57:42 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary NULL check before
 unregister_sysctl_table()
To: Chen Ni <nichen@iscas.ac.cn>, mark@fasheh.com, jlbec@evilplan.org,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250422073051.1334310-1-nichen@iscas.ac.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250422073051.1334310-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/22 15:30, Chen Ni wrote:
> unregister_sysctl_table() checks for NULL pointers internally.
> Remove unneeded NULL check here.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/stackglue.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index ddd761cf44c8..a28c127b9934 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -691,8 +691,7 @@ static void __exit ocfs2_stack_glue_exit(void)
>  	memset(&locking_max_version, 0,
>  	       sizeof(struct ocfs2_protocol_version));
>  	ocfs2_sysfs_exit();
> -	if (ocfs2_table_header)
> -		unregister_sysctl_table(ocfs2_table_header);
> +	unregister_sysctl_table(ocfs2_table_header);
>  }
>  
>  MODULE_AUTHOR("Oracle");

