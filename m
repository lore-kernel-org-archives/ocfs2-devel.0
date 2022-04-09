Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA22C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 08:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+pKy8+vF6hY449BLgSuhEytYUXNWmq6cQGlmvsUCnpA=;
 b=p3BPxx7k19OZJef19C0JQxjowa3qsAV2BrkXsnorAZReIsUcZ+/WmG+fQrSJnIIyjkQ8+6w6bGfI
   mWQC7HI0JN/iBm8N1GqzIS4ENJNq4bmFXYwMn6vXUu9IBeuL1eOTPB/jWXJOLyHREVMe1/aQupic
   DBDXYWJLrs4eocpdFK6fiSfC2HLn8sMEHo1v4FPbgyGbTm31zJIyN0C6m92TcfH1JKgncf2TVFec
   jhIn6MRv5ZW7COkSS5JrE4J0ei7bpcPONc28rzg1Gw/oV7iDEP5/bTidk3mzT3yzgX6nnuyERdwQ
   O8TDIzh3A1fFwJahcYkcNTct2YRGenfgZoX9Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+pKy8+vF6hY449BLgSuhEytYUXNWmq6cQGlmvsUCnpA=;
 b=BeOBnKWXFIIq+Ge8C3W87X3sr/DtXBKd9KBRjAHRR0Q5Tb/krav0K1iFF75H1pBbDhRH73fZKYNg
   bkL068PLQOeZDBiJgzb6A2b/5dcYMuHs2VL97trPV4YEYN/0BphtGdX1CgwnsFbrc/Pno2bGkQjv
   nCvGL2B1wr/fQTW9t0+nUGQVbIKBkGlbOM844mVdrFNb6NR8imzXT9DGmTHLgTBjjtJteEuXtYfN
   SxywWId84kMWrmaW3PR11EXFmuCLXinZD9VvuoBY6+oMVhCXJOQXPE3wOMRzdG22sK9Si6fZ8EEX
   na4MrRsaJpo+FgGAXyamFs/kkyfg6bJwdPDkYw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA6003YP0X3BGC0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 08:00:39 +0000 (GMT)
Message-id: <4b574a02-626d-8cb8-6c2e-e8c824546c22@linux.alibaba.com>
Date: Sat, 9 Apr 2022 21:30:46 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-4-heming.zhao@suse.com>
In-reply-to: <20220408103012.1419-4-heming.zhao@suse.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 impostorscore=0 clxscore=2 bulkscore=0 mlxlogscore=999 priorityscore=30
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090090 domainage_hfrom=8395
Subject: Re: [Ocfs2-devel] [PATCH v1 3/5] ocfs2: ocfs2_initialize_super does
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9aYrgM_1649511046;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: zpflHrt896ilFehx7XxLvCIUiA4770gz
X-Proofpoint-GUID: zpflHrt896ilFehx7XxLvCIUiA4770gz
Reporting-Meta:
 AAFGBoIIISjA1IH1ZbbI1eW+dJfdQMT/Q2qCe7KoRKsTfUEWaGH1dm4js4MsT/fz
 WsJq9vBnhZmRMb0IproaFn56217juwlMRK7QNhc64h6pYTZAyxZHOQ7u6N/NI+RL
 iFQEXQxRY9b6nWQApafelK0U66lR8QIjA8vToaIo9XJDRFmViL3LCiusnyd8qUeC
 EwRRzr+s4saH3dm2I76N5FCw15ZuNcW+fUJcIpn1ahsaSHBllQKougrn6354aVtk
 zQYYwUbWPH219j3fIIgr2zg43EvQo5JWLYxlumuEPN7+VCJYzK/IXNmgH7mQ1SH/
 nxNEgzszBlMxwxnarXlcawR4JzqQJmLq9rwHFaRket5T6qobB5FXREIz8qWq3sf+
 Bw6b8cKa4ND0s3oecpZgAMUxF3FQZweXbd4TcCO8iFqJld5l/Uo0STy1vbEDtv16
 YiT8QR/K8p5EQxlb1XBgbkNQXsvfIWawIoeF8qj0Gt8krMEVN59aoxt2Il0rrSpD
 QHSkbpk8ao3EKrXnfPzzHaDgyXc8NMLsROg/Rw+4Zpux



On 4/8/22 6:30 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_initialize_super.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 58 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 40 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index f91c5510bc7e..8443ba031dec 100644
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
> @@ -2204,7 +2204,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!journal) {
>  		mlog(ML_ERROR, "unable to alloc journal\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto out_orphan_wipes;
>  	}
>  	osb->journal = journal;
>  	journal->j_osb = osb;
> @@ -2231,7 +2231,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>  		     osb->s_clustersize);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out_journal;
>  	}
>  
>  	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
> @@ -2243,14 +2243,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
> @@ -2270,7 +2270,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_dlm_debug) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_uuid_str;
>  	}
>  
>  	atomic_set(&osb->vol_state, VOLUME_INIT);
> @@ -2279,7 +2279,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_global_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_dlm_out;
>  	}
>  
>  	/*
> @@ -2290,7 +2290,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!inode) {
>  		status = -EINVAL;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_system_inodes;
>  	}
>  
>  	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
> @@ -2303,16 +2303,38 @@ static int ocfs2_initialize_super(struct super_block *sb,
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

Should set osb to NULL here to prevent UAF in ocfs2_fill_super().

Thanks,
Joseph

>  	return status;
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
