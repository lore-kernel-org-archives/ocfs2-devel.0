Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A7DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 11:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hgBGf1GBYrD9wr5MZ/bCJ+KthjPxiynB21Sm2tzharg=;
 b=F/DphKj+bgx9SaMKnaSv0T7I57jcwrQPVvjyecqy0NpuXLBiH+LUF/Nv7+NM7aC/eVEgdc2x8hHY
   zcLK2Rbi40q4kNwolHQf+SAk+5G36qR845PIQqy72UDnFe4byXCPxfCschsxov79uyfRczOx4fBR
   3HkbSEb8YDrB/5oR/lUba1ZejNJHG03MTdRegh2dEMTKkUXr0XQKvFkZ0STQohQ/L6MdkV9l/Ax2
   tqg63d9TqYfPmb9o42eS9xC97Ee+xFTb0WWyPgu+OeyvPeAiSQA3N3sQWQ8GcPShIJc1tVrpOnrC
   +lXSZ73gW3UpQy2BMnY04JVavTgsJqq2gp+w+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hgBGf1GBYrD9wr5MZ/bCJ+KthjPxiynB21Sm2tzharg=;
 b=bWnTjl96dZILf2HKxc6IXPCJWF+AIcD4qR4GD1xu8qn2n+Zjci8L1A20IIqAIycMyVkVAtl01rNA
   mPgzPst5KEdkIw2bhE0ImLZastbgQpAErAMAM45bNytVSOjMGo6A16Wh/gKzc085rwuPyzft5CVN
   mFWnbyei6+HPrkiLRblAzZdJ4xtYhAMXCoGgAqIVg+M5jv/I1jYOiFNret68eBggSS2F8MfnJBRq
   LvRmWNECdgoQXw3xd4f0bjQ3Kes4fr1+6qsrui6k0wZI2JlvJ1HR+8W5n1TL5vbr3rRXMFfoEM8n
   Taz22eWA0qZQQf1S9Gn8wVFaEWaHU4pIqqWAUQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA9007Y5YQW8B90@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 11:04:08 +0000 (GMT)
Message-id: <eda4bed2-205c-2a1b-8263-caee28bc240e@linux.alibaba.com>
Date: Wed, 13 Apr 2022 19:02:41 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-4-heming.zhao@suse.com>
In-reply-to: <20220413082957.28774-4-heming.zhao@suse.com>
X-Source-IP: 47.90.199.4
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 priorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=194 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130061 domainage_hfrom=8399
Subject: Re: [Ocfs2-devel] [PATCH v2 3/5] ocfs2: ocfs2_initialize_super does
 cleanup job before return error
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R681e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9zdIFz_1649847761;
X-ServerName: out199-4.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: zdYZymtIj4Oqz4Kv-3PpOFD1cJYFFUuf
X-Proofpoint-ORIG-GUID: zdYZymtIj4Oqz4Kv-3PpOFD1cJYFFUuf
Reporting-Meta:
 AAFlXPWGD5eKB91uR0e73AjaDAsScpunomaRcCTkbc2kiJQAd5Mxn9pPzTvQun/l
 NTMLIupS+pkQj4iYDMOxPdkqSOGYEM5w4pDtB9NsOsxyXO3X/7Cml8FUU/cskFua
 /3ZKSUyHe8tw6n/6Ser5pgOjgHTE1zQ45Z/PMTPYRRbtSyWS/sTQH9zun2rIe5n6
 8dRHgbtJxutK+7WwdYQSvsjeeQMD24Sr3BPlkB9+GXrEh72KCVWzsvuHwyJHjxW7
 GOEcfeLLseRt215wuWVeOumQ1tUnCltn3WwKPX/XyanvRX+x7mT0Q/TkWr0yP9B7
 L5AGjlbe0sOKaME1inz6/c5hJE/yHqNseRyOWCV4HOpaK4d0rgwwcdnAoGWV3KAt
 oRVo10AfMclvyT0SBDirz1JuUsF5BfzwXJyNka/QP9YbiBdUCOMTR6+fkoyDbvDo
 /xIwpDcqrrXNbEqnmBXdLxaWr9xz3AYlxsaUQHB9xMpgs0nzhfD4vM2/8uUdu9Fl
 d3o1iDMNHk5+GM5a2H1tXlj5RJ9HMdYRe9gnBSy9yIfQ2g==



On 4/13/22 4:29 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_initialize_super.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/super.c | 59 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 7076125f5b46..4302c3e9598c 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2023,7 +2023,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out;
>  	}
>  
>  	sb->s_fs_info = osb;
> @@ -2084,7 +2084,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
>  		     osb->max_slots);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out;
>  	}
>  
>  	ocfs2_orphan_scan_init(osb);
> @@ -2093,7 +2093,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (status) {
>  		mlog(ML_ERROR, "Unable to initialize recovery state\n");
>  		mlog_errno(status);
> -		goto bail;
> +		goto out;
>  	}
>  
>  	init_waitqueue_head(&osb->checkpoint_event);
> @@ -2117,7 +2117,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->vol_label) {
>  		mlog(ML_ERROR, "unable to alloc vol label\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto out_recovery_map;
>  	}
>  
>  	osb->slot_recovery_generations =
> @@ -2126,7 +2126,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->slot_recovery_generations) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_vol_label;
>  	}
>  
>  	init_waitqueue_head(&osb->osb_wipe_event);
> @@ -2136,7 +2136,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_orphan_wipes) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_slot_recovery_gen;
>  	}
>  
>  	osb->osb_rf_lock_tree = RB_ROOT;
> @@ -2152,13 +2152,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "couldn't mount because of unsupported "
>  		     "optional features (%x).\n", i);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out_orphan_wipes;
>  	}
>  	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
>  		mlog(ML_ERROR, "couldn't mount RDWR because of "
>  		     "unsupported optional features (%x).\n", i);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out_orphan_wipes;
>  	}
>  
>  	if (ocfs2_clusterinfo_valid(osb)) {
> @@ -2179,7 +2179,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			     "cluster stack label (%s) \n",
>  			     osb->osb_cluster_stack);
>  			status = -EINVAL;
> -			goto bail;
> +			goto out_orphan_wipes;
>  		}
>  		memcpy(osb->osb_cluster_name,
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> @@ -2199,7 +2199,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	 */
>  	status = ocfs2_journal_alloc(osb);
>  	if (status)
> -		goto bail;
> +		goto out_orphan_wipes;
>  
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
> @@ -2214,7 +2214,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>  		     osb->s_clustersize);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out_journal;
>  	}
>  
>  	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
> @@ -2226,14 +2226,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume too large "
>  		     "to mount safely on this system");
>  		status = -EFBIG;
> -		goto bail;
> +		goto out_journal;
>  	}
>  
>  	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>  				 sizeof(di->id2.i_super.s_uuid))) {
>  		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto out_journal;
>  	}
>  
>  	strlcpy(osb->vol_label, di->id2.i_super.s_label,
> @@ -2253,7 +2253,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_dlm_debug) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_uuid_str;
>  	}
>  
>  	atomic_set(&osb->vol_state, VOLUME_INIT);
> @@ -2262,7 +2262,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_global_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_dlm_out;
>  	}
>  
>  	/*
> @@ -2273,7 +2273,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!inode) {
>  		status = -EINVAL;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_system_inodes;
>  	}
>  
>  	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
> @@ -2286,16 +2286,39 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_slot_info(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_system_inodes;
>  	}
>  
>  	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
>  	if (!osb->ocfs2_wq) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> +		goto out_slot_info;
>  	}
>  
> -bail:
> +	return status;
> +
> +out_slot_info:
> +	ocfs2_free_slot_info(osb);
> +out_system_inodes:
> +	ocfs2_release_system_inodes(osb);
> +out_dlm_out:
> +	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
> +out_uuid_str:
> +	kfree(osb->uuid_str);
> +out_journal:
> +	kfree(osb->journal);
> +out_orphan_wipes:
> +	kfree(osb->osb_orphan_wipes);
> +out_slot_recovery_gen:
> +	kfree(osb->slot_recovery_generations);
> +out_vol_label:
> +	kfree(osb->vol_label);
> +out_recovery_map:
> +	kfree(osb->recovery_map);
> +out:
> +	kfree(osb);
> +	sb->s_fs_info = NULL;
>  	return status;
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
