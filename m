Return-Path: <SRS0=Mf06=IH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71863C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Mar 2021 06:39:20 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F0DEE64EF1
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Mar 2021 06:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0DEE64EF1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1296ThDq034534;
	Tue, 9 Mar 2021 06:39:19 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 3742cn64gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Mar 2021 06:39:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1296UwJ9040571;
	Tue, 9 Mar 2021 06:39:18 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 374kgrcvfn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Mar 2021 06:39:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lJW1V-00030a-6J; Mon, 08 Mar 2021 22:39:17 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <xiaoguang.wang@linux.alibaba.com>)
	id 1lJW1S-000308-Jl
	for ocfs2-devel@oss.oracle.com; Mon, 08 Mar 2021 22:39:14 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1296V0Xf040946
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Mar 2021 06:39:14 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 374kgrcvdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Mar 2021 06:39:14 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1296YFwW008000
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Mar 2021 06:39:13 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by userp2040.oracle.com with ESMTP id 3740bvtwfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Mar 2021 06:39:13 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=xiaoguang.wang@linux.alibaba.com; NM=1; PH=DS; RN=15; SR=0;
	TI=SMTPD_---0UR3PFCN_1615271941; 
Received: from 30.225.32.219(mailfrom:xiaoguang.wang@linux.alibaba.com
	fp:SMTPD_---0UR3PFCN_1615271941) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 09 Mar 2021 14:39:01 +0800
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <5e7766f9-0224-10be-6810-2e516e610191@linux.alibaba.com>
Date: Tue, 9 Mar 2021 14:36:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	phishscore=0 mlxscore=0
	priorityscore=48 impostorscore=0 clxscore=181 bulkscore=0
	lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
	adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103090032
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 00/10] fsdax,
	xfs: Add reflink&dedupe support for fsdax
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090032
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1034 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103090032

hi,

First thanks for your patchset.
I'd like to know whether your patchset pass fstests? Thanks.

Regards,
Xiaoguang Wang

> This patchset is attempt to add CoW support for fsdax, and take XFS,
> which has both reflink and fsdax feature, as an example.
> 
> Changes from V1:
>   - Factor some helper functions to simplify dax fault code
>   - Introduce iomap_apply2() for dax_dedupe_file_range_compare()
>   - Fix mistakes and other problems
>   - Rebased on v5.11
> 
> One of the key mechanism need to be implemented in fsdax is CoW.  Copy
> the data from srcmap before we actually write data to the destance
> iomap.  And we just copy range in which data won't be changed.
> 
> Another mechanism is range comparison.  In page cache case, readpage()
> is used to load data on disk to page cache in order to be able to
> compare data.  In fsdax case, readpage() does not work.  So, we need
> another compare data with direct access support.
> 
> With the two mechanism implemented in fsdax, we are able to make reflink
> and fsdax work together in XFS.
> 
> 
> Some of the patches are picked up from Goldwyn's patchset.  I made some
> changes to adapt to this patchset.
> 
> (Rebased on v5.11)
> ==
> 
> Shiyang Ruan (10):
>    fsdax: Factor helpers to simplify dax fault code
>    fsdax: Factor helper: dax_fault_actor()
>    fsdax: Output address in dax_iomap_pfn() and rename it
>    fsdax: Introduce dax_iomap_cow_copy()
>    fsdax: Replace mmap entry in case of CoW
>    fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
>    iomap: Introduce iomap_apply2() for operations on two files
>    fsdax: Dedup file range to use a compare function
>    fs/xfs: Handle CoW for fsdax write() path
>    fs/xfs: Add dedupe support for fsdax
> 
>   fs/dax.c               | 532 +++++++++++++++++++++++++++--------------
>   fs/iomap/apply.c       |  51 ++++
>   fs/iomap/buffered-io.c |   2 +-
>   fs/remap_range.c       |  45 +++-
>   fs/xfs/xfs_bmap_util.c |   3 +-
>   fs/xfs/xfs_file.c      |  29 ++-
>   fs/xfs/xfs_inode.c     |   8 +-
>   fs/xfs/xfs_inode.h     |   1 +
>   fs/xfs/xfs_iomap.c     |  30 ++-
>   fs/xfs/xfs_iomap.h     |   1 +
>   fs/xfs/xfs_iops.c      |  11 +-
>   fs/xfs/xfs_reflink.c   |  16 +-
>   include/linux/dax.h    |   7 +-
>   include/linux/fs.h     |  15 +-
>   include/linux/iomap.h  |   7 +-
>   15 files changed, 550 insertions(+), 208 deletions(-)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
