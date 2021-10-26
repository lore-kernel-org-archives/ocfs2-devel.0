Return-Path: <SRS0=myWd=PO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF4CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 05:16:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0489F6103C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 05:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0489F6103C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q37wjt026948;
	Tue, 26 Oct 2021 05:16:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhsbc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Oct 2021 05:16:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5Fsux091930;
	Tue, 26 Oct 2021 05:16:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4gyy117-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 26 Oct 2021 05:16:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfEmQ-0003Xk-MA; Mon, 25 Oct 2021 22:13:46 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <tytso@mit.edu>) id 1mfEmI-0003XE-UG
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 22:13:39 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5BtlC080691
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 05:13:38 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bx4gyxvf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 05:13:37 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19Q4LuVQ013623
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 05:13:35 GMT
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bxak10ess-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 05:13:35 +0000
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net
	[72.74.133.215]) (authenticated bits=0)
	(User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 19Q5Crw3021006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 26 Oct 2021 01:12:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id C967515C3F84; Tue, 26 Oct 2021 01:12:53 -0400 (EDT)
Date: Tue, 26 Oct 2021 01:12:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YXeOVZqer+GFBkXO@mit.edu>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHc6FU6JC4ZOwA8t854WbNdmuiNL9DPq0FPga8guATaoCtvsaw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU6JC4ZOwA8t854WbNdmuiNL9DPq0FPga8guATaoCtvsaw@mail.gmail.com>
X-Source-IP: 18.9.28.11
X-ServerName: outgoing-auth-1.mit.edu
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:18.7.21.0/24 ip4:18.7.34.0/24
	ip4:18.7.62.0/24 ip4:18.7.68.0/24
	ip4:18.7.71.0/24 ip4:18.9.1.0/24 ip4:18.9.21.0/24 ip4:18.9.25.0/24
	ip4:18.9.28.0/24 ip4:37.59.249.0/24 ip4:37.59.69.128/25 ip4:54.88.39.81
	ip4:64.128.67.16 ip4:64.128.67.20 ip4:69.25.199.0/24 ip4:72.55.140.81
	ip4:74.62.122.128/25 ip4:75.98.95.161/27 ip4:87.253.232.0/21
	ip4:87.253.236.214 ip4:96.43.144.64/31 ip4:96.43.148.64/31
	ip4:128.136.37.0/24 ip4:129.41.172.95 ip4:139.146.146.128/25
	ip4:139.146.160.0/25 ip4:139.60.0.0/22 ip4:148.105.0.0/16
	ip4:165.192.56.56 ip4:165.193.101.141 ip4:165.193.101.142
	ip4:165.193.56.42 ip4:178.33.111.144 ip4:178.33.137.208/28
	ip4:178.33.221.0/24 ip4:182.50.78.64/28 ip4:184.173.153.216
	ip4:185.189.236.0/22 ip4:185.211.120.0/22 ip4:198.2.128.0/18
	ip4:204.14.232.64/28 ip4:204.14.234.64/28 ip4:205.201.128.0/20
	ip4:205.217.12.155 ip4:205.217.12.177 ip4:205.237.106.0/24
	ip4:206.25.77.25 ip4:207.211.32.0/24 ip4:207.211.46.192/26
	ip4:207.211.60.0/24 ip4:207.211.61.0/24 ip4:216.138.238.192/26
	ip4:216.75.197.192/26 ip4:18.7.16.0/24 ip4:198.2.132.142
	include:spf.protection.outlook.com include:et._spf.pardot.com
	include:sendgrid.net include:mail.zendesk.com
	include:_shortspf.launchmetrics.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	clxscore=181
	phishscore=0 mlxlogscore=911 adultscore=0 priorityscore=146
	malwarescore=0
	spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2110260027
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
	deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260028
X-Proofpoint-ORIG-GUID: kuZMe3Pg5iEunB_dziaYgblbL9Fyymi0
X-Proofpoint-GUID: kuZMe3Pg5iEunB_dziaYgblbL9Fyymi0

On Mon, Oct 25, 2021 at 08:24:26PM +0200, Andreas Gruenbacher wrote:
> > For generic_perform_write() Dave Hansen attempted to move the fault-in
> > after the uaccess in commit 998ef75ddb57 ("fs: do not prefault
> > sys_write() user buffer pages"). This was reverted as it was exposing an
> > ext4 bug. I don't [know] whether it was fixed but re-applying Dave's commit
> > avoids the performance drop.
> 
> Interesting. The revert of commit 998ef75ddb57 is in commit
> 00a3d660cbac. Maybe Dave and Ted can tell us more about what went
> wrong in ext4 and whether it's still an issue.

The context for the revert can be found here[1].

[1] https://lore.kernel.org/lkml/20151005152236.GA8140@thunk.org/

And "what went wrong in ext4" was fixed here[2].

[2] https://lore.kernel.org/lkml/20151005152236.GA8140@thunk.org/

which landed upstream as commit b90197b65518 ("ext4: use private
version of page_zero_new_buffers() for data=journal mode").

So it looks like the original issue which triggered the revert in 2015
should be addressed, and we can easily test it by using generic/208
with data=journal mode.

There also seems to be a related discussion about whether we should
unrevert 998ef75ddb57 here[3].  Hmm. there is a mention on that thread
in [3], "Side note: search for "iov_iter_fault_in_writeable()" on lkml
for a gfs2 patch-series that is buggy, exactly because it does *not*
use the atomic user space accesses, and just tries to do the fault-in
to hide the real bug."  I assume that's related to the discussion on
this thread?

[3] https://lore.kernel.org/all/3221175.1624375240@warthog.procyon.org.uk/T/#u

						- Ted

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
