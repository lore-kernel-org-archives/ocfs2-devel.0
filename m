Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652F9C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:51 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE0EF60F44
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE0EF60F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DEFhij008877;
	Mon, 13 Sep 2021 14:28:50 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rtt1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEDP6e034968;
	Mon, 13 Sep 2021 14:28:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qh6tv-1;
	Mon, 13 Sep 2021 14:28:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwx-0004bh-Mv; Mon, 13 Sep 2021 07:28:47 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <tony.luck@intel.com>) id 1mJlBT-0006FU-A6
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 16:22:51 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RNFNbV119083
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 23:22:51 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3aq5yy968g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 23:22:50 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RKfOP6018407
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 23:22:49 GMT
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq7a8h9ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 23:22:49 +0000
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="197608073"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; d="scan'208";a="197608073"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
	by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Aug 2021 16:22:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; d="scan'208";a="538679488"
Received: from agluck-desk2.sc.intel.com (HELO
	agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
	by fmsmga002-auth.fm.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 16:22:47 -0700
Date: Fri, 27 Aug 2021 16:22:46 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
X-Source-IP: 192.55.52.136
X-ServerName: mga12.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	mlxscore=0 spamscore=0
	malwarescore=0 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
	priorityscore=285 mlxlogscore=599 lowpriorityscore=0 clxscore=376
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108270139 domainage_hfrom=12939
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 mlxscore=0
	phishscore=0 mlxlogscore=744 suspectscore=0 adultscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270139
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 05/19] iov_iter: Introduce
	fault_in_iov_iter_writeable
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-ORIG-GUID: 4-tZ-zmLFu_aTF2HDy-ED6Ut1ic9MS7U
X-Proofpoint-GUID: 4-tZ-zmLFu_aTF2HDy-ED6Ut1ic9MS7U

On Fri, Aug 27, 2021 at 09:57:10PM +0000, Al Viro wrote:
> On Fri, Aug 27, 2021 at 09:48:55PM +0000, Al Viro wrote:
> 
> > 	[btrfs]search_ioctl()
> > Broken with memory poisoning, for either variant of semantics.  Same for
> > arm64 sub-page permission differences, I think.
> 
> 
> > So we have 3 callers where we want all-or-nothing semantics - two in
> > arch/x86/kernel/fpu/signal.c and one in btrfs.  HWPOISON will be a problem
> > for all 3, AFAICS...
> > 
> > IOW, it looks like we have two different things mixed here - one that wants
> > to try and fault stuff in, with callers caring only about having _something_
> > faulted in (most of the users) and one that wants to make sure we *can* do
> > stores or loads on each byte in the affected area.
> > 
> > Just accessing a byte in each page really won't suffice for the second kind.
> > Neither will g-u-p use, unless we teach it about HWPOISON and other fun
> > beasts...  Looks like we want that thing to be a separate primitive; for
> > btrfs I'd probably replace fault_in_pages_writeable() with clear_user()
> > as a quick fix for now...
> > 
> > Comments?
> 
> Wait a sec...  Wasn't HWPOISON a per-page thing?  arm64 definitely does have
> smaller-than-page areas with different permissions, so btrfs search_ioctl()
> has a problem there, but arch/x86/kernel/fpu/signal.c doesn't have to deal
> with that...
> 
> Sigh...  I really need more coffee...

On Intel poison is tracked at the cache line granularity. Linux
inflates that to per-page (because it can only take a whole page away).
For faults triggered in ring3 this is pretty much the same thing because
mm/memory_failure.c unmaps the page ... so while you see a #MC on first
access, you get #PF when you retry. The x86 fault handler sees a magic
signature in the page table and sends a SIGBUS.

But it's all different if the #MC is triggerd from ring0. The machine
check handler can't unmap the page. It just schedules task_work to do
the unmap when next returning to the user.

But if your kernel code loops and tries again without a return to user,
then your get another #MC.

-Tony

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
