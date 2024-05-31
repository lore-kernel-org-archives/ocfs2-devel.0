Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326126FB8
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 May 2024 01:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717120473; cv=none; b=tcmwmPfvZD9am0SrbhzXzvjwwfL7oEnaF4Et6QxCccLeZ87PLQdOcksXFWhvwxnhZXizNFEFGa8AXGAMxpXRIHo01X567zblLrkL9XY/MHdg1q2Rk1SxPxb9mD3Z/+Yt9ba5KLeyW6xBgYatqi3iWKSaaJ4u2YKUX5dc28TymJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717120473; c=relaxed/simple;
	bh=PuaS6t/rkGhSyJXS4ffedJ6MEkhfBkg9mtD6fPhpxyM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XAUHNazaZ7tmOWMHRMAlIsXHtDRFoZv/5m6cwQJUr4TYlOZvNeKSW6h0t8a6MB3qkzw1KRwShSOAkcGTBiLCrkARo2a3RH/ol+AWvI6YV4kMDpcufVgxJsOHAaORQkRLHzpsQ7AWpE3z+8O3+S0tE83loikyg+I3h5sVP4XA7b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EhV/cNr6; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EhV/cNr6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1717120467; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=WO63GWhOAu4VlcMnDbuko3b8Kl/uBefaEEXYFsU9Du4=;
	b=EhV/cNr632/olXhEb9IxmQVO3EmYjYrcMVX+XfY7en8+LgoCsgsGf6KkKPWowtif2GJQCa8VwhwU7XC7NGlbJuBkGq2i5Fx1dOUL2vNPG4oEH8UZrZJVyAB51Tt8asm+gvHP0e8mpLIYElUGf9JYXZFgrVj/5Qj0Moc2WUnCFsk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W7YI4y4_1717120466;
Received: from 30.221.129.0(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7YI4y4_1717120466)
          by smtp.aliyun-inc.com;
          Fri, 31 May 2024 09:54:27 +0800
Message-ID: <e70fe1df-89b5-4345-999b-70a3e2c84596@linux.alibaba.com>
Date: Fri, 31 May 2024 09:54:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: fix NULL pointer dereference in
 ocfs2_abort_trigger()
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: ocfs2-devel@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20240530110630.3933832-1-joseph.qi@linux.alibaba.com>
 <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

This way seems to be problematic.
I'll think it more and send v2.

Thanks,
Joseph

On 5/30/24 7:06 PM, Joseph Qi wrote:
> bdev->bd_super has been removed and commit 8887b94d9322 change the usage
> from bdev->bd_super to b_assoc_map->host->i_sb. Since ocfs2 hasn't set
> bh->b_assoc_map, it will trigger NULL pointer dereference when calling
> into ocfs2_abort_trigger().
> Actually this was pointed out in history, see commit 74e364ad1b13. But
> I've made a mistake when reviewing commit 8887b94d9322 and then
> re-introduce this regression.
> Since we cannot revive bdev in buffer head, we can get super block from
> ocfs2_caching_info first and then associate it with ocfs2_triggers to
> fix this issue.
> 
> Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
> Cc: stable@vger.kernel.org # 6.6+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c | 179 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 111 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 27c7683c7d3f..1cf1ae2152e5 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -483,8 +483,24 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
>  struct ocfs2_triggers {
>  	struct jbd2_buffer_trigger_type	ot_triggers;
>  	int				ot_offset;
> +	struct super_block		*sb;
>  };
>  
> +enum ocfs2_journal_trigger_type {
> +	OCFS2_JTR_DI,
> +	OCFS2_JTR_EB,
> +	OCFS2_JTR_RB,
> +	OCFS2_JTR_GD,
> +	OCFS2_JTR_DB,
> +	OCFS2_JTR_XB,
> +	OCFS2_JTR_DQ,
> +	OCFS2_JTR_DR,
> +	OCFS2_JTR_DL,
> +	OCFS2_JTR_NONE  /* This must be the last entry */
> +};
> +
> +#define OCFS2_JOURNAL_TRIGGER_COUNT OCFS2_JTR_NONE
> +
>  static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
>  {
>  	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
> @@ -548,85 +564,67 @@ static void ocfs2_db_frozen_trigger(struct jbd2_buffer_trigger_type *triggers,
>  static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
>  				struct buffer_head *bh)
>  {
> +	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
> +
>  	mlog(ML_ERROR,
>  	     "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
>  	     "bh->b_blocknr = %llu\n",
>  	     (unsigned long)bh,
>  	     (unsigned long long)bh->b_blocknr);
>  
> -	ocfs2_error(bh->b_assoc_map->host->i_sb,
> +	ocfs2_error(ot->sb,
>  		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
>  }
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
> -
> -static struct ocfs2_triggers xb_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_xattr_block, xb_check),
> -};
> -
> -static struct ocfs2_triggers dq_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_dq_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -};
> +static void ocfs2_setup_csum_triggers(struct super_block *sb,
> +				      enum ocfs2_journal_trigger_type type,
> +				      struct ocfs2_triggers *ot)
> +{
> +	BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
>  
> -static struct ocfs2_triggers dr_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
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
> -static struct ocfs2_triggers dl_triggers = {
> -	.ot_triggers = {
> -		.t_frozen = ocfs2_frozen_trigger,
> -		.t_abort = ocfs2_abort_trigger,
> -	},
> -	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
> -};
> +	ot->ot_triggers.t_abort = ocfs2_abort_trigger;
> +	ot->sb = sb;
> +}
>  
>  static int __ocfs2_journal_access(handle_t *handle,
>  				  struct ocfs2_caching_info *ci,
> @@ -708,18 +706,33 @@ static int __ocfs2_journal_access(handle_t *handle,
>  int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers di_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_DI, &di_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
>  }
>  
>  int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers eb_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_EB, &eb_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
>  }
>  
>  int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers rb_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_RB, &rb_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
>  				      type);
>  }
> @@ -727,36 +740,66 @@ int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
>  int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers gd_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_GD, &gd_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers, type);
>  }
>  
>  int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers db_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_DB, &db_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &db_triggers, type);
>  }
>  
>  int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers xb_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_XB, &xb_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers, type);
>  }
>  
>  int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers dq_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_DQ, &dq_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers, type);
>  }
>  
>  int ocfs2_journal_access_dr(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers dr_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_DR, &dr_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &dr_triggers, type);
>  }
>  
>  int ocfs2_journal_access_dl(handle_t *handle, struct ocfs2_caching_info *ci,
>  			    struct buffer_head *bh, int type)
>  {
> +	struct ocfs2_triggers dl_triggers;
> +
> +	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
> +				 OCFS2_JTR_DL, &dl_triggers);
> +
>  	return __ocfs2_journal_access(handle, ci, bh, &dl_triggers, type);
>  }
>  
