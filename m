Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB384A3E
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Jun 2025 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750131963; cv=none; b=osGY+BYc45VLMTRKCYSHtVIhUhWx7RYwlG8ytJShVBgFyBqFh66bEvlpQEnZgXj6MZnRMqSK4YX0t0nwqAOu1EvL48/+njAxwj7K+/8fldXL0aAsLf6X+UAR3eWlizY0wT1zzTrM9TVY8PHBfItgvQIkTNOLbea148wNCS8xPso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750131963; c=relaxed/simple;
	bh=EVmPOSuwAmSIzBpYblPdbnWUzE8rHXEf3JdvJyVg1V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/fRWHGNxJYPqOoW76/oy/PalC+khdKbN5NgYC0DlQY9d2rsK//hoiTuCEViwIjlpuoTvAtxuQhVtFHWauDLT9XiTYrCDEEG2QuK0s/jlK5bdPxXpg0eWLAOyhh3vYyJBhh/0nWNYKbF/l04OGXm6JAi/Kpva9s8SuobNwaLvvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dOAQ1Jh9; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dOAQ1Jh9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1750131953; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=su8AjYq1mTXuvuqEJMcdWzV7oOfzvL5oojBam3qcnoE=;
	b=dOAQ1Jh99oK9j5r9eQGRmj9+ncubiwT9b3eAuEfB3hQkJtxetpGRDbTnUAyO4ADMFqKzzmE0ZUAV6yQ+OcOBrK3RXWV+ymnmYaVOStyZYFWvcfR2Czhv1gLHb19XfZe5dUvlvTpdMzZRsqMNPcp8VfNueghP/7ja4f696l7ibO0=
Received: from 30.221.144.119(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0We7Hh50_1750131951 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Jun 2025 11:45:52 +0800
Message-ID: <cc276140-8214-42d2-9224-619906364982@linux.alibaba.com>
Date: Tue, 17 Jun 2025 11:45:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reset folio to NULL when get folio fails
To: Lizhi Xu <lizhi.xu@windriver.com>,
 syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <684efdcd.050a0220.be214.02c1.GAE@google.com>
 <20250616013140.3602219-1-lizhi.xu@windriver.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250616013140.3602219-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/6/16 09:31, Lizhi Xu wrote:
> The reproducer uses FAULT_INJECTION to make memory allocation fail, which
> causes __filemap_get_folio() to fail, when initializing w_folios[i] in
> ocfs2_grab_folios_for_write(), it only returns an error code and the value
> of w_folios[i] is the error code, which causes ocfs2_unlock_and_free_folios()
> to recycle the invalid w_folios[i] when releasing folios.
> 
> Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 40b6bce12951..89aadc6cdd87 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>  			if (IS_ERR(wc->w_folios[i])) {
>  				ret = PTR_ERR(wc->w_folios[i]);
>  				mlog_errno(ret);
> +				wc->w_folios[i] = NULL;
>  				goto out;
>  			}
>  		}

