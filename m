Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2247FC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:42:11 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8609264EEB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8609264EEB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239PJhE026548;
	Wed, 3 Mar 2021 09:42:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36ybkbat14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 09:42:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239PG8d099664;
	Wed, 3 Mar 2021 09:42:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000y6xxk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 09:42:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHO19-0007ml-AO; Wed, 03 Mar 2021 01:42:07 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lHO17-0007mV-Ew
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 01:42:05 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239PHYn099794
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:42:05 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 37000y6xvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:42:05 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239XusO041370
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:42:04 GMT
Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com
	[216.71.156.125]) by userp2040.oracle.com with ESMTP id 36ycpvk4um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:42:04 +0000
IronPort-SDR: N2vBnOhHF00BN3sFk68swl1Ie6TQfYav2wTU6rU0pjuv+HuoOlJtJ/7YLkiyxJvV81ERGJ6N2Q
	kQlD7uDUlJf+GG0gojH9hIqX1PhTFWpRM4IIv5Iz6y8B5eTFl6lhVQvPZQYdgvgt9+OKynT+NO
	Av9mFJoy3Uy+Bk87AncNHz9AOKZlCbpn7DgvU/Esp7ujdoFb6P+IFEIA9Rr1++fWpOA74dU/JF
	uej+6imPRd37NHp6J4mYu6JxReE4NcEn/ulold5IRGiKhW2R3mutsrqlB14SEqjAnMgn3XxRjL
	ISA=
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="27215766"
X-IronPort-AV: E=Sophos;i="5.81,219,1610377200"; d="scan'208";a="27215766"
Received: from mail-ty1jpn01lp2051.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.51])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:41:57 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=hebJBv4S4kTB7aAdX/6Z2K2qWlgMuJbSobmkpv1H7HimL6k0jTLvM9hW24+p1HM0atKWiKYS71NXIaX22XbY5snVtO6BNT0jey2bTAcbQHhYD+vRoW8dDmUKC4elYJTIcxwD80ti13dcD3X0wn6yFeiPwll+jatS2RhX3IN/r/2MyBa8Eq9HOvMun+bT/4QUMX1Jf2Rw1exfcfpVgH0pEmE/qOJ+6UhxfM0RqkHDANoo8rsYEDW0bTEI5NZokLgbS1JvURjI/D85Ou6r5qjdevbLsMLczTVXpvfKJBlzYg0+T94JpPehWarwDPtxba1yTtPvZ7ecCTxhwZs2P8r6Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=rhiXeoGfqZkbUgg7Vnsz3v5ES4Eolr6prC3jJBXv8xE=;
	b=Ro896AlKR3Vbh8bBPE7xGiztOpXW0hZhMyOsEu8jQRO0+PVuKiT9j27YbpK1YO2uyzmoprqaby8opi02wiGOkRkvStY17cddR9eF45Rkl3aSpgETKH+/DNunjscSEjcgp1k6oMY9egweR7lg+srvTKEYoYteJplhmc8u2PniKqlpbeObKzmgIEF+67k2vucyn+MVMaVoU4C6zBDaFmgcW62WQBpc0wqbUGXgN3EZs3rre9jZPyXxZWUlH1XNwewHhwmtW+ro48qJtKHuw69yiuGK64HvMfuG/SKcAf1yi83fn6qYVoy6U2/lw7YEYDoRSnd2mfTfwTshFF+1xEoxtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSAPR01MB3746.jpnprd01.prod.outlook.com (2603:1096:604:5c::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20;
	Wed, 3 Mar 2021 09:41:54 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098%7]) with mapi id 15.20.3890.028;
	Wed, 3 Mar 2021 09:41:54 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v2 05/10] fsdax: Replace mmap entry in case of CoW
Thread-Index: AQHXC9VOcVwwceNu3UeOW0JIEFKrYKpyCCMAgAAAik4=
Date: Wed, 3 Mar 2021 09:41:54 +0000
Message-ID: <OSBPR01MB2920FB5AD1C9ADC64100238AF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-6-ruansy.fnst@fujitsu.com>,
	<20210303093052.GE12784@lst.de>
In-Reply-To: <20210303093052.GE12784@lst.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
	header.d=none;lst.de; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [49.74.161.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f81d1847-7391-4703-c00b-08d8de289455
x-ms-traffictypediagnostic: OSAPR01MB3746:
x-microsoft-antispam-prvs: <OSAPR01MB37469C082DDCEBB34A657956F4989@OSAPR01MB3746.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZrZi0rarAs5czYATJCUwpbjcAq8nHTZaG4gTGN0i9CqGYqQhgqNJTwcUokRyLh49lNF21Hfewocon3zDzUlSTolFdoYEeNyxGqFajj7d9Q4RAdhrLtJ3g5HuruzuWsBVWe9LokcpUy6eummNAbtt1du5dkhfl3+bXqHPPPTCcJDreOx+Zamwg9o20SaFF1KjbIJw7OMkcauR07UFtgerj8dLCi007dgFJavmp/ah9FZTcwgsrTYJ7v4vjSzdZFh7fv3s3m80DcHWEfvyAxa8ABYozKyyCHRITB7GroOuOO64Q23MbJkHn7yTs2n5PnDnfZLzjJ09YHv1EpkFiqRARJp9FwcaSm3WbI48duu8I3EtG+mJvB1OAfe1Ke5fK5/JkLFWHiodkMld3DRfPnmaG1h6hQLdWCA7S2O5ImZtcU8JOKCQxGfygKgWGsrfDvmzO6r7crdVz04X1vcyuUgCPkAOe5AZTDwnpeHBrJHDG8FVowU0AVsnO5s4KAC9Tuw9j/u7MdUg3rEOpA6Wdsbx2w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(91956017)(6506007)(7416002)(86362001)(4744005)(55016002)(8676002)(6916009)(316002)(83380400001)(66446008)(478600001)(33656002)(9686003)(52536014)(85182001)(186003)(66476007)(71200400001)(8936002)(7696005)(5660300002)(2906002)(66556008)(66946007)(4326008)(26005)(64756008)(54906003)(76116006);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?gb2312?B?VFBCdVhaVE1Ib0RaLzJCNmhmbWo2U3RwamRlWE9NeVNHWTIvdlVPQWtHTHp6?=
	=?gb2312?B?Ly9YNnBhdXlVYmYzVWtFNnhLT1ZHQXNWbGRWV0V6Z2RhS0RPdncrelpDUzk1?=
	=?gb2312?B?MDJPQ1U3UDdjbUt4VjFCUHR0RU1Xb3ZKalAvOU9YRnBCT1RvemZmVUFuMkJ0?=
	=?gb2312?B?SWxBY3dUZS9MczlHYzJKampLeTVRVDBPWTFrbmVtRWZzc01OOHhMOTN4aE5m?=
	=?gb2312?B?Mll6ZHhIb2VaMUJ6cXJxVktEL3BhdmUzZWZFQ2pvRjNaNG9mS3N5cUpybXFN?=
	=?gb2312?B?UlZTOFg3VDh2Q2k2REpSYnM1Q1l0WUYycGFBQWR2U2dpb2RqMmtPUXoyTzZw?=
	=?gb2312?B?cmdpMGlhOEhhbGZNRHlLWWNRdm01cW5UQmhobHUxSEVaSWJnZUo1dk10V0hZ?=
	=?gb2312?B?SUVrK3NOdFZlcFRobU9jalIzQ2Z1S0hpZnZpM3N0bUZYWVArdWNXNDIxTTBS?=
	=?gb2312?B?L0NhQUhrOGZiUlRVSHU5bGVnR1VtbW12V1pEbFFsY1hmZjdnQks5Tk9QM3pq?=
	=?gb2312?B?cWxUTGtWd2ptSWxzbWc4OEErNGJ3U21qMmNmOEdneFprVms2cGNSdVJ6dG0x?=
	=?gb2312?B?V3Q3eUZZOVJKdlUyZXo3ZGNYVlpUNDdJSU1mSGFFSUw4WmI4Qm9lV1dBdXJq?=
	=?gb2312?B?NE52dkFDYTBpUzREelFETjBZVXJhZ3FNc3FtN0xtSEpBQnVsMXp1L0paQXBv?=
	=?gb2312?B?bXN4c1NlRDdKTTh3d3RXYzhUblJxWWVxeGtnV21wWUN0Um9ncnREN2F4RUI3?=
	=?gb2312?B?RkFvMkhSamdXeXZicFlZVmdKdGVUdGFLRUdPLzNKRlE1OHZXVGMvaVhNU21X?=
	=?gb2312?B?M2FRUDdFL1IwaVgwWDA4QlNtZEZjTmI0U2ltYkw3ZmRaZTJneHhLMGZreWs1?=
	=?gb2312?B?NVh2RWIyZUZqV0M1bHpPc2tNQ0VaNlErY1VaL0ZaL0dGczU5Lzl3elYzTGx2?=
	=?gb2312?B?TFRtdm1ZdUtEQWltUXgxSGNsYnhpQmJOUC90dXhXNDJNU1BVK1hHSFJ3cFNP?=
	=?gb2312?B?S0hRYjZuZ3AvSFUyOG1aVmp3emRHQU5LYzNQRVlxVEltdjlpNUpMOXJGWHV1?=
	=?gb2312?B?VXZqSTdIMHRVckhhY0hGWXpreXNFcmpscGRuY0gvNTIzV0pLcDV3SjF5bWRO?=
	=?gb2312?B?SDVOT3hqandvUFdLODA2TVdWdEFtZnNIT1d6Kzk1Q0FZWEVyV1REOXNqU2hn?=
	=?gb2312?B?Y2dycmYxL0JZTE9GaVpxM0dUNllYMWxsL2JPa1Fpb3piNjFJRlZOUDFmRnVh?=
	=?gb2312?B?R1hJTGFHRzAvZmFYc0hmRDkwc05LYk9OTFMzRWVQemowdWRoY1NtN1g5S0dK?=
	=?gb2312?B?bnpLRWxKaXIrWmtLRS95cjcrNklsbkhXQ3NjMXA2ajM1LzdEa09OR2VKVVJ3?=
	=?gb2312?B?SXNSS1VnUEJlT0RhdVdMVUdFOEJIdElGZy9RY1E0QXdXME9PYjY3cWZGTG82?=
	=?gb2312?B?YnlOcGhha2x0WXVFLzRkeERaM2d5OXdUZ1hnQzNNMDNIZk9rNnBLUXJnWDds?=
	=?gb2312?B?RzYzMEVNNUpTb2RkWE8rVXZGWGhCR2FubTdzaHMvanZzTzRxb0ZLK2ducXYv?=
	=?gb2312?B?SGZRT2hoMmd0T1AzMnAzc29oVERVWjluTnc4Q3QxSGxVbFNESFZpallHVDl5?=
	=?gb2312?B?dXpJeXFiWTJnakRUc0ZpZzFkanJmRzMrRjRRRExlZmpMZlFqU1ZRSndaWjZG?=
	=?gb2312?B?TFZCS25LV01uc0NYSXI3aWxJNnhQQnJJa3lNbnVzZm1zZmdyMjBGS3NMdXFC?=
	=?gb2312?Q?eqOGzsT3S+O0hFv4Zw=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81d1847-7391-4703-c00b-08d8de289455
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 09:41:54.0501 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OguGaSnpr7LS1ZjNETdBtYWQ9K7E06MOoFSTSpnxtUKH81Fw0bC+ZgmUjaQqjG6Hns/zqCFoIDilXHDC7fBYiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3746
X-PDR: PASS
X-Source-IP: 216.71.156.125
X-ServerName: esa12.fujitsucc.c3s2.iphmx.com
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
	bulkscore=0 clxscore=159 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030072
X-Spam: Clean
Cc: "jack@suse.cz" <jack@suse.cz>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 05/10] fsdax: Replace mmap entry in
	case of CoW
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030072


> >
> >       if (dirty)
> >               __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> 
> I still think the __mark_inode_dirty should just be moved into the one
> caller that needs it.

I found that the dirty flag will be used in the next few lines, so I keep
this function inside. If I move it outside, the drity flag should be passed
in as well. 

@@ -774,6 +780,9 @@ static void *dax_insert_entry(struct xa_state *xas,
         if (dirty)
                 xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+       if (cow)
+               xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
         xas_unlock_irq(xas);
         return entry;
}


So, may I ask what's your purpose for doing in that way?

--
Thanks,
Ruan Shiyang.
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
