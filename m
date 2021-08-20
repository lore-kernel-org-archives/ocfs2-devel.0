Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59640C4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:49:33 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17E50610FF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17E50610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KFkFCt027911;
	Fri, 20 Aug 2021 15:49:32 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aje2687e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 15:49:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KFjDgP148156;
	Fri, 20 Aug 2021 15:49:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aje12vxve-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 15:49:30 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH6lt-0001tS-T7; Fri, 20 Aug 2021 08:49:29 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david.laight@aculab.com>) id 1mH6ls-0001t6-2m
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 08:49:28 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KFj7pa111121
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:49:27 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vns8jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:49:27 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KFlwRP019276
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:49:26 GMT
Received: from eu-smtp-delivery-151.mimecast.com
	(eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahvfvdh1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:49:26 +0000
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	uk-mta-131-DAGKzonBN4SYNa4fYJu3Dw-1; Fri, 20 Aug 2021 16:49:23 +0100
X-MC-Unique: DAGKzonBN4SYNa4fYJu3Dw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
	AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft
	SMTP Server (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 16:49:22 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
	AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
	15.00.1497.023; Fri, 20 Aug 2021 16:49:22 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Jeff Layton' <jlayton@kernel.org>,
        "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [PATCH v2 1/2] fs: warn about impending deprecation of mandatory
	locks
Thread-Index: AQHXlctJ2CxbK7rVbku/gUAYi8DQHat8icSQ
Date: Fri, 20 Aug 2021 15:49:22 +0000
Message-ID: <c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
	<20210820135707.171001-2-jlayton@kernel.org>
In-Reply-To: <20210820135707.171001-2-jlayton@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
X-Source-IP: 185.58.86.151
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
	include:servers.mcsv.net
	include:_spf.act-on.net include:aculabcloud.net -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=30 impostorscore=0
	lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=263
	mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200089
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
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
X-Proofpoint-ORIG-GUID: od3y1g5009TB0mLsG8kjImx_OorU6KMI
X-Proofpoint-GUID: od3y1g5009TB0mLsG8kjImx_OorU6KMI

From: Jeff Layton
> Sent: 20 August 2021 14:57
> 
> We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> have disabled it. Warn the stragglers that still use "-o mand" that
> we'll be dropping support for that mount option.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/namespace.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index ab4174a3c802..ffab0bb1e649 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
>  }
> 
>  #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> +static bool warned_mand;
>  static inline bool may_mandlock(void)
>  {
> +	if (!warned_mand) {
> +		warned_mand = true;
> +		pr_warn("======================================================\n");
> +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> +		pr_warn("         will be removed in v5.15!\n");
> +		pr_warn("======================================================\n");
> +	}
>  	return capable(CAP_SYS_ADMIN);
>  }

If that is called more than once you don't want the 'inline'.
I doubt it matters is not inlined - hardly a hot path.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
