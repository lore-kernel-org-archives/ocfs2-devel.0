Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5F4C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AFF6960F44
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFF6960F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DEFhim008877;
	Mon, 13 Sep 2021 14:28:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rtt1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEDPrg034954;
	Mon, 13 Sep 2021 14:28:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qh6vn-1;
	Mon, 13 Sep 2021 14:28:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwz-0004f9-9t; Mon, 13 Sep 2021 07:28:49 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <tglx@linutronix.de>) id 1mKQqA-00016O-6X
	for ocfs2-devel@oss.oracle.com; Sun, 29 Aug 2021 12:51:38 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17TJpcBn095176
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:51:38 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aqcy1qx0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:51:35 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17TE9weq012617
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:51:34 GMT
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqxfbp4ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:51:33 +0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <YSvj/ML2saV3+5Ru@zeniv-ca.linux.org.uk>
References: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
	<20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
	<87r1edgs2w.ffs@tglx> <YSqy+U/3lnF6K0ia@zeniv-ca.linux.org.uk>
	<YSq0mPAIBfqFC/NE@zeniv-ca.linux.org.uk>
	<YSq2WJindB0pJPRb@zeniv-ca.linux.org.uk>
	<YSq93XetyaUuAsY7@zeniv-ca.linux.org.uk> <87k0k4gkgb.ffs@tglx>
	<YSvj/ML2saV3+5Ru@zeniv-ca.linux.org.uk>
Date: Sun, 29 Aug 2021 21:51:29 +0200
Message-ID: <87h7f8ghby.ffs@tglx>
MIME-Version: 1.0
X-Source-IP: 193.142.43.55
X-ServerName: galois.linutronix.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	adultscore=0 spamscore=0
	mlxlogscore=621 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=339
	lowpriorityscore=0 priorityscore=234 suspectscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108290127
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0
	phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=624 bulkscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108290127
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: cluster-devel <cluster-devel@redhat.com>,
        "Luck,
	Tony" <tony.luck@intel.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Borislav Petkov <bp@alien8.de>,
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
X-Proofpoint-ORIG-GUID: b-NwNQFnS9JI4qYFubgwj5D5mZRRKDpd
X-Proofpoint-GUID: b-NwNQFnS9JI4qYFubgwj5D5mZRRKDpd

On Sun, Aug 29 2021 at 19:46, Al Viro wrote:

> On Sun, Aug 29, 2021 at 08:44:04PM +0200, Thomas Gleixner wrote:
>> On Sat, Aug 28 2021 at 22:51, Al Viro wrote:
>> > @@ -345,7 +346,7 @@ static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
>> >  	 */
>> >  	err = __clear_user(&buf->header, sizeof(buf->header));
>> >  	if (unlikely(err))
>> > -		return -EFAULT;
>> > +		return -X86_TRAP_PF;
>> 
>> This clear_user can be lifted into copy_fpstate_to_sigframe(). Something
>> like the below.
>
> Hmm...  This mixing of -X86_TRAP_... with -E... looks like it's asking for
> trouble in general.  Might be worth making e.g. fpu__restore_sig() (and
> its callers) return bool, seeing that we only check for 0/non-zero in
> there.

Let me fix that.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
