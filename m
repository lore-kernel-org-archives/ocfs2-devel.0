Return-Path: <SRS0=aW/Z=IK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D889C433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 12 Mar 2021 09:05:15 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A859764FD0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 12 Mar 2021 09:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A859764FD0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C94PEs005675;
	Fri, 12 Mar 2021 09:05:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 373y8c1ett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Mar 2021 09:05:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C95B6o056374;
	Fri, 12 Mar 2021 09:05:12 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 374kgw8bn9-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 12 Mar 2021 09:05:12 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lKdgD-0002Ln-DK; Fri, 12 Mar 2021 01:01:57 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lKdfj-0002Ks-RU
	for ocfs2-devel@oss.oracle.com; Fri, 12 Mar 2021 01:01:27 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12C8taHb179683
	for <ocfs2-devel@oss.oracle.com>; Fri, 12 Mar 2021 09:01:27 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 374kat0r06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 12 Mar 2021 09:01:27 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12C8sRrW042165
	for <ocfs2-devel@oss.oracle.com>; Fri, 12 Mar 2021 09:01:26 GMT
Received: from esa19.fujitsucc.c3s2.iphmx.com (esa19.fujitsucc.c3s2.iphmx.com
	[216.71.158.62]) by userp2040.oracle.com with ESMTP id 377vqbfd9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 12 Mar 2021 09:01:26 +0000
IronPort-SDR: XwMPvmtS+QhyaW0mgQMq0tkoYtWMwLEccBeT5Iy7LTixvkSgUmj7X822rXwLF+vphUfE12FweD
	ftJvoOIwyaEycQrePYSc9Bya4t1OsBRyVgurx4wVpM2blv5xkhpLu4qh9a8SZ5g7EdkJZIgfgS
	A/ycrOONk+qTZ5WyhrPbiARNsC8jLdIo6ElpfT5Qjuxstv9vT3mWExkKkTcPM9IUyc24x8Pyja
	QU164iKOGM3ShCxXZkrcKxFK1M+cuHc3rHd+rAS4EAX548gktDDN72/qE4/n2Ni4GGwT4ZAAGP
	KYg=
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="27513876"
X-IronPort-AV: E=Sophos;i="5.81,243,1610377200"; d="scan'208";a="27513876"
Received: from mail-ty1jpn01lp2054.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.54])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 18:01:19 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=J6Vn/9orDAW5RAPYuf7Pbk/luxrTHBcAoBq/ROqQKVvVFoZeQMoJUQZcmowzrIaQz+S/YZXZI/M797IZzZFuBrcRdXWFHbsk6CeAmf4Iv8SZQGm29pfowxTYC+xKS40fuZB9U0wx2wTxONx1mMIPK1wgAJ4uCUFtZMh6oT25lgig9PnpIquZYBHt784lmRllBx+Wzm8topnWX9Wu6/yjpLUcJ+kPOVVHE0Xiz8LXf3PIiJHAE/mZTf/jhHU3o7g2+r4SjVWo4Y7kNlmFsgXIQVa/LRuEweQqt4KcJkVqRuGCFIUc3fUtJbMvMJpA9BRRs2uouUaOUNzffrfSVQ8sBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=yk+YTFH8WKhgYZ09EllwyG/0uEjhEVlJiYWnTzQ+u3U=;
	b=Wd4sM+KpTBbr8mxvBHYhDUoN6RTZYDI1nHUo0RnYAQqob/iNow9j8dM068+nBBCqR8OpeWYxjShpj3DDOVGybL4AWczHfcf/oi1zU/zrkUopAQII1B/VvQBheeydbgA3avwDnq4rKs+CT/UcRmr4V81zcQSyMFmYcZP1JL3prm0n3BYQFgrI5eusDXBzEIY0W+xcxPuBU6TvripgMPC6+W3/G6nRdWLIMfA88aMyDiJrxrjM8bIAdgNItgiKPahoAlE5RlYF1zalLAxDST44i7oiRv39R0coTTJXgap+D0p9gHqC0Eif21t+UAPYMi3kOITZDR/g/pgU2YDP4nHo/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS3PR01MB6008.jpnprd01.prod.outlook.com (2603:1096:604:d7::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17;
	Fri, 12 Mar 2021 09:01:16 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::c482:fa93:9877:5063]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::c482:fa93:9877:5063%3]) with mapi id 15.20.3912.027;
	Fri, 12 Mar 2021 09:01:16 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v2 02/10] fsdax: Factor helper: dax_fault_actor()
Thread-Index: AQHXC9VNT4eMfybPE02XhaXtAzw9EqpyB2AAgA4UeOA=
Date: Fri, 12 Mar 2021 09:01:15 +0000
Message-ID: <OSBPR01MB29207FE4814F0FDA5C08676AF46F9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-3-ruansy.fnst@fujitsu.com>
	<20210303092808.GC12784@lst.de>
In-Reply-To: <20210303092808.GC12784@lst.de>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
	header.d=none;lst.de; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [180.96.28.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54a9c150-8c32-497a-d769-08d8e53564e2
x-ms-traffictypediagnostic: OS3PR01MB6008:
x-microsoft-antispam-prvs: <OS3PR01MB60088C492D598BD1204E6352F46F9@OS3PR01MB6008.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7kmmeD4H5zkV3RVC1U5hnXEtyF6PDsktGhQgqN5r/YZM21UJKxyD2b4buhjuIZKD9zD5hc7MQYqv6oh3MV0S6U65/lCWiRMFtfuGEAy5nn1ZzeZ66CQNUPce4tSXJIVCTjw9XALK1JbI3jYglIFiX/VwUlRMeWIjtMU483g/K2obv69V3swFm7m0oP9R/4yOl2vT8fteU6KxqGJZgUkpngmJ+lVWqTBq89wq7H+MMt9+d/XIIBg+OW8UfOJzfaBEPHnlAwc4pimTfxgmkoTa1ZyKharcMDAiNW1apg+yOaQBVt5tJW4tGTLItkgmS/BVEHOh8QEKQjUn25sLSfDYPL26p1fmXyddc4YHjIPwdkt1UE2NJp2UuICX7XrUU4NVJ72+eP6WK5RCnXd9bYkNGoCzYei4ykY/8T4FFoO+3ox6nbra/QRiPzypU4qzh3Ypg3q58FPiilRVlbWylXMd9p7XTAKsBEChe8tqfS5ShMTysNFnG4825y8Um+GVXjlUfE7ZkiMKuF86cM3kQMlmyA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(6916009)(7416002)(4326008)(478600001)(6506007)(5660300002)(316002)(71200400001)(55016002)(54906003)(7696005)(33656002)(9686003)(64756008)(26005)(66476007)(66556008)(85182001)(76116006)(66446008)(52536014)(186003)(2906002)(8676002)(86362001)(8936002)(66946007);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?gb2312?B?USttYkl0dE00WWYyMjNzTThsYUh0WWc4WlZKSGtWUzd2N292UzR2R2k5YzM5?=
	=?gb2312?B?cWo3SCtqNHp6RmhXK0dKUlpEdGU5NnQvZ1BweXJld0lDL2JLRnc2VFVtbkIw?=
	=?gb2312?B?ODZLOUR4dER3Yyt1VGo3VzdSYU9mRzlkZ3ZxNmZIRVlDSFpQSXNGSUsvekda?=
	=?gb2312?B?UWtvMld0WnZOMy9XcVdVeEpFZklFUGYyKzV4YXNJTmV6bHAwMzhpNzVnRzVJ?=
	=?gb2312?B?TnVTNzRpWGEzY0l5U1VUNVhWOGhZRDVPbVEzNys4b1lnd0ZHdHJST09BUHZO?=
	=?gb2312?B?K3RBcmJMamtCUVRnQlFIN0o4SmpOWUYwZFp3K3g3aitucjZ4ZHdsbFBldy80?=
	=?gb2312?B?RVRmRkJJOXJjMW8vZE1FNVF0VEFhUzc5aHk2TDk4VTRmeTN1b0swcE1Sc050?=
	=?gb2312?B?cnZPYWlXelVGWnVWNVJBTzA5UjVhbmxuc2JLemNPSXJZdzl2WGVUQk9OMVdO?=
	=?gb2312?B?UzJxVkV5NWVJU0JYdkJjQmpLZVUvdEwrNDJjUGpXb0xXQmNKam1jbDlRbWVu?=
	=?gb2312?B?UkkvQzc1T2l3cUMvUWhWQ3lUZlFpcERiN2M2QVV3c08vZVlBNExaMjVNeGty?=
	=?gb2312?B?aDBqamwvSUNMc3ZNQm5CK0J6WUJ0bTJnaEFPbVNDbVpGWlQzQ3VzMXdDSFVG?=
	=?gb2312?B?b29RNW9CZzZxaWZ5RUxYM2xCcHdkWVBnYncwakxxSjIxdTY2SjFXUi9wcm1S?=
	=?gb2312?B?N3k4V3puNFBOYmp4LzNJRDB5NnpQTWI1K25Mazg2Nk5HMDIxdGhyWEtqeHRW?=
	=?gb2312?B?cFoyOUxvTDBJcHcvOStzUlNjY2JzK3JJK2ovaEw3ZWVuVHVOaTcvdndBNG5K?=
	=?gb2312?B?N1pYYk9UeHVWU1d1c2JDWEF2Tk90V2k1dFNNZVl6U0QvbldFK0dzQXJBVjZD?=
	=?gb2312?B?aGxDZC9Cb2dRamlxZnJTSnp5OW9pZ3ZEQ3RsRC90U2M0OENDYndSMkYxRFZ3?=
	=?gb2312?B?QUZ0ZEdhZDZCNWxURUM1ZTRqZ3JCOE1ZanQvK05YdFN2K3kwY09xSnRoWFBv?=
	=?gb2312?B?bHR1Rm5PYXBXQmhFaXZkR0V1Wko5T1RxTGphRW1RWnE2MlliVmFLVXFoK0Iz?=
	=?gb2312?B?YkttVmJETEdpY0VoQk5FTGwrM2ZZeUFvVnJQREtaUy8wUmFiejV0aVNMdkx0?=
	=?gb2312?B?ZDlJUitJTFQveXdEVUxnRVZMNGJoS0RuYnBSdkZrL2JNdlUxUTZRQkowYmRr?=
	=?gb2312?B?RWJWTEJtb0tYU3Fxd2J4NlpyUnpPMWhhODhrR3A3MktrUWZJM1VYS1V4dDhh?=
	=?gb2312?B?eUFoaWpzbFRxZ1hoaVh1SzlMeHRYQ1NBTzM4MU9rQ2hsWElrWVVoQTRoYTFr?=
	=?gb2312?B?QjVUNVc5V05ONHNueFkzbDZxNUZZUVZOazhiOHZOU0lJWFUwQnpNWHBwWmIx?=
	=?gb2312?B?V3FGTUFOeFJNeFNBLzhmbGxhRnZOZWJQYjcwaFlRMjdqZDExZXJCM3c2SDdv?=
	=?gb2312?B?SEdTeUVnNnp6S3hFWGdqMWdoWmVoYTBWYzV2cUF0ZUFnV1dzTmpnWjg5d0x5?=
	=?gb2312?B?YTZKYlE0bDhwbFFQZm1EblN6VEluSVE4ZmNYdFhscTlEVGV6TWlOOGZJRUs0?=
	=?gb2312?B?bUdXY0VFTFpWZmVuTyszOGdQY0t4RWNMQ0kyYTljeEVSdjRZZm9MU2JFSFBB?=
	=?gb2312?B?cFV5MTZ5R3VIOGh4Y3FNR0o0d2ovR24zc1J3UkJReCtNUFV2TG1icVRkb3M0?=
	=?gb2312?B?T0VNY0lXaEN6bGJqTUVoclFibFExWGw2RXhMUXBPYmVJbUExMDBzOXcrdFZR?=
	=?gb2312?Q?G726GbID3S6M2b1TXWOmXMsOFOR18SIHIUJTo/L?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a9c150-8c32-497a-d769-08d8e53564e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 09:01:16.0131 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /AEPTqwh8cAviCA9l1QTBTEbIEEpYpFqlxgzvxG/jmU0FMBZBVhRxH65sLsjCEz0PSdQ62R1uHT6+0QSDcONYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6008
X-PDR: PASS
X-Source-IP: 216.71.158.62
X-ServerName: esa19.fujitsucc.c3s2.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=110
	spamscore=0
	mlxlogscore=825 malwarescore=0 phishscore=0 bulkscore=0
	lowpriorityscore=0
	suspectscore=0 adultscore=0 mlxscore=0 priorityscore=85 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103120060
X-Spam: Clean
Cc: "jack@suse.cz" <jack@suse.cz>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 02/10] fsdax: Factor helper:
	dax_fault_actor()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120062
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120062



> > +	/* if we are reading UNWRITTEN and HOLE, return a hole. */
> > +	if (!write &&
> > +	    (iomap->type == IOMAP_UNWRITTEN || iomap->type ==
> IOMAP_HOLE)) {
> > +		if (!pmd)
> > +			return dax_load_hole(xas, mapping, &entry, vmf);
> > +		else
> > +			return dax_pmd_load_hole(xas, vmf, iomap, &entry);
> > +	}
> > +
> > +	if (iomap->type != IOMAP_MAPPED) {
> > +		WARN_ON_ONCE(1);
> > +		return VM_FAULT_SIGBUS;
> > +	}
> 
> Nit: I'd use a switch statement here for a clarity:
> 
> 	switch (iomap->type) {
> 	case IOMAP_MAPPED:
> 		break;
> 	case IOMAP_UNWRITTEN:
> 	case IOMAP_HOLE:
> 		if (!write) {
> 			if (!pmd)
> 				return dax_load_hole(xas, mapping, &entry, vmf);
> 			return dax_pmd_load_hole(xas, vmf, iomap, &entry);
> 		}
> 		break;
> 	default:
> 		WARN_ON_ONCE(1);
> 		return VM_FAULT_SIGBUS;
> 	}
> 
Hi, Christoph

I did not use a switch-case here is because that I still have to introduce a 'goto' for CoW(Writing on IOMAP_UNWRITTEN and the two different iomap indicate that it is a CoW operation. Then goto IOMAP_MAPPED branch to do the data copy and pfn insertion.)  You said the 'goto' makes the code convoluted.  So, I avoided to use it and refactored this part into so much if-else, which looks similar in dax_iomap_actor().  So, what's your opinion now?


--
Thanks,
Ruan Shiyang.

> 
> > +	err = dax_iomap_pfn(iomap, pos, size, &pfn);
> > +	if (err)
> > +		goto error_fault;
> > +
> > +	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
> > +				 write && !sync);
> > +
> > +	if (sync)
> > +		return dax_fault_synchronous_pfnp(pfnp, pfn);
> > +
> > +	ret = dax_fault_insert_pfn(vmf, pfn, pmd, write);
> > +
> > +error_fault:
> > +	if (err)
> > +		ret = dax_fault_return(err);
> > +
> > +	return ret;
> 
> It seems like the only place that sets err is the dax_iomap_pfn case above.  So
> I'd move the dax_fault_return there, which then allows a direct return for
> everyone else, including the open coded version of dax_fault_insert_pfn.
> 
> I really like where this is going!
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
