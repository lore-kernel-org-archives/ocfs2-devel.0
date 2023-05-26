Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13FBC77B7A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 May 2023 02:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t6HSdK0EOvxZC5Q24lhTEUUjysnMzZoP2fd8v4ThCvk=;
 b=V0P2lbo64xnazDdlF+drSPDj3OmN6OjdyS4KqOodwVI6cLN5ag5nHT79uBhA9vzqwEYde/wNYvXj
   ShV9LiUlaPgqequyhtELP1eEmVrh7EAS+hDigBD35duoJDjXqWd0D8+MtrHhMKm4SrSEiNH0AoQz
   hqC+18UeLVMSZGBtVC3S40qAoaY6b+k5TtyPIWQW+/TS8Yy7eNhmH9a9cxjLVaRaQjeqIWpNzw9G
   I5vnprUp2zys3BzNlDUUKPGUjJa6UuO11r7oR2ck2DR9ZIOrw4Esc3HnwiQ6E1cxcKWhz0skMdxB
   wtEJF3cVZLLXbjhZRve0FbCFMv1gXzHIfZvX8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t6HSdK0EOvxZC5Q24lhTEUUjysnMzZoP2fd8v4ThCvk=;
 b=H6RrKWDDRR0b5f2pZgoSDddbhlWwWU8xKZoRg+y22viboAfs5cPj4SU1t9HEbfy+hU/46wAJ5dlY
   bQBYjUIVno0HFIq3OE/yUXpWyB9NCODLoBHX4sfl9+QlCENyC6NyVlv0tNF+/qfwog3AzVI76f6y
   rhfLmjd6xbrWKWFXjQBitOpdYldlp5PeYrlHte79cE87OIq05MHMNdMo9zFE+HWZ723hBfkMJ/5M
   TsrUUT0qewc2uuut87cvG7+8I5Pth+xDTDhkvzq57zDyxLKNpf0obI7ubqrHpv46zfI7hlDwZDUi
   GpkkWFOem5C92OreRbcdmuxQzw3XbzDjX8tqVw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RV800OGXUAHOI40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 26 May 2023 02:15:53 +0000 (GMT)
Message-id: <bcea2cee-57e3-019f-3ce9-22e31f2f1f0e@linux.alibaba.com>
Date: Fri, 26 May 2023 10:15:34 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
References: <20230525205556.680DCC433EF@smtp.kernel.org>
 <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
 <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
In-reply-to: <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
X-Source-IP: 115.124.30.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10721
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 priorityscore=0 adultscore=0 impostorscore=0 clxscore=67 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260018 domainage_hfrom=8807
Cc: mm-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to
 mm-hotfixes-unstable branch
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
 TI=SMTPD_---0VjU6cH-_1685067334;
X-ServerName: out30-124.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: gNkWGO1-7u2nVvN6FP0lX2soqZ5CMWTk
X-Proofpoint-GUID: gNkWGO1-7u2nVvN6FP0lX2soqZ5CMWTk
Reporting-Meta:
 AAHLYjwYkFpDCdu/uDN+ijTE4rwI91PquadtLvgXWO+cmVnKucRY/dIoL6WlYWc+
 tqVvJvpNlDYPPmyPKqD1Pe0iTTElpnF+Zt/GDMJ3CjZd5sglBGgLlf+R8wyZdt/8
 PSAIDqQYSFum4yLDMuCRom+anFrC1AJHUWZBjyBc360FDHmWtJlMaPaP3rczcoj2
 N+EDZNXAgz2T1IMLyTATtMRYpEJVmtu1q8Lxs996oJ3KgdJvIZ+krF3WDvdDVI6C
 85nySKo1YmCFyFNsaScuDQ7SNCGretE+NbPOpaMBLKN02XACv948UxVwVZHhgEf+
 x1oq1ND6uKLsf5h8PZ2wECfrce1Qfkspyr7++peQJ79E9e91Z/qoL5NNSyJeCCGb
 7JCcXymmMkOsmAP5AtZ6Bu5fh01pk8/Bc27KxN8+lT/A3M2urAB1cr5agJhGk1PP
 Dtx22t4KI2Odu+P/LwmeSB3gkMNtOxV2x5OApHen0SQm2w9R+p9gByYZzROLT45T
 Ipj2Oy8nj4xZyT2rCDKYg6/M3RKe+qtvA+tANaT63hOE



On 5/26/23 10:05 AM, Andrew Morton wrote:
> On Fri, 26 May 2023 09:36:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Hi Andrew,
>>
>> There is an updated version v2, which describe more clearly about the
>> case:
>> https://lore.kernel.org/ocfs2-devel/e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com/T/#u
> 
> Sigh.  Thanks.
> 
> As you can see from the above link, the email never hit ocfs2-devel and
> never hit my inbox.  I'll piece it together from your reply.
> 

Sorry for the inconvenience. I quote the updated description below:

"
It's trivial to trigger a use-after-free bug in the ocfs2 quotas code using
fstest generic/452.  After a read-only remount, quotas are suspended and
ocfs2_mem_dqinfo is freed through ->ocfs2_local_free_info().  When unmounting
the filesystem, an UAF access to the oinfo will eventually cause a crash.

BUG: KASAN: slab-use-after-free in timer_delete+0x54/0xc0
Read of size 8 at addr ffff8880389a8208 by task umount/669
...
Call Trace:
 <TASK>
 ...
 timer_delete+0x54/0xc0
 try_to_grab_pending+0x31/0x230
 __cancel_work_timer+0x6c/0x270
 ocfs2_disable_quotas.isra.0+0x3e/0xf0 [ocfs2]
 ocfs2_dismount_volume+0xdd/0x450 [ocfs2]
 generic_shutdown_super+0xaa/0x280
 kill_block_super+0x46/0x70
 deactivate_locked_super+0x4d/0xb0
 cleanup_mnt+0x135/0x1f0
 ...
 </TASK>

Allocated by task 632:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x8b/0x90
 ocfs2_local_read_info+0xe3/0x9a0 [ocfs2]
 dquot_load_quota_sb+0x34b/0x680
 dquot_load_quota_inode+0xfe/0x1a0
 ocfs2_enable_quotas+0x190/0x2f0 [ocfs2]
 ocfs2_fill_super+0x14ef/0x2120 [ocfs2]
 mount_bdev+0x1be/0x200
 legacy_get_tree+0x6c/0xb0
 vfs_get_tree+0x3e/0x110
 path_mount+0xa90/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 650:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0xf9/0x150
 __kmem_cache_free+0x89/0x180
 ocfs2_local_free_info+0x2ba/0x3f0 [ocfs2]
 dquot_disable+0x35f/0xa70
 ocfs2_susp_quotas.isra.0+0x159/0x1a0 [ocfs2]
 ocfs2_remount+0x150/0x580 [ocfs2]
 reconfigure_super+0x1a5/0x3a0
 path_mount+0xc8a/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
"

> The ocfs2-devel list is really bad.  Can we move to a vger list?  Or
> get some maintenance work done on ocfs2-devel?
> 

I see. It seems something wrong with ocfs2-devel. But I'm not an
administrator of it:(

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
