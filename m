Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3D1C433E0
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:58:06 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8830764EEB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8830764EEB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239n6Ij069830;
	Wed, 3 Mar 2021 09:58:04 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36ybkbaw0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 09:58:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239ubti159279;
	Wed, 3 Mar 2021 09:58:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyut822h-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 09:58:03 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHOGY-0000OE-8V; Wed, 03 Mar 2021 01:58:02 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lHOGW-0000Np-4Q
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 01:58:00 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239t5LH038783
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:58:00 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 3700012xqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:57:59 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239rOax014456
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:57:59 GMT
Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com
	[68.232.156.107]) by userp2040.oracle.com with ESMTP id 36ycpvkc5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:57:58 +0000
IronPort-SDR: 6x+xJWaC7pRv+9hIhuGr2c3J7i0si7DX7IAGONM9LfdolWkntM/ZFh6faHYVBV8nFEMWDnvKpz
	8R+9UAVKu9DZFPEtgJ+59xxTMb5z80H9ZoIycW0RIK8+HlmqexIbEd5oRRQCv0P7uwk0xCMftM
	dMxfQWpWxedWcrOIuFJiW2OXJsbBDP1fKRPF+H5LFPgnBLkO6e3q123xov5VcynEOxxfoRcPOB
	wOyPMRdnng6njP3T8n7n6OarqsMkq+tRPzaaJee81lxOJcVBJULM8MLysYgAwD5lSRpt+zpQs1
	Gg8=
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="27045987"
X-IronPort-AV: E=Sophos;i="5.81,219,1610377200"; d="scan'208";a="27045987"
Received: from mail-ty1jpn01lp2057.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.57])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:57:52 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=kQ8qCvs9VGZce7RXIGO/HYPsT5G7x2hCaQmfiCRcX/KorgAc3IuDPXcEzdxxJY02Z3GqEDhbtkdUhiBuA8NyUCvVVmofIxEAYidk1xv9/jBLeSbOy3KDrEPbyRBL/7fyaUpwsO5JT0H2I24mlKay5I+0r7DwmurxgpFpcMaEf9gv+FYSEjexHjfvsai0BbbgFBASsyyLMOX+g3FLfiSNa95kLEqAMYUB0v1DUUW6tTgGmmLe74A8ryo6O5PcgpqqEEwpc9DEQ7+8ptCGrS8aFfKeAPVZpCllMwiNFr0eVLOiJ1cX1wHQubUabjG694epnAn57OXLasNo0jPB47dN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=mKBmE+x9CyD3zaAexGZ0CUdqoTyyAG0+6Qsy/hgTmBA=;
	b=NvKPJDHPfQYeyt3Qgnamc3UMB1VtvKa3ya6JjmI+Mwj3D84uWMNhCu/Ayh3zb31JNNpRGW2Q9VLkyRk6EpuRJfnVSs9fiE1D4xiwLDGfRTulw4dY30LgN0cHaQJNDDYI4xH+SngURLZFYDU9RL0zcRfzaSKGv/FwKzxyvcu9oGF7Mr4MAf1N26HINuaqQ+0bsTG30z8WhdNPjDoVJggE8NEdi/fukuslIcYTG4W3uY0HphmzSm0BzAKOjEPghpHKv72w5Q9uyQ4ix8exhT4Ee1fvr2hnkSN/keO9pCKRpNZOlMywWzX/Z870hFR9E9Fwl7swQcmFA686grxBFQ/STw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB2823.jpnprd01.prod.outlook.com (2603:1096:604:1a::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17;
	Wed, 3 Mar 2021 09:57:48 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098%7]) with mapi id 15.20.3890.028;
	Wed, 3 Mar 2021 09:57:48 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v2 09/10] fs/xfs: Handle CoW for fsdax write() path
Thread-Index: AQHXC9Vk3oCFfiQYI0S5UeFuOjPnZ6pyC5KAgAABpsU=
Date: Wed, 3 Mar 2021 09:57:48 +0000
Message-ID: <OSBPR01MB2920500BEA2DF0D47885A8FDF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-10-ruansy.fnst@fujitsu.com>,
	<20210303094309.GB15389@lst.de>
In-Reply-To: <20210303094309.GB15389@lst.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
	header.d=none;lst.de; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [49.74.161.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b53e7b0c-1497-4f8c-7fb2-08d8de2acd60
x-ms-traffictypediagnostic: OSBPR01MB2823:
x-microsoft-antispam-prvs: <OSBPR01MB2823183F4E82A5C444EF5125F4989@OSBPR01MB2823.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x8m7uV0I6YSHA74LwyFd7fBAzHfKWRNhE543SLtrSxZNVRK5OQyveGZQn1IoTG/nV+xTuwYAj/s0MYXuvRpD7NAonm+YRbthqrzrCMCPp5wWVEXgM5h2wWt9w2vqa5gCG2amJzw12pZFzJEQqTzW1dismlaSXHt7Tp04hnB9nsySAu9fRpEAWyNVGosg75VBkyd7oJNJ/fTydDnstvhJ9mLdwJ1PTr16IWO1WbAeYKSFdvMmr1kfncSjB56FeJ9qBEXLM5xurU+M/SDdq1DEygegFQAnAqpuC92wv3moTvoLY7XevwtiyBtlQDOFTH6nHlVv7Ab/6v09aU6hi8DnsdVgORsQx5t0r3PhudGSXC01OQvlEOmWoH0z15FCuSRy3Gm8qcxEl8TaeJhtzpexxqKWl+zXZ2Ui2qfwRwc1g6qg0Y/Fx0Q1XBuebY0hk3WdrO/aLgarPW8C21kTDKWWl6X96ImfkPm92RcjCoSwZH3YcvDUMEwAi4S0RBrgusFD+yALo5hD/qlE4EbcozOxDw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(7696005)(86362001)(85182001)(8676002)(33656002)(478600001)(6916009)(54906003)(55016002)(9686003)(7416002)(66556008)(5660300002)(52536014)(186003)(66946007)(76116006)(66476007)(2906002)(91956017)(8936002)(4326008)(71200400001)(83380400001)(26005)(66446008)(6506007)(64756008);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?gb2312?B?RzVNVHVmN0k0Ky9HNWxYT3dwTDVMa0toTUtkR3ZBdWh6Nng2RGttbE4vR0xk?=
	=?gb2312?B?Sk5ybHAwa090dXd4YTdkaW8zZjluZHFMbC85N1lsZG5OWTdCcEhUdDRkaTdW?=
	=?gb2312?B?d1JlYVhQazU1VDhISDZ0eFg3RzZONWd3QlU0OWhwbEMwbExjWUgwd1RYc0V5?=
	=?gb2312?B?UHJML1lhUUtIZTA3ZG9leDhBcklZa1gzdFg5ZmdsNTZkN3BFN3pMTThhM3E2?=
	=?gb2312?B?S3I2TTUvK0lKTXFSRFlTbk9OVktHMnNOZFhlOUhZaVVqbUNyUE1NYTA3V2Qy?=
	=?gb2312?B?bjIzclo0Tk9GZ2o1cEdoV0VsMXlHTkhFYzZmU3lRK1VjUTVSaXZJMmJVak05?=
	=?gb2312?B?UGlsZ01zYWwyV1pUODJiOWUyYnBqM1B5UWVwYThteFF5N3gyOUExV3dMY0Vi?=
	=?gb2312?B?b3lzRXBPUEhMMGs2dEZSbENTdjlNVm11YmhXQU8vdTRhWlhzU0dwNDd1SXor?=
	=?gb2312?B?cGQwV1NpRVUwakdHTGROQm9JY0N6NTUxdlBJZnZUSjloSmVFNXpoVGpwTnZz?=
	=?gb2312?B?cVpKa1p0Z0FLaGlvVVZrMHhSUCtEMUZkcldUbjBtd0pQK1BBZVZad3R3dkVy?=
	=?gb2312?B?Yi9mSGxBTjBvb3lIYkU1bWovN0VIbS9ILzZ4SzN5YXNqcnFremErMWhWUlBG?=
	=?gb2312?B?RWFkTDRsQlpMZzFhcnFNaXZYdDFWc01wYUJHWVFjYmdGYlVzR05wMTN2cEJS?=
	=?gb2312?B?Z2FSellIZXdvQzR5bHJKOFFWVS9jVGZNYnJKMTJMSHl2Sm83bERKOCtlSy9t?=
	=?gb2312?B?dlRRVkt2bkhYTTZ2V1A4NFNaejVESXRac2M5NXpMK3l2WEJ0Skl6YjNwMUky?=
	=?gb2312?B?U3JxRnpHMW9ackRseVJNWkc0MmhBMEJ1dS9tSGFaQmVSTFJhQnNYMWQ0UUtr?=
	=?gb2312?B?SU1hZFI4by82N2JqTkVwSjk0SDFqZ3B2VUJRaWl5TWJSVmJHV25iT29mcURj?=
	=?gb2312?B?N05iR29jT1UwZzhXTnlsQ3U1bDNlekhWRkVDcjVvZVQzcHh4UE9WNTl6M3ZS?=
	=?gb2312?B?Z1ZXeDlvR3M4WDkwdHFsMmtxelJKdzh3NTdaVFcwK0FSb2tFL3cyQXJFeVdY?=
	=?gb2312?B?NzY4YkdPbnJjZC84aXRRdVUwWFVCbkcvRkxSZ2I0NEE1RllxZFVjZEcyYW5R?=
	=?gb2312?B?WVFra25CaXk3WnRmZFA0NlI0VEREczY5ZmZSYUVqSmxPNjdDS05YaVdQTG10?=
	=?gb2312?B?VjdPd0ZsWURMY214MWVsSXFYdzBGdk1JbFAwcmQwTFExZ0lGbTl0QU1LV2dr?=
	=?gb2312?B?Y0NoeGhvNFExZno0TnNRemluOXdPRWZJL1ZCWmZxQkZWK3V3Znk3a3NCZ1Qx?=
	=?gb2312?B?cE44NnV5ZFlYdGpGb3graERmQ3ZJblgxODFERHN1dlJ1OWV2VEpuQWZFa2FD?=
	=?gb2312?B?YWxDNmYrN3RTZndjKzRYUGJyUGZKeUpHQnRxVFNGSEtlRUlSTkxCYjdrb0lw?=
	=?gb2312?B?bnpnTXYvVXFIL0pnc0FrRGgrdmJPMUxISk1naUduWnlVYkFQT2xtZXZtNGlx?=
	=?gb2312?B?Rmo1NC82N1hLQUplNURoSzZ0NDA1UFdSai9ZU3gvQXVJYkJiR0IyK3RZMHJr?=
	=?gb2312?B?QU5nYmhNVTB2LzNXNHZkQnB2a0NOLzV0Z25oVEJwTmJrU2RYTnNHS1cvQU9Z?=
	=?gb2312?B?bFcxOHlPVUE3Mm84RjVzUnhBb0NudStVZTBaUlZyK2IzL3dkZFJ4b1V6Q2J2?=
	=?gb2312?B?aFB4L1FhMG91MXhtNFBndkZDNTJ0VitONDJtZWdRWElTSjA2SXZHa3kvQ09y?=
	=?gb2312?Q?ZgP4IO2WPnfgPElXuk=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53e7b0c-1497-4f8c-7fb2-08d8de2acd60
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 09:57:48.8251 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mJ9Ip4nCq6qinztLEtVWMzw+X/KJl+BRTtDueg+guZ8VCn3WDIxnLkBO75Ed0FFQwQZB8S6RwHMwgsVPuPT8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2823
X-PDR: PASS
X-Source-IP: 68.232.156.107
X-ServerName: esa15.fujitsucc.c3s2.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=30
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=625 mlxlogscore=883 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030074
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
Subject: Re: [Ocfs2-devel] [PATCH v2 09/10] fs/xfs: Handle CoW for fsdax
	write() path
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030075
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030074

> 
> On Fri, Feb 26, 2021 at 08:20:29AM +0800, Shiyang Ruan wrote:
> >       error = iomap_zero_range(VFS_I(ip), offset, len, NULL,
> > -                     &xfs_buffered_write_iomap_ops);
> > +               IS_DAX(VFS_I(ip)) ?
> > +               &xfs_dax_write_iomap_ops : &xfs_buffered_write_iomap_ops);
> 
> Please add a xfs_zero_range helper that picks the right iomap_ops
> instead of open coding this in a few places.

OK.  I'll add it.
> 
> > +static int
> > +xfs_dax_write_iomap_end(
> > +     struct inode            *inode,
> > +     loff_t                  pos,
> > +     loff_t                  length,
> > +     ssize_t                 written,
> > +     unsigned int            flags,
> > +     struct iomap            *iomap)
> > +{
> > +     int                     error = 0;
> > +     xfs_inode_t             *ip = XFS_I(inode);
> > +
> > +     if (pos + written > i_size_read(inode)) {
> > +             i_size_write(inode, pos + written);
> > +             error = xfs_setfilesize(ip, pos, written);
> > +     }
> > +     if (xfs_is_cow_inode(ip))
> > +             error = xfs_reflink_end_cow(ip, pos, written);
> > +
> > +     return error;
> 
> What is the advantage of the ioemap_end handler here?  It adds another
> indirect funtion call to the fast path, so if we can avoid it, I'd
> rather do that.

These code were in xfs_file_dax_write().  I moved them into the iomap_end
because the mmaped CoW need this.

I know this is not so good, but I could not find another better way. Do you
have any ideas? 

>
> Also, shouldn't we cancel the COW rather than finishing it when setting
> the file size fails?
> 

I did forget about this part.  Thanks for pointing out.


--
Thanks,
Ruan Shiyang.
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
