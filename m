Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B02FC433E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:39 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A285564E85
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A285564E85
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGtJsq104903;
	Fri, 26 Feb 2021 16:55:38 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 36ugq3sh6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGsfjf118581;
	Fri, 26 Feb 2021 16:55:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc2uqsm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOt-0000fK-SZ; Fri, 26 Feb 2021 08:55:35 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lFYDY-0005rj-48
	for ocfs2-devel@oss.oracle.com; Fri, 26 Feb 2021 00:11:20 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q8AkIl043826
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 08:11:19 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36ucb34cfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 08:11:19 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q84rHi001687
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 08:11:19 GMT
Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com
	[216.71.156.121]) by userp2040.oracle.com with ESMTP id 36wskfnafs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 08:11:18 +0000
IronPort-SDR: XdyspZ0K3AQ1hivyUf5vavZpHyeFYzuAKSBraN8RWBGdBGOlUK6bgTLMmwmaUWBeCbyIZ6gXST
	EW0AmuXfd7zwLrVqmMtUd+7NII0BP3XReh8jd3ACh6S2T53p+8lP7lQhY98FUGMJaTyn02uhi9
	07VmxzTzJF/TCBiFAJ9zKE+P1tanAd1SPCGkM9EJWvA783JUT4ZamDhYqYEJrZgV01thXyOJXP
	PramsgEA+rNDazhNCvf3C2gPy1qSe1nGuOfAl1i8StZBadrz5iRHqSn/XxcMt6mx0ZFsxxxixu
	eUY=
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="27000737"
X-IronPort-AV: E=Sophos;i="5.81,207,1610377200"; d="scan'208";a="27000737"
Received: from mail-os2jpn01lp2050.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.50])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 17:11:12 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=O3MhxQoPho/U1lPviKSvvjbDdTJP9DxkgqSW0S1HkFTCJAp+TwPM8blmh+18lX8dafb372rKfWkmFSUwGUqNQHTn0GrP93vPq1MkrJGArtoiEf+PxUnsbMZGD9ADcolj3e+Iz8e7qjbzl84XpMLM17yeLN0wkaduYcV0m1wdiv2wJ3eyLm0afLgNFlIRmxpulTVMJOQsA2srLiyYDD12YMyH8BBe619q7vSYroD/CMlrY1No/uY1EfryguNS7i3KYQW7yqYoTrd95gh6NgTPpAxKQd9KqpHQkKozHNXI52UrSffcuKAYDt3We6daC/LZEMK/U7sDwVvZFmeV/MZ1GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=Ak/meoZ1EyG8mMt+rOT6jIYSj0VqRGrv2s4mcMfbPyY=;
	b=nEcTW9xGFCLJkjom14NN/ukWnrdd92pgb27H9a+3rBZxLDUmqx0xeZVD8w3397Pooe3RqYwx/dKY8+++80vIZwjxiDdmgkq58ySnWu+ORWp2al7cs4qUDD8oUnoJFZIHkwEOzfxlq5t+wGMlYw7/HS3J7exKHy3Fdd9d3LPmyGdvwxp4Z/mR4BRtG4mVPLYtcMfg8PTZdFwfMZ9MbUsHvS9sXs/MD0kCxSAdS9ijrn+IpdhjnEpJpVHJ3gEABiZhKqqgUfgpFcRFcV5W2+eFyGP87pfVNzbgzIjDRA4b9S7xG8hhdt72HuuwTRnKh5WqZwTiz2Jp06flZ59+bI3j7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB5206.jpnprd01.prod.outlook.com (2603:1096:604:7a::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19;
	Fri, 26 Feb 2021 08:11:08 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098%7]) with mapi id 15.20.3868.032;
	Fri, 26 Feb 2021 08:11:08 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [PATCH v2 07/10] iomap: Introduce iomap_apply2() for operations
	on two files
Thread-Index: AQHXC9VfucWA/H9ic0KAPVDA087Khqpp1CoAgAA7HZg=
Date: Fri, 26 Feb 2021 08:11:08 +0000
Message-ID: <OSBPR01MB2920FA6E33A264133D7908FDF49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-8-ruansy.fnst@fujitsu.com>,
	<20210226041446.GV7272@magnolia>
In-Reply-To: <20210226041446.GV7272@magnolia>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
	header.d=none; kernel.org;
	dmarc=none action=none header.from=fujitsu.com; 
x-originating-ip: [49.74.161.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53e551b0-aa10-4f49-8d2b-08d8da2e129f
x-ms-traffictypediagnostic: OSBPR01MB5206:
x-microsoft-antispam-prvs: <OSBPR01MB520628761B6D8816BF0340F4F49D9@OSBPR01MB5206.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gtxO5QWcSBPdTNvxLBYJjskcYhfLOL6c1WO2hyFQmo2rvJqlazNXFbMAEn8sMb6N6rZ6p34xVtHHSXds3+xrAa0IficHEu8mFa+QRyBkZS55V387YfUCBX3msJGT0Yx8MVUTnEXWvEpVt6S3DDtZibH0PCwP81MynNWQWJ1VuU7nLeQiIX0EaXW77893h9TZLwz+q4JfUgURVOaC1sLU/0Wqxxb+VUiM8nNAedV7Rx5vwZuq9xiHhPtwc9/hLsZpFgtY5wzi33yGq2pbUkDcT7Ch9LFVIkmdRXYwP2od0WZGMH3aSid8eIG2k+dH799Qu18x4Ch599VBKwQL9e44IFY0yS1fdjZ8u+N3OFL54qTXet7utgVxD9CkaMnz6JbpsnK8UQ3US8DwZikX4Z03v6MK+G2hmdxqnW3RFytX1i9ZTf40tPUIJoVB2GZMv+4tMzaW6ws7rWAYha3V7EnyVu6zmNRr9TA8tD+o/Gm8feceqe7gn0btFl9DjpvASLE4ZUpa3j1dimhmNFZDBiE1pw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(83380400001)(86362001)(55016002)(71200400001)(91956017)(2906002)(26005)(66476007)(52536014)(4326008)(478600001)(9686003)(66556008)(54906003)(85182001)(5660300002)(76116006)(8936002)(8676002)(186003)(6916009)(66446008)(316002)(6506007)(66946007)(7416002)(7696005)(33656002)(64756008);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?gb2312?B?YU9aWnFXR0l5bk8wbTlFVWNMRFkrbzVSY1JYazZBUXlGMVhZRmVPbzg1VS9z?=
	=?gb2312?B?WFl0VGtFdnpvWVR1ZHBhSDljbWFZYXAvbUQ2TndBY1pPcnBaK1NUbVdLaGlB?=
	=?gb2312?B?dHlPTE9yMVZCQWdoSTBtQ3Z5aTJFdE4ydU1NRGhmeXpBRXBMWnA0dy92Uk95?=
	=?gb2312?B?OFBDWDA3SVY2RDRFQXpqSkZSRUJPTWxwdzhSMGNLRDVtWVc3TDNuOTRXU0pH?=
	=?gb2312?B?U3pzdHV0Z1h6cWZSZVNHSkVzSjhPRFdUeU1DbThkaGlTdU5zQlB5OGsvanNh?=
	=?gb2312?B?dVJvOGZGWlMwNnU3aVpub0dKTDkrMHlVNnZYejBjaU9BYVJaN2FLVStDeENW?=
	=?gb2312?B?a0YvSktSRkR3UmdQcXZmQVdCQ1U1aWVkOHhRNDFQTlpZcVRZdkNDT0lkSUZI?=
	=?gb2312?B?ZUt3OU54MFYza0FGcmhZQVM1RlZhUlBBMXYyTW9nbHBEUVIwa2E0TERXUSt2?=
	=?gb2312?B?YWxkdUZESlE4eGtucStaZzNhY1NBT2ZFUWhZVENoMnVMMWQwZkRzWElJWHNI?=
	=?gb2312?B?ZkZqMkluNndhWGlGdnVDdHdTVDhQc3pMOGYvendmdWRpRDIvR1ZmdENrNlIv?=
	=?gb2312?B?VFpPcXgzTUdwTFJYa0toaEdIMmU1RE40RVppV294WisyeWxvNUtyRnFRRzZK?=
	=?gb2312?B?Wk0zU3M0bTRQSU9RNUlkVEdPT3dxTEtHTzZmRHRTREY3MktPZ2liMkR5OVN2?=
	=?gb2312?B?MlF5SmFIRWpJU2tKZmkzWTRxVHRJWGNsV1BrSXM3TzZoeWsvbDk4WnFnemVR?=
	=?gb2312?B?Mk1LbFUzbkg1M1N5L1ZQazJJbW9SZHhOR2h3QWp5cWZsRUs0NnpENXdMdEFj?=
	=?gb2312?B?cHdDbEMzcDhtbUwrNEttd3N2ZGVuL0RVSTVVQk9Lalg2d1hFbXRGcDhLeTdK?=
	=?gb2312?B?OHlDWThKdHhGTE1IVzdERHRPZkQrSURpN3ppdnJIVWV6TWdaSlk1QmZrWWJR?=
	=?gb2312?B?V0lsS0lPWmFNYm1QdStnRUVpencxZEtFc0xWWHJYczdFUG9mR1JXb0RmZjRB?=
	=?gb2312?B?NDk3NFNhcmxwQ29UMWpnLzJpZGV0UWowOGdSdS9jb1hIMlpyenJYQTMwQm0r?=
	=?gb2312?B?SXc4bm5ZcjlsaHNZUkdjZUNiVHRLMTVMK3NZanQraVRrZ1FnRFZZTDRLSTB5?=
	=?gb2312?B?TXVxNnVwNWpvUERPYjVKVExtS1Azd2lLa0Eya3B4TkNUaHM2aFVZbE9wWlht?=
	=?gb2312?B?S3pPZjFuY3piZUpvNDJKVFUxYUllVm9Hc1Q0UXRRYmJVZXdkOEtrNmprQkto?=
	=?gb2312?B?MnVRZ3R5Nk9TeVRiQm1kSkFlZ2tjbTdvdFdPT1JJeHlzOTJpZlRDNW42VGkr?=
	=?gb2312?B?Q1FsZzJ3Q2VHS0ZCdi9WSkI2eFB1ZnlGM2ZqOVU2NGoyWGJ5cEEwQ0VxOEo3?=
	=?gb2312?B?M0N5QS81L0YxRHdDNnc0RHh4cHFsQ0ZyTTArNDhDbXpyMDZkOUZJTUI1dWZy?=
	=?gb2312?B?UDFpYmVXZExVcHlHNUhkdUQ5Qi85R0srVEc4aGppamczYWFNTkcvOEJwWW5o?=
	=?gb2312?B?T2lORkZobE9rSmx1Y0N1alNlaVpVQnJyVlBGeTMyQU9veGNwenNqTWdKTFNW?=
	=?gb2312?B?MXNNVU5uWmk4WWFDSlBYUkNXbUZlK3lGMXFtOWJBWnhiSEFJTUozRmo2NytG?=
	=?gb2312?B?K3ptSkx4NUpwaWx4cmxGYk43TjRnSkJPTU9LWXVKbDFZU1RzR2pDalUyZ3VJ?=
	=?gb2312?B?ckR2Z0M1Ukc5d0VLUnVGY3BmN0R6V0l3M2MzQTdBWEFMaU56VGw3U1BWZDQz?=
	=?gb2312?Q?qDYcgqXbVieYrMemKc=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e551b0-aa10-4f49-8d2b-08d8da2e129f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2021 08:11:08.8082 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZNSXOreGeQUtbY7EWsTdTCz+g9SWOv59SsCpWKha7TMfwM1aXA9P+3pribqcF6HouIIusVp2AAdyRhc1aGWXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5206
X-PDR: PASS
X-Source-IP: 216.71.156.121
X-ServerName: esa11.fujitsucc.c3s2.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	adultscore=0
	lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=863 phishscore=0
	priorityscore=48 suspectscore=0 malwarescore=0 clxscore=409
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102260062
X-Spam: Clean
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
Cc: "jack@suse.cz" <jack@suse.cz>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 07/10] iomap: Introduce iomap_apply2()
 for operations on two files
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260125
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260125

> On Fri, Feb 26, 2021 at 08:20:27AM +0800, Shiyang Ruan wrote:
> > Some operations, such as comparing a range of data in two files under
> > fsdax mode, requires nested iomap_open()/iomap_end() on two file.  Thus,
> > we introduce iomap_apply2() to accept arguments from two files and
> > iomap_actor2_t for actions on two files.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  fs/iomap/apply.c      | 51 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/iomap.h |  7 +++++-
> >  2 files changed, 57 insertions(+), 1 deletion(-)
> >
...
> > +     ret = ops->iomap_begin(ino2, pos2, length, 0, &dmap, NULL);
> > +     if (ret)
> > +             goto out_dest;
> > +     if (WARN_ON(dmap.offset > pos2)) {
> > +             written = -EIO;
> > +             goto out_dest;
> > +     }
> > +     if (WARN_ON(dmap.length == 0)) {
> > +             written = -EIO;
> > +             goto out_dest;
> > +     }
> > +
> > +     /* make sure extent length of two file is equal */
> > +     if (WARN_ON(smap.length != dmap.length)) {
> 
> Why not set smap.length and dmap.length to min(smap.length, dmap.length) ?
> 

You are right.  I found that I understood it wrong.  My bad.

I'll fix this patch and the next one which call this function.


--
Thanks,
Ruan Shiyang.

> --D
> 
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
