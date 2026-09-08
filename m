Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0BA2D5932;
	Tue,  8 Sep 2026 01:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830600; cv=none; b=KKQNm/+5PlJ2SaW55xsOK6wHv6tM1Ym4RY5Ep7nK1E4gPCYAAfIgPotyMjfXyS5ZxpAiaX4yNDkhvQ5pPscIZ/+P6m58nIE+FOfxAyTVcB9bShE/zjuuTNdUkexpxewI0geAIZr01MJHumdDoWOrB5+iuc2SF9vgOfmwJShw0sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830600; c=relaxed/simple;
	bh=fR7kC+3rzpvjoYvVERI016H5Lrj76/1ZoC/PSXVJvK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XlCdvmEz3JVCtTCY2TyO7c6txYcDEdpH7gi2b3MwDtpY3XIrmYdLn0u9ySJOJ+YwFPIbTdDgp0+NflH1JSgZSRTz1mX/eRYKKobt5LTdHzV9x4XMTRQCVyXU2ZB7Ej+tL/fffO52PJvFuV/kKXRqmGrwf7na8mSo3kqgmKpqtFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q+pKMqIg; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q+pKMqIg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788830592; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nD7gGh4AZ10FefEACzj9jolAeDfiEc31jFoW7AJG6Vs=;
	b=q+pKMqIg70Qlhy7VkAImsm5pLlyGNFB66RAXDL4NQ9foTi04PkAg/qFG/ZK/OppqmA9queWG1WeFiybA9Ki1oDZzRjJX0PZx7OwEoC2ZCeizP85LF0+RxPeQ1mLJU0bdyFoSI8UfFhK/1m5heDfedA2OhLuqR3UeCn28yXyu7cE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XAZebXf_1788830590;
Received: from 30.221.129.137(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAZebXf_1788830590 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 09:23:10 +0800
Message-ID: <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Date: Tue, 8 Sep 2026 09:23:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary ret variable in
 ocfs2_calc_xattr_init()
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Andrew Morton <akpm@linux-foundation.org>, kernel test robot
 <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202609040247.8B3lmoqX-lkp@intel.com>
 <20260907132202.48834-1-krystianmkaniewski@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260907132202.48834-1-krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
This has already been addressed by:
ed57836ff300 ocfs2: make ocfs2_calc_xattr_init() return void

Thanks,
Joseph

On 9/7/26 9:22 PM, Krystian Kaniewski wrote:
> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
> ocfs2_init_acl()") removed the only code that could change ret in
> ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
> and return zero directly.
> 
> This fixes the reported Coccinelle warning without changing behavior.
> 
> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..ab3b645983c9 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  			  int *want_clusters, int *xattr_credits,
>  			  int *want_meta, struct ocfs2_acl_state *acl_state)
>  {
> -	int ret = 0;
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>  	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
>  
> @@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  	}
>  
>  	if (!(s_size + a_size))
> -		return ret;
> +		return 0;
>  
>  	/*
>  	 * The max space of security xattr taken inline is
> @@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  		}
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int ocfs2_xattr_extend_allocation(struct inode *inode,
> 
> base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d

