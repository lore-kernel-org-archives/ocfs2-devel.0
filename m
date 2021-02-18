Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7019CC433E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 17:28:37 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C336160202
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 17:28:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C336160202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QHPqWi184434;
	Fri, 26 Feb 2021 17:28:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36xqkfa922-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 17:28:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QHKI6J150475;
	Fri, 26 Feb 2021 17:28:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36uc6w5fcr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 17:28:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOx-0000lr-D7; Fri, 26 Feb 2021 08:55:39 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=6762db3dd=Chaitanya.Kulkarni@wdc.com>)
	id 1lCY75-0002Pi-Lc
	for ocfs2-devel@oss.oracle.com; Wed, 17 Feb 2021 17:28:15 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11I1Q6gI107146
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 01:28:15 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 36prpyunm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 01:28:15 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11I1O5oY048540
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 01:28:14 GMT
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	by userp2040.oracle.com with ESMTP id 36qrn1rqn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 01:28:14 +0000
IronPort-SDR: 4M88/9R/M4HR78hDDgozsqeLNcrKDcQhQIJmP9TXkmbtTPL6yPoZ1bM7xqHkXXxRFDDdTwigus
	mX5gd0CwlopugYCRTtOHQJopUAAsTISKaYaw4apfQyBsiluX3a4Rjf7VpS2Lf3x7MzVjK/nTdx
	djmGlB7C12dt0Rta8wMbhG6TZWfwu4HmiE1uxo6qqVm89CyfifeWMzkq23vWWRp6oFDDG6pKxJ
	IGK+ZbjuTPsRQYy55cOH0fLinw9UoYX1CD67RhnSXlGc+WYIAKau3aAnc6EaAEKVzmR4RuLma5
	7b0=
X-IronPort-AV: E=Sophos;i="5.81,185,1610380800"; d="scan'208";a="160235283"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO
	NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
	by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 09:28:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=GsvHQavf7uNlQ8d/3oXOF87+GvxVIS7rl+xPiEGXnHP+bBUzAqaNm79hvp6eEOelgsqnMdrw+/UPYXBqUqOTa5pnRU4tFNgDa9nLm4urO01I3oavRBVKe/vBSZY0cmZCNUfeMdAy448tzUkbPFZ+HA0L678ORN689HKD3GlNknbjj/aa/inu26GRcHgxm6ZoaTp4vnJIX0csxabEjE6nXT7No/iQFEwefWDC2u9zDR33iE8JiBL/QdUGhtOfICUkWaWMVhHbQwy1/JhuPajet2bj67dnvUlXiTo9kDSgmRpWiIUCJN5wOqA3M1VNKsXEe2jfnCtxL0fSMYuJw4vVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=nVXbQhzjMljenFFGdNZDlx1QlYnqBP6C3iQWXjZAeDQ=;
	b=D5Ytc/df2DjxEIjW1QryLJ4PGUbnB4Ea3TV4TMBIJJe8DPrtS7/fCrYYQqqU4ssKhfL6DXKyI+ZNIR6LwOebIgPjxKUsjt0VplzRsXrmumld0mbBvENF/awZ15Ok/IV6/9F9mTCXij7K1iD7W+Z0sFanabFIx+4VFlXzVHtIjaNPcKGT03ZluX8jLrza9njERNtaKgX2RI3q74SGBrf4x8krmb/G7SmtLcmpf9Z+p8jh5zsmy03qoXUJFM7u3O4PUmydrU65J49EK9YrYeUvGRQPEtmB28UyPJfcA10fq1voUzC4x1k0u63AqIPz8W0Gv9XhFgSoMRGCHlVRMjeeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com;
	dkim=pass header.d=wdc.com; arc=none
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4759.namprd04.prod.outlook.com (2603:10b6:a03:15::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38;
	Thu, 18 Feb 2021 01:28:03 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3846.041;
	Thu, 18 Feb 2021 01:28:03 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Pavel Machek <pavel@ucw.cz>
Thread-Topic: [RFC PATCH 29/34] power/swap: use bio_new in hib_submit_io
Thread-Index: AQHW9UVtzcRBxm47UEq6Z+ZGJ3C99A==
Date: Thu, 18 Feb 2021 01:28:03 +0000
Message-ID: <BYAPR04MB49652FAADFDCAA3DF72DDEE186859@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
	<20210217220257.GA10791@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ucw.cz; dkim=none (message not signed)
	header.d=none;ucw.cz; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06721654-7df7-4cf0-a01b-08d8d3ac6fd8
x-ms-traffictypediagnostic: BYAPR04MB4759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB475955F370F81E8B007520E886859@BYAPR04MB4759.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RcRwgz6IM2A/u/TWxloQlzmC7jpW7IdpwapwE2srZFbILm7vBO1dKGMJs5xJorby8uToHqvtIxmTesokOK2N67DDeAojN22PAHvdQmSqNaSTDLBzH2qMKpFV1+WzWIVjxYMdCnh4jbF3SPjmDqwN/yIYFDFyk1EwDVJOfFLLMnaVxJAscRAP1ZFSZCNBzbges1ZNat9Mh1a+bsGirLXNwdSp2Afj7WrLg+DqkEDznkumbqbojWv2cikOO/w0aDpnRPnXREJ+NQdYMomG/M/yAnArKOyCvjTCoBmEv3pXZZerNQ1l33hI6zSUNjzJcTlPZ2+8e2cI2VO0+TzZ/hOuxZ06W2eFjAmeVDqVAaTFUCCfPrlmFghyrFtQzTvLF3BAta6ZiKq6LdIOocMNcqDB7SvM+Vy8jGmeQRmHkzsdJBhthIkjCGU/2Ujs3bqZtAIGKXyX+QheehpSxQ7dv8hPsjXXDBRnon9r6T5eMc3v1712HMeHqbj4g63qCPkU2S/O4NB5wD8r4YmNhCQ8vmr6qQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:BYAPR04MB4965.namprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(6916009)(33656002)(2906002)(55016002)(5660300002)(7406005)(9686003)(8676002)(4326008)(86362001)(8936002)(478600001)(71200400001)(7366002)(316002)(186003)(7416002)(52536014)(54906003)(76116006)(66556008)(66946007)(64756008)(7696005)(53546011)(6506007)(66446008)(66476007)(26005);
	DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FIItwhJNoqlHqrXr7ohF0LCXk2DS0EdG1yLZV0Z4VhMmvaysA9SgTmrClqIG?=
	=?us-ascii?Q?H3mrueUZG2rfqbYjvGN1Y1jpOkrI0tSChqG3PmuxYoz9EC8+CqA2NMt8YiG0?=
	=?us-ascii?Q?avib5faAAruYFRaTRBrtOZqj5Kae+D1MvohlzKuTpITQC0MUwI3xYA7RkXrc?=
	=?us-ascii?Q?sgn3HFfoZar+Qd1DoDBCAFo7j8O/MTD5eZZo9pgTs5AtwYk1hYbuFqmFZlpl?=
	=?us-ascii?Q?bSWSn/tV9sXNp9d/FpFzxvANMuy2h0Z4koAntonbxCVQWy4RXgZuCfKx8ihl?=
	=?us-ascii?Q?8ITpSwYLWRPvHfIrYc71WuBsdFzfr/s7nQZKVj5B6Oc/989Pk5sDFQTMhl8s?=
	=?us-ascii?Q?8d+5CSeJfjq/AR24QEulThpVLzLCKx9lznAAO1BPf9880E0vT+ocFYFXhz+T?=
	=?us-ascii?Q?2pCjGrPdpVJOwWMBa+WyzoiugWCSlCBlIQtpNUlB/QyBMx5eN5PUQsDN1btn?=
	=?us-ascii?Q?qlENDWj+45WaUXLdHYx6Ks+YpBEKLM2r1XMI5fdEEGkfwh7f7GqMUFbfOk0K?=
	=?us-ascii?Q?HIIBEvTq3oJXoFzib/yy596Ppl2fJiJGTDpXIdDPU/zN4dtzkkyv0VD085vR?=
	=?us-ascii?Q?0HkezDO7QBfwWpmkoV6OewO/RJOFoq5jNR/QJiiiqsPEzV7Z6T1Q95PJdvTP?=
	=?us-ascii?Q?PZuGAalpLyPcO7ms4hMFMo1U8+6XyfAmlkCrgWrtJieSu89xTLjPjcIurFvC?=
	=?us-ascii?Q?jufErXi6AIdXYhjfC7Qn3j6LJFeUffVyeQJ3yqz7aMaCXyh0N61ZHZ49g2hv?=
	=?us-ascii?Q?2SUpJ4MmLH7bSeIDLDUkJs9k1ufFvCwpfwdb3NBo6YxbGJPxFKXaR8idCCSb?=
	=?us-ascii?Q?QJNDgOlpvtM1yL3zcYDbkemuOABjcaDowGs8058X3FlzN1YAwF/CVtD0ThkW?=
	=?us-ascii?Q?zZNPs/x8dmVxzxocn+ZAXR+OsGnBy+YX/PRHIFYX90Am3Qbmfrzs+aJchYGK?=
	=?us-ascii?Q?zIm2tUM2jO4CTM7LW+UBFu8AJ0Cei4vmpe6L49QadsHoZuf5OahJLq6jE/j1?=
	=?us-ascii?Q?5pn6S4Byv5bclnFanhxBSiVv6JKQ6F5huJ3GY5KxMKvPj/X0TWWcX6uK0vq6?=
	=?us-ascii?Q?tHS/FYwrjHMEiMY+qErRsjEL30TJZlvtn9X9cKL0SUutNIDqZfNys6WxLiUX?=
	=?us-ascii?Q?oDsEk2EkVDQxEL/eb/QRixTUrTZcELUTddej0C3ypQcmIgJHJPhLB/8bzobn?=
	=?us-ascii?Q?RzpfPgCl6hVEWzSynB3Lqqljq5oh5VUFHrvF2iVFdEpMKWDlnBnVzKP1MoVY?=
	=?us-ascii?Q?+9+yJJYgYEJjcZPzXmUL4J2skzLncVRkrpGKxdRSLWhJrGgqm7HHSe67r4PW?=
	=?us-ascii?Q?BAQaAMKewt7oKQDpMEem1Qmz?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06721654-7df7-4cf0-a01b-08d8d3ac6fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 01:28:03.6019 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iwT3NHWXg8QVXADRxHceCUGDm5QEez0FiJmRfbimNLUHwFL3p95byR8mLhVMJL3VGD62zPKA+aTh7kf1DD7ORrPoFj0oolcWym1ymC0x1KQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4759
X-PDR: PASS
X-Source-IP: 216.71.153.144
X-ServerName: esa5.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ptr ip4:35.160.12.30 ip4:52.34.195.46
	ip4:35.162.181.10
	ip4:35.162.44.129 ip4:68.232.141.245 ip4:68.232.143.124
	ip4:52.36.78.170
	ip4:52.86.68.205 ip4:52.86.226.44 ip4:68.232.142.99 ip4:68.232.148.20
	ip4:52.26.217.74 ip4:54.187.119.58 ip4:216.71.154.42 ip4:68.232.143.124
	ip4:68.232.141.245 ip4:216.71.153.141 ip4:216.71.153.144
	ip4:216.71.154.45
	ip4:199.255.45.14 ip4:199.255.45.15 include:spf.mandrillapp.com
	include:servers.mcsv.net include:spf.protection.outlook.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	suspectscore=0 adultscore=0 bulkscore=0 clxscore=221 priorityscore=60
	impostorscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102180007
X-Spam: Clean
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:38 -0800
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
        "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
        "jth@kernel.org" <jth@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>
Subject: Re: [Ocfs2-devel] [RFC PATCH 29/34] power/swap: use bio_new in
	hib_submit_io
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260128

On 2/17/21 14:03, Pavel Machek wrote:
> Hi!
>> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
>> index c73f2e295167..e92e36c053a6 100644
>> --- a/kernel/power/swap.c
>> +++ b/kernel/power/swap.c
>> @@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
>>  		struct hib_bio_batch *hb)
>>  {
>>  	struct page *page = virt_to_page(addr);
>> +	sector_t sect = page_off * (PAGE_SIZE >> 9);
>>  	struct bio *bio;
>>  	int error = 0;
>>  
>> -	bio = bio_alloc(GFP_NOIO | __GFP_HIGH, 1);
>> -	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
>> -	bio_set_dev(bio, hib_resume_bdev);
>> -	bio_set_op_attrs(bio, op, op_flags);
>> +	bio = bio_new(hib_resume_bdev, sect, op, op_flags, 1,
>> +		      GFP_NOIO | __GFP_HIGH);
>>  
> C function with 6 arguments... dunno. Old version looks comparable or
> even more readable...
>
> Best regards,
> 							Pavel
The library functions that are in the kernel tree which are used
in different file-systems and fabrics drivers do take 6 arguments.

Plus what is the point of duplicating code for mandatory
parameters all over the kernel ?


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
