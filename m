Return-Path: <SRS0=okW4=JT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C296C43460
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 03:25:41 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B6CA61445
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 03:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B6CA61445
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M31Tdj019747;
	Thu, 22 Apr 2021 03:25:37 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37yveakpn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Apr 2021 03:25:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M3K1Tw172114;
	Thu, 22 Apr 2021 03:25:36 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3809ev6rep-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Apr 2021 03:25:36 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZPv8-0005TK-Ph; Wed, 21 Apr 2021 20:22:26 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lZPv6-0005Sz-SE
	for ocfs2-devel@oss.oracle.com; Wed, 21 Apr 2021 20:22:24 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13M3K1im172102
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 03:22:24 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 3809ev6myt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 03:22:24 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13M3DOGl020539
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 03:22:24 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36]) by userp2030.oracle.com with ESMTP id 3830688xhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 03:22:23 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UWMIiCM_1619061727; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UWMIiCM_1619061727) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 22 Apr 2021 11:22:07 +0800
To: Jan Kara <jack@suse.cz>
References: <20210421162953.GA13863@quack2.suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
Date: Thu, 22 Apr 2021 11:22:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421162953.GA13863@quack2.suse.cz>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	impostorscore=0
	mlxscore=0 mlxlogscore=958 lowpriorityscore=0 suspectscore=0
	clxscore=33
	phishscore=0 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104220027
X-Spam: Clean
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Possible fs corruption when hole punch races with
	other ops
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220028
X-Proofpoint-GUID: oEKfxfpbI4cL7O478pJl0S92Sd91g9oU
X-Proofpoint-ORIG-GUID: oEKfxfpbI4cL7O478pJl0S92Sd91g9oU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1034 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220024

Hi,

Checked the code flow, it seems the race you worried truly exists.
We have to take ip_alloc_sem before calling into ocfs2_get_block().

Thanks,
Joseph

On 4/22/21 12:29 AM, Jan Kara wrote:
> Hello,
> 
> I'm unifying protection various filesystems use to protect hole punch
> operations from racing with other operations (like readahead, page fault,
> writepage etc.). I was looking into OCFS2 and I think it is prone to a
> following race which can possibly lead to filesystem corruption. But maybe
> I miss something so that's why I'm writing here. The scenario I'm concerned
> about is:
> 
> CPU1					CPU2
> ocfs2_remove_inode_range()		ocfs2_writepage()
>   ...					  block_write_full_page()
>   ocfs2_remove_btree_range()		    ocfs2_extent_map_get_blocks()
> 
> Now ocfs2_extent_map_get_blocks() runs without protection of ip_alloc_sem
> AFAICT and so both these operations can be modifying extent map at the same
> time? What am I missing?
> 
> 								Honza
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
