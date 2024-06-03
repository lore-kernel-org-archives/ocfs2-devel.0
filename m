Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A1F4FA
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Jun 2024 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717385318; cv=none; b=c2fX+AdWLRSOPXzW9pIK5yScPw1oJLHQaQlFjUrIVKQGSihv+0cSxH1woMVbM9EU3wxmK9JDgSaLpUzGSQSLlC6keLNXZlWjEL0ozdHAJmnRphEh9nZJiJ3xjwat5cCdCU7tp68wd9LJ4FwlXG5hdjWZQzp4+eBICk8jyf0EleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717385318; c=relaxed/simple;
	bh=Li86PU41Nt+9OBHggia7vK5vHdwg+4pdj6cpGzSs/CQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gqu0DHD5AZyYTHXa8pWwPFEEbkb+Vk2Q+sOTxInL0RuY+V+Nhk01KJinNGLkw5wXHr9z8NvWzIZ0IQxDlxuWyi9tL7Od/2zqfKKMWOAlpejuQXK6hbFTPLJLtBNEQ1rOepAw9/HhpF0aX1NwkWV3r0i0QoZ0A/kLuOe7t2zGeNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DoXV3HU2; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DoXV3HU2"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ea9386cde0so35669371fa.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Jun 2024 20:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717385313; x=1717990113; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zesscjGBqz/xsOLpYlTYeHa+sIy6zQNbni4XcoywXOk=;
        b=DoXV3HU2+Ao2XMjDyozWaApaMs2x2k5ViyyjsRZ0lCuEnOpSASzSDTSNLwj24GPHlA
         8WPG0qDRhYWN1XptvgG4I1HRzEyCywwTZOhZR4ZUPjFRXxAOnBvExT7kGUwc+oAt+Dra
         dbB5YBqBhsnaPlIdEj1TZjN5anzJPL6iY0pXjkcka9aAQYeyGKtjATrsFQZIwaW+Skhu
         dtJdpeRSXZBZWUsUOEX3b7ymid0im5S1WpJzF11S24MdyiNBsN8IzwsI7GZx7uBX2u5c
         7y0j5fEyvgz51TuhgOpZETTGBw0cMzsMa5Aps/TVnBodGLzf7pZyWdgCUQmXYJ7TsxJv
         X/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717385313; x=1717990113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zesscjGBqz/xsOLpYlTYeHa+sIy6zQNbni4XcoywXOk=;
        b=Apf70uQrdnXiOjdVV19ERZmjKNFFiWWUknlLQ3fDxxNlIMCeWsh8QlzETcgxHALjnG
         Z5qfoFjJTcqNTrNz8VlA60v6VRvJVo26dNLRze2YtDz7CSieqYHbUSJGVnGdwlqf3vdm
         nC4ljd9kWAtBT1RpiUQT651ZAxNJNKbtzVJqWFFKNmeQvQMaHdOJy0PKTiOmP8xpgLkv
         pCg1gOEYtS+CS3fKYamvc6kVWGO0aZwWzFX+NrbBjOuCNvn6w27L1pec7xMpqpcNVe6O
         ooljr1s6whP8GK5pByDnuNd5OmUh3pUVQL7VyRVh1qZbxa4HtjXyJ9sJ/nW5e8qCv7Cr
         9/xA==
X-Forwarded-Encrypted: i=1; AJvYcCWvkyI9s/QuEZrbG9wFFpEYwt9h2rzJ2X0NgLLkjZQ+ud9gG2vE3VXslyJgiKx3g6aGT++3SeVO5I+o96kaT6igwJBjhog1QjzFvRE=
X-Gm-Message-State: AOJu0YxyeXgLKVSmkavoTjKzo5JJOZPPDyGNAzCV5D9kgVT6RofNZ/5y
	/PHnROnM+IbgO3Rc2t8z02lT34Xo9RJbzkYzSYDTVV+5cZzXOBXv1gOcHq5MUst9wCfsg/wkMYr
	4
X-Google-Smtp-Source: AGHT+IFXlld2GZ3cNR6r/1mHpYM1mG2APD4PapMKj9lLREgWdcqhpHUbneTbRBQ15eWKPDx8wYkLjg==
X-Received: by 2002:a2e:b3ce:0:b0:2ea:6f45:1973 with SMTP id 38308e7fff4ca-2ea950c7f49mr53695991fa.2.1717385313434;
        Sun, 02 Jun 2024 20:28:33 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b0914dsm4715712b3a.179.2024.06.02.20.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 20:28:32 -0700 (PDT)
Message-ID: <f063b598-d5f1-471f-99e4-7d21d681ae4e@suse.com>
Date: Mon, 3 Jun 2024 11:28:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: fix NULL pointer dereference in
 ocfs2_abort_trigger()
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
References: <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
 <20240602112045.1112708-1-joseph.qi@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240602112045.1112708-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

This patch looks good to me. please see my comment below.

On 6/2/24 19:20, Joseph Qi wrote:
> bdev->bd_super has been removed and commit 8887b94d9322 change the usage
> from bdev->bd_super to b_assoc_map->host->i_sb. Since ocfs2 hasn't set
> bh->b_assoc_map, it will trigger NULL pointer dereference when calling
> into ocfs2_abort_trigger().
> 
> Actually this was pointed out in history, see commit 74e364ad1b13. But
> I've made a mistake when reviewing commit 8887b94d9322 and then
> re-introduce this regression.
> 
> Since we cannot revive bdev in buffer head, so fix this issue by
> initializing all types of ocfs2 triggers when fill super, and then get
> the specific ocfs2 trigger from ocfs2_caching_info when access journal.
> 
> Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
> Cc: stable@vger.kernel.org # 6.6+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>   fs/ocfs2/journal.c | 182 +++++++++++++++++++++++++--------------------
>   fs/ocfs2/ocfs2.h   |  27 +++++++
>   fs/ocfs2/super.c   |   4 +-
>   3 files changed, 131 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 27c7683c7d3f..86807086b2df 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -479,12 +479,6 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
>   	return status;
>   }
>   
> -
> -struct ocfs2_triggers {
> -	struct jbd2_buffer_trigger_type	ot_triggers;
> -	int				ot_offset;
> -};
> -
>   static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
>   {
>   	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
> @@ -548,85 +542,76 @@ static void ocfs2_db_frozen_trigger(struct jbd2_buffer_trigger_type *triggers,
>   static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
>   				struct buffer_head *bh)
>   {
> +	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
> +
>   	mlog(ML_ERROR,
>   	     "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
>   	     "bh->b_blocknr = %llu\n",
>   	     (unsigned long)bh,
>   	     (unsigned long long)bh->b_blocknr);
>   
> -	ocfs2_error(bh->b_assoc_map->host->i_sb,
> +	ocfs2_error(ot->sb,
>   		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
>   }
>   
> -static struct ocfs2_triggers di_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_dinode, i_check),
> -};
> -
> -static struct ocfs2_triggers eb_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_extent_block, h_check),
> -};
> -
> -static struct ocfs2_triggers rb_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_refcount_block, rf_check),
> -};
> -
> -static struct ocfs2_triggers gd_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_group_desc, bg_check),
> -};
> -
> -static struct ocfs2_triggers db_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_db_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -};
> +static void ocfs2_setup_csum_triggers(struct super_block *sb,
> +				      enum ocfs2_journal_trigger_type type,
> +				      struct ocfs2_triggers *ot)
> +{
> +	BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
>   
> -static struct ocfs2_triggers xb_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_xattr_block, xb_check),
> -};
> +	switch (type) {
> +	case OCFS2_JTR_DI:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_dinode, i_check);
> +		break;
> +	case OCFS2_JTR_EB:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_extent_block, h_check);
> +		break;
> +	case OCFS2_JTR_RB:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_refcount_block, rf_check);
> +		break;
> +	case OCFS2_JTR_GD:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_group_desc, bg_check);
> +		break;
> +	case OCFS2_JTR_DB:
> +		ot->ot_triggers.t_frozen = ocfs2_db_frozen_trigger;
> +		break;
> +	case OCFS2_JTR_XB:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_xattr_block, xb_check);
> +		break;
> +	case OCFS2_JTR_DQ:
> +		ot->ot_triggers.t_frozen = ocfs2_dq_frozen_trigger;
> +		break;
> +	case OCFS2_JTR_DR:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_dx_root_block, dr_check);
> +		break;
> +	case OCFS2_JTR_DL:
> +		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
> +		ot->ot_offset = offsetof(struct ocfs2_dx_leaf, dl_check);
> +		break;
> +	case OCFS2_JTR_NONE:
> +		/* To make compiler happy... */
> +		return;
> +	}
>   
> -static struct ocfs2_triggers dq_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_dq_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -};
> +	ot->ot_triggers.t_abort = ocfs2_abort_trigger;
> +	ot->sb = sb;
> +}
>   
> -static struct ocfs2_triggers dr_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
> -};
> +void ocfs2_initialize_journal_triggers(struct super_block *sb,
> +				       struct ocfs2_triggers triggers[])
> +{
> +	enum ocfs2_journal_trigger_type type;
>   
> -static struct ocfs2_triggers dl_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
> -};
> +	for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
> +		ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
> +}
>   
>   static int __ocfs2_journal_access(handle_t *handle,
>   				  struct ocfs2_caching_info *ci,
> @@ -708,56 +693,91 @@ static int __ocfs2_journal_access(handle_t *handle,
>   int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
>   			    struct buffer_head *bh, int type)
>   {
> -	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
> +	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
> +
> +	return __ocfs2_journal_access(handle, ci, bh,
> +				      &osb->s_journal_triggers[OCFS2_JTR_DI],
> +				      type);

Legacy code uses a static define '&di_triggers', new code does some pointer
converting to fetch 'trigger'. I am not GCC expert, but in my view, it's better
to add the 'inline' attribute for some (not every) ocfs2_journal_access_xx()
function. e.g: ocfs2_journal_access_di().
I checked some ocfs2_journal_access_di() callers, most of callers already
have 'osb'. If GCC could inline this functions and remove the duplicated
pointer conversions, there could save some cpu time.

Thanks
