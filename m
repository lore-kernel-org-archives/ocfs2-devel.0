Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEC8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C196F60F44
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C196F60F44
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fieldses.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESvg6024785;
	Mon, 13 Sep 2021 14:28:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka92qup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DED7Pq133716;
	Mon, 13 Sep 2021 14:28:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b0hjtjvqc-1;
	Mon, 13 Sep 2021 14:28:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwx-0004YF-2j; Mon, 13 Sep 2021 07:28:47 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bfields@fieldses.org>) id 1mH5Cn-0004HX-Vk
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 07:09:09 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KE57BM135517
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:09:09 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vnkw45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:09:05 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KE81OV018564
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:09:04 GMT
Received: from fieldses.org (fieldses.org [173.255.197.46])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahvfvc6d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 14:09:04 +0000
Received: by fieldses.org (Postfix, from userid 2815)
	id 0D0065BAF; Fri, 20 Aug 2021 10:09:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 0D0065BAF
Date: Fri, 20 Aug 2021 10:09:03 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@kernel.org>
Message-ID: <20210820140903.GA18096@fieldses.org>
References: <20210820135707.171001-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210820135707.171001-1-jlayton@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: 173.255.197.46
X-ServerName: fieldses.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:home.fieldses.org -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	impostorscore=0
	lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=190
	mlxlogscore=918 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108200079 domainage_hfrom=7291
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200079
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: linux-nfs@vger.kernel.org, david@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, w@1wt.eu, cluster-devel@redhat.com,
        linux-mm@kvack.org, rostedt@goodmis.org, ebiederm@xmission.com,
        luto@kernel.org, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, torvalds@linux-foundation.org,
        linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk
Subject: Re: [Ocfs2-devel] [PATCH v2 0/2] fs: remove support for mandatory
	locking
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-GUID: ip-EOvNXgZnlJkghQwcX9GHEHzPjZ39t
X-Proofpoint-ORIG-GUID: ip-EOvNXgZnlJkghQwcX9GHEHzPjZ39t

On Fri, Aug 20, 2021 at 09:57:05AM -0400, Jeff Layton wrote:
> The first patch in this series adds a new warning that should pop on
> kernels have mandatory locking enabled when someone mounts a filesystem
> with -o mand. The second patch removes support for mandatory locking
> altogether.
> 
> What I think we probably want to do is apply the first to v5.14 before
> it ships and allow the new warning to trickle out into stable kernels.
> Then we can merge the second patch in v5.15 to go ahead and remove it.
> 
> Sound like a plan?

Sounds good to me.--b.

> 
> Jeff Layton (2):
>   fs: warn about impending deprecation of mandatory locks
>   fs: remove mandatory file locking support
> 
>  .../filesystems/mandatory-locking.rst         | 188 ------------------
>  fs/9p/vfs_file.c                              |  12 --
>  fs/Kconfig                                    |  10 -
>  fs/afs/flock.c                                |   4 -
>  fs/ceph/locks.c                               |   3 -
>  fs/gfs2/file.c                                |   3 -
>  fs/locks.c                                    | 116 +----------
>  fs/namei.c                                    |   4 +-
>  fs/namespace.c                                |  31 +--
>  fs/nfs/file.c                                 |   4 -
>  fs/nfsd/nfs4state.c                           |  13 --
>  fs/nfsd/vfs.c                                 |  15 --
>  fs/ocfs2/locks.c                              |   4 -
>  fs/open.c                                     |   8 +-
>  fs/read_write.c                               |   7 -
>  fs/remap_range.c                              |  10 -
>  include/linux/fs.h                            |  84 --------
>  mm/mmap.c                                     |   6 -
>  mm/nommu.c                                    |   3 -
>  19 files changed, 20 insertions(+), 505 deletions(-)
>  delete mode 100644 Documentation/filesystems/mandatory-locking.rst
> 
> -- 
> 2.31.1

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
