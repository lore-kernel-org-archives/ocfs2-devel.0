Return-Path: <SRS0=SdAF=OS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D060C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 12:06:06 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0BEEB60EE9
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 12:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BEEB60EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAxSLR004509;
	Tue, 28 Sep 2021 12:06:05 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbejegfrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Sep 2021 12:06:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SC0c2u106656;
	Tue, 28 Sep 2021 12:06:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3badhsn8ed-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 28 Sep 2021 12:06:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVBs1-0004ek-Fh; Tue, 28 Sep 2021 05:06:01 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mVBrY-0004dY-Js
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 05:05:32 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18SC1VjR178767
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 12:05:32 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3b9x520h1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 12:05:31 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18SB5faw000519
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 12:05:31 GMT
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bbepk16gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 12:05:30 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UpwTFLo_1632830722; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UpwTFLo_1632830722) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 28 Sep 2021 20:05:23 +0800
To: Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
Date: Tue, 28 Sep 2021 20:05:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
Content-Language: en-US
X-Source-IP: 115.124.30.133
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 impostorscore=0
	mlxscore=0 phishscore=0 clxscore=276 adultscore=0 mlxlogscore=999
	suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=100 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2109280068 domainage_hfrom=8202
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: mount fails with buffer overflow
	in strlen
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280068
X-Proofpoint-GUID: FUtqhCvtST9AmeWLs8zhFSwpHCWq77oM
X-Proofpoint-ORIG-GUID: FUtqhCvtST9AmeWLs8zhFSwpHCWq77oM



On 9/27/21 11:44 PM, Valentin Vidic wrote:
> Starting with kernel v5.11 mouting an ocfs2 filesystem with either o2cb
> or pcmk cluster stack fails with the trace below. Problem seems to be
> that strings for cluster stack and cluster name are not guaranteed to be
> null terminated in the disk representation, while strlcpy assumes that
> the source string is always null terminated. This causes a read outside
> of the source string triggering the buffer overflow detection.
> 

strlcpy in ocfs2_initialize_super() is introduced 8 years ago, so I
don't understand why you've mentioned that the issues starts from
v5.11.

osb->osb_cluster_stack and osb->osb_cluster_name is always larger by
1 than which in ocfs2_cluster_info, and the input size of strlcpy does
the same, so I don't see how it overflows.

Thanks,
Joseph

> detected buffer overflow in strlen
> ------------[ cut here ]------------
> kernel BUG at lib/string.c:1149!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 1 PID: 910 Comm: mount.ocfs2 Not tainted 5.14.0-1-amd64 #1
>   Debian 5.14.6-2
> RIP: 0010:fortify_panic+0xf/0x11
> ...
> Call Trace:
>  ocfs2_initialize_super.isra.0.cold+0xc/0x18 [ocfs2]
>  ocfs2_fill_super+0x359/0x19b0 [ocfs2]
>  mount_bdev+0x185/0x1b0
>  ? ocfs2_remount+0x440/0x440 [ocfs2]
>  legacy_get_tree+0x27/0x40
>  vfs_get_tree+0x25/0xb0
>  path_mount+0x454/0xa20
>  __x64_sys_mount+0x103/0x140
>  do_syscall_64+0x3b/0xc0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
> ---
>  fs/ocfs2/super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c86bd4e60e20..1dea535224df 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2169,9 +2169,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (ocfs2_clusterinfo_valid(osb)) {
>  		osb->osb_stackflags =
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
> -		strlcpy(osb->osb_cluster_stack,
> +		memcpy(osb->osb_cluster_stack,
>  		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
> -		       OCFS2_STACK_LABEL_LEN + 1);
> +		       OCFS2_STACK_LABEL_LEN);
> +		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
>  		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
>  			mlog(ML_ERROR,
>  			     "couldn't mount because of an invalid "
> @@ -2180,9 +2181,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			status = -EINVAL;
>  			goto bail;
>  		}
> -		strlcpy(osb->osb_cluster_name,
> +		memcpy(osb->osb_cluster_name,
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> -			OCFS2_CLUSTER_NAME_LEN + 1);
> +			OCFS2_CLUSTER_NAME_LEN);
> +		osb->osb_cluster_name[OCFS2_CLUSTER_NAME_LEN] = '\0';
>  	} else {
>  		/* The empty string is identical with classic tools that
>  		 * don't know about s_cluster_info. */
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
