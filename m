Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C904C433E6
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:15:41 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A917E64D9D
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A917E64D9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S89FFl139049;
	Thu, 28 Jan 2021 08:15:39 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 368brkts5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 08:15:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S8AEK1091598;
	Thu, 28 Jan 2021 08:13:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wqyy4c2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 08:13:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hv-0003d0-SV; Wed, 27 Jan 2021 23:27:11 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=6551138a8=Damien.LeMoal@wdc.com>)
	id 1l51g5-0003Hm-Dp
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:25:17 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S7PAJQ125951
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:25:17 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 368wcq9h0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:25:17 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S7OUXa012372
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:25:16 GMT
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	by userp2030.oracle.com with ESMTP id 36bqd391sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:25:15 +0000
IronPort-SDR: 1XO4jceGpXsh5IubGHdLerxe4aeG9SxsSlvvinyZ7xz57Mp/Yn2xXzprrhv/lGRMw7sD89FT+6
	0aDVxAiCPzDc65NGiWOiKo5gxtNSPZKz5mlSA/25VzwvVnfoogtEwKBkNuupemZT6VWxmBVgoz
	1kutj7VUKXVePpFPNy7xf0zdg+eN3kJwPBnQ3H0UcYQsyPV+WI7edJnh+Tc18j4bolIOp7HUx9
	V4l3St9H+gnv0HQImdqL8myuAw+VCjktcivp9mOSzOLzABQ8HsgpcL3yN2K451BrUxmzcCQRu1
	NX8=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158518131"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:25:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=mPdcK/wrqdrll5sSKfk/tpq+HKxGIlQ0olUV0quQ8r2P/3nkAWU1JEEJynwYK81uPBXyiVe8P/0ReiX0vWx1ysl3aPlfWX/zWMKqDpP3Q5OUw49avJXJH2gTxuUGjO1ciVP4bhrZgRGcJvgcVGiWfncxPWNr4BpcNlSKmoScyPyxO+CsrdP/WJneJ6H0ickT2bAe8XRmNbNkCDwsfGyW0Z0LbNI+jh0D89leTmSOwyP/lyte+GTjeNnQuv3TwgkY8ipQuG5F0C6TnV/hLz2zC8MxcG19vCz2vtGsbqAPOIHDQ1zaNzys+NQGoUOAO83YzvMc1YgQqq42Ugx4+leh+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=jSgQdFikue5ip6XRlyXPzYKx1++P+Hg8uK52x5aYL+k=;
	b=KUUNYeeXKSAbS8LV+b7WXja6brRVaKoFOOm0ujkmkWuJSLPzgus7drFwpT6L7Ot2K4uRF84HiOSSRTJ/a1vz14uMNSrmk+D9cmd4fog2uuZkq8Bg4yioVRqhjkmTj95TPpunAFyXu7wrfwI+6bUToQUict0wo7eAxK2IKlx9ih/NNFUjYgwBtAu2Gc9hsgJ9vjHItWNsy/YUwdnRsmPGo4+Lx7RcpvBVDiWHK/y4ptKzFiztsD/lV909+yhlv4jzL9U/PMYvvQ46Zlbx5vG6kL0q+Dd7XlcNgHHYYN46v11y9UnCCpJz2FcBxuVohCL+wb9/1zfcSBwhN80oplJPxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com;
	dkim=pass header.d=wdc.com; arc=none
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4852.namprd04.prod.outlook.com (2603:10b6:208:59::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 07:25:08 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:25:08 +0000
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
Thread-Topic: [RFC PATCH 28/34] zonefs: use bio_new
Thread-Index: AQHW9UVkomvF2vpeIk+EkJoBWTZvag==
Date: Thu, 28 Jan 2021 07:25:08 +0000
Message-ID: <BL0PR04MB651467E7A7C6EA542A435DC6E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-29-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
	header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 571a2e12-0985-48c6-3f9d-08d8c35dd761
x-ms-traffictypediagnostic: BL0PR04MB4852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB48526F818C0FABCE58FE358FE7BA9@BL0PR04MB4852.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32W9x/cXloQ/0z7DAt7qSsx7G7lrDFeZKKnz06uUAgqmQA0gT3PPCEyknGB3ASTcaW8hMZsSv7e4qBntNlXUHbZ8XUAGPoKPUEg8L3NUMI7uFcJfpKllkC7jh907tv13wKROCFhzy3qIjUrr1qvxVNJbHg4AnaAu7Hd0n9BSJd6ltHb+lx6Kt1Bn0OufCV7+r+cTwGKhQjCwuKOs+4ysKSQ8sW8+mt0qxyYFn2M/rNCmGKkhY8zImLX2a4W554RAzTEia6eb4MM87+6pBC8w1Q2HNfvRcd39MixEiA1EUbkbySsl2l7XWBYBO5mzIk9WQ9arSlUleijKB3OzhzhTK6LyklxSc45/PlQXclMCdkFEDXw4Ertp1VGxUdGU8cRWvDhZS9EfEEXCIfXImgIiA9tufLH1CjNO2bVvXzP6PLtxkgtk9qCm5MMg8XrWcy13k6zxpm3w4mC4P9lE98bhvznAFUhPPMQYCtcaqGBVD8wVrEEVpyd7b42fgd6EvLNMLYC9H3silifIWz/Rg5TpNU9zXgVikI9bgP+aoGCiEFisN+if7JaPfhP5VriRPmet
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:BL0PR04MB6514.namprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(186003)(66476007)(83380400001)(53546011)(5660300002)(66446008)(316002)(8676002)(71200400001)(66556008)(91956017)(86362001)(64756008)(6506007)(2906002)(66946007)(52536014)(7366002)(7406005)(9686003)(33656002)(110136005)(7416002)(55016002)(54906003)(4326008)(76116006)(7696005)(921005)(8936002)(478600001);
	DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KUYSxjXYfQyNkYu8LxobzslWgbRrh1Hl0zsXUUsbHOAiFNIp1CHkc7Nx0P0Z?=
	=?us-ascii?Q?86/TnX/TPZp6t3X6c/g7GjztYvohIOlICO4H8k7mNeR7y+CZ3BtbwC7PEo6W?=
	=?us-ascii?Q?HqJHIyObHou2BiSclkZegmCnVRenHuoXxGl5D73K00V1VymVtpakkO57xYsU?=
	=?us-ascii?Q?Ck0cY+BcGGROkuC2MoyqtVOpp/iltPkRzE6GJ9wDOX1598WYiKIvr2y+YmQ+?=
	=?us-ascii?Q?wQwbQRUTninVVh6zv6CkTTAfZTBHB090EUDht5aK+Fo6z/eRCqrS4IlOCGFq?=
	=?us-ascii?Q?498LbIthUnE3rks5RvI2V2xbSQzfsFQhY5vova5SXPsbG/TiZr8HjDcdE2oW?=
	=?us-ascii?Q?8BGJ9GFuH2UrnBhdHujwELLdv6L1T/WlR5cJq/tiDhld5tUhYHzFjjWvNE6c?=
	=?us-ascii?Q?I+VXBTmaxLP14RoKqfP5otrWi3wLf4bycUl7pkHG2CaWA7+0Ez531fX8rOvT?=
	=?us-ascii?Q?cwBmQi02GfJo21WpVkvrl8s38CKqH8j5qJewOxErbbHe0iDj02o7T820Cxzj?=
	=?us-ascii?Q?xCnk763l4wH0f6+ovzE1ZlF3iE7LNGxHlBwqoKcf39VHXx7/AAy1GrT22ApX?=
	=?us-ascii?Q?MgPXcNJ0iSVZtFkZFzM73MhFM1bOuiOO7NGIY/4aAWcEdzhZflqdsD+WsBkL?=
	=?us-ascii?Q?yp43gtW33O9bJEtWIvPn6iuK2yQ3bsRg283jdRUh6QLEtjciruqLGthtvhIy?=
	=?us-ascii?Q?s+Qcu4k/NE4d2HrVekBg/BxoUQUacAxI3FQJlsyVGEJY20k7Q9k0OMh9tvCp?=
	=?us-ascii?Q?qtaZtRNzfpvdZXte5TfUlQMxq5WV2WBBQqcSz1ND4HWP/deex/dHdrNwRKlk?=
	=?us-ascii?Q?djYJIdTki4xpkR5Xk97EgRFyZ8k35H0GsnLJuHCvt6gVnkwWsZ+ztFnhpOd/?=
	=?us-ascii?Q?Y0xM6YlGj/6zQRgzmDTOlwzdb/zAxqF+vxvcQn6Fv/iysP57q5ld+v5t6054?=
	=?us-ascii?Q?LtNzFHBIocUBaYhhkclP8GsmoPTepXiqTfUXqM+B+fDDX1DL9mTRkt9y9Qak?=
	=?us-ascii?Q?Nh8TG/F+F4jszRp6q+6wcfEuAiihnLxXxfrviLvmh8gYVfagv93E5lxVVktd?=
	=?us-ascii?Q?hXXp0Bqmg9I+K4jbZwyXDH49F3B4s9kYdbA1Xhg2QrjeOTNP7nU4t9UFW+4p?=
	=?us-ascii?Q?Jw/JubtNhiONkVlxC0ibXm51hfwOkfGG6g=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571a2e12-0985-48c6-3f9d-08d8c35dd761
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:25:08.3693 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2LVRo+jq8H43Yomo5AbZnE8GRpz0qPYcTtqFQS+Wx0lj+olf9/bMCZK+x9/8XOA2sWiiRbuHCzb/zC8+GMypw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4852
X-PDR: PASS
X-Source-IP: 216.71.154.42
X-ServerName: esa4.hgst.iphmx.com
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
	clxscore=200
	mlxlogscore=901 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=156 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280035
X-Spam: Clean
X-Mailman-Approved-At: Wed, 27 Jan 2021 23:27:08 -0800
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
Subject: Re: [Ocfs2-devel] [RFC PATCH 28/34] zonefs: use bio_new
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280040
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280040

On 2021/01/28 16:15, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  fs/zonefs/super.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index ab68e27bb322..620d67965a22 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -661,6 +661,7 @@ static const struct iomap_dio_ops zonefs_write_dio_ops = {
>  
>  static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  {
> +	unsigned int op = REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;

I do not see the point of adding this variable since it is used only for the
bio_new() call. Pass the op value directly.

>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	struct block_device *bdev = inode->i_sb->s_bdev;
> @@ -678,15 +679,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  	if (!nr_pages)
>  		return 0;
>  
> -	bio = bio_alloc(GFP_NOFS, nr_pages);
> +	bio = bio_new(bdev, zi->i_zsector, op, 0, GFP_NOFS, nr_pages);
>  	if (!bio)
>  		return -ENOMEM;
>  
> -	bio_set_dev(bio, bdev);
> -	bio->bi_iter.bi_sector = zi->i_zsector;
>  	bio->bi_write_hint = iocb->ki_hint;
>  	bio->bi_ioprio = iocb->ki_ioprio;
> -	bio->bi_opf = REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;
>  	if (iocb->ki_flags & IOCB_DSYNC)
>  		bio->bi_opf |= REQ_FUA;
>  
> 


-- 
Damien Le Moal
Western Digital Research

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
