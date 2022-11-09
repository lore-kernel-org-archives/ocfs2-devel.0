Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14CEC433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  9 Nov 2022 06:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tfRm3c3CN1Mge6Oz7tfU0t+tYJByydqyvH9jjFR0UfI=;
 b=ILf0mgkCEYyQ5FQQFx+bplnf89QwEFebvi7Gj78FatBxeZyeoCCBl+ZnbByW0KvpzajFyDNRFO0H
   M1g0j/lQcsC4lWZg4SYSYqMaICspS2jEujvZxHvE1xurycBVRhZSQz1BxPjhWl/L8xoDWGCu0uiD
   bCpqP3CNpxPvm5VjU9XZKNrO2Deit0yBflzCp6BpirD6wYOzygMDmFk2ru3GvTeMrKVFFkVjcClI
   dxteZ2+XXDEyZzsugLPtoXtdAK0/vEu1WMJQuDRLKU/72fPfDFwiaguMv40HMlhNXVobJawcYC+e
   tSqeaqWbrY+cug6RJgSblmTFtQGDY7/5ul5mMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tfRm3c3CN1Mge6Oz7tfU0t+tYJByydqyvH9jjFR0UfI=;
 b=UuqV/FIRoVWhVle8BpyZ3kO+GzEdZc1uTLDToW6lIoxDXB+JAkuy1lbjnVgrJXT+FXB286CMQPy0
   Lhr3nJsZfTQnHELwrSpyrrP8Jthi2R6qL7cLD0vXPUffq9fKGgbPgEIZaVE0o7nSgfGVqoRqiwg4
   Hz6nhA7YWYL38gsi1+qyJETqTa4jjkRCArNrBaCkT16X3C7Rz8mJ0ko44zKdu0OSI/plv18gfweL
   m7bRW2MJ0UcBVcp+MsUDJTYVre0YpZEYpdrUCe3rxq96oojUAuKNmXTLhyZ4ah2FEvHnfv+f9sjE
   mjxZWlxEkEo13PtXGsr535dJbVeLWVc5E8y2rA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RL2003KJI32RQ30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 09 Nov 2022 06:30:38 +0000 (GMT)
Message-id: <05c24286-427d-e572-aa70-8f1d882b9602@linux.alibaba.com>
Date: Wed, 9 Nov 2022 14:19:21 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
To: Li Zetao <lizetao1@huawei.com>, mark@fasheh.com, jlbec@evilplan.org,
 srinivas.eeda@oracle.com
References: <20221108152516.1189165-1-lizetao1@huawei.com>
Content-language: en-US
In-reply-to: <20221108152516.1189165-1-lizetao1@huawei.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10525
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=85 phishscore=0 adultscore=0
 clxscore=98 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211090047 domainage_hfrom=8609
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix memory leak in
	ocfs2_mount_volume()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R261e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VUMT3zM_1667974761;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: hHimyGFv-X4b0p8vYmJzlHNoEOeKX0ET
X-Proofpoint-ORIG-GUID: hHimyGFv-X4b0p8vYmJzlHNoEOeKX0ET
Reporting-Meta:
 AAFvEjTzwIBRP8aBJPpU/Fc77BR29s3Phr3HvC+4Wr0ZUrz7MBSEDeyT8Qt2uMex
 P2t8RiRsH/Dnl8tpumVijXp7puq475T3ewkSWI7+mYTPubijcMqis2ZFIlyGaGIY
 2dA3tBOqOblSPqKLhk/Ut11qQAW2b8xdNAtm58ZJFjgBwM3Bj0jhaDnASooTj/i2
 lC5rizhYHtjGXYWYPEzdFEd72KftOPjxRkmGspXIEucmjU4WakMjXci3S+81K95j
 sRLAXbt09bkXWOcSfcNzmHYdQsFnfK06g65reZ5n84bHP6fM2UNtoVlDuBahxOjr
 ayNURe9Fcqsz1E6zQcY8fsudYLbxKfiOPnD/90GeddHPfbp7ksbbP3UPys3zOFnu
 w4G2uYVREtOQRnOINpocIB+Ha9Xg3LEZES30fmgPbwcacXVHM6JpngmLEVJ/DZDu
 yWvWF86Y4uML/irZiz+Txam/HhEfZjAcR74OPcVHmFyeaf4Vv8pJ4oWci3//HzCF
 h+AvKLC8fquSjf6QuhVM6RUOcNQkRHfzLNvlYlC7/5g=

Hi,

Thanks for so detailed analysis.
The patch almost looks good. A minor improvement, please see my
comments inline.

On 11/8/22 11:25 PM, Li Zetao wrote:
> There is a memory leak reported by kmemleak:
> 
>   unreferenced object 0xffff88810cc65e60 (size 32):
>     comm "mount.ocfs2", pid 23753, jiffies 4302528942 (age 34735.105s)
>     hex dump (first 32 bytes):
>       10 00 00 00 00 00 00 00 00 01 01 01 01 01 01 01  ................
>       01 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<ffffffff8170f73d>] __kmalloc+0x4d/0x150
>       [<ffffffffa0ac3f51>] ocfs2_compute_replay_slots+0x121/0x330 [ocfs2]
>       [<ffffffffa0b65165>] ocfs2_check_volume+0x485/0x900 [ocfs2]
>       [<ffffffffa0b68129>] ocfs2_mount_volume.isra.0+0x1e9/0x650 [ocfs2]
>       [<ffffffffa0b7160b>] ocfs2_fill_super+0xe0b/0x1740 [ocfs2]
>       [<ffffffff818e1fe2>] mount_bdev+0x312/0x400
>       [<ffffffff819a086d>] legacy_get_tree+0xed/0x1d0
>       [<ffffffff818de82d>] vfs_get_tree+0x7d/0x230
>       [<ffffffff81957f92>] path_mount+0xd62/0x1760
>       [<ffffffff81958a5a>] do_mount+0xca/0xe0
>       [<ffffffff81958d3c>] __x64_sys_mount+0x12c/0x1a0
>       [<ffffffff82f26f15>] do_syscall_64+0x35/0x80
>       [<ffffffff8300006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This call stack is related to two problems. Firstly, the ocfs2 super uses
> "replay_map" to trace online/offline slots, in order to recover offline
> slots during recovery and mount. But when ocfs2_truncate_log_init()
> returns an error in ocfs2_mount_volume(), the memory of "replay_map"
> will not be freed in error handling path. Secondly, the memory of
> "replay_map" will not be freed if d_make_root() returns an error in
> ocfs2_fill_super(). But the memory of "replay_map" will be freed normally
> when completing recovery and mount in ocfs2_complete_mount_recovery().
> 
> Fix the first problem by adding error handling path to free "replay_map"
> when ocfs2_truncate_log_init() fails. And fix the second problem by
> calling ocfs2_free_replay_slots(osb) in the error handling path
> "out_dismount". In addition, since ocfs2_free_replay_slots() is static,
> it is necessary to remove its static attribute and declare it in header
> file.
> 
> Fixes: 9140db04ef18 ("ocfs2: recover orphans in offline slots during recovery and mount")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  fs/ocfs2/journal.c | 2 +-
>  fs/ocfs2/journal.h | 1 +
>  fs/ocfs2/super.c   | 5 ++++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 126671e6caed..3fb98b4569a2 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
>  	replay_map->rm_state = REPLAY_DONE;
>  }
>  
> -static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
> +void ocfs2_free_replay_slots(struct ocfs2_super *osb)
>  {
>  	struct ocfs2_replay_map *replay_map = osb->replay_map;
>  
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 969d0aa28718..41c382f68529 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -150,6 +150,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb);
>  void ocfs2_recovery_exit(struct ocfs2_super *osb);
>  
>  int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
> +void ocfs2_free_replay_slots(struct ocfs2_super *osb);
>  /*
>   *  Journal Control:
>   *  Initialize, Load, Shutdown, Wipe a journal.
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 42c993e53924..f8041aebe4ee 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1159,6 +1159,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  out_dismount:
>  	atomic_set(&osb->vol_state, VOLUME_DISABLED);
>  	wake_up(&osb->osb_mount_event);
> +	ocfs2_free_replay_slots(osb);
>  	ocfs2_dismount_volume(sb, 1);
>  	goto out;
>  
> @@ -1822,12 +1823,14 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  	status = ocfs2_truncate_log_init(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto out_system_inodes;
> +		goto out_truncate_log;
>  	}
>  
>  	ocfs2_super_unlock(osb, 1);
>  	return 0;
>  
> +out_truncate_log:

I'd like define this label as 'out_check_volume', to indicate that it's
the entry to do cleanup work of ocfs2_check_volume().

Other looks good to me.

Thanks,
Joseph

> +	ocfs2_free_replay_slots(osb);
>  out_system_inodes:
>  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>  		ocfs2_shutdown_local_alloc(osb);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
