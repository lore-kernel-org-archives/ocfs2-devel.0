Return-Path: <SRS0=dMzQ=NU=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C270C432BE
	for <ocfs2-devel@archiver.kernel.org>; Sun, 29 Aug 2021 19:55:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F77360F42
	for <ocfs2-devel@archiver.kernel.org>; Sun, 29 Aug 2021 19:55:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F77360F42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17TEMXeV031585;
	Sun, 29 Aug 2021 19:55:08 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3arbxsg60y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 29 Aug 2021 19:55:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17TJo2j7116793;
	Sun, 29 Aug 2021 19:55:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aqa8vy8uw-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 29 Aug 2021 19:55:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mKQnP-0000Uf-IA; Sun, 29 Aug 2021 12:48:47 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mKQnJ-0000UC-O0
	for ocfs2-devel@oss.oracle.com; Sun, 29 Aug 2021 12:48:41 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17TJe1g8104429
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:48:41 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3aqa8vy1uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:48:38 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17TF2l0B015648
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:48:37 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqxu1x3av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 29 Aug 2021 19:48:36 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mKQkm-00H7LP-82; Sun, 29 Aug 2021 19:46:04 +0000
Date: Sun, 29 Aug 2021 19:46:04 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Message-ID: <YSvj/ML2saV3+5Ru@zeniv-ca.linux.org.uk>
References: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
	<20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
	<87r1edgs2w.ffs@tglx> <YSqy+U/3lnF6K0ia@zeniv-ca.linux.org.uk>
	<YSq0mPAIBfqFC/NE@zeniv-ca.linux.org.uk>
	<YSq2WJindB0pJPRb@zeniv-ca.linux.org.uk>
	<YSq93XetyaUuAsY7@zeniv-ca.linux.org.uk> <87k0k4gkgb.ffs@tglx>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k0k4gkgb.ffs@tglx>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=166 impostorscore=0
	lowpriorityscore=0 suspectscore=0 mlxlogscore=883 malwarescore=0
	phishscore=0 clxscore=359 mlxscore=0 adultscore=0 bulkscore=0
	spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108290127 domainage_hfrom=9159
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	adultscore=0 malwarescore=0 mlxlogscore=936 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108290126
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108290127
X-Proofpoint-GUID: _udgw23NirL1HI5kPSpFTA_zHgxt8LhI
X-Proofpoint-ORIG-GUID: _udgw23NirL1HI5kPSpFTA_zHgxt8LhI

On Sun, Aug 29, 2021 at 08:44:04PM +0200, Thomas Gleixner wrote:
> On Sat, Aug 28 2021 at 22:51, Al Viro wrote:
> > @@ -345,7 +346,7 @@ static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
> >  	 */
> >  	err = __clear_user(&buf->header, sizeof(buf->header));
> >  	if (unlikely(err))
> > -		return -EFAULT;
> > +		return -X86_TRAP_PF;
> 
> This clear_user can be lifted into copy_fpstate_to_sigframe(). Something
> like the below.

Hmm...  This mixing of -X86_TRAP_... with -E... looks like it's asking for
trouble in general.  Might be worth making e.g. fpu__restore_sig() (and
its callers) return bool, seeing that we only check for 0/non-zero in
there.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
