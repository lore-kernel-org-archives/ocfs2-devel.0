Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBE12B83
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Jun 2024 05:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717391253; cv=none; b=XxUnwhpO1lbSUUe+m1uHQAvfuQXNCM9CoxWWpFv4bE9yN0TDRzQ63ayCNzJXdOOi3CcjI1R//6X8RSqMJW3mFTjL31MdPKGYcPVjc9+KTVyZZSi+VwwEGv4fKYjSxa8n4MFTsSsvOOylQTVru3bhWEDDvKwpeYOSPo8SwIZgAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717391253; c=relaxed/simple;
	bh=WC8+rdHWPUkhWg+ktD4YVayomVrXsbULqU1Z7yDl88s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6eqAng8belxHG/oirIxDYXhSpVkixLfhDiD6DQlgqD4efrzvo7ySvh/nYzUqMwsEUR1kgCsqY2yWvP8orOl2vLb/z4kpGzYtk9t0e8MaQ+9sFbOHhp1UKdqGDvFMO2CmdAdni31I1VPeqTZBJec93fqCKL43gZAgXdAe9klX2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VB3zmaLG; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VB3zmaLG"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e78fe9fc2bso55495051fa.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Jun 2024 22:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717391249; x=1717996049; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AZT6PFKzxA5l9467kR4zKdg/eD4itJaO5HISjY9oYe4=;
        b=VB3zmaLGZ4o/Utme9BFmFINQMggbJEVtsncIjx6YDJWj6ti6iQTc1e7I3ijI+QOXNj
         +JmL08jl/K4jv3LS7Bef9hRpPoODsQm0U8e0vxL08h6407zsBEBBLMqqhZ6cKZvI1gdq
         /NTq32FZ/ZhwdlGDXL2KK+4bV1d/WSLFhsDT0WBg+JK1Gn/8acqQvYD8SW5JBxLpUyaX
         6fM+vIYNaSd0vRaa6ezlX01ysPXZ124dAeH5CVaoicqh/C2rtHqBoX/getU5LnQXqSzD
         NQKXk3ntivpb3F8JnrHJ+f+juWbPys6oswY1h/736FzWEmSztdieaBLNG4vOLSYZ6ket
         1ULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717391249; x=1717996049;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZT6PFKzxA5l9467kR4zKdg/eD4itJaO5HISjY9oYe4=;
        b=ksQy21oufQ6yRzsaM195IC48fxlkqC+yAiXinWcqTK/vR/QVrLGvnKicMElmqLo2eA
         YOwMGPkFZCxKDDfs1fq+iI7yTtwtDu39ueiqBx9Fych1EAG6GLDA3OkxJSPM5qwGV6RU
         rL95yJmlzvcG8z4vfSMgr+juI1RQ2jvhMMEH8MfLTlgrdmxTRxnbhVwDSRxLjxkYi+c0
         bhXC4P78dgeg2z0nGarZud3PMHh560Xe0q4Srp6j5cXlTuo9jU3TxoKUFsuXtQLGWH64
         sf/EPWUP1uTA2oN/BCrSUpo/PdN2HwL7pJ7Z86cZvylKbk2t/J7xKU7Bl6QzSQ94eJvu
         c6Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXVcUVuQICUdUxnlREdXtNOYsRO43fmDDKdjJvE1pHq4U7VOQKVD5VUMZwRL74IP5Kfjp45FOgCXkvtnqBRCEaBDfa0OFx17UrlwIo=
X-Gm-Message-State: AOJu0YwFT2leXY+Qf20cEi4IedkdtHos/7ElpCEtW55kX2zFDWi6PBA3
	lbTgtnqEVLdtlxYvYXdSGlhRNr5WEJ69ASPiJzMCqjJdJyyVlz8PGykeyWNRnYQ=
X-Google-Smtp-Source: AGHT+IE/RrIbIc6eAjqdtT8/Y0v4Rk4bVDeX0T9Kv+AKR2NXdpKd8dZv6IDlw5rYrrzTwA4pYSp1ag==
X-Received: by 2002:a2e:9181:0:b0:2de:d4ef:af19 with SMTP id 38308e7fff4ca-2ea950fdc1emr55412151fa.10.1717391248645;
        Sun, 02 Jun 2024 22:07:28 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70266890d94sm1413743b3a.96.2024.06.02.22.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 22:07:28 -0700 (PDT)
Message-ID: <7fb7c469-2acf-413e-833e-6b170a62a057@suse.com>
Date: Mon, 3 Jun 2024 13:07:24 +0800
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
 <f063b598-d5f1-471f-99e4-7d21d681ae4e@suse.com>
 <c02c9dc8-0a08-43f2-b13d-8e31c0d196d6@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <c02c9dc8-0a08-43f2-b13d-8e31c0d196d6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/24 11:43, Joseph Qi wrote:
> 
> 
> On 6/3/24 11:28 AM, Heming Zhao wrote:
>> Hello,
>>
>> This patch looks good to me. please see my comment below.
>>
>> On 6/2/24 19:20, Joseph Qi wrote:
>>> bdev->bd_super has been removed and commit 8887b94d9322 change the usage
>>> from bdev->bd_super to b_assoc_map->host->i_sb. Since ocfs2 hasn't set
>>> bh->b_assoc_map, it will trigger NULL pointer dereference when calling
>>> into ocfs2_abort_trigger().
>>>
>>> Actually this was pointed out in history, see commit 74e364ad1b13. But
>>> I've made a mistake when reviewing commit 8887b94d9322 and then
>>> re-introduce this regression.
>>>
>>> Since we cannot revive bdev in buffer head, so fix this issue by
>>> initializing all types of ocfs2 triggers when fill super, and then get
>>> the specific ocfs2 trigger from ocfs2_caching_info when access journal.
>>>
>>> Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
>>> Cc: stable@vger.kernel.org # 6.6+
>>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

>>> ---
>>>    fs/ocfs2/journal.c | 182 +++++++++++++++++++++++++--------------------
>>>    fs/ocfs2/ocfs2.h   |  27 +++++++
>>>    fs/ocfs2/super.c   |   4 +-
>>>    3 files changed, 131 insertions(+), 82 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>> index 27c7683c7d3f..86807086b2df 100644
>>> --- a/fs/ocfs2/journal.c
>>> +++ b/fs/ocfs2/journal.c
>>> @@ -479,12 +479,6 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
>>>        return status;
>>>    }
>>>    -
>>> -struct ocfs2_triggers {
>>> -    struct jbd2_buffer_trigger_type    ot_triggers;
>>> -    int                ot_offset;
>>> -};
>>> -
>>>    static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
>>>    {
>>>        return container_of(triggers, struct ocfs2_triggers, ot_triggers);
>>> @@ -548,85 +542,76 @@ static void ocfs2_db_frozen_trigger(struct jbd2_buffer_trigger_type *triggers,
>>>    static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
>>>                    struct buffer_head *bh)
>>>    {
>>> +    struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
>>> +
>>>        mlog(ML_ERROR,
>>>             "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
>>>             "bh->b_blocknr = %llu\n",
>>>             (unsigned long)bh,
>>>             (unsigned long long)bh->b_blocknr);
>>>    -    ocfs2_error(bh->b_assoc_map->host->i_sb,
>>> +    ocfs2_error(ot->sb,
>>>                "JBD2 has aborted our journal, ocfs2 cannot continue\n");
>>>    }
>>>    -static struct ocfs2_triggers di_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_dinode, i_check),
>>> -};
>>> -
>>> -static struct ocfs2_triggers eb_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_extent_block, h_check),
>>> -};
>>> -
>>> -static struct ocfs2_triggers rb_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_refcount_block, rf_check),
>>> -};
>>> -
>>> -static struct ocfs2_triggers gd_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_group_desc, bg_check),
>>> -};
>>> -
>>> -static struct ocfs2_triggers db_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_db_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -};
>>> +static void ocfs2_setup_csum_triggers(struct super_block *sb,
>>> +                      enum ocfs2_journal_trigger_type type,
>>> +                      struct ocfs2_triggers *ot)
>>> +{
>>> +    BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
>>>    -static struct ocfs2_triggers xb_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_xattr_block, xb_check),
>>> -};
>>> +    switch (type) {
>>> +    case OCFS2_JTR_DI:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_dinode, i_check);
>>> +        break;
>>> +    case OCFS2_JTR_EB:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_extent_block, h_check);
>>> +        break;
>>> +    case OCFS2_JTR_RB:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_refcount_block, rf_check);
>>> +        break;
>>> +    case OCFS2_JTR_GD:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_group_desc, bg_check);
>>> +        break;
>>> +    case OCFS2_JTR_DB:
>>> +        ot->ot_triggers.t_frozen = ocfs2_db_frozen_trigger;
>>> +        break;
>>> +    case OCFS2_JTR_XB:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_xattr_block, xb_check);
>>> +        break;
>>> +    case OCFS2_JTR_DQ:
>>> +        ot->ot_triggers.t_frozen = ocfs2_dq_frozen_trigger;
>>> +        break;
>>> +    case OCFS2_JTR_DR:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_dx_root_block, dr_check);
>>> +        break;
>>> +    case OCFS2_JTR_DL:
>>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>>> +        ot->ot_offset = offsetof(struct ocfs2_dx_leaf, dl_check);
>>> +        break;
>>> +    case OCFS2_JTR_NONE:
>>> +        /* To make compiler happy... */
>>> +        return;
>>> +    }
>>>    -static struct ocfs2_triggers dq_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_dq_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -};
>>> +    ot->ot_triggers.t_abort = ocfs2_abort_trigger;
>>> +    ot->sb = sb;
>>> +}
>>>    -static struct ocfs2_triggers dr_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_dx_root_block, dr_check),
>>> -};
>>> +void ocfs2_initialize_journal_triggers(struct super_block *sb,
>>> +                       struct ocfs2_triggers triggers[])
>>> +{
>>> +    enum ocfs2_journal_trigger_type type;
>>>    -static struct ocfs2_triggers dl_triggers = {
>>> -    .ot_triggers = {
>>> -        .t_frozen = ocfs2_frozen_trigger,
>>> -        .t_abort = ocfs2_abort_trigger,
>>> -    },
>>> -    .ot_offset    = offsetof(struct ocfs2_dx_leaf, dl_check),
>>> -};
>>> +    for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
>>> +        ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
>>> +}
>>>      static int __ocfs2_journal_access(handle_t *handle,
>>>                      struct ocfs2_caching_info *ci,
>>> @@ -708,56 +693,91 @@ static int __ocfs2_journal_access(handle_t *handle,
>>>    int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
>>>                    struct buffer_head *bh, int type)
>>>    {
>>> -    return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
>>> +    struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
>>> +
>>> +    return __ocfs2_journal_access(handle, ci, bh,
>>> +                      &osb->s_journal_triggers[OCFS2_JTR_DI],
>>> +                      type);
>>
>> Legacy code uses a static define '&di_triggers', new code does some pointer
>> converting to fetch 'trigger'. I am not GCC expert, but in my view, it's better
>> to add the 'inline' attribute for some (not every) ocfs2_journal_access_xx()
>> function. e.g: ocfs2_journal_access_di().
>> I checked some ocfs2_journal_access_di() callers, most of callers already
>> have 'osb'. If GCC could inline this functions and remove the duplicated
>> pointer conversions, there could save some cpu time.
>>
> 
> Compared with the old way, it may introduce a bit overhead.
> But I don't want to change the APIs to pass 'osb' directly, which will
> introduce lots of changes.
> Since 'co_get_super' is a simple container_of operation, I think it's
> acceptable.
> 
> Thanks,
> Joseph

