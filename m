Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6DAC432C3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:39 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B5A2C64EEE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5A2C64EEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGtOPU085518;
	Fri, 26 Feb 2021 16:55:38 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 36tsuranvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGoIgJ004615;
	Fri, 26 Feb 2021 16:55:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36uc6w48v4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOu-0000hV-3D; Fri, 26 Feb 2021 08:55:36 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lFZh6-0001wK-Cs
	for ocfs2-devel@oss.oracle.com; Fri, 26 Feb 2021 01:45:56 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q9eUuA017199
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 09:45:56 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36uc6vp22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 09:45:56 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q9hWrH009938
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 09:45:55 GMT
Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com
	[68.232.156.101]) by userp2030.oracle.com with ESMTP id 36wqdyqp27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 09:45:55 +0000
IronPort-SDR: 30NIOz+v1U7CTutXgsRs+B3u20+2uEer2a+NbxzbQbCgp3zOsF28JaDmfwab+riwsUCo3Cmy2t
	BmdEWl6zv+D28QlyiUHAASFe9UVQa8xOZ5DXlcn+zxdSue3o8Og2Lca4ur/AELapZRBx7HZa97
	hNlDeei+QrQuiHCSnBdKXq2MwcZE34FX/0sfMKMa5oXr3xGeoWXyEXr7GrulQCvXeXe3W4dohn
	21BB81KHTJhiTKIkZRisyhpthSeW3fzCIKNb9TQJYnJ4j0mqtr3wQsmCkXpddXP2GyS9zFcI5r
	Q9c=
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="26805831"
X-IronPort-AV: E=Sophos;i="5.81,208,1610377200"; d="scan'208";a="26805831"
Received: from mail-os2jpn01lp2058.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.58])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 18:45:48 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=f1B7fr7M3/ILV0fyZLflcpt77M15UxdzvUFwAjHta8+BlGE9qrdyjctmG2J8CdoPvvY1EQtS+OmIfgy+6KrsnT9ylo6oobaZsl7vbAB0Gz5x+8G5u3YigbmwJplRhkTO2WT74OBg/ejS1nESeGuSv0UJcHFSR5pIeDFshettEunYtG9Ded2X53Yh9WUFhWB1J9jgcDE+rV+lNDGb+J/GW5Yo7DLjf8hV0GAQA70fD1LAgEMZmRXEnmtnFgdwLy8liBSLkeWoRxbIVdSyc+RB2si1W5JUvYmrxZ4m/7AM/8QWXS+ILsNEOekCeeH59ljkdA9otJQ4ma2KLoV1KFl4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=LJtXw0i4KVuKh0cTDpJQX59bhuFx0Wf4wSWTrGM2Asc=;
	b=k4DYLD59EW4hLWo+37rtm4Ixhw4fDUq+UsisaYoL7GO7rtoSJVpwm8HM30lGlSA+9h4+/ke4AmnLjhAvV5GRyD5Fjpb+L8zyWHiRkY/LuRgi2GGH4LLx0volao+LW7zLLfhp7RXiOMD1v0KNXccle0ODEsWdG5dMh6MXXTSruwk8M+Sg1jEZGP7WXwFf76aVifyioxVLIgWZIvNN9CQ4nx2ynDEJ8XR3/08iCkuaWlnxRN198y0340fV697IYQDjm3LELtI4XHPUmfJq027YEKRtOCqLcBgHEB+IigsHvaBra6GCD3AHj0r2D33iOEF+H5DFPnHS7v1z1iN1zzFBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS3PR01MB5816.jpnprd01.prod.outlook.com (2603:1096:604:c4::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19;
	Fri, 26 Feb 2021 09:45:46 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098%7]) with mapi id 15.20.3868.032;
	Fri, 26 Feb 2021 09:45:46 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Thread-Topic: Question about the "EXPERIMENTAL" tag for dax in XFS
Thread-Index: AQHXDCQnpTImuSbsuEuKD1BHo1YY+g==
Date: Fri, 26 Feb 2021 09:45:45 +0000
Message-ID: <OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
	header.d=none;vger.kernel.org; dmarc=none action=none
	header.from=fujitsu.com;
x-originating-ip: [49.74.161.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f91ecbdd-db6b-4d96-5caf-08d8da3b4ab8
x-ms-traffictypediagnostic: OS3PR01MB5816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB5816BC74D5D1DDD232082EEDF49D9@OS3PR01MB5816.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Q8rtszZWkgDFHOR4Q7xcuYxtpqq19TxUr/I2JQRudOKHQCslSZQYyEqexZtGEqdDdTrFmCgSmbgVpIxQcS3YieDDlGiWSUHQlycHW0SrBSBr89RRugwihofN7nCsuE4AbBf5npxqkrP+sUR6jUDlOuU4N/w8v/Mky7puaAxFoK04Wa/yONDJFgJsa+uToZPOQWCnAmzjP8oX5uj495rEB4uOX6FwzAmW4fk9G/6uPthe5cH8D6aH2d/bjszkmqRfZQnbCbibKqb8LbCBHUdyZ6TJGoAi9ihiQwkCw6aqR65sbMbdNW0jEuBdiPF2w4sPIM3u8zJyzbqR8GfqahMSJ9yP17o2CzQu8BUXHueVdWz9jaquaAAU4IVY8HL2NTHgp5kwkmFUh1DgQqT6mrxjBuizwmNesdETU3j7Ynvf80PbEzfnlWrhKYe88xqmNdxeJBIU/xV9dOwnI43+4FlfzAcT3A8ChMkvYyVMTk/UPx/qY8zW0bJR8kbR2NdoHFxIMcyfC+XbAa1ZZRbKJMCfQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(66556008)(52536014)(9686003)(7416002)(66476007)(55016002)(86362001)(64756008)(66946007)(66446008)(110136005)(83380400001)(71200400001)(316002)(107886003)(85182001)(7696005)(4326008)(186003)(8936002)(8676002)(26005)(6506007)(33656002)(4744005)(5660300002)(54906003)(2906002)(76116006)(91956017)(478600001);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?gb2312?B?SHUrakJTcU5DS0pvVUw3MjByNXlVc3QzZG9pdGhsQUdaRTZKRDlZbDN0MGNG?=
	=?gb2312?B?TDFKaWZVNlk4ZTVMb1lNa01GN0NiR0xuaDVkWGkvVWZnYktuakR4V0hwQlhT?=
	=?gb2312?B?dWlya3d5cEI3bXIzQ2RzYVFld01qTVRUaEJpRnd5UC83LysyQVF3SnBBbzdy?=
	=?gb2312?B?RXI3dEdOYUE4MzB3SzQ2VXB1bWdMbFJuUm4wd0lQVURVbHViL2gwN1RycTEv?=
	=?gb2312?B?VEc0UVc0NitoSXlRQVNwRm5sODgvcUhFVFRHSkFHL0VHUnA1TERzN3c3Tm0y?=
	=?gb2312?B?SWF0d0xGZ0V1Zm1lYXdIZmgyVldnY2hHdUd0NVFYT2cxdUhzVmRvTjBVNU9u?=
	=?gb2312?B?QTBKTXhLZmZNR3FkVUxwQ1BieEEvQWpXcU80dUtoWmpPRDdOZ0JjRVJ3R05j?=
	=?gb2312?B?MnRTVFZqYUpIMXM5UlFtQUFtVEgvbEVOUnROUVRnc0J4WnVDdHFPVUpvTnU0?=
	=?gb2312?B?bGwyUDZyWWlPVGlwdEI3czk4cTNvRHhwdFlROCtFWURyNWI5Q0x3UkdsR3M5?=
	=?gb2312?B?OXhvZnJSeThCZmFuY3lOQyt2WjduZmRSVjBQay9VRjJaL1NtYVBidjF1QXlI?=
	=?gb2312?B?R21taWM2d1VqcGthUExkemU0MjVOeFhwb2VaU01UZzFuTHJySDVzV2JheFVH?=
	=?gb2312?B?eHJ2MFNkdktCUm8yU1p2UUx3Y3licE9UdW1WNEwvSDRZb2h0MElxNE8vdk9V?=
	=?gb2312?B?c1g2Yzc2ZHhRcHpINm01c29xVk9SZk8zZ1psdTY5UEdLdUdrTFlBMmdvTHFq?=
	=?gb2312?B?a2VBc24yQjlhZmg1ekZCL25RQWkrUksxMnVHMWJYaFpIRlV3dDYxeHlmbW9X?=
	=?gb2312?B?ekpJT2FuY3NnaDNDNDhuTUkvQ0pQQjduVkExWGh2N1VQMXpxZHIyeFdlcytE?=
	=?gb2312?B?OVVNOUo0WkpKR0RHQkNYRDU0Ulg5MDFMSkJlZm9EbTcxOWNSUll2MEgrM2tC?=
	=?gb2312?B?ZzdNV3AwT2diUHVrMWlra0FoZU03MHFkVkJ2S2VnY3RoL1BWSTJabXRRVWRq?=
	=?gb2312?B?ZWNJb3VzbFZmZ0pVRE9RQTYyNFN0VmNTWEszMWJBS3pGenFSay9EaTZtb3Nz?=
	=?gb2312?B?T2NRbVRNcHNtejNJLytZeEF2eitSS3FEcVMyYWdBcVIvcEl2TysrdFJreTZW?=
	=?gb2312?B?dzJpRGc2SVY2cHJEWmpid01XM2pQOWtDa09NdkdEMzlJQlVrQVV1Vlpxakxy?=
	=?gb2312?B?VzBITytEM0VoZEhsSWd0MEt1OE9XSzdXeWxtc2FtVzhmWDlGVlpQcFZ5bVBW?=
	=?gb2312?B?cTdUQ0VBKzltek9LcC81YlJFWnV3Q3VyRkFnaXZrYWFNcmU0ZlNlMkxvRWNi?=
	=?gb2312?B?WFZJQjlPS0FORldkRTRVcFpUbHhkSWNXekFjeXlqclRqRFBub3MwWjM1Z2dn?=
	=?gb2312?B?WXVxOEFjc0ZkL1dqYzd5MVhmb2xSajFNWEl0QTJadG50eHhPblo4NHFqRjh2?=
	=?gb2312?B?THdvZXNDNytCQ3I2aVhzdXlheXdJUE1iZUNvaGxTYmRkZnVHSEFlS3JuQ2NT?=
	=?gb2312?B?OTk4MGcrclc5VDF2Wm9TS09OYk9vUnhHc002a3Vlbk8wVXRIWUE4dWxRaEFF?=
	=?gb2312?B?VzRTSWd4SjNUUndrTG5tY2tXckUvWWNxS1QrL1oySmRrMDE0NkQ0NzBFd0Jw?=
	=?gb2312?B?bitudUdsZGs2WmxLbFY5YkwvTFRCTU1lc05Bc2tWdjBSV3lLbkErRFppTGlS?=
	=?gb2312?B?cUNFRDlnWFJEK053eGFwRm1SLzlCbVdPWk1GZ0ZaZEQ3UVRmbmNGMzIzSXlW?=
	=?gb2312?Q?8k/mqON7zWkH4Xlfcg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f91ecbdd-db6b-4d96-5caf-08d8da3b4ab8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2021 09:45:45.4003 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: otIJH1RssPktwNRpAw+JDESOzIwYfxsevw0arpYCB3GzBsQoYWknNqOGh9az5QcVQTA5Aaz1oU9DD2tOSyBUlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5816
X-PDR: PASS
X-Source-IP: 68.232.156.101
X-ServerName: esa14.fujitsucc.c3s2.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 spamscore=0
	malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
	suspectscore=0 priorityscore=48 mlxlogscore=999 phishscore=0
	clxscore=377
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102260073
X-Spam: Clean
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
Cc: "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: [Ocfs2-devel] Question about the "EXPERIMENTAL" tag for dax in XFS
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
 definitions=main-2102260124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260125

Hi, guys

Beside this patchset, I'd like to confirm something about the "EXPERIMENTAL" tag for dax in XFS.

In XFS, the "EXPERIMENTAL" tag, which is reported in waring message when we mount a pmem device with dax option, has been existed for a while.  It's a bit annoying when using fsdax feature.  So, my initial intention was to remove this tag.  And I started to find out and solve the problems which prevent it from being removed.

As is talked before, there are 3 main problems.  The first one is "dax semantics", which has been resolved.  The rest two are "RMAP for fsdax" and "support dax reflink for filesystem", which I have been working on.  

So, what I want to confirm is: does it means that we can remove the "EXPERIMENTAL" tag when the rest two problem are solved?  Or maybe there are other important problems need to be fixed before removing it?  If there are, could you please show me that?

Thank you.


--
Ruan Shiyang.
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
