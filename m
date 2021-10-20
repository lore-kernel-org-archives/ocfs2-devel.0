Return-Path: <SRS0=sznG=PI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9236AC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 08:26:54 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 04772611C6
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 08:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 04772611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K7gd0X015004;
	Wed, 20 Oct 2021 08:26:53 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsnjhy4m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Oct 2021 08:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19K8FZUm077671;
	Wed, 20 Oct 2021 08:26:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gts3j8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 20 Oct 2021 08:26:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1md6vy-0002Xc-2C; Wed, 20 Oct 2021 01:26:50 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1md6vu-0002XE-SW
	for ocfs2-devel@oss.oracle.com; Wed, 20 Oct 2021 01:26:46 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19K8GpAw162553
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 08:26:46 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bqmsg36qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 08:26:46 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19K7ea5O029228
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 08:26:45 GMT
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bt653x2dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 08:26:45 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R261e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0Ut1R0Id_1634718398; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Ut1R0Id_1634718398) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 20 Oct 2021 16:26:38 +0800
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        ocfs2-devel@oss.oracle.com
References: <1634707081-16450-1-git-send-email-gautham.ananthakrishna@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <0edb00d1-c596-505f-6f86-c8f2e94d279f@linux.alibaba.com>
Date: Wed, 20 Oct 2021 16:26:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634707081-16450-1-git-send-email-gautham.ananthakrishna@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.42
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	spamscore=0 mlxscore=0
	lowpriorityscore=0 mlxlogscore=999 clxscore=233 priorityscore=48
	phishscore=0 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110200046 domainage_hfrom=8224
X-Spam: Clean
Cc: rajesh.sivaramasubramaniom@oracle.com
Subject: Re: [Ocfs2-devel] [PATCH V1 RFC 1/1] ocfs2: race between searching
 chunks and release journal_head from buffer_head
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200046
X-Proofpoint-ORIG-GUID: 2TtZNVmJY8L4_JIo1TDDjiuvOeh9Z1mJ
X-Proofpoint-GUID: 2TtZNVmJY8L4_JIo1TDDjiuvOeh9Z1mJ

Hi,

How about make the change like following?

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8521942..481017e 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1251,7 +1251,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret;
+	int ret = 1;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
@@ -1259,14 +1259,18 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	if (!buffer_jbd(bg_bh))
 		return 1;
 
-	jh = bh2jh(bg_bh);
-	spin_lock(&jh->b_state_lock);
-	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-	if (bg)
-		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-	else
-		ret = 1;
-	spin_unlock(&jh->b_state_lock);
+	jbd_lock_bh_journal_head(bg_bh);
+	if (buffer_jbd(bg_bh)) {
+		jh = bh2jh(bg_bh);
+		spin_lock(&jh->b_state_lock);
+		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+		if (bg)
+			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+		else
+			ret = 1;
+		spin_unlock(&jh->b_state_lock);
+	}
+	jbd_unlock_bh_journal_head(bg_bh);
 
 	return ret;
 }


On 10/20/21 1:18 PM, Gautham Ananthakrishna wrote:
> Encountered a race between ocfs2_test_bg_bit_allocatable() and
> jbd2_journal_put_journal_head() resulting in the below vmcore.
> 
> PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
>  0 [ffff8802435ff1c0] panic at ffffffff816ed175
>  1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
>  2 [ffff8802435ff270] no_context at ffffffff8106eccf
>  3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
>  4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
>  5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
>  6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
>  7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
>     [exception RIP: ocfs2_block_group_find_clear_bits+316]
>     RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
>     RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
>     RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
>     RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
>     R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
>     R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
>     ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
>  8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at ffffffffc11ef680 [ocfs2]
>  9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 [ocfs2]
> 10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
> 11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b [ocfs2]
> 12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb [ocfs2]
> 13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf [ocfs2]
> 14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at ffffffffc11cc0db [ocfs2]
> 15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at ffffffffc11ce53f [ocfs2]
> 16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at ffffffffc11f59b5 [ocfs2]
> 17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 [ocfs2]
> 18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at ffffffffc11dc169 [ocfs2]
> 19 [ffff8802435ff960] ocfs2_make_clusters_writable at ffffffffc11e4274 [ocfs2]
> 20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
> 21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
> 22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 [ocfs2]
> 23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
> 24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
> 25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
> 26 [ffff8802435ffec0] kthread at ffffffff810a7afb
> 27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1
> 
> When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the bg_bh->b_private
> NULL as jbd2_journal_put_journal_head() raced and released the jounal head
> from the buffer head. Needed to take bit lock for the bit 'BH_JournalHead'
> to fix this race.
> 
> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> ---
>  fs/ocfs2/suballoc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 8521942..86f33f2 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1256,9 +1256,17 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>  	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
>  		return 0;
>  
> +	/* Fast path */
>  	if (!buffer_jbd(bg_bh))
>  		return 1;
>  
> +	/* Slow path */
> +	jbd_lock_bh_journal_head(bg_bh);
> +	if (!buffer_jbd(bg_bh)){
> +		jbd_unlock_bh_journal_head(bg_bh);
> +		return 1;
> +	}
> +
>  	jh = bh2jh(bg_bh);
>  	spin_lock(&jh->b_state_lock);
>  	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
> @@ -1267,6 +1275,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>  	else
>  		ret = 1;
>  	spin_unlock(&jh->b_state_lock);
> +	jbd_unlock_bh_journal_head(bg_bh);
>  
>  	return ret;
>  }
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
