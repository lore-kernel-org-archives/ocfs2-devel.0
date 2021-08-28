Return-Path: <SRS0=7twz=NT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F9CC432BE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 22:19:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A957C60E93
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 22:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A957C60E93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17SEChg0022182;
	Sat, 28 Aug 2021 22:19:23 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aqdpu0ubk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Aug 2021 22:19:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17SMFtb5154436;
	Sat, 28 Aug 2021 22:19:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aqa8ur6k7-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 28 Aug 2021 22:19:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mK6fY-0003g0-It; Sat, 28 Aug 2021 15:19:20 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mK6fX-0003fe-6y
	for ocfs2-devel@oss.oracle.com; Sat, 28 Aug 2021 15:19:19 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17SMFdtR029472
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 22:19:18 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3aqsrf83hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 22:19:18 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17SHp6JJ030028
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 22:19:17 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqsw51cef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 22:19:17 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mK6fI-00Gu1S-6O; Sat, 28 Aug 2021 22:19:04 +0000
Date: Sat, 28 Aug 2021 22:19:04 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Message-ID: <YSq2WJindB0pJPRb@zeniv-ca.linux.org.uk>
References: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
	<20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
	<87r1edgs2w.ffs@tglx> <YSqy+U/3lnF6K0ia@zeniv-ca.linux.org.uk>
	<YSq0mPAIBfqFC/NE@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSq0mPAIBfqFC/NE@zeniv-ca.linux.org.uk>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	mlxlogscore=999 bulkscore=0
	malwarescore=0 suspectscore=0 clxscore=333 adultscore=0
	priorityscore=248
	impostorscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108280156 domainage_hfrom=9158
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	malwarescore=0
	phishscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280156
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280156
X-Proofpoint-ORIG-GUID: TEqTXZwsaUkshVKYasI6Cdg7aIneBqak
X-Proofpoint-GUID: TEqTXZwsaUkshVKYasI6Cdg7aIneBqak

On Sat, Aug 28, 2021 at 10:11:36PM +0000, Al Viro wrote:
> On Sat, Aug 28, 2021 at 10:04:41PM +0000, Al Viro wrote:
> > On Sat, Aug 28, 2021 at 11:47:03PM +0200, Thomas Gleixner wrote:
> > 
> > >   /* Try to handle #PF, but anything else is fatal. */
> > >   if (ret != -EFAULT)
> > >      return -EINVAL;
> > 
> > > which all end up in user_insn(). user_insn() returns 0 or the negated
> > > trap number, which results in -EFAULT for #PF, but for #MC the negated
> > > trap number is -18 i.e. != -EFAULT. IOW, there is no endless loop.
> > > 
> > > This used to be a problem before commit:
> > > 
> > >   aee8c67a4faa ("x86/fpu: Return proper error codes from user access functions")
> > > 
> > > and as the changelog says the initial reason for this was #GP going into
> > > the fault path, but I'm pretty sure that I also discussed the #MC angle with
> > > Borislav back then. Should have added some more comments there
> > > obviously.
> > 
> > ... or at least have that check spelled
> > 
> > 	if (ret != -X86_TRAP_PF)
> > 		return -EINVAL;
> > 
> > Unless I'm misreading your explanation, that is...
> 
> BTW, is #MC triggered on stored to a poisoned cacheline?  Existence of CLZERO
> would seem to argue against that...

How about taking __clear_user() out of copy_fpregs_to_sigframe()
and replacing the call of fault_in_pages_writeable() with
	if (!clear_user(buf_fx, fpu_user_xstate_size))
		goto retry;
	return -EFAULT;
in the caller?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
