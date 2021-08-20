Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE925C4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:54:10 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 668506113E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 668506113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KFkc6K027391;
	Fri, 20 Aug 2021 15:54:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aj6rfs9jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 15:54:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KFjDpw148139;
	Fri, 20 Aug 2021 15:54:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aje12w651-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 15:54:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH6nJ-0002Ee-WF; Fri, 20 Aug 2021 08:50:58 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jlayton@kernel.org>) id 1mH6nI-0002E3-U2
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 08:50:56 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KFj3CP134322
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:50:56 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3ae5ndtu7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:50:56 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KFlvAZ019203
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:50:55 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahvfvdhu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:50:55 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22846610FF;
	Fri, 20 Aug 2021 15:50:52 +0000 (UTC)
Message-ID: <7efb04fe6e0c867e7c87d75cf3349221b08b4210.camel@kernel.org>
From: Jeff Layton <jlayton@kernel.org>
To: David Laight <David.Laight@ACULAB.COM>,
        "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Date: Fri, 20 Aug 2021 11:50:51 -0400
In-Reply-To: <c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
	<20210820135707.171001-2-jlayton@kernel.org>
	<c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200089
Cc: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "w@1wt.eu" <w@1wt.eu>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "luto@kernel.org" <luto@kernel.org>,
        "v9fs-developer@lists.sourceforge.net"
	<v9fs-developer@lists.sourceforge.net>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [Ocfs2-devel] [PATCH v2 1/2] fs: warn about impending
 deprecation of mandatory locks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200089
X-Proofpoint-GUID: vDhdLS0UsphqBYH3c3T7dDCP9X8ZY4Pi
X-Proofpoint-ORIG-GUID: vDhdLS0UsphqBYH3c3T7dDCP9X8ZY4Pi

On Fri, 2021-08-20 at 15:49 +0000, David Laight wrote:
> From: Jeff Layton
> > Sent: 20 August 2021 14:57
> > 
> > We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> > have disabled it. Warn the stragglers that still use "-o mand" that
> > we'll be dropping support for that mount option.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/namespace.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index ab4174a3c802..ffab0bb1e649 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
> >  }
> > 
> >  #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> > +static bool warned_mand;
> >  static inline bool may_mandlock(void)
> >  {
> > +	if (!warned_mand) {
> > +		warned_mand = true;
> > +		pr_warn("======================================================\n");
> > +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> > +		pr_warn("         will be removed in v5.15!\n");
> > +		pr_warn("======================================================\n");
> > +	}
> >  	return capable(CAP_SYS_ADMIN);
> >  }
> 
> If that is called more than once you don't want the 'inline'.
> I doubt it matters is not inlined - hardly a hot path.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

ACK. Of course. That really needs to not be inline. I'll fix that up in
my tree.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
