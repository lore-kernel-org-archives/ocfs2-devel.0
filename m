Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEE194AD5
	for <ocfs2-devel@lists.linux.dev>; Sat, 12 Apr 2025 23:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744501670; cv=none; b=kwrRKtucX2OZs13RXbCgaRW1D0yD8TH6FT4p4KPXMBm6Iu4iSkQo+hPQRyEtGyimNALLaKkrr3zWLbvAOL+rjhzaVUBRwnUfHDro5cCY2bSkpFtAIntL2Iz6B13OP0X4ifAHhuIJKlPKWV26s8qCKafLkM4KNCPuuFx57pUihPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744501670; c=relaxed/simple;
	bh=YY7Muxx2VHyl2KIJgoBZZAPx6kPG48VM8wqu+PB1XSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlDgrxdwaOGz7fWZGkzi4WA9VeEAzqWpfXb6VrHjqwUgKFuGd8nqxTFlNqlXUXBPcb5a4CuwFWLqgymfdzGswRwvIoOkKUQ5GXCwhMAHiprWVGdzybOMSJ7Whh06WCTLbVWpUB/5rqPJk6sUJC6c4DwuMyuwEWHg+FAVmrAOGCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XgG7G1Bm; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XgG7G1Bm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744501658; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4jPbQvsvZBRt5p/DT1a1z0KMZ7DdFMY/fFDaSoky6pI=;
	b=XgG7G1BmMnThYoT1OFKxF146/R9X8kPIZFjru9IvVJrFcvMmclxzmInNwDkt0+R0LHNhZPiQucPSXQrqG4wMnY4xIOqx84rWefLk3xcfp62p1e6N18X6gTU5fdxAEDAwmKevxAAL/58o4BA4JcfZdtniTBQFTyX0tb5yy5W7Rt8=
Received: from 30.212.138.182(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WWZU9rC_1744501655 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 13 Apr 2025 07:47:37 +0800
Message-ID: <7de24670-89cc-4502-adbe-308bd5786f1d@linux.alibaba.com>
Date: Sun, 13 Apr 2025 07:47:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: v2 [PATCH] ocfs2: fix panic in failed foilio allocation
To: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, Changwei Ge <gechangwei@live.cn>,
 Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>,
 Mark Fasheh <mark@fasheh.com>, Matthew Wilcox <willy@infradead.org>
References: <20250411160213.19322-1-mark.tinguely@oracle.com>
 <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/4/12 00:31, Mark Tinguely wrote:
> In the page to order 0 folio conversion series, the commit
> 7e119cff9d0a, "ocfs2: convert w_pages to w_folios" and
> commit 9a5e08652dc4b, "ocfs2: use an array of folios
> instead of an array of pages", saves -ENOMEM in the
> folio array upon allocation failure and calls the folio
> array free code. The folio array free code expects either
> valid folio pointers or NULL. Finding the -ENOMEM will
> result in a panic. Fix by NULLing the error folio entry.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>

Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Fixes: 9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of pages")

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: stable@vger.kernel.org
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> ---
> v2: sorry, ocfs2_grab_folios() needs the same change.
>     the other callers do not need the change.
> ---
>  fs/ocfs2/alloc.c | 1 +
>  fs/ocfs2/aops.c  | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index b8ac85b548c7..821cb7874685 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
>          if (IS_ERR(folios[numfolios])) {
>              ret = PTR_ERR(folios[numfolios]);
>              mlog_errno(ret);
> +            folios[numfolios] = NULL;
>              goto out;
>          }
>  diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 40b6bce12951..89aadc6cdd87 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>              if (IS_ERR(wc->w_folios[i])) {
>                  ret = PTR_ERR(wc->w_folios[i]);
>                  mlog_errno(ret);
> +                wc->w_folios[i] = NULL;
>                  goto out;
>              }
>          }

