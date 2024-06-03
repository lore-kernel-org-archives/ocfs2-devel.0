Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77528631
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Jun 2024 03:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717386202; cv=none; b=eD9Gn9fDJtLJd6yoqq11YFeLZn82kuoCZYLg3+M6JBHh2lMcleSmH3ebd8Ni2pLGFxujpUMd7tRE+Na0FqRGlaQfh/G7uzX+EOMAbjZbE5tTy/yVIBjF5yhFFXK8bh8O1QS14Yrz/vs4TuHa3xkWTVF+TfIVBJV1ZgsNtuFS+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717386202; c=relaxed/simple;
	bh=o383vuiBsmWf+QJviVZAsKQ1dp+96qg0EHGaxhHRzN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c5H3inSkxSrhhgvKQPSrcIIjgV9qS3V2U0Xn9Gs+3yffDd5WLXtDdMckIWbSPibbTaraBNpIMyT4b3L7eSL5xki3+nqK4TmRC6FkBmbeq4xN/oe9im0l20GDkDRiK7OEO07878+CpGS22Iuj8DPtiejhN2hYwvokuSVuTrPV300=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J8o0276o; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J8o0276o"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1717386197; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9P0ilHG8AU0SsQVkdjFLJnIRfT1lqDvot4bUEYMU4U0=;
	b=J8o0276o9mKN87Y6gxUM5JMK/pDdw9FEAvKH85o+Pk+ek7N7zOGyFTBmkWBevEZt5C2OmAi/S7TXymchFc5C+AhSrwG/RZmgG//iVCrwfKXhXn+Wwx/ooqTD8yYqUDD4HHa/agLDjiOUl6Jc/DA6hBnH+cEExU/M1hQcBwwHA4E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W7gfB9Z_1717386194;
Received: from 30.221.129.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7gfB9Z_1717386194)
          by smtp.aliyun-inc.com;
          Mon, 03 Jun 2024 11:43:15 +0800
Message-ID: <c02c9dc8-0a08-43f2-b13d-8e31c0d196d6@linux.alibaba.com>
Date: Mon, 3 Jun 2024 11:43:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: fix NULL pointer dereference in
 ocfs2_abort_trigger()
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev
References: <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
 <20240602112045.1112708-1-joseph.qi@linux.alibaba.com>
 <f063b598-d5f1-471f-99e4-7d21d681ae4e@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <f063b598-d5f1-471f-99e4-7d21d681ae4e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/3/24 11:28 AM, Heming Zhao wrote:
> Hello,
> 
> This patch looks good to me. please see my comment below.
> 
> On 6/2/24 19:20, Joseph Qi wrote:
>> bdev->bd_super has been removed and commit 8887b94d9322 change the usage
>> from bdev->bd_super to b_assoc_map->host->i_sb. Since ocfs2 hasn't set
>> bh->b_assoc_map, it will trigger NULL pointer dereference when calling
>> into ocfs2_abort_trigger().
>>
>> Actually this was pointed out in history, see commit 74e364ad1b13. But
>> I've made a mistake when reviewing commit 8887b94d9322 and then
>> re-introduce this regression.
>>
>> Since we cannot revive bdev in buffer head, so fix this issue by
>> initializing all types of ocfs2 triggers when fill super, and then get
>> the specific ocfs2 trigger from ocfs2_caching_info when access journal.
>>
>> Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
>> Cc: stable@vger.kernel.org # 6.6+
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/journal.c | 182 +++++++++++++++++++++++++--------------------
>>   fs/ocfs2/ocfs2.h   |  27 +++++++
>>   fs/ocfs2/super.c   |   4 +-
>>   3 files changed, 131 insertions(+), 82 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 27c7683c7d3f..86807086b2df 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -479,12 +479,6 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
>>       return status;
>>   }
>>   -
>> -struct ocfs2_triggers {
>> -    struct jbd2_buffer_trigger_type    ot_triggers;
>> -    int                ot_offset;
>> -};
>> -
>>   static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
>>   {
>>       return container_of(triggers, struct ocfs2_triggers, ot_triggers);
>> @@ -548,85 +542,76 @@ static void ocfs2_db_frozen_trigger(struct jbd2_buffer_trigger_type *triggers,
>>   static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
>>                   struct buffer_head *bh)
>>   {
>> +    struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
>> +
>>       mlog(ML_ERROR,
>>            "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
>>            "bh->b_blocknr = %llu\n",
>>            (unsigned long)bh,
>>            (unsigned long long)bh->b_blocknr);
>>   -    ocfs2_error(bh->b_assoc_map->host->i_sb,
>> +    ocfs2_error(ot->sb,
>>               "JBD2 has aborted our journal, ocfs2 cannot continue\n");
>>   }
>>   -static struct ocfs2_triggers di_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_dinode, i_check),
>> -};
>> -
>> -static struct ocfs2_triggers eb_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_extent_block, h_check),
>> -};
>> -
>> -static struct ocfs2_triggers rb_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_refcount_block, rf_check),
>> -};
>> -
>> -static struct ocfs2_triggers gd_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_group_desc, bg_check),
>> -};
>> -
>> -static struct ocfs2_triggers db_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_db_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -};
>> +static void ocfs2_setup_csum_triggers(struct super_block *sb,
>> +                      enum ocfs2_journal_trigger_type type,
>> +                      struct ocfs2_triggers *ot)
>> +{
>> +    BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
>>   -static struct ocfs2_triggers xb_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_xattr_block, xb_check),
>> -};
>> +    switch (type) {
>> +    case OCFS2_JTR_DI:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_dinode, i_check);
>> +        break;
>> +    case OCFS2_JTR_EB:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_extent_block, h_check);
>> +        break;
>> +    case OCFS2_JTR_RB:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_refcount_block, rf_check);
>> +        break;
>> +    case OCFS2_JTR_GD:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_group_desc, bg_check);
>> +        break;
>> +    case OCFS2_JTR_DB:
>> +        ot->ot_triggers.t_frozen = ocfs2_db_frozen_trigger;
>> +        break;
>> +    case OCFS2_JTR_XB:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_xattr_block, xb_check);
>> +        break;
>> +    case OCFS2_JTR_DQ:
>> +        ot->ot_triggers.t_frozen = ocfs2_dq_frozen_trigger;
>> +        break;
>> +    case OCFS2_JTR_DR:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_dx_root_block, dr_check);
>> +        break;
>> +    case OCFS2_JTR_DL:
>> +        ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
>> +        ot->ot_offset = offsetof(struct ocfs2_dx_leaf, dl_check);
>> +        break;
>> +    case OCFS2_JTR_NONE:
>> +        /* To make compiler happy... */
>> +        return;
>> +    }
>>   -static struct ocfs2_triggers dq_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_dq_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -};
>> +    ot->ot_triggers.t_abort = ocfs2_abort_trigger;
>> +    ot->sb = sb;
>> +}
>>   -static struct ocfs2_triggers dr_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_dx_root_block, dr_check),
>> -};
>> +void ocfs2_initialize_journal_triggers(struct super_block *sb,
>> +                       struct ocfs2_triggers triggers[])
>> +{
>> +    enum ocfs2_journal_trigger_type type;
>>   -static struct ocfs2_triggers dl_triggers = {
>> -    .ot_triggers = {
>> -        .t_frozen = ocfs2_frozen_trigger,
>> -        .t_abort = ocfs2_abort_trigger,
>> -    },
>> -    .ot_offset    = offsetof(struct ocfs2_dx_leaf, dl_check),
>> -};
>> +    for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
>> +        ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
>> +}
>>     static int __ocfs2_journal_access(handle_t *handle,
>>                     struct ocfs2_caching_info *ci,
>> @@ -708,56 +693,91 @@ static int __ocfs2_journal_access(handle_t *handle,
>>   int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
>>                   struct buffer_head *bh, int type)
>>   {
>> -    return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
>> +    struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
>> +
>> +    return __ocfs2_journal_access(handle, ci, bh,
>> +                      &osb->s_journal_triggers[OCFS2_JTR_DI],
>> +                      type);
> 
> Legacy code uses a static define '&di_triggers', new code does some pointer
> converting to fetch 'trigger'. I am not GCC expert, but in my view, it's better
> to add the 'inline' attribute for some (not every) ocfs2_journal_access_xx()
> function. e.g: ocfs2_journal_access_di().
> I checked some ocfs2_journal_access_di() callers, most of callers already
> have 'osb'. If GCC could inline this functions and remove the duplicated
> pointer conversions, there could save some cpu time.
> 

Compared with the old way, it may introduce a bit overhead.
But I don't want to change the APIs to pass 'osb' directly, which will
introduce lots of changes.
Since 'co_get_super' is a simple container_of operation, I think it's
acceptable.

Thanks,
Joseph
