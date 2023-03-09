Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486DBC77B74
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vWcwwyvAGun45lMY0osv7gfxrWcEjS4Ks0X7h2xC4Jg=;
 b=pbc/FLA0pl+qwHpgg78GJUbnzNcwyM8g4cADQiqNa04CEiwU0sudxQ97dJasALduAdpf91dvLtfN
   E0B4QZ2TF/9DbQtFOpJyebkereqrgLL6ETPEEJ/xmbIqJjC+psy2iHWnxR2vwgq8Dl0c9gb0mdAh
   zKy6GNf/azz1gV3D2bU4IWn0B4gKEf5/Zfil+6RdwftFsJOHnEiNvDpOeXOCPNOaItQAyA7K+pD6
   RKxpNxkWa9IutHLUelaBcCrZDv6nB7g5hMwMIYvJOlayvQ5F3RETRYBdidYEKb2UBAnY37IaY63f
   IYBHCvm4JSAYb5IjT+wj8bQk/zjkUBYI8DNBQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vWcwwyvAGun45lMY0osv7gfxrWcEjS4Ks0X7h2xC4Jg=;
 b=mTXVwmFpYa7GzoZoLkKJm+2t3gO1quktHfK29uFebND+nyjvvXS0+bHN/PjxmCmihKngErGzdzp9
   AZFesHfyfeBx1igHy+fYpCocBhGWV5fpKqg5wjuksqW9ZWuI6czq5CwFKJ8aU8K3fXW3JgUfUCuk
   X8CNQ8cUK/NkAov1fOCSskfbk9yFqJ7KFiCiQ5OcLnVUN9Z0YH/wKVs55OCvPFB5cXE7DkB/+KtR
   OWgksvAMWmULgRfty4Nvrjq0aaKKcnzY8wEsugmWiJ9MerbRimsctjoCoCwThla2Pj1QCppYnHuL
   9TVG2YlCPq8tky3iCCunGFsiGSjaKWNYM7AYUA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00G54M178MB0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBAJWSn5iYdhpB+5xdqRyRLOd9k9qit8bZNsJiO34oQzQKdqH6Sr/AK34teHp29ItFqfxQpz632Kas3bQ0Z+oypeGanG5TUJYjxHCKrUqMbPTMFqPhgrOGlrB0g1946RYaDCOAn1pWav7/hOLP28XpEBoOBwmxH7AHKilIQj8XuiP+QrYOhwYczO4UkP8dELyA2FwC+PZXZAIHdIsMHfiUc44yUePcmvPdmBvmHL7cv7VCVWKNVob3FyHGqF4N98fwLDO4mywbYu/D+ymiNLNu5TZVwE8/qFT1OjUFteNKnYpHLhyEHzKhRVV7wmoS+tZKXJf588Irtiy8tnnoeauw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EN5Y7OXDT4V2bpXioGREHUJ3PuMN8TbPuqNvpGP3jcc=;
 b=XPIwo5mwdrs4NQ6yL9qYHMXUnuP8ONYTt96v62AP1lJUkaZfmQ+zObVYlskFxWc50iSLLMQh7qoT2ZfIFvGwdojaREdXVB4JL3GNO0Tu07+gSF4mT+/SUcPGlk37o1uh1nuFkphO0tmVohaeuzIQDI0oTmaJuvyBPMrJrYJZVUWmBDDZEGChmNFnE9BguhP48lj2IrCKYEpZVaCgpBpvF0R8Ze+upryUND7hXlJkLv6sNUKQeDBgi+BkoLsPUOuC9U+8ZYQchgT+s16x9w9m8AgYtOExobvPAYEpJiQae5E2c10aOhNcPoU06uSB3svs6vbFy+Dwi2RPaIsGq0mcoQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EN5Y7OXDT4V2bpXioGREHUJ3PuMN8TbPuqNvpGP3jcc=;
 b=WLWfPvQU2bhObgm6GxjC+aS9Q596I2BOM2k9fq6Uv86oCb3vOWSmp7XDdyV6fWh5v2LFcEkw3ji4sdyirJA1LbYeruxuYvPZSLR9TL3SNKOmzMkI+tlVO5UtraaJzIvkNi4jzzuRRa5Dq44JGll2I6f2oj8lKC/qU7ODpnI9WI8KZBI/wUVQMG2fleksKeuXo8hu5WgSETOgEi+NJjYTVKWJEfyLVWJnG1xIMoYks6ae1zcc+rCVnsqqjRLzN/Xs83TPsjJkrCwaVtTXbdO+IPb1fNXEyIqe4mDvqTtYaWx/o+1E7RMlEFVrV+c3HxWvt7mPSVTzwV4e53q7ouDgPg==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 23:21:24 +0800
Message-id: <20230309152127.41427-3-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309152127.41427-1-frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(36756003)(921005)(86362001)(38350700002)(38100700002)(1076003)(6506007)(26005)(107886003)(6512007)(83380400001)(6666004)(186003)(2616005)(8936002)(5660300002)(6486002)(478600001)(7416002)(52116002)(41300700001)(4744005)(66946007)(2906002)(66556008)(8676002)(4326008)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:22:13.1549 (UTC)
X-Source-IP: 40.107.255.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=148 malwarescore=0
 mlxlogscore=821 adultscore=0 clxscore=104 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090121 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v3 3/6] gfs2: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30) To
 SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9c6312-19bb-4ca1-342f-08db20b20ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9zw4iYeFkgTHMTIZeNkJQD6Ts/vtKZyF060qehqrCBZt1Gok3wu/rHoVurBt9d3xFwtq6mygGzq0NZN8BemSVoOgfcujo+OY07p+6TXy0W+DdnrM6Vnym2YcXhYv51U2/9IXugNs/hZCV7piJbF02H6POkCBsVokTW4Js473fKVpNlZH5hhLIDPZ7wAHoNWRGrg95yTu61qbzMlKA6JPXzpOP/zp136bq4M/LpUhMqDMUauavqgS+rmAVxGSUUmr77X3q0JvSOsbUU0Luba74tDMa+O115DjgP2QRXo+2mrQP8Jqq5LDJ6unI/ZIfnOO+QeI2uxIm6uob9icCqtn6A1J1cXsZyzFvHTkowEne1JPTCTUpWx3iJ7duBkS2Tr7bUl0z87E8+khMM7O+vZdVUulh1W2zLoBi7m47ZH4sUBOiVGiR2+2z6AO4afxqhJtbsNht6Td/WtKUjhJZAnP0UAWvzvTxGnXEjZcyVJy4PdW5zPmJzx9Yv3icjm4Rooo9vUVfBceHMR/Y7Gks2NBlsGeNLZhkqJfUIa7e9ihw35/3mtPZgyHideRhddlxEqqG2vhemQFMoDhdJwjvfLAZgun1yFyhoEE8r01CKoFlxoTWkYZEDzm6sfy3ZYXTXaR3TU3sZSYkfmjnnf80QMN4wWTIz37hF9pq/FVjScK6qTOnqGeFH/O3w9EKVIno4hDpIITGKinL/M1G8CGPe4XtuvAF/qmJP6i7WHMCso83BI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FdlOoEXvsQSiXX57b9tinHs6OggfuNN8FYqn7UcnWWb9ANcQEYafcJ6eeYtI?=
 =?us-ascii?Q?uihc0DCNa4zgy+cs6MvaY4UjfNE+gADkXhHYoy7z/QK6WyGwLJqWOE3E0Mlf?=
 =?us-ascii?Q?d/BKNy7+Y5FRanoktcqLoXnvz1o0Lne+bP8q0NIAXv0tV+2faEwW4vLXbw+n?=
 =?us-ascii?Q?cfNFClaDIz3NV/YQpobmnRN6YG7RO9GMhGyfMmgHmdtoXqvHRTr4U3D8CXm/?=
 =?us-ascii?Q?jK2CsZcfuW2iQhYosPjhb/oYCU62l2lcSeprzHFHeoP7IEzto6XoFXNNNQrh?=
 =?us-ascii?Q?zXXLsUTmZZkLEExEgHjHmVU/mLNa6RmUkVLmUUgAuoQEHILaJm0sQHZot6kT?=
 =?us-ascii?Q?FwQDubqJLx8rJNR4xKePsQRMgWsbIOzUrBCPYlVO7ROJBeSfiHiSX/MIfCfx?=
 =?us-ascii?Q?UVCdwhtzIWHPE3rG8cabQUhJ/zK/U9jdUybEtAMpWk3L0hFfxX7V3z5Ip0uy?=
 =?us-ascii?Q?6RBNYZ0+/C9Be2dr4S8OXjxxrq5Xz644wgFGrfOUd0nEaf4NuTCOe8KdIUUO?=
 =?us-ascii?Q?fm+932ZZxT8SFbO0rMYZxKoRtep7vIB7NBLKThzDRIloWb8Ax6FFmceEf8Bt?=
 =?us-ascii?Q?+EMopz+/6gkMCVgQ4OKFqC5OFjba9KMAUY5OgIJuLrRY+BwH7/OPV0QI/k6A?=
 =?us-ascii?Q?M8aN1Zdej5FEoSCuuzo05Tb8J6vUUyBIhvDCLJ0WS/ykZzSblE8rYUdvsBfS?=
 =?us-ascii?Q?Qdm5LXTd9Ce4dP7TRf7W9zNMAQAYc78xwr7a8ITFEZSvHbcua1x2fvXZejUN?=
 =?us-ascii?Q?EVgNYSwfGNMBcJ9MDsJ9SUWKrgJx6lB+Jw6muJMmFWZWksNgd38F4uVWdsZA?=
 =?us-ascii?Q?lOgksyHRiGwNjQy5fwxJpI45oFqpA5wwrNGobYcO6m4Rif6o4n4VwWoXbi93?=
 =?us-ascii?Q?Nd5cO1HOjb4bP318SuM00PVObrK3Gon2nbw5umMy3NSfvtXgVU2SZnuBNebV?=
 =?us-ascii?Q?Zfk4oVJS2cYCVPP8wL/MTlBJROunMtShYqAUpcjam+D3X7gtVJOHI5OpsSma?=
 =?us-ascii?Q?sXt+yGWdkqVCoCE9GvyiUWILJESOCgbrErRvTTn50ri5M9pTawGKJ+QoeyaV?=
 =?us-ascii?Q?dFQ8VGy+H+OJr64A2CuBdG+VmqfsX21XUdXByzSWQRU7HWYUg9T0lOZF8mOh?=
 =?us-ascii?Q?TNM0aZQKS5aMCL3nnVcaocxBRoNTuQglgC/yqp+LDzVQHqWUTr0XysE0AbPc?=
 =?us-ascii?Q?u8z7Ym32Bq4FvMqHgADf4bW/58Vg+51HVd5C/er3wEtzfs/Tui9xghtAT06G?=
 =?us-ascii?Q?mTp7ovMGqOhh53lhm/hq80AxBkcbe4UkovLmsNCi8g9JR29vi9he1cu3Cx42?=
 =?us-ascii?Q?TZBqrnNLBabxl21uxaxhmHiVyiGaAkD8lGwZi5/r5n+4HvtTieX+jQeBHNcy?=
 =?us-ascii?Q?SZuap9NNtG7pqgzGUmXvFSD895rwmJJcGVxVAoyXIKwKWugUUsRQdE4MaZTo?=
 =?us-ascii?Q?fEnPr06YthGoexPatzVeo4o8V5yxPvtjqaF2vHqe4bjbYfzH38nTFjG6mSu5?=
 =?us-ascii?Q?HF5nWEXFVNHt1wzyzufr4cIbQ0HjMgvIv4iPCcL2VJp5IxZJmET3KuHwCwxl?=
 =?us-ascii?Q?oliUT3wMXoaRsj1xo/8j4i/sN/+iJrDzoX011Odm?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8a9c6312-19bb-4ca1-342f-08db20b20ee5
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 wGe9vUdPVyn6A7qlLYid3EacqnHwDSvXb5oWXoeWdaBo/XkJYg4ytVLp5Zq8VCxfh7SMnYzeeqxVDXMo06KMRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
X-ServerName: mail-psaapc01on2118.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: __9VAVQL-ad8sP3snQgJSoVm0Uwwxudf
X-Proofpoint-ORIG-GUID: __9VAVQL-ad8sP3snQgJSoVm0Uwwxudf
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAG3wcyqsF4lCeJdoz6b3Xr4ab9afnh5FvFBqIm2FcJJnNLCLkswR9vlVcHpf6aO
 Ma1mv5KA7PLzLx01gCOjaVIPsHdkUMzNlAGGqOJdEXvZTlAod0wuLR4IFxwNPgZ1
 9VkCfjTgsjA5sX9PXNGUIGRq8eeZy8AmxzlGngA3qVmYbOs9kYQnLGGBObsEu5CQ
 s5fIhTMQxbIZmVFsQ5qrefdStX/jA0mwsmssf/IiJXrkTm+2YowWADSz93rexrON
 8ByU9iaeRmA9L4XeIAIPO0zxwqLzm31sW7hAqSjzOcX9s4ZnYya9+itn/8/cyzjl
 4rhJK32VJyIb4bf82CsASS3YUfvpC01cGfnCLX5fUYydoT78EoVasOWi4PgHF103
 R/mAEtdaoTAUaIjaK1oZVyAaE0X7QHegyrG64vNA8P/9dwWfRw/lNC2eJV6lIBPY
 JdIWfOkdGWUhYGHzWbVQyOEhBawO6ZINjwf3cyuZhGJaNaSNjlu4LQZt57cXFj8H
 L0zw53nkNi2AZ5IZvBbxkxaLW0rH5JEw0b9Tl0AzADrd

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v3:
-none
v2:
-convert to i_blockmask()
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index eedf6926c652..1c6874b3851a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -960,7 +960,7 @@ static struct folio *
 gfs2_iomap_get_folio(struct iomap_iter *iter, loff_t pos, unsigned len)
 {
 	struct inode *inode = iter->inode;
-	unsigned int blockmask = i_blocksize(inode) - 1;
+	unsigned int blockmask = i_blockmask(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned int blocks;
 	struct folio *folio;
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
