Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7B6525E
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718414521; cv=none; b=WDzoT96vm4YY5NzLtZbam/WvSMvtKSnDyMIo+rVijdLoV2FX2GdNmCWg5ZKXI1GTH2HIJu7t8E5kkZ2D+Cc3YBMZUee5eDbcV4LXNb19p8ldj3fuAM1zkDXjMciBapatWb3xH8JLESUDu/jwYpX7+y5n5QlGUq55qkbJqTs+NEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718414521; c=relaxed/simple;
	bh=5i7YmcDFr9Ma9v+OHzkd7vU9LV2EAPSdjvhVdMBauNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qaZiSuR3beg0qm7C4wEkSBUEWXMFO6rvelTtXtBgzsSc9GIJUVfs8vY+r4O1eD8nlQwOVW2IahlZv535q8bK73bZEpvLomtXCLkJLDwzpCbLOim2ELlDb/c/Dnkn57uaC+LuInQKudLE3pV83NBi5ZU8h6ntIjpZAUEWNvrnToM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZymF0nzU; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZymF0nzU"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e724bc46c4so29286981fa.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 18:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718414516; x=1719019316; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QedNufGBaw/BqYgaJqHLOX7/+H0aUoxhOUKQcGDATsA=;
        b=ZymF0nzU9mYlST2gj9+yO+I4fWKgpE1mpW3fWMOVdlndpNvFifEZYuw5pIGUTg1qC5
         8wXAjoH+FnY3WFUr19gkgVBzemLkPglZ/GVr7/ApBJo3foyKSqSFQtDtXcprhqcQ3olC
         S2L2MYJl9EaMqWfQoRquu43bpX/ITuXbULaHZCQ/0BpJ3xp794TDaXrxBIKW9TUVh357
         pPs/dCe9MS3nrgChlD9xvY+2em0YhezHp92xlmaDyDBAS19tdzDtgvrT1qNRLQBHJVW1
         d8x2MReSWjx1MkKeGqNaEGdfZP7qHUy966bPLT4nD+XB+4Umf5zcGLvAKUhM/R4ev1TK
         qjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718414516; x=1719019316;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QedNufGBaw/BqYgaJqHLOX7/+H0aUoxhOUKQcGDATsA=;
        b=iUySluUK06oqS1c0L0wdP7rFYg1mdFUBPbkGnyeL8geIBalChDvziUah8XxdChl+BP
         9qeBFkkuBlgMt4QOZQNqFQu/4svVX3sImbywlLqpHM7UOQN5sd9rgR7HQCkiwz647VUr
         vnqRk5vjxzMGuqnpzAaJi1PMXrwIHv1PcCmKxcxe1U76BPbVoPn8uufc75fiP1fPHDJ/
         jLEPMEOc9ABuo6RiC70qYQk05S5MV65x1FwKXm89h/gxnM/CY9mB9/7wglET8xy0WqmQ
         8dRVuSzcVmaMwS3icXU3qFvranU+C18PXbYFacInS0D83WcbdWwvYff+jByp91QYKJ6g
         JZRA==
X-Gm-Message-State: AOJu0YxA3DfNgVTFAlE3pcklyZ/xesUw/PtDT+znieASF+WHLah4PrOE
	EWIlQhy+zwzOXwiVK8MtOYlqNmmcTzWPANyu8PBad8CPposeMwv4QA5bVPjmE7o=
X-Google-Smtp-Source: AGHT+IGZaAELCEnNClqLTgObyzbGiDcgHtFTDZIDt3uVKCzVln7tGX0HCDNiircgUzoAxwkN2YCtKQ==
X-Received: by 2002:a2e:9c05:0:b0:2ec:1ad3:fb0a with SMTP id 38308e7fff4ca-2ec1ad3fc06mr16156281fa.43.1718414516419;
        Fri, 14 Jun 2024 18:21:56 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e5b0d4sm38889165ad.42.2024.06.14.18.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 18:21:55 -0700 (PDT)
Message-ID: <2ec660c6-6f5d-448c-8488-3924552e261f@suse.com>
Date: Sat, 15 Jun 2024 09:21:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction
 credits
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>,
 Mark Fasheh <mark@fasheh.com>
References: <20240614145243.8837-1-jack@suse.cz>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240614145243.8837-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/24 22:52, Jan Kara wrote:
> The code in ocfs2_dio_end_io_write() estimates number of necessary
> transaction credits using ocfs2_calc_extend_credits(). This however does
> not take into account that the IO could be arbitrarily large and can
> contain arbitrary number of extents. Extent tree manipulations do often
> extend the current transaction but not in all of the cases. For example
> if we have only single block extents in the tree,
> ocfs2_mark_extent_written() will end up calling
> ocfs2_replace_extent_rec() all the time and we will never extend the
> current transaction and eventually exhaust all the transaction credits
> if the IO contains many single block extents. Make sure the transaction
> always has enough credits for one extent insert before each call of
> ocfs2_mark_extent_written().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks for Jan's patch, it was used to fix a SUSE customer issue.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/aops.c        |  5 +++++
>   fs/ocfs2/journal.c     | 17 +++++++++++++++++
>   fs/ocfs2/journal.h     |  2 ++
>   fs/ocfs2/ocfs2_trace.h |  2 ++
>   4 files changed, 26 insertions(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ba790219d528..f4d7c0675651 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2371,6 +2371,11 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   	}
>   
>   	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> +		ret = ocfs2_assure_trans_credits(handle, credits);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		}
>   		ret = ocfs2_mark_extent_written(inode, &et, handle,
>   						ue->ue_cpos, 1,
>   						ue->ue_phys,
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 604fea3a26ff..4866d7d3ac57 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -445,6 +445,23 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
>   	return status;
>   }
>   
> +/*
> + * Make sure handle has at least 'nblocks' credits available. If it does not
> + * have that many credits available, we will try to extend the handle to have
> + * enough credits. If that fails, we will restart transaction to have enough
> + * credits. Similar notes regarding data consistency and locking implications
> + * as for ocfs2_extend_trans() apply here.
> + */
> +int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
> +{
> +	int old_nblks = jbd2_handle_buffer_credits(handle);
> +
> +	trace_ocfs2_assure_trans_credits(old_nblks);
> +	if (old_nblks >= nblocks)
> +		return 0;
> +	return ocfs2_extend_trans(handle, nblocks - old_nblks);
> +}
> +
>   /*
>    * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
>    * If that fails, restart the transaction & regain write access for the
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 41c9fe7e62f9..e3c3a35dc5e0 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -243,6 +243,8 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
>   int			     ocfs2_commit_trans(struct ocfs2_super *osb,
>   						handle_t *handle);
>   int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
> +int			     ocfs2_assure_trans_credits(handle_t *handle,
> +						int nblocks);
>   int			     ocfs2_allocate_extend_trans(handle_t *handle,
>   						int thresh);
>   
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index ac4fd1d5b128..6c3f4d7df7d6 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -2579,6 +2579,8 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
>   
>   DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
>   
> +DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
> +
>   DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
>   
>   DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);

