Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E577EC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XnUNppDHFQkurcpTM1y2H2CIOAfsfMa4JTgW/tvL4sY=;
 b=QpVbN5LQHVIlCg7iQ/HACn4TYG67cSdvlixqyuRrHaV98E8I7qV78EtMMQ7tdnbbrJMoKfZ136oX
   wVqNnXx+bCCYSzz11m3B4QDFMIJ0JiItnhMzXpCpuhu+XBk+BJR9xWYCMoLqGkPCmjBheeraxjQB
   z4dh4IkAg3xCAgFWR2z09e2oVLSpIpP1aWsXjRAqNuHAs/LhdXWVL1yJXp4qOTPPwUEMct0unJCz
   +XB1ZNAyFWeODqZQndoEC4p3ecqQkekxuWXRgUJ9HjztJgAKs4cJBYsMRF41wp6iwVGFDJ+32vBQ
   8jpYjyIGjPZ71YsEHwfnwQ/2NgYRQqYyPzyJvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XnUNppDHFQkurcpTM1y2H2CIOAfsfMa4JTgW/tvL4sY=;
 b=NmK1gX2zwUMp3Zl13BdatE5yn415Uv/kavgKgpPC1YTbpXkPJyMHnpBfA9+c6dJhU51CmUjb8jQC
   NMilNuFPs3mH8egXJ+nkUTMjkiLNL2ia6jhC2g87aN/Ao7DKqDg7a4rwph7uzqxtdGIpy8wGXJF1
   PPAv50/uv+Ee9Ncyd0PLXLI6UtOsHjrAtUEN9Gl3qvGZceL9DmntMtRicJ/kAOKNhYyQ5qPScHEJ
   QcFzitlIFaT/4zglpRx3Nu6BTZf96ck2RbqwCEE8hIjVPjoKGYCoQAj/TMQbXtOJK7H46xm2m0vn
   D9rXDw0NLHapgjOGC5Frf3XQX9+Eq3gD/T6QCw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB100M56SAT0KE0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 11:37:41 +0000 (GMT)
Message-id: <df95d0b8-0fa4-e705-9a2b-5db888f53282@linux.alibaba.com>
Date: Thu, 28 Apr 2022 19:37:20 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-4-heming.zhao@suse.com>
In-reply-to: <20220424130952.2436-4-heming.zhao@suse.com>
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=90 clxscore=134 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280071 domainage_hfrom=8414
Subject: Re: [Ocfs2-devel] [PATCH v3 3/5] ocfs2: ocfs2_initialize_super does
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R611e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBaXwE7_1651145840;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: G2B4y6sCEYcTHSs2jEX1L727SKdEWK-P
X-Proofpoint-ORIG-GUID: G2B4y6sCEYcTHSs2jEX1L727SKdEWK-P
Reporting-Meta:
 AAFFdelbZOAxDtbRzOctMXAnRBu7nTeDJUL1RazR/kgFlqjIGXLA/2dx21/qUyrS
 qnW8sSTJl4oFKR9GUzJKGVetDObCx45clETPMI4z2EZcxZtwSP7hGHnzgWXh1Rov
 QHOKrxANOms5FbLW128N10vUFIlDahW0X3A8sKkcbP8P7VcvKexdo2l5CbsjtaLd
 jSch4WjQJ3p96kxo2PUG0GgLM7fH2eiNYWxPOTc9OJVXhlOGcWK4oInaKW4Q8mTO
 myezdIDFfOEWGy0WbFGMoI0Q0NT0IwFlvzn40TsTl+2cTAVX6uuW6ghqKl3dyWgW
 uUAMZ+n/h9BT2Tksqv9/mpOGThMbdYfqanfLU3yvtgh7AlMziinZW0QfsE90wTFP
 ytjW6hVzawLYZDkPBbp2sgR/8qNvS3jSbsjLRZKLnNE1dgM2QaXQRlBZA5r7k01k
 I2kZFu/Kv+CG0FKOxxKMYUTUmOfWYQK0EkgCj5SxtTEBiObigC6oIsIS/qDuaiom
 c+Xl2HMVN9SH9NRpVQ3qo4GxLhgMOX/lZxWHzrmNFNQ=



On 4/24/22 9:09 PM, Heming Zhao wrote:
> After this patch, when error, ocfs2_fill_super doesn't take care to
> release resources which are allocated in ocfs2_initialize_super.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 59 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8014c690ef72..758ea3313f88 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2022,7 +2022,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out;
>  	}
>  
>  	sb->s_fs_info = osb;
> @@ -2083,7 +2083,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
>  		     osb->max_slots);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out;
>  	}
>  
>  	ocfs2_orphan_scan_init(osb);
> @@ -2092,7 +2092,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (status) {
>  		mlog(ML_ERROR, "Unable to initialize recovery state\n");
>  		mlog_errno(status);
> -		goto bail;
> +		goto out;
>  	}
>  
>  	init_waitqueue_head(&osb->checkpoint_event);
> @@ -2116,7 +2116,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->vol_label) {
>  		mlog(ML_ERROR, "unable to alloc vol label\n");
>  		status = -ENOMEM;
> -		goto bail;
> +		goto out_recovery_map;
>  	}
>  
>  	osb->slot_recovery_generations =
> @@ -2125,7 +2125,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->slot_recovery_generations) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_vol_label;
>  	}
>  
>  	init_waitqueue_head(&osb->osb_wipe_event);
> @@ -2135,7 +2135,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_orphan_wipes) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_slot_recovery_gen;
>  	}
>  
>  	osb->osb_rf_lock_tree = RB_ROOT;
> @@ -2151,13 +2151,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
> @@ -2178,7 +2178,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			     "cluster stack label (%s) \n",
>  			     osb->osb_cluster_stack);
>  			status = -EINVAL;
> -			goto bail;
> +			goto out_orphan_wipes;
>  		}
>  		memcpy(osb->osb_cluster_name,
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> @@ -2198,7 +2198,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	 */
>  	status = ocfs2_journal_alloc(osb);
>  	if (status < 0)
> -		goto bail;
> +		goto out_orphan_wipes;
>  
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
> @@ -2213,7 +2213,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>  		     osb->s_clustersize);
>  		status = -EINVAL;
> -		goto bail;
> +		goto out_journal;
>  	}
>  
>  	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
> @@ -2225,14 +2225,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
> @@ -2252,7 +2252,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!osb->osb_dlm_debug) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_uuid_str;
>  	}
>  
>  	atomic_set(&osb->vol_state, VOLUME_INIT);
> @@ -2261,7 +2261,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	status = ocfs2_init_global_system_inodes(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_dlm_out;
>  	}
>  
>  	/*
> @@ -2272,7 +2272,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (!inode) {
>  		status = -EINVAL;
>  		mlog_errno(status);
> -		goto bail;
> +		goto out_system_inodes;
>  	}
>  
>  	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
> @@ -2285,16 +2285,39 @@ static int ocfs2_initialize_super(struct super_block *sb,
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

Or just set "osb" to NULL is enough to keep code consistency.
Other looks good. Once it is resolved, feel free to add:

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


>  	return status;
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
