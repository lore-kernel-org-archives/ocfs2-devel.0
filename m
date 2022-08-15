Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D931C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon, 15 Aug 2022 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=npTqo5lJUjsCaRM4H15dFXNIcL32zDePEQE2K50erjo=;
 b=yuf8QG7iUTsKoGHCaM32Xu8+pM+6RW84dWjLa6Ue0dE66T7c0S+rV7FsuDr+T29eRUsIDEgIMUjZ
   8V7lQQ8DMgxmkjhlkbZz+u8YoyFdGrUFqZP1tq8AnwtDZZ2FfLuzQchz/FGLRpLNgfCI5GSNNBqj
   OzKhVsy0+O0k3v14KXgLuZcHpM/DQxRgeehovoiX1vttXVNCwMhRaBWS9viNKhsStKKaIcY2kfq2
   zjjocI0cOKPDotaxR9scebKQXCBin3cNMjx2JJsvw5oRw7UhXqMbnPzV4vP55huCX3XKEkDmbE26
   OpT9XKpxvDYuyge5ZwoCTKsMhjEpQYAWJAM5iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=npTqo5lJUjsCaRM4H15dFXNIcL32zDePEQE2K50erjo=;
 b=XZ65OdjYrc6cxZhwiJHZ3KVxB7pIOrybA3TzOWCwQa0JwUmapLhGBodKvlyUafGJUC89gM4eoPq3
   zqZ/zLTBd3TDv08wU7CM+gpnfANWX1/8H8xIe7S6ajHEiNijJC1bvDTmBD9MvMEZTt/V7OXbnZ4u
   VwyxYZGatFrdI8Uo5G/lFl3zfJS66kF8Lc0PqSF5EUUofLRYwoEVSzodNIL2HviS6obHCzjdTsG6
   n6VkgA4EcwepN3mGYWSMGonFrOw5GPzBnOP7PLLoCKFcHCmsaAUd1xmASLAnxhL6+U1n9PiQZ9pW
   0XS5E77ekVFM4cmfVNfDctBSo78dkIJiUi3U9w==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGN00H6WH2ITSC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 15 Aug 2022 09:30:18 +0000 (GMT)
Message-id: <b746bbe3-d131-157d-8cc5-5b8a60309579@linux.alibaba.com>
Date: Mon, 15 Aug 2022 17:29:52 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, junxiao.bi@oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220815085754.20417-1-heming.zhao@suse.com>
In-reply-to: <20220815085754.20417-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10439
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 clxscore=-25 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150033 domainage_hfrom=8523
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Fix freeing uninitialized resource
 on ocfs2_dlm_shutdown
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R491e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0VMHyE5u_1660555792;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Hf2EdFKVokmKPkB7Sst86X1rRoO3vVjn
X-Proofpoint-GUID: Hf2EdFKVokmKPkB7Sst86X1rRoO3vVjn
Reporting-Meta:
 AAE8/2exqvIiGGsvYwHcYvl9kyngFmdU9705up1P0Xt8dc3Yix/1JRa13HbmPkiO
 prKhbO7L54cJQsC2aEiHc66wNHpJ7C5L+wKteV95EnQ9pesMePYsQM1OjbnbYiPy
 DK8g+bw04eGKuvGaXcZ2vFDYw8vPIaTPIyDHF5hIs6ieaP3etI95dNy/hlm0xo5/
 5uNC8xsluwCKxRkR43oA2jCZ2VufVitJZ3ehPZF1R2dEIUeeLcEbyAzoSZqaTCNi
 CPIifeVyr7bGuZdbNkHX0Vp7v5/6LEhq/Dtz01I/k7ePoUvdLSjFk/9qv4b6MEVZ
 flXPZDydl77WLY+EGlZXCZLq+ebb3Yedqk9AOy+S1trAYcndfgU9RG7jqzl6gYfT
 3MnLwc1fT/xNkLzjsIZRPztRTMgfMwZ+AaxKj67SsbZ/F7L22co9+bEVPab4lN/L
 Sn+kr3cGYnGNgjhbA+IYfu3VR9TpOhmi9DVVUOBw21XPbGJ8Z/yDKR/ENnICJ9hc
 2v4hPrsc0KWJ/ZACw4FTO8c0O+UpkYHo9YNWiJ1pyWmN



On 8/15/22 4:57 PM, Heming Zhao wrote:
> After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
> before return error"), any procedure after ocfs2_dlm_init() fails will
> trigger crash when calling ocfs2_dlm_shutdown().
> 
> ie: On local mount mode, no dlm resource is initialized. If
> ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
> will call ocfs2_dlm_shutdown(), then does dlm resource cleanup
> job, which will trigger kernel crash.
> 
> This solution should bypass uninitialized resources in
> ocfs2_dlm_shutdown().
> 
> Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v1 -> v2:
>  - by review comments:
>    - revise commit log
>    - remove improperly checking osb->cconn in ocfs2_dismount_volume()
> 
> draft -> v1:
>  - separate to a single patch
>  - by review comment:
>    - do free lockres in shutdown path
>    - put 'Fixes' string in one line
>  - revise misspelled & grammar mistake in commit log
> ---
>  fs/ocfs2/dlmglue.c | 8 +++++---
>  fs/ocfs2/super.c   | 3 +--
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 801e60bab955..c28bc983a7b1 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>  	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>  	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>  
> -	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
> -	osb->cconn = NULL;
> +	if (osb->cconn) {
> +		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
> +		osb->cconn = NULL;
>  
> -	ocfs2_dlm_shutdown_debug(osb);
> +		ocfs2_dlm_shutdown_debug(osb);
> +	}
>  }
>  
>  static int ocfs2_drop_lock(struct ocfs2_super *osb,
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 438be028935d..bc18c27e9683 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	    !ocfs2_is_hard_readonly(osb))
>  		hangup_needed = 1;
>  
> -	if (osb->cconn)
> -		ocfs2_dlm_shutdown(osb, hangup_needed);
> +	ocfs2_dlm_shutdown(osb, hangup_needed);
>  
>  	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
>  	debugfs_remove_recursive(osb->osb_debug_root);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
