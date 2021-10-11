Return-Path: <SRS0=Exlr=O7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A00C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 17:38:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 03F0B60E78
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 17:38:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03F0B60E78
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BGvKJV028913;
	Mon, 11 Oct 2021 17:38:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmpwn1emx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 17:38:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BHV26b166660;
	Mon, 11 Oct 2021 17:38:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bkyv8my5q-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 11 Oct 2021 17:38:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mZzFU-0002dL-Bs; Mon, 11 Oct 2021 10:38:04 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mZzFR-0002cz-5G
	for ocfs2-devel@oss.oracle.com; Mon, 11 Oct 2021 10:38:01 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BHUNqg117180
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 17:38:01 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bkyxq9t4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 17:38:00 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19BFn4MC011815
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 17:37:59 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bm0sa02dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 17:37:59 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A26E60560;
	Mon, 11 Oct 2021 17:37:56 +0000 (UTC)
Date: Mon, 11 Oct 2021 18:37:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YWR2cPKeDrc0uHTK@arm.com>
References: <20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Will Deacon <will@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110103
X-Proofpoint-GUID: UaNsPVTVLVwYfYInG4vcsZUuCb16xe-T
X-Proofpoint-ORIG-GUID: UaNsPVTVLVwYfYInG4vcsZUuCb16xe-T

On Tue, Aug 31, 2021 at 03:28:57PM +0000, Al Viro wrote:
> On Tue, Aug 31, 2021 at 02:54:50PM +0100, Catalin Marinas wrote:
> > An arm64-specific workaround would be for pagefault_disable() to disable
> > tag checking. It's a pretty big hammer, weakening the out of bounds
> > access detection of MTE. My preference would be a fix in the btrfs code.
> > 
> > A btrfs option would be for copy_to_sk() to return an indication of
> > where the fault occurred and get fault_in_pages_writeable() to check
> > that location, even if the copying would restart from an earlier offset
> > (this requires open-coding copy_to_user_nofault()). An attempt below,
> > untested and does not cover read_extent_buffer_to_user_nofault():
> 
> Umm...  There's another copy_to_user_nofault() call in the same function
> (same story, AFAICS).

I cleaned up this patch [1] but I realised it still doesn't solve it.
The arm64 __copy_to_user_inatomic(), while ensuring progress if called
in a loop, it does not guarantee precise copy to the fault position. The
copy_to_sk(), after returning an error, starts again from the previous
sizeof(sh) boundary rather than from where the __copy_to_user_inatomic()
stopped. So it can get stuck attempting to copy the same search header.

An ugly fix is to fall back to byte by byte copying so that we can
attempt the actual fault address in fault_in_pages_writeable().

If the sh being recreated in copy_to_sk() is the same on the retried
iteration, we could use an *sk_offset that is not a multiple of
sizeof(sh) in order to have progress. But it's not clear to me whether
the data being copied can change once btrfs_release_path() is called.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=devel/btrfs-fix

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
