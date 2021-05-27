Return-Path: <SRS0=xTLC=KW=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCC1C47089
	for <ocfs2-devel@archiver.kernel.org>; Thu, 27 May 2021 14:14:20 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8418A613CA
	for <ocfs2-devel@archiver.kernel.org>; Thu, 27 May 2021 14:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8418A613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14REBoJr192938;
	Thu, 27 May 2021 14:14:18 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38rne47uy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 May 2021 14:14:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14RECKXK056846;
	Thu, 27 May 2021 14:14:17 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqucbh1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 27 May 2021 14:14:16 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lmGj4-0006Mf-Ks; Thu, 27 May 2021 07:11:06 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david.laight@aculab.com>) id 1lmGiW-0006Ld-49
	for ocfs2-devel@oss.oracle.com; Thu, 27 May 2021 07:10:32 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14RE15G2035461
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:10:31 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 38rehgdw3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:10:31 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14RE3O0R038428
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:10:30 GMT
Received: from eu-smtp-delivery-151.mimecast.com
	(eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by userp2030.oracle.com with ESMTP id 38smf58xft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 27 May 2021 14:10:29 +0000
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	uk-mta-140-jheLYrfmNJS7VYboBqC6Hg-1; Thu, 27 May 2021 15:10:23 +0100
X-MC-Unique: jheLYrfmNJS7VYboBqC6Hg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
	AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft
	SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May 2021 15:10:21 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
	AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
	15.00.1497.015; Thu, 27 May 2021 15:10:21 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Chen Huang' <chenhuang5@huawei.com>,
        Michael Ellerman
	<mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Boris Ostrovsky
	<boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano
	Stabellini <sstabellini@kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Joel
	Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        "Andrew Donnellan" <ajd@linux.ibm.com>,
        Alexey
	Kardashevskiy <aik@ozlabs.ru>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Thread-Topic: [PATCH -next 2/3] xen: balloon: Replaced simple_strtoull() with
	kstrtoull()
Thread-Index: AQHXUg74rK/OAxNe1kmGDaODmfSqv6r3X4NA
Date: Thu, 27 May 2021 14:10:21 +0000
Message-ID: <0f03f9b9ff41460db2935e077f7f80c7@AcuMS.aculab.com>
References: <20210526092020.554341-1-chenhuang5@huawei.com>
	<20210526092020.554341-2-chenhuang5@huawei.com>
In-Reply-To: <20210526092020.554341-2-chenhuang5@huawei.com>
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
X-PDR: PASS
X-Source-IP: 185.58.85.151
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
	include:servers.mcsv.net
	include:_spf.act-on.net include:aculabcloud.net -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=48 malwarescore=0
	lowpriorityscore=0 clxscore=291 suspectscore=0 bulkscore=0 spamscore=0
	phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105270092
X-Spam: Clean
Cc: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH -next 2/3] xen: balloon: Replaced
 simple_strtoull() with kstrtoull()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270093
X-Proofpoint-ORIG-GUID: EsCenFIILeZn-QHjAbWCYawqVvORfqb3
X-Proofpoint-GUID: EsCenFIILeZn-QHjAbWCYawqVvORfqb3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270093

From: Chen Huang
> Sent: 26 May 2021 10:20
> 
> The simple_strtoull() function is deprecated in some situation, since
> it does not check for the range overflow, use kstrtoull() instead.
> 
...
> -	target_bytes = simple_strtoull(buf, &endchar, 0) * 1024;
> +	ret = kstrtoull(buf, 0, &target_bytes);
> +	if (ret)
> +		return ret;
> +	target_bytes *= 1024;

I'd have thought it was more important to check *endchar
than overflow.
If you are worried about overflow you need a range check
before the multiply.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
