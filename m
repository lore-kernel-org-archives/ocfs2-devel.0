Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18791C43381
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:25:13 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B7B264DF2
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7B264DF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SG9FQd109753;
	Thu, 28 Jan 2021 16:25:11 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 3689aaw55b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 16:25:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SG9rGo151962;
	Thu, 28 Jan 2021 16:25:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wju9ruc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 16:25:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5A6W-0007zN-Qs; Thu, 28 Jan 2021 08:25:08 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=6551138a8=Damien.LeMoal@wdc.com>)
	id 1l51n4-0003xM-36
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:32:30 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S7Pp5Y103740
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:32:29 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 368wjtnayw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:32:29 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S7OL2A012213
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:32:29 GMT
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by userp2030.oracle.com with ESMTP id 36bqd393r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:32:28 +0000
IronPort-SDR: 5meZAAXbPsZyMOd9RQOAURE7ue4N8I0GylPazNiN4F+IkU2Nf7CrEdUTmPOyFzJi7zfeggOiiu
	Gt5Od7xhy+yHk7m31eLzfrafTPyIE2+841Tdhjt9RuKfy1UwsAhsaJEc7TrPpyeonTG5OoNRbW
	jYwfp8qY1//btPd2uEMJY+wlNQ6hUZhFAaCgz+oVCXV8JG1R++3gaALgNG32rpHLVCAPpUvSm5
	ZnyqhIjEF7MhfKsrin8SIf9C2tCW+9kugysfCU7OmxJSUh1jT50kH6wLdq3lVUWVW9JSAnaEIT
	sQI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268893463"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO
	NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:27:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=B83E+AQw1n8nLaPpws6ZVk2Dvv0JowLzEH6tW4QBIZHQO5bOyKoRkl9zce6LAfAcYeKNBnUqMBuqWKPapazajsM6mugFl46pUPnH27w2MyNgzfB2U64tU7/YQtksU04S+GWbxUwv7ua6jeuaCXw0Q2a/INcuYW1pZmbpSmGcHX0jgHrsfKIziwmv/KoIW40wdsUPJfmkSsIjxMNkqU8mSH3CYfS72OI5u+QFvQXzGlRrot81kEsbS6zPF3R+md3jI0xbLOthW81i6HkUhnZFc7n6i76TjivEJep1dTrNSJmAcZacixJJoHL5R1ayC6mgKhmUp43MFeS2JhA8RHsWLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=7dHgs/1VLBXJ5Fid/0F/6cbHkJ0A+oW1xrqX9+A0GgQ=;
	b=WpVsW1S/kKhHgGTEzveH/WBQWziddYzWdBCW+5peeK2CMYzuM35ikhiL93qQisaU2sh5XUUpBGRi/TFqqx3OmGIe24yyfIzJAQbSDPUcgJl828BlV9USdpsDOoEeDZtHgttMYKmGI1gJsSt+V6kxWrCrBRnN8lSCWDpfiroaO+QmE16osB2eevjAkuP0qNTfCZo6bo3ZQRwiDwhweVFwoM8Ww9mA8MT5yPoo5QtVqHYpRPAG0NbaJNanr+SI0Duz8hOTcNB65u4JLwKXGhuJHAalGmP1VOd5oTVjmseyILk+5VEQB5HpwincSvcGZkpYEkN24oBog5tfK+cn6HqdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com;
	dkim=pass header.d=wdc.com; arc=none
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4852.namprd04.prod.outlook.com (2603:10b6:208:59::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 07:27:21 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:27:21 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "drbd-dev@lists.linbit.com"
	<drbd-dev@lists.linbit.com>,
        "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>,
        "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>,
        "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
        "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>,
        "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Thread-Topic: [RFC PATCH 02/34] block: introduce and use bio_new
Thread-Index: AQHW9UTnP+XqlvwCeEC+5iodtWSeNA==
Date: Thu, 28 Jan 2021 07:27:21 +0000
Message-ID: <BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
	header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98283964-c91e-431c-9fb9-08d8c35e268c
x-ms-traffictypediagnostic: BL0PR04MB4852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB485290861AB8AD7380809BB0E7BA9@BL0PR04MB4852.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hxj4fa4GkcBNNCunfMw7J9/b9iCM3fJznMuhOWkCQfvwJ0NrAIluFKg3+jXWfl1tLzPUJCh7B78dGsB53Gqk1Z2m7MWGTazT/q4pi5bAn+XOAilmmSdZvZ9sqjmQNXhEiTj4kt72t+S3/drX6amXX9FT+FK55adEN2vnuJcgUNqzT4TxQrX+LcNNGQZnWc1Tlo1+uTv04dXECuuh7Tu9LBWclBuE7jek77LbLzIUJdaPhgbGq6L/Pdx0JqnyYF+FEQPM8881yuui+kueEXVoqlzgBqK5vaKAqGJTqa0aBFevZqZNENtO6og/LDPr5d9E1UWTTP7/Da2oTdLL+35iaIOLalRmCHBRvUY6cEGhYxURyVSG+g4j64QtJxsEF71Nji99U+trtgurQXiLlnDTDGxf+MDnSLAb7nLKVPD/4Kml1pvdzPIUKukEtZD2GxrzabB/3418cwibWgs+12obfmiGrBfi16NV2BeC0p+Se0p+BmqHDY/WZr2ITJIpH7HBw28kQg7FWHu0BZbkFGLyZ1vhLckxE+yPI8cR0tXHr+nJtxvmCqxf3bBjfbGb7Q3/k4D1vq2cQ3zlnKpMfEgb0g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:BL0PR04MB6514.namprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(186003)(66476007)(83380400001)(53546011)(5660300002)(66446008)(316002)(8676002)(71200400001)(66556008)(91956017)(86362001)(64756008)(6506007)(2906002)(66946007)(52536014)(7366002)(7406005)(9686003)(33656002)(110136005)(7416002)(55016002)(54906003)(4326008)(76116006)(7696005)(921005)(8936002)(478600001)(21314003);
	DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sgomRkWS3uJS/HM3uKXHylAhoSZM+lVQWdt2dHx9bjA8NQXvXFM6Dfv8MW1A?=
	=?us-ascii?Q?iCsEXvQot8m+wWe1prFL3N6W4X/zd4E4zBQMqtLQEJA5H+WTWLCNwdvng6U5?=
	=?us-ascii?Q?SkD6CC9MBeyZGtVMnjn2C+bStrwfe/6T4Mh4yY7H804uejWxG1MgZhnXTjqp?=
	=?us-ascii?Q?f36HcMhJa8fqBRYTB616pNnmAuoeQyPrXZYwSIUFh1bkSg5h3DWdvFdnge8/?=
	=?us-ascii?Q?O9MCM+eECuYQXcaVSUcc0tBlY9mVO1xLxaHa+pFR3r6GyIUZVhAFKPD8DMJf?=
	=?us-ascii?Q?WqsPp+KkYw2miQ2VWu7CKnb5XE/WZZK8NjFYrO+UvBi0zDKD7ZerGy3ioMo0?=
	=?us-ascii?Q?d5CGojo5bVlNDYR39iusEWUd7T18JfU4UoWDmqvKw9astFDt7GxuiNAHMcX0?=
	=?us-ascii?Q?yyVIMk2hKHQYRROUDYWJXFKFYeCK5lmmjxBt04cM+t3AhLH2tTJ8jpap65/Y?=
	=?us-ascii?Q?8A/ijV/T2IbajTQmqxd38MsAkL8lLy0sB7zTUHpkXikXfHmE6OhpRLxglctK?=
	=?us-ascii?Q?/aViM41m44269sQxLJudPSQx/yzA7+nPRic11ihTWQ2xQYSelMI6oY07tQjC?=
	=?us-ascii?Q?hVnAD1Qaet3As9B+ynly4BGIECf/ZcPbSzc+Oocke/rsdoUZIRCx9A5o9NPg?=
	=?us-ascii?Q?7g0qYPFGa112F08uWlKr8jI4vxPqF3DcPOVvoayIcVqK9XZoqxF6lkGygG5v?=
	=?us-ascii?Q?YJDU5PuEe/Bm7FrQH0EsVCPz9aYpSofnlInNuhSpB7hk8gf+GLuZQe8ZAkA7?=
	=?us-ascii?Q?lLd1unSvvMeP5ssLoUJow6t03g2CrTllNyQmec0sH/jgAMA2cCCp8r8xmKu0?=
	=?us-ascii?Q?Gg+Dly15s3nODQmsmpsV0f+GypiBJPNVpzMiB5Rnrtqy507XVwyx/YdLVrRR?=
	=?us-ascii?Q?7DSFyDH/Gxm1k2D/VzvvIJvHY1LnFzctkrr2UgpR99aD9dEGB6hzTFgdaIQZ?=
	=?us-ascii?Q?nCCmPvdeJum19k9qpYis5Ika8c3StyujyDXHLcdbNXrwFYeKpNzciRcoJEUu?=
	=?us-ascii?Q?eP4u0Tzg0LWQzv92vuaJ8NPyfWg9Lh2zkr0bUa/54WZ0wuoaMHYXuXRE9cLO?=
	=?us-ascii?Q?raOcqCp92WeqiaDleK2EmL+MyhJdBYKk0193myzV8+3E9alBggQTIB9lKXUE?=
	=?us-ascii?Q?7KMBpTg7b29BlR2LscuWM6WzgIjSyYfNWQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98283964-c91e-431c-9fb9-08d8c35e268c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:27:21.2324 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2IrgMXm3pcAMmUWJ3iRNrQ3DcnbFiB1YBVtQXVgzQ2J9zyuh/I6YXHgjhJr8lFi69x2/0yQ3ft/PTFeop9ktQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4852
X-PDR: PASS
X-Source-IP: 68.232.141.245
X-ServerName: esa1.hgst.iphmx.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	clxscore=208
	mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=186 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280035
X-Spam: Clean
X-Mailman-Approved-At: Thu, 28 Jan 2021 08:25:07 -0800
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
        "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "osandov@fb.com" <osandov@fb.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "jth@kernel.org" <jth@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [Ocfs2-devel] [RFC PATCH 02/34] block: introduce and use bio_new
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280081

On 2021/01/28 16:21, Damien Le Moal wrote:
> On 2021/01/28 16:12, Chaitanya Kulkarni wrote:
>> Introduce bio_new() helper and use it in blk-lib.c to allocate and
>> initialize various non-optional or semi-optional members of the bio
>> along with bio allocation done with bio_alloc(). Here we also calmp the
>> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().
>>
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>> ---
>>  block/blk-lib.c     |  6 +-----
>>  include/linux/bio.h | 25 +++++++++++++++++++++++++
>>  2 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index fb486a0bdb58..ec29415f00dd 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>>  			sector_t sect, unsigned op, unsigned opf,
>>  			unsigned int nr_pages, gfp_t gfp)
>>  {
>> -	struct bio *new = bio_alloc(gfp, nr_pages);
>> +	struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
>>  
>>  	if (bio) {
>>  		bio_chain(bio, new);
>>  		submit_bio(bio);
>>  	}
>>  
>> -	new->bi_iter.bi_sector = sect;
>> -	bio_set_dev(new, bdev);
>> -	bio_set_op_attrs(new, op, opf);
>> -
>>  	return new;
>>  }
>>  
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index c74857cf1252..2a09ba100546 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
>>  	if (!is_sync_kiocb(kiocb))
>>  		bio->bi_opf |= REQ_NOWAIT;
>>  }
>> +/**
>> + * bio_new -	allcate and initialize new bio
>> + * @bdev:	blockdev to issue discard for
>> + * @sector:	start sector
>> + * @op:		REQ_OP_XXX from enum req_opf
>> + * @op_flags:	REQ_XXX from enum req_flag_bits
>> + * @max_bvecs:	maximum bvec to be allocated for this bio
>> + * @gfp_mask:	memory allocation flags (for bio_alloc)
>> + *
>> + * Description:
>> + *    Allocates, initializes common members, and returns a new bio.
>> + */
>> +static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
>> +				  unsigned int op, unsigned int op_flags,
>> +				  unsigned int max_bvecs, gfp_t gfp_mask)
>> +{
>> +	unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
>> +	struct bio *bio = bio_alloc(gfp_mask, nr_bvec);
> 
> I think that depending on the gfp_mask passed, bio can be NULL. So this should
> be checked.
> 
>> +
>> +	bio_set_dev(bio, bdev);
>> +	bio->bi_iter.bi_sector = sector;
>> +	bio_set_op_attrs(bio, op, op_flags);
> 
> This function is obsolete. Open code this.

And that also mean that you could remove one argument to bio_new(): combine op
and op_flags into "unsigned int opf"

> 
>> +
>> +	return bio;
>> +}
>>  
>>  #endif /* __LINUX_BIO_H */
>>
> 
> 


-- 
Damien Le Moal
Western Digital Research

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
