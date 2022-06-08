Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE25BC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 10:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EACENGggtCI2JKQkY15EymTTavpVZJ/5xN+k/OgKVdM=;
 b=JYVGlQXmvAYCjuojFMSqIDRYGA1LJuImtdrhkbNs2FgoCklniaE9xNJhXff/cItQMaugC/S/YeZs
   AUrbojxlJBEgHgREUwgThKMDZKiVI/ShFI+BGQrk5d9KXArFXooCL40JWFho0MNAQ7iqJV9E/+9H
   OKzKgr0ZPK2nX8eqOAqdRXza7O18IrHRhAp2m83COTuQd2gXBvsJXgoO5kZiS5QWbzEP8t/ysQdu
   8JgGsIQGSVL1ObH2o4UYC4IXp6pzReTjhMresBW5SohHnwZjo+g7J0n5AQHojtLds0U6V68FvigY
   Zw1L4Jmbebv2G2JgAEojFsfy1YGisszRikXa3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EACENGggtCI2JKQkY15EymTTavpVZJ/5xN+k/OgKVdM=;
 b=iK/DVTzb7P7uvVyse0hf3pZgYke5GHcIPVG+yXUv+0A+8L0nfT5sChb3lOy34o3uLd0FrXJRreSQ
   S1Pdw/AyEnf7qoltApdHK4hOfWfeJFoMzYnF5nZOZvHvbd35a0Koz8hYgwpHS4lMuwWA+4u0UMWg
   0TSkd7vv9FvTnDjYSZULa7NIlPk2xRC3vcF2E6L3WBEIhfqPLJg97DaaPBmTKzO9y/985gLdTe67
   SpgnBZjAMPtopEqD4FsOd3O29R2FdT01wETEeT1uYzrrt8ytIz9AG9g1+Hku7sOIK6UjocRfixue
   uwrEQnATqUSXcXNzRSKIpJhTAKRoqyGBcv/tAg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD5008H6ND8XL90@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 10:48:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654685306;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=4M4EyUuoCPZr92IioDsSgc7EnkwKC1F3dohr2tCIKTU=;
 b=XxcYLBEQHXS3967emaIXGB2aJGcwEfep1yiBW3aX1T+nYEXOq5T1xiAfsR5DvDegWsd6U1
 ddqQB9Xd3/lNV7hCFqvW9dlfeOkP79c1Kalqk8NJUJx1XWP083hh4gKrjoa4u3VwZmSvu4
 qBNQxPcUNtVQYIE5wizRLe+hpV1Gx8M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lodpcLQhWKQxINZXtBDtwY2Dq1EkEks6KItiZllM+Ql0xETWHB/gnUd4lfbzySPPHK+6HIPs+9ohVkiprCeeNd+OzGWC35nNJjy9KLmiwQmjslEaaOdGgA4usIQOvA5HVjHEORDxUqL00GKzdf3ZyNLU1QnCCZA70KP3sJ/ZJWwwRDCgKaPPrOAThmH9scjnpv8zioIoDAa7BKc+dxqlUP8Vi9ZFg6bnRcrr8qY1zfGFkqXAu+OAoqR43820oeaNehG9bdMTuiQ+8Np5OhnfPBJWLZIZARFR5emq1P3AytZhsC0Rb1eSa8mUesqANti7HkzncqMNXf3gaupidEOwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJp4NDMzRgHaCCS6CoIUckzE3cy7D7nIx9eY1GcmuSQ=;
 b=lyh7y6MFwUhMv7yhP1JoTav+jg6VzVrL+MhXZr4XxdL6kD9P88gBN+yvW0xdw99OaXig0y7YDUZ+7zkouSsdXQrAtVUd9hBo+NtGn5qVLXasFxCRsVZseO6V5A0KJuyls5y9quvwNrYDurCcU4jJfu+qeECPhpf0Y+OsEJrcdgQ6YJ/jnbng7BnLZ4dtEyiZmotNvo62sUBBdgrEy1QaDU/R1Fzta/ViIrm9VgVM+W5a0+bc7chbKb6V3kn+KxE48SJOJnwXOgn5DQI5svMU+V3PS5WEccxbHaEr2DwYwXTtz8zdmD6G+/951n73g8EKw7DpV+8kdABgSzhaleX2cw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysuse.onmicrosoft.com;
 s=selector1-mysuse-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJp4NDMzRgHaCCS6CoIUckzE3cy7D7nIx9eY1GcmuSQ=;
 b=WOug5Z/ljVAdS9yB3s8+nwmmo/lqQ0KmnKX9MHH9Sc8l8xdzSdNODbYn8O3eQVeCIyjtClSPEDS5QT5y6mjASqmWJ7QmjMOPiOdDiuhNbkP9F6Xsf19cnEa5wU6UcDMDb2YuJmcAhxySTlEQDIOktpvO6vPv6ZPNLw8QFFQ8nAuHi8DLIkKIkxf0dDm1gobAYnrC/RSrk8KsnnQ0IkHNPPqJyeWaGAxbSILxhQhylxCbiN0nTf/oeZGRMdA5ClmYzeMPJ21V0XABSh1mBGNB4RpRodxcaSnYKj8g60TOG4nvCbqzDqHNos9Jmea4ZtQ1jOA8faGghcHTxhQJCGohww==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed,  8 Jun 2022 18:48:07 +0800
Message-id: <20220608104808.18130-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(36756003)(66556008)(86362001)(5660300002)(316002)(26005)(44832011)(6512007)(4326008)(8936002)(2906002)(8676002)(1076003)(66946007)(6506007)(66476007)(83380400001)(2616005)(6666004)(508600001)(6486002)(186003)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 10:48:22.8948 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 priorityscore=173
 mlxscore=0 mlxlogscore=950 lowpriorityscore=0 clxscore=203 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080046
Subject: [Ocfs2-devel] [PATCH 0/1] test case for patch 1/1
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: Utgfuoc6PNuxCXTCP0zOhw-1
X-ClientProxiedBy: SG2PR04CA0203.apcprd04.prod.outlook.com
 (2603:1096:4:187::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d33bbd06-8a2d-4f47-0a84-08da493c6885
X-MS-TrafficTypeDiagnostic: AM6PR04MB6327:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR04MB63271E75D11090025ABA11A897A49@AM6PR04MB6327.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 OskV3UHHratDGn0LI7yY22fE8CABqTCAQ5yF7/ltPrXSouK3X6WK+HtYeg92HWn3jSpkLBOHIYYEvV+p8p96n28NmXn27fztNjT8Cm3d/4aodkY/RQAkFzusOqayFMWGHa+luci/YpCsXzicsRXq7udQboXQ/1fnJ/y+NJt0E8JAypMfrSdD9QMJB6MeyQbFrbemh45W5sl5DY/IHqzrVV9Ly9U3Kq/QyeQsplTBlCcj7BvvvEfMENzMWi1eWxsCPMAg46IOfgKSvDO7o/XVn2rGQAkg8wnbzPM+FRnFKZ5wYWwU5fR/ZS0UWdfOwITmdxSiUb2uF3MOpsq9wlR+DsjENvQiF4w85k7yMUyMH31vk+d/sOee3vhVEQ1DMqtKbbep+731ynuwNqvqFAFeIr1DDEHzGP8uvaYOGuxJMcYt0sKJJeV+Ip6RhfgeeJBGX3cbhVxKcawb5UAxL3kFKlGq59i6DDPDeyU32xuYJAX7MWipdx0OQfPE80GjZhSb3Nm9L4QzmMO3cvvpLJ3sgdg1nCxkzbr2hOp6n905UGnRXbapdyAFkbDjMIdsuoZchqttR5lb3d9HKUlBoJIEiD0nop1UQKlkH3vDhaIiLgWUMWVgxwftOkNXjYI4LYZ4A0gsxPyL7H2WbQvsMY9Hdg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FunHQoBJL6IBMsY9RUcXKWIvBDi7phsQ7OtM7BGQzBAUtVO63QdjDA7nnHg7?=
 =?us-ascii?Q?vHTzhBHPLK062PwgVDZ2DzCF24I2+OGdTBgN+aOGpSmh6XUaZdzQcUPQuZBq?=
 =?us-ascii?Q?CJBWpwuqk6gKsAIrTTHkIwLakW1xOeLr91n9s6tltkI/wHEJcNe+J3NrM3yc?=
 =?us-ascii?Q?0nRbF0ejbluIy6CTWAb9Jk9+XfyqS8Nd3YfoT5Y1/MeHevefHFj1X4L9mRC2?=
 =?us-ascii?Q?b6y3UdbjkLf5CRxj7Q4e7UGlTRalB7DSz+qNEvLJtWISLCxjB182m5x4Rlk4?=
 =?us-ascii?Q?WUUivOhNiK4hDNEs64Bs+gvwzk+AyKNXtYQxf5jLjpXr9iKuuAYXS9hi0xsb?=
 =?us-ascii?Q?A/dQeBwwUfe6/6gPT4+CSNsQ1kOVCJX98fWgSp1Znyp9jc0YmX1DuOA59S5F?=
 =?us-ascii?Q?BbwshODMXF9oXSxRpbaELtPm+MgyZiCxiQVsPPuQd5HVyk8P/Z+fsV9nD1Xq?=
 =?us-ascii?Q?uYY+Ij1LBn7Gg2yiPe+5/wbwLvCrKm5U6eByYl4xn9mT7IF3TlcIyKfjGatn?=
 =?us-ascii?Q?C7dksyv2QvTilMWC3EEvsJoroswhfWqjzU6x8DVxH1Rdqbdo8EGuBRV7DnO7?=
 =?us-ascii?Q?uEN47sYaw/Xnhg3Q4niCM4PHVI+M75R75gQyC/HNnTC9xxiflbAYyt5P5iAL?=
 =?us-ascii?Q?hHTm+LHWTyTLEkC9+RLPl7EGXJEj9S5XRy6Ycyflckw4WrMBh0FRdhsN2Q6G?=
 =?us-ascii?Q?X2fhalNgc5FpoZooEYT6wAabB99WBe7/jyGiih2ugzaigbYEl26R2aLUQok/?=
 =?us-ascii?Q?rS2hKLSOk2hN2RvPshW3eOtvl+PJ3GeIW9z6xNF0RXHjLlK6Ax2t05OeDdFm?=
 =?us-ascii?Q?CqVPG1Q92fFFTNVaCgov4mqS81j/6MoHFDBnBSBoa4S1o9OR6MgCYjBTXtwJ?=
 =?us-ascii?Q?dQeFaknzbYFbeenlp8a+jh/7SnAaxRgz33iNxamu5LxfxuwRH9yDKDiEGMEa?=
 =?us-ascii?Q?evlZPZWw8ZTcaBpzupUq1gr7UEITnR1vXEKZSRIIHtmjN9881iYS/M8l+k9B?=
 =?us-ascii?Q?iWK1pMTnhFNGacmXvmz95omkEtvLEl4RQoSQiLVz9jP/Y+4uJKVTxXVs1hTW?=
 =?us-ascii?Q?lk578gMrA1/heKTHZly3+BmJZ2rGQaImBZmmc5mBbMBKBNmcH4PMxslffkdW?=
 =?us-ascii?Q?SIwG9Ero5Vkz9NESY7I8TwfeplHDSPPiDsaE/uqr2b/8/aQuUi8ON69cdZS4?=
 =?us-ascii?Q?NSi3fFKb4pnjsSAhrB3/9d2uOBeD/1ykaj1J3gBGOuUpaPUSU/vJZpjrlKbS?=
 =?us-ascii?Q?I7Cqfl7HZj4hKrx15rrgxm01nmyGU1HI1geu77xVPQAD8nbw/Jgx9euLKThY?=
 =?us-ascii?Q?7Cf55Qxw9dsvCcQMEGHnR8wZ+vXrE9d4nDOoauE2dBMy3lRAL2jxGOtFUnvP?=
 =?us-ascii?Q?2v6uCe0dW0ypvl1hnH9RLBdVOth5+On85HOO2Qjsd0Mfdiz9NUVlpM7l28OE?=
 =?us-ascii?Q?lkpq1qylDBNZB85Ahenp+Y0DLzoi/68ULGqW7eHmHmr5ylFYHOR5Wm271hmr?=
 =?us-ascii?Q?9bjF/td2TKEzXjp5CGnoWufOPRJhh5OA2yqdfVn+NH5VKrB9X/t2jVKl5Ygx?=
 =?us-ascii?Q?1F1dKeC1hMebF7PVs1CvMgkFocdp44pIjFPmBbxeNxhfdj0QiN0thTJ4on9Z?=
 =?us-ascii?Q?MqXQvZFlagUiZvCcuFS/ackdxdzfuNt+3//y9q9SnOURsk8HdL8uV2YVdtOV?=
 =?us-ascii?Q?4zaxS7kPaP9oYiknKZAv0px7GJNhgEJBo2Ex2jk/2NMzkCs0JrRG64kbu+Wf?=
 =?us-ascii?Q?hlBTkiM5mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 d33bbd06-8a2d-4f47-0a84-08da493c6885
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 lVgLWXAbA8FvxpJ8lTxor2NXiy82BqlwpGR5lei+/ljTQxFnkDfXvzlkKbFqfCqTjouU9jPUsTkp4w28GTGB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6327
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: uGysozYFsTIs0Q-O2Vkz1YNyKNsPGK0I
X-Proofpoint-ORIG-GUID: uGysozYFsTIs0Q-O2Vkz1YNyKNsPGK0I
Reporting-Meta:
 AAGV/xBgEY8U4jnG7Ct5344KLVN0JMtnuEc5OFM0Kzdr7qgh3YAVTHZFE/CW/Iea
 lIM0zAdL1PRZbe8tWPhQzZOC5PzoJWhwk5wa5NYlkhlei6MNeOz8Ol6EX5VQXB1U
 Zv81h3tAzFjgi5Gg2jqGC8s5ub7RtVtO0JNq7qVJWM9OwSPSoNkEhprGsN5s4xtr
 qUcy2rW5hKvtCvkyLpy2T5aI78LnIPDRMFXcju6bszs8ODs29BucF6QiPo3VgVRa
 XjFA50N+3bKZS3LW9cC1a9W3Ahiq0Rxqjx22WOnI3O5fPF6qhC+5gOap8Q2uWdSO
 uq9OQuahbX4aMjQCmt0ynLoNBjkeEgddNOleIrBcP4pVwqH/qP4OQhrMpvVrolAp
 kaukXVX8ok/yd8TcFf2mWig2XfuQAV3hCkT0RtSnR6GejyYooMPSHAcYRFx71y1n
 W86NV1dhP1HlDFGqEHzH7yirFi8XGMc51j6mhFhCeOKTiSCsxkryIml/G8U/JCKF
 SCrbCL+vU20IBvGhd4E/TNHnbLwB26j139Vu/kXEgdrA

=== test cases ====

<1> remount on local node for cluster env

mount -t ocfs2 /dev/vdb /mnt
mount -t ocfs2 /dev/vdb /mnt              <=== failure
mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure

<2> remount on local node for nocluster env

mount -t ocfs2 -o nocluster /dev/vdb /mnt
mount -t ocfs2 /dev/vdb /mnt              <=== failure
mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure

<3> remount on another node for cluster env

node2:
mount -t ocfs2 /dev/vdb /mnt

node1:
mount -t ocfs2 /dev/vdb /mnt  <== success
umount
mount -t ocfs2 -o nocluster /dev/vdb /mnt <== failure

<4> remount on another node for nocluster env

node2:
mount -t ocfs2 -o nocluster /dev/vdb /mnt

node1:
mount -t ocfs2 /dev/vdb /mnt              <== failure
mount -t ocfs2 -o nocluster /dev/vdb /mnt <== success, see below comment

<5> simulate after crash status for cluster env

(below all steps did on node1. node2 is unmount status)
mount -t ocfs2 /dev/vdb /mnt
dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.cluster.mnted
umount /mnt
dd if=/root/slotmap.cluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== failure
mount -t ocfs2 /dev/vdb /mnt && umount /mnt <== clean slot 0
mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== success

<6> simulate after crash status for nocluster env

(below all steps did on node1. node2 is unmount status)
mount -t ocfs2 -o nocluster /dev/vdb /mnt
dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.nocluster.mnted
umount /mnt
dd if=/root/slotmap.nocluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
mount -t ocfs2 /dev/vdb /mnt   <== failure
mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt <== clean slot 0
mount -t ocfs2 /dev/vdb /mnt   <== success


-----
For test case <4>, the kernel job is done, but there still left
userspace work todo. 
In my view, mount.ocfs2 needs add double confirm for this scenario.

current style:
```
# mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
Warning: to mount a clustered volume without the cluster stack.
Please make sure you only mount the file system from one node.
Otherwise, the file system may be damaged.
Proceed (y/N): y
```

I plan to change as:
```
# mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
Warning: to mount a clustered volume without the cluster stack.
Please make sure you only mount the file system from one node.
Otherwise, the file system may be damaged.
Proceed (y/N): y
Warning: detect volume already mounted as nocluster mode.
Do you mount this volume on another node?
Please confirm you want to mount this volume on this node.
Proceed (y/N): y
```

Heming Zhao (1):
  ocfs2: fix ocfs2_find_slot repeats alloc same slot issue

 fs/ocfs2/dlmglue.c  |  3 ++
 fs/ocfs2/ocfs2_fs.h |  3 ++
 fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 62 insertions(+), 14 deletions(-)

-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
