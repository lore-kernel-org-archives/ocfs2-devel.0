Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5675EC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:12:59 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A73B46146D
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A73B46146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S89Gln189320;
	Thu, 28 Jan 2021 08:12:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 3689aau15d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 08:12:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S8BnnK106841;
	Thu, 28 Jan 2021 08:12:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjtq4ms-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 08:12:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hv-0003cP-N2; Wed, 27 Jan 2021 23:27:11 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=6551138a8=Damien.LeMoal@wdc.com>)
	id 1l51cm-0003C2-14
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:21:52 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S6xmTx017809
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:21:51 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 368wjtmwg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:21:51 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74Nnq040626
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:21:51 GMT
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	by userp2030.oracle.com with ESMTP id 36bqd390ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:21:50 +0000
IronPort-SDR: QEF+8TGngCqTGDYAfES0k7Iq8Lj8Z1j23hWw3M3LnFhL6QZih1XM5LZxSRsfTJXgpv5E1SblKM
	Bsu7V10JhP5TnAvBjYRtRxEqUPv2HJm33T5x70FdtpKeTam8Lku0k8SIl7hluBD5ij/As5Vw9s
	nKuDQlS8VQ8KHSrpBH6erXI92dE58YUlccMAgxKbmkG5Krj4uGkirZn5TulPgUw8Qky4rfx2PQ
	aWCuLtWfwtNgNSyX+xM2wVuWWfLlJn8a8AVx4NTLiKKss4UTZKw7CG5gC5hQr1D2fM05/SrZuv
	r5A=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158517952"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:21:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=XGvTFC0yVocA1hFeGOYvjQ+f/YSuD75Q/8tkuiyNxQkF23UxvMywneYGAln1lw8Xhs3qjQvWItdgd+CqdoCZOLpmuH4ptIfJkiKypbJOF8fjo6xly5kpeejMCcmb9TV+VYlceFyaNhO46nha82bqmy7/luCs/lrsoL/cArREno60UHuMizWsEmdy4Bxfq7LnJpERyi07H9ww2vM5jeFFQj0tMeAigkwO1DsWafJt0Fq839vVOSa6z1KrJTZS1iJDKKe3rPYdaA3pbji5icSyWi0MHi2Av8SuAEzbzvSxch0j+tb0kMkBwUJVhvH8tc9lyxzjLZbBWdlEFDj4KAQoSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=rZQ79VfW37oEjUPhbUXgVDt26btMTlh35TXahcKTIxw=;
	b=ewcyy+f5pm0Gvfuq66QLUzmljFfxV1XcSt+FlXT110bCllm3RqvEk+y6rdwmDmRsLuIdGvXsMnFhphdnjfxABcalxu6RrTkW7MnOnWh9EF/8L3nffa7eXXB95G3BRw9RE5QltDcCZ1vcJ9c2HoEAI4HaooQEfE5prpKhyIBJc+z2sT8ynyDdElAtc2TQJJC8yAuAd8n0jS7Wc+YTaNR4fwo2ziu1wBo7rB+4xYRJnj/90sIzgR+/oyqJ8hNKi14vk4mwaZnVXoctiOqF4V0CjyJ2prws95UPtxPw9I8GHkzSJXn0TdiFJJTWo1ZfduzHSE90W7Sesm7qKNrg2W5Wag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com;
	dkim=pass header.d=wdc.com; arc=none
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6352.namprd04.prod.outlook.com (2603:10b6:208:1ab::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Thu, 28 Jan 2021 07:21:42 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:21:42 +0000
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
Date: Thu, 28 Jan 2021 07:21:42 +0000
Message-ID: <BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
	header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb871fa1-3f12-44a2-a077-08d8c35d5ca2
x-ms-traffictypediagnostic: MN2PR04MB6352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6352DBDFAB902914B9C585EEE7BA9@MN2PR04MB6352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M09uEpCy2sHYnN+orzp8d3r4sKwPwnS+kovdPTr+X2vGltHHUOiuwt35YiL4pwUTQFJb9lI/cctrcvMtSEsYDG11B6WuQeQ5LhCFOm8xnCx/j7IUhZfAc+BSTsEsxty8tkWMahat2Us5tDlHI9XpWnzEpUBuIiTIis6CFGcSzDbZQv+YTkDwb0pb6zKYryvjjNyuaDbfN6d7lDvAFgMe/S84pCGpf8NIYlMhpfcnANa9rtVk1fEfaQ11KXM8VaoFYslEaC8FtVVKMdMiSlVm1G6wR6EIe9QpF54CPrt28byH/cHhwj053vEXp8RFF07hlGeGEHLWbouozYb93iT1K6F5OPFCWV/ewR8z5Kn/uykKQypwrh09HC+m3KNohPQSss4YboxRFNRKIUOjUD9KDfOD2dh3DMVG9Wehar1cknnRs6eoICQxgNf9XdAqhQxkvWGbAdwofxGFVG96zdq+KiRY7l6iGEQ9lizBBRpl1Cl5YsTWF3Ebz7haDS4uRI4CUlc0EEMGTEpRabqGyepXSSCQauC0I01aeQXMPzWGYL5JlkA/UoQC4yu0QYoNvMSIgo+cZP34MN7KkNUL2U0tyA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:BL0PR04MB6514.namprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(7366002)(7406005)(64756008)(66556008)(66476007)(66946007)(5660300002)(7416002)(316002)(6506007)(186003)(66446008)(76116006)(110136005)(83380400001)(53546011)(7696005)(91956017)(54906003)(52536014)(9686003)(86362001)(55016002)(71200400001)(2906002)(478600001)(33656002)(4326008)(921005)(8676002)(8936002)(21314003);
	DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ilRnIHb2W+3T2C2caNzRqpDzJ0Ea0Xivh3HFrmVjFepbjG/4fJPeoU7kjRlT?=
	=?us-ascii?Q?4cfEdoxq1pKIhTR8YC8VWpTJjQgCARNQwY+MfHwWAHyq7XzZrTJ+W5zBB4Nr?=
	=?us-ascii?Q?gbqboym+VApr7h2E6XSe0FmXOz+omKq6DFZVboi3NwQAYnWCDCcygMa0n5ZC?=
	=?us-ascii?Q?i+orw+uEOMmnA8L/tMdOkJYMmLEyVDh+G9pnjfMmYkt0blpGnFBWHNDym39U?=
	=?us-ascii?Q?dIrdmaQbh6883La06gFXbWGdjQgjXOXLEnZ3UgQdxTZ3JyxZKLQ71jVVbmhr?=
	=?us-ascii?Q?0p2pkHIwQoMPz5HKOnR6V80LYTmpcP7VgrO091zZ/4rct/lsBVwykJza+GD5?=
	=?us-ascii?Q?IHbQu1IRlEAKFeXGAtTjEb578LsnTaSvJCJYoQS2vP+axrzwvVVw8mOt+5k0?=
	=?us-ascii?Q?KL2XZSeojWALtQsww9PwXxXKo/u++tt+9E5GT2jM5O4BtWCGYIeHt1uhRADL?=
	=?us-ascii?Q?gJ0hzvvlILRjU/TqEgmmCXBE50OH3C99QT7ii97n4+QFDEjw2bGLKb5lrf6H?=
	=?us-ascii?Q?IHyTRN7gvNFJTUay5wTAkpCCUyYWXZIjEb2UFpB6lV531wPPtNPC4ZXwwrWy?=
	=?us-ascii?Q?UUwx0RViz7R7iLMJP7kZUpan/n9xAtlMTSdfuUl+LJK65X0ynOT4EUBmjZh1?=
	=?us-ascii?Q?7f2FeVb24U1zoxD5JnIuvykDuOYgmJlnvf2GvI4IfNA9RybrTxAbVd7Ev1uE?=
	=?us-ascii?Q?iYKXh1HRo38Gzl+/krexExV4e0GgKuB8ROJUM1mrrLxC0PLvUJVZZWIIKY/T?=
	=?us-ascii?Q?EtWttQJe8PPeFmAWMbSTnlaoUKPvNyDC93hjlfGSDIjTTLIFZ4iZg/v8/mfl?=
	=?us-ascii?Q?vPF743c6M4QtXnUUQcdd8jMU2Xffoi6iuon4E7e6TeLOR0e7niaTBUf3bgPv?=
	=?us-ascii?Q?W2AR7teeocTc9v/wp1bkGDqoO4PDXnCni+0tsViRKD+BHAkawcDVDIjbtPby?=
	=?us-ascii?Q?TmOiQAj1HhTITExgPZ3Am1ML0xT8XHeZOcxCj8XLjunGXY367EkeICLa7oc4?=
	=?us-ascii?Q?Hx+SgjQnG25wJn9UaUXUtvbZ+SxW0OdUJGfxAAPJaG/AhMr+s6nN+ezf5jC+?=
	=?us-ascii?Q?TnbTVjltXe3BweymPazgpv3fxkvT/+e3/ihgd/xwUglKOJv1POJWqDO9pOjp?=
	=?us-ascii?Q?vVmRwBKsvdP+eIgHWtuWTOV2jEyOlzJg4w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb871fa1-3f12-44a2-a077-08d8c35d5ca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:21:42.3813 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOBO+8eTXWVmpt6dgIHyBBjDN753lOgBMYt0QXNGr1qUdGHKogIJ1c3Ww3ZO4DM7PeQNbxVnSGwrctGN0hiVFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6352
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
	clxscore=238
	mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=100 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280034
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280040
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280040

On 2021/01/28 16:12, Chaitanya Kulkarni wrote:
> Introduce bio_new() helper and use it in blk-lib.c to allocate and
> initialize various non-optional or semi-optional members of the bio
> along with bio allocation done with bio_alloc(). Here we also calmp the
> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  block/blk-lib.c     |  6 +-----
>  include/linux/bio.h | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index fb486a0bdb58..ec29415f00dd 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>  			sector_t sect, unsigned op, unsigned opf,
>  			unsigned int nr_pages, gfp_t gfp)
>  {
> -	struct bio *new = bio_alloc(gfp, nr_pages);
> +	struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
>  
>  	if (bio) {
>  		bio_chain(bio, new);
>  		submit_bio(bio);
>  	}
>  
> -	new->bi_iter.bi_sector = sect;
> -	bio_set_dev(new, bdev);
> -	bio_set_op_attrs(new, op, opf);
> -
>  	return new;
>  }
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c74857cf1252..2a09ba100546 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
>  	if (!is_sync_kiocb(kiocb))
>  		bio->bi_opf |= REQ_NOWAIT;
>  }
> +/**
> + * bio_new -	allcate and initialize new bio
> + * @bdev:	blockdev to issue discard for
> + * @sector:	start sector
> + * @op:		REQ_OP_XXX from enum req_opf
> + * @op_flags:	REQ_XXX from enum req_flag_bits
> + * @max_bvecs:	maximum bvec to be allocated for this bio
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *    Allocates, initializes common members, and returns a new bio.
> + */
> +static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
> +				  unsigned int op, unsigned int op_flags,
> +				  unsigned int max_bvecs, gfp_t gfp_mask)
> +{
> +	unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
> +	struct bio *bio = bio_alloc(gfp_mask, nr_bvec);

I think that depending on the gfp_mask passed, bio can be NULL. So this should
be checked.

> +
> +	bio_set_dev(bio, bdev);
> +	bio->bi_iter.bi_sector = sector;
> +	bio_set_op_attrs(bio, op, op_flags);

This function is obsolete. Open code this.

> +
> +	return bio;
> +}
>  
>  #endif /* __LINUX_BIO_H */
> 


-- 
Damien Le Moal
Western Digital Research

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
