Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972DD2798F8
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448530; cv=none; b=kaqJP+p3rwVzkO/w2x1tfV0xKm8tSO2KkPmo2efelj5+1xIrmG36HNvL5TH2CXGbqHopm9/GLYL3q4u2tfAYdBZ5na6gPxtKbNcsB+nz6iPpyiqWk45ouoerDNhVmIeOQru/FdfSfZFSNbLpph24f1ie2ds1YKJ+pgbRs/YFNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448530; c=relaxed/simple;
	bh=qFZ9XYDnRmDNjL7pv3XMAFeV1pKbOYwxExOW601tFFQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=X+dAkMxjULGbPMSKI07mVp2crkIheX6X0zSDXTXbgPrgKL7yPIEzqGRuDnHbzzzGIlkKqW5kGhr4muCk8JWswr4j8FPnveIm+P5mV+365fHB3K8kfG5DTg5oPTO2+Kunl+2lb3WJjjCmwCuYrM3uM2JZj0vj10A152WcHsLOgWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tx3+Lk8Y; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tx3+Lk8Y"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-87005a0e052so6789657b3.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Sep 2026 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788448529; x=1789053329; darn=lists.linux.dev;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mf2cMzcJB7ZgyTGSGNOkCh7zEnrruRaHuarVNveDD7w=;
        b=tx3+Lk8YbB99JrycR1e7Rwe28dt7fJiYm9VjQjSkb+qw0lgQvCaaFCZuETHuJzo+EG
         pFlhV1Iy86gF5CDgvkHvIgZZuUXSiFItF36c7v7m/i92lRefZox9Ji1nzVAxnPXEKNfX
         /A6IOvqDKQaXXIqA3Vmt0B1mu40HDDOmnaxgxF3UP2sV97mhaZJg5jJeZOQ0ZoKeR/rN
         bvtj1U4PMpw0QWH03e+ZvW5qANVeKdQwyq2oTMLr8niMjxDdTpMUW5KCWVhGRizuDpRD
         J/LokNYjsy7+hrV2B7EEyfAJykgR+guN5T4dDFvldkKtWHSw15xlAfR8GEf2iod1OhSa
         xDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448529; x=1789053329;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mf2cMzcJB7ZgyTGSGNOkCh7zEnrruRaHuarVNveDD7w=;
        b=i+C8k1seIL6V36lizSUi2gPTB5at6eiEN6U9fhZWUsQ4NHkTGybSSEXp4xlAS8JqIi
         jp2E714utCpW1PzWvRPA7xhlx3yAqd2+DQp7TYJ5B0HNi0fOoEMRUa8E3EBX/mzkvHsY
         4f5UveR/BvDnLrzcN6vcO4dTh4PkSTH/GxqSc225EhW2tnlpWHnzAeDssA8Tq7ULDUxy
         xNrfL3KGYN/9+bPHVgBhsHPSh0Zfm/xMfkqygAW4d5+9Andss/C8d4Sy+omrLzHmU6H+
         8tn6ayBF3yqnrGBj4dZwlx7LT6fiAtCNSkO6Orjtn7xVHEU4PF1j5ChhLe0tYO/w1+ut
         azIg==
X-Forwarded-Encrypted: i=1; AKwUvBzWQ+4bM1A8OlP1jBTejH9E7LI22fO9DCeDELuSEC/EVGX5uR2lhhxPWdGNBzVugaZGohDEBMzaWUq/Mw==@lists.linux.dev
X-Gm-Message-State: AFuF++kzfXRFxVbJnAob5/IJrHeLqEwjQRvLnLYXkChIsR2/yWbROtO6
	Z4ldFPbeBqobOk7nYc4llVE45+42QJuWxy9fSD2BS+/VVDjoUAo0O/z15Fyze06hbg==
X-Gm-Gg: AYBFou03s2r1LDCB3Nj/cq5P+B7+FKSM3L8mvjlCvWnZkrLRTYe9htJXVFVhbEJSXeU
	RjKidDz9LMx7y/cMh3vO3ZSCFpJE6VNNus1QJlyPno/HBM4eCh0tGrrxEnmdb37Bs6o3R9IaJVG
	KIRJE8MRHMbUbG3WEQXFt3Ep55FOsUASlv2aRyPCT8Mc6WhIY1+k8m9RFY8TczUrdohsrQW2CJB
	boGLcv9+8ba2Q6oSvEouBxjz1ZdFNBGOg1BEpNDxmEpzQcfxVKbyCUECXCBCoanx1D8c15lveEu
	n5wPBRIyD0I5zZWWkyA9U7IXsB6vHpN8LrdzdpGjObBk7I5vHnDrjAYrw5hShjPcnnMl8GPUO3Q
	ZG4u/skukhixpft+qiYk8Q9GkVwOB7VYxDIbnoou+YTlS7rT8IAd8qaFdUN3aUhZ3CMWBbfiHb4
	d0170FZa40z0G3T9l+5qJul3/rsQ6HyFSX/Mqm7/2kH1VLzF/MxyYZ0iin1oAG851Dr6YSGHSfN
	sLiBj/8c+YjhLujXdFvAN5KGFIM0rl43JvT/aSmjDXSko5a
X-Received: by 2002:a05:690c:30a:b0:858:def3:3422 with SMTP id 00721157ae682-86c53989a23mr76445507b3.27.1788448527781;
        Thu, 03 Sep 2026 08:15:27 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c10c9461esm43081537b3.7.2026.09.03.08.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:15:27 -0700 (PDT)
Date: Thu, 3 Sep 2026 08:15:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Jan Kara <jack@suse.cz>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
In-Reply-To: <20260903090508.1360863-4-jack@suse.cz>
Message-ID: <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
References: <20260903090053.13120-1-jack@suse.cz> <20260903090508.1360863-4-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 3 Sep 2026, Jan Kara wrote:

> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using tmpfs quota format. With suitable
> passed arguments this can actually succeed in enabling tmpfs quota
> format on top of ext4 filesystem which leads to crashes later in
> dquot_acquire().  As tmpfs quota format is intended for tmpfs
> filesystems only, verify we are indeed enabling quotas there.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Hugh Dickins <hughd@google.com>

Thanks: yes, please do route it through your tree.

> ---
>  mm/shmem_quota.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index d0b92d6da50f..a3fa4bd93e75 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -30,6 +30,7 @@
>  #include <linux/slab.h>
>  #include <linux/rbtree.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/magic.h>
>  
>  #include <linux/quotaops.h>
>  #include <linux/quota.h>
> @@ -54,6 +55,10 @@ struct quota_id {
>  
>  static int shmem_check_quota_file(struct super_block *sb, int type)
>  {
> +	/* Verify enabling happens on tmpfs superblock */
> +	if (sb->s_magic != TMPFS_MAGIC)
> +		return 0;
> +
>  	/* There is no real quota file, nothing to do */
>  	return 1;
>  }
> -- 
> 2.51.0
