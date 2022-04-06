Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE090C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=q52gOY5KlzkZ/kyVW/QTBgPSJIMR4YKbHacFuXSATyE=;
 b=AEn2Brz7iBgnCVYH3NLAZeDwdHEEodlTlSC9lW0HnlEJbNwJ83+bkKG4Rt3XHccp0sik9z4L0yTi
   VEncjcM2RwRLIC0u5aLnETOew0hlK4lLAggl3lWQwXMgJu5JGo6NLG+IQaTU4R4wlfq4C4YxL1hw
   RqrlwM2etF9XvVKwJDvcVPaM+LESSYXHhI7+KS7UO6qxpKRl8M1UYnccBIvYEL4sl241XoN6fCzj
   Dttbe6vbg32F7RdnIS156lGoeaGEZLvNKFC0rx338qrejbWpuuVgp3YWSYTbFMsMSnTCWKhl8Lqa
   v+z1jkF/9FdYxkmGYkZGrs+IrxcugqJgLdu+qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=q52gOY5KlzkZ/kyVW/QTBgPSJIMR4YKbHacFuXSATyE=;
 b=lS/3Oqv82/etoFuRkU4b9FYKP1IxRwiPM0FFYD5oYZm27wQY+Fvpn7sWFQALPabeBRGPv9FZqu+8
   MbWtcb0m7Z4TZpybwQ3Y5jpJAUNoNkL2i40SRCga3W4YUfAQR1TuwYhfnrr27leuSrCe8V1ATix1
   BdlqWDZRL0lYcnpZnBWgV4sOWQi/arEOemuH1/95/EXi2RZ0RPSLRpLoRdRNnI/RGMYMizgvGnoS
   65NG0OJNjglSj4M4wYUa3QD4SVY1cStmaTQu1rMj93vrWSf5Rqsy21cgA3UoQVjlh6g/Q8ixNImI
   mjz2ejHv6o+AvBzPlQFQMZBMwT10W4WROajvyw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00KCNX2EE320@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 09:59:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1649239128; x=1680775128;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=HOJSTfD4kUHvggz/8S+3n4FY6u2FGj7TFdA4mhprZqYXvtMgORHMCBKI
 FnHaIaTsWjLp5fVv7Vwd6uVdo1a7SCKVKNzLv/mY8m5UAeHDBaScPOJDd
 LSNlgFJHVektlPLFjdrxWvv35tmUG838b1iJSe1pAyCQaa1C7luZCGnsC
 VfdZbS35ECCiPnQ34uzYxD9AqcEPJV5baVR6Mw1QsomLg4VT1f2+fBJcB
 bfhhQi0gvj3l9ZmsdllUR1k0VaI1gWj/jp7tmstO3ABayRS8m5+P6/WIe
 IB0jGJn+HFvVSQkxLLiq6iUuYV5+3Klo3rfVNqftQQ7MWFG+0HH+lK83n g==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZywV7ltuw9siQImxgkQoPP6wfeZPfN+DIbYHoqvFqg8PspHMPPVbjOGu34Y1VCFutPfcbN7w1CG9uIcpq7NyPeQGhoZepeW1TOBP2zlcPqBmDXXzU/6c4WbvphC7Vg116kMB0hFPBg7c0Q8rkL+JUb9EXS6dJaeFy2qxfVUyz6z5nIddZ1wFqqzpUGT5JOGzqrfslikOn+wgvc+mUxHDocSWTysyYNK8wrMgO8wpoMwwUIy+nw0WFak2qxflo6GZSub70OFUZwWc0j4ME1BjgYxeSUHxKV4AKu7Di064nEfOqWFlcU+DqH/AlhZbI61biQSOcOMiOF9lEL7ZElf4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=AbViV6LyHbwBkCkSSzHf7MhBfjPBdr54WKxpT8TH/IU79sCSAQffxHuxJ9RNY2EzqxKBO+p/CtlU2dIfFhcVyLKexjvE2GMJkTgUnVGgE8ZOGiAjsWqGZCz+S4s0fi2KF7ovt1G+WQXRH9g/XDe2khg/oNuFANUcA0NsqpLGuhYCzvHSwii3EIBQFNHKMIid6CPBxGtrz4Mt5DenDBgz5WpbjSMua2zobVu8OimqR7cgihpvHcnC6bLPpJAgTQfi0XWpFkQ8aMP4PqpPSOJMwa8Rj/g7k4SszozuP84H/nQt/5puzDMJImjRpwNl+TA3FTVQjs1S5PLAZKzjLAUHxA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=vanbsnJo4FhAc05B4EMLdoIDZnZc6CnMGAlQXIgKOZVYA6DbT80UxMUlZ/wZQXpK2g5bXanvTRVKrwfWuZkUTgFBF43n8wxbCegEebQVh5Yb5s9fBVE6XXBs8KIPE7Ai+IRlVXIjfihcLTETxl4No0fuwffum1oyx+1efB7QykE=
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-topic: [PATCH 14/27] block: add a bdev_max_zone_append_sectors helper
Thread-index: AQHYSZgY1jr1xIM/YUq07NGHawfBLw==
Date: Wed, 6 Apr 2022 09:58:44 +0000
Message-id:
 <PH0PR04MB74161D2CCC5AD43AF09264799BE79@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-15-hch@lst.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(4270600006)(9686003)(508600001)(186003)(6506007)(7696005)(2906002)(7416002)(5660300002)(55016003)(8936002)(54906003)(19618925003)(316002)(71200400001)(110136005)(66946007)(52536014)(91956017)(66476007)(66556008)(4326008)(8676002)(64756008)(66446008)(76116006)(122000001)(86362001)(558084003)(38100700002)(82960400001)(33656002)(38070700005);
 DIR:OUT; SFP:1102;
MIME-version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 09:58:44.4524 (UTC)
X-Source-IP: 216.71.153.144
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=159 mlxscore=0
 phishscore=0 priorityscore=78 spamscore=0 mlxlogscore=655 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060044 domainage_hfrom=10918
Cc: "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH 14/27] block: add a
	bdev_max_zone_append_sectors helper
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Johannes Thumshirn via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; d="scan'208";a="197229644"
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f6a7f3a-4bbd-4cc2-85a2-08da17b40972
x-ms-traffictypediagnostic: DM6PR04MB6607:EE_
x-microsoft-antispam-prvs:
 <DM6PR04MB660754EAC2F7575A81C46B4A9BE79@DM6PR04MB6607.namprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Pf+KzgmagSIS5atE7qUNGRr1myBVVGSwEKyeGnwHdGjwF8GKBkvoIHDqMGnWFjO7XVa7Cmit9VnU9OIYztUkoZ6Oaqq+m+DiWH3/Dcl/UxK+P88E3f1isC2vpAnDpZpqgSoxQyKuSo19P3TzE/8glOLI6z0BLxqJa3LBIp+eJLbka+iU9uRCJGcYyq2EzzvF+GSwaV6/rfbL34RfHGjSRx0zwHlAe3Kbe4uou4XPkMqQqujVK+FspM3sA99WzgIx4Zcg+5oQR1jIyR4eA4XENp/K0m69Xx8aQEVd4C4NwBIAYB3DJbFAzY/xwFTEh8jZCLaKfZtso51HpFNskLoQWcTVyjcyZmpcj72RYBDj8bY8b+y0gW5f99u30BEwD03iXMk539DztkZxuC2HzN3BPR9e7KwNaRwwncQjXFedlJ7i/0TsMz5nf+dZ1/3hTsc6CrDt4p9WXnzuh263wo3xd8b6MW4eTv1TtLR3IzWdMRJG6cBeGO9RPQAMiItBrNypFxmRFeU4T1cp36pirzbw2w/ywCTEUkYc9uazSWAmIkbs2ELSVlHFGtwIR9gzIB7PlEGWJvLVp2CUKQFt3mcwlEIarIZ+6NjuqDOsMS6YGKX7bI/K6LKHavdoNguno7hvxdITrai2aC+YdO67pyr3n4smmpegwjXfnaI0Pmp9jFcUJll/tJASQJQReuEZSzAgzPzXDpY2hiiRf4a5gE9HNg==
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FnQ2cDOI1Y8dqfwBZ9O49we2ex33sga4MDlqyPsi59CHLjzinNdqahxJKb+7?=
 =?us-ascii?Q?nLvA4glwLQWN5EGlwq9Vu5N+6RAHp5zPzMSHYKAI+ROqS5ObV22YE1uWhKPU?=
 =?us-ascii?Q?t/Slc0Vx6la1V2Ehl/8AFvAWHw7Kk3JevtOLqRNrLr0w3euyxPc4I6O7fPTQ?=
 =?us-ascii?Q?wLfN+Opb6mKJvfOq9BzXaoPuzM535gJJgXGiZQqr6/qzazXpx3T737nbJ/fT?=
 =?us-ascii?Q?5AYtInAAQcaVRXLBBJ6GN9tSCFD9aXABykDN429p4xlLfpuoDafHP6Jt5DbB?=
 =?us-ascii?Q?Iydzn9jRd0E0RXYdxFp2csxTMSqFiUWkGWouJQyBb2zUZOXn7G6VB6J4KuZp?=
 =?us-ascii?Q?fgPATSu1EoTsQYfHXonfg+YKrx8NlCxiY/WvDPDFylow6ArLN9X0TnmQSu+/?=
 =?us-ascii?Q?95IkUf/R+6oTU/6z37jGwKNh1BGImR8Z7zNd/uM1kkUQPDt6xtfwy79ITE6l?=
 =?us-ascii?Q?Q9xvZjwe1VhuWGzbavCQQVHCFV7hHqZE4hFqaAuJ/8loV7GxSt384nH03jh6?=
 =?us-ascii?Q?9hvUXSFWyQok4WycdVBAq2Pne6x63Kd/dzPArvViOJMCNXPPzMfEK2zH+VNk?=
 =?us-ascii?Q?3w+JAGP9eY7icR0QYXZpvCQn8jI2n5T3gvnfOW20uZaiR/w7EP9NAVWC238p?=
 =?us-ascii?Q?YyBdPiC0Py8H4BU3o6Exn/i3teu+O1s1FRXY9XsoYqSfv67wXY2BgOSNYQbS?=
 =?us-ascii?Q?A5HFhEpzP7fd8WRvXw6jIXWJduai4VwRFzBDYyAROlXlWkq4K5uZrnKpDVri?=
 =?us-ascii?Q?Lt5+iS19PHx7Rg1R4wXdhMzRCIjeeZd6PFaYSh3xZnuu+5Y/9ohSG9i7K502?=
 =?us-ascii?Q?1a/bzUyzkQNxTw1tQYH5EyiyC91aNMcH4nxXhtJ0Wedzj7mvIGc92lxOt5nE?=
 =?us-ascii?Q?JXxVC1uDiYmPEFzx4Y7D/dReZPhWqdc/jJdKt2W1YymXQazllgQwdagCnVsb?=
 =?us-ascii?Q?womFEzuPHfgISWVwI5IydynP4xWEHyHSeic/OWVf2vvnSOGfChy1xgRteWK8?=
 =?us-ascii?Q?O6lHklcYNZMBh105u3WOxpHTEenIZDxy4CJyZmOxjyHRyQ4/hAEahlgNd5T0?=
 =?us-ascii?Q?IIYsp55Li1hGb6kle+7E42lhFheoGmLSgVlPzJ2wViUr5JkB3zXPshZNHdCK?=
 =?us-ascii?Q?Drnr9ry+2eR2o1K0g1sZTYgaa453J2FLPb9EsxMmvl+A368fmvtLSJc6/GHO?=
 =?us-ascii?Q?kvIPug1OZFdbVSPQJnxaWdWK/ZgXRpNAH8KH2/la8sZCkHzfpGIcxpeAnxvp?=
 =?us-ascii?Q?Fu1KO8wFnzRvdlhTkpS+//xvC//Yvj9IUA7H47sdMX0MyyQstXAAASDIKQzq?=
 =?us-ascii?Q?4itpwg8G4I0h6hT1UWz/LYa9haG+XO08rx/HcQSRBLKhwhVFQQ/8TK7uDzGe?=
 =?us-ascii?Q?UrBw7s5v4mnnSjnPPV0U3E8GhTQO8/rq7n7rEAF9/BOb/A895TI4AENRfP2H?=
 =?us-ascii?Q?p0lPtXAfbYI2WYitkaAvMjep+iCpB8qGIW0MlNI4ahmo4gxlHF5/DOEVAML3?=
 =?us-ascii?Q?BsIhXDlHoRVG0p5dRxMkYVIPTIGR3tyHD8mDdRoSdVHc4PDkENOpi0vFrLjM?=
 =?us-ascii?Q?EsYFTB8/yWBXoKQrEy5lf4EqcvGyrksY/i+ncEk0C/qi0ucMo5O259xy4P5n?=
 =?us-ascii?Q?3OstWIQojxiCGjB3QzJ3ozRjmyPwY1cmzijUV+XzsMpKKikC4jRprDn5XJ3B?=
 =?us-ascii?Q?Z+ROJZpHXnIZCV41bUfdPSJQIk3jFqaSY3c3C5xSCmsfRuvM5N+mx+Qv0l5x?=
 =?us-ascii?Q?vgoI5NvxJ4DIaRE4F1vbqPEUlylYZ3nOFgGkB+69touDu3OoVoMGP2adpG05?=
x-ms-exchange-antispam-messagedata-1: pB0amHYuRq2xU5J1OT0zoHwBXpZuYFgg+OQ=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2f6a7f3a-4bbd-4cc2-85a2-08da17b40972
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 cIO2gZbnUPowYwL5/+TFbMlM0mfXcWCM9eVRDLVDk37wzbnptzItElefyoFDRl92/LtkQZrZmaM/CVn+ZNQbb4SjElNyDclRC+u7dyWjvW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6607
X-ServerName: esa5.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.wdc.com include:spf2.wdc.com
 include:spf3.wdc.com include:spf4.wdc.com include:amazonses.com
 include:spf5.wdc.com include:spf.mandrillapp.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: rQcFN63VTwJH3Jb6s_55y8L5HSke8-H7
X-Proofpoint-GUID: rQcFN63VTwJH3Jb6s_55y8L5HSke8-H7
Reporting-Meta:
 AAERhZANd5rQ21mtbjIpcH4tf9qB28Xm4C3i9LgFyCOEQnp2o1XLNX0OgetJ2Bnb
 76B0ZEKLLtUn8jtiO67ig1J8qeMhIyTHoxh33aNrPGxb5XUUoPK+7PqNBQ7y6etu
 P1w7Io/hjxK+KyqbQmsk1Yz8T4JDKrRlPDxhl0VCign4T80ZD6ORsfKggru5XuxL
 fA+69Y11gRMGQa+akwsIpg8dEBPdY31egWYh/F6QjGHrwtssfmitmC756Qhkbh60
 nDUstqkilZcLzD72PvVKxNtWLxerBqKlcThkof+gyuvVu7EASH9sppmPU2jgHe8W
 cfKbqY7uf5rofvVBehZwomQKV/PELJaRWV4JtftneRlpRCSvLDsCiewt+RJKZ/F+
 GwS/XwGX1XNDWb33negN4vpC+haLvVr2+bq/UJYCqjUyrA+Sx5SEFQhZckTzEdnO
 1XIygSKDUghTO6lom50HKFOL9AoxXM1JVM61QwN2nHhqfDVOb2ztlpyTDBI8NDDi
 E9j6wHb0dU+ZKWxsj5+kvrzcS2gHIYtPS+j4kgch8pE=
wdcipoutbound: EOP-TRUE

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
