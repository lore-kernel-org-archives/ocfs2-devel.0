Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A6FC7EE26
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1tDHnY1n31SyIuwbQ6En/jRMvDlygwb7ek+JiwctxKE=;
 b=AYiLa9IG1Y/ig/H+5LNROfEuk7iQgWNBqIgf7A0qh0m+njY34mHCYwgkexhPS9Z7Usk8YwmD1pwc
   fHSMl/nYo1JHLKHccaA5TdVUjZfQZK+O5cbHk9dRPhq3x+xRjxU98CrtYsHxLBXe5Y0tlaRoRdyB
   wMJPRIVlMXZ0IYFSA+/yVAQvgq/6a+EqNbKzfxHbbebKt5yk59ysjVWld0aK6uoPvpH1Tv3EoSPD
   qimoL4VjCtbmBVmff4vT2GxXAUbJpv3k3Zt5UFB1ZnEoHX9b1zxdhoVwmQLJQ7nQW9eR+HcM5rbA
   W2VmEKtNo9VjTTTzj69E8+c8/5t8ZsKNZtQmew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1tDHnY1n31SyIuwbQ6En/jRMvDlygwb7ek+JiwctxKE=;
 b=WFgV+kDRF16ll2Sin8gNmhcG+k65uzvhze8AWtRNn2ZSGpix2svGZN9a5uUXGyKPq38y+8ssDkXA
   bfYKVwR8kzevC4/SHQSpc1UP4UKxf97yCuJ6AApcP0BqiBJGKS3+j6s+oNo2CGuQP6p7rhey+jvT
   wAJXM1lEIcxHVANeo9M5vqLuw7ABMkQPcIk/ASqln0FB+czIECjF+/WhaFX88lOFZkRerlt7y+8R
   Ay+25rC8XWU+liM1DZ7w5Jgx5s3DzXVv5vBJY0zRyYFaDTj5StWM4CyT0+X9mMscC8tHyYwpc+xy
   G7lqDwMWZLdwDk6hgdiEh9tQ49uixC6CYA7oOQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00ESGM1AIG90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWbsmDz3Q2K6OARrdihhP2RXNeHBtlqd0FyhX8t0Ftfxsfz690J7WssQIhXEafh38/G6PBwqTMDCAZgbF5oLViI9TyPMNc1o1EhzJgpPw6APONSvcCeD0J/tarxnNg3lh9Uz4429NejRK96xTehgNHxW+e3Tj66WfK50a/X57teBI/omiqvUt0L889RD+xKXor26OrVCl6J0XI/JAn8riuUT10tqz8lW4JL1vnpyi94njttvOdyBEAdrBT1WfXnZ6F7jb+dQ6NwugTCyJO+QWAVRPrjDyupuF9Mn1xYnLRR9AHpBefcljeq3+2w7wbRCmUxtxmV+vxV71ewU/P3/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzjxnsJbJDnjGik/CxYLa2sqgyThkXSxTjJWJGKdsro=;
 b=SYpubDVv+6QdDc6XT0SqYSP+2skv9qGiIrvqUY4pPJs3T2lI7i9A7EXA3fICict/jBKB5+Y2FUd7pmjKasaSpJTSgXNUofaA0GswUGycTxmq1g5+jT4OQFtqY4Ih7RSkzYwLqQWlaIGPBTPmYU62b/zjejpq1wsSvsw0Lqyb4bfnobSGaijHplSLzn/NHci5jTl8sOpzjR0Tq7Tkn66tOfnqdtxJwzT1rRqE23fUQ6Cz3VHXFPT+jzDI+3jMRq0l1D6BRL6JvAjSVaaIJ/fBWFpLkI/x/j+YnvEJKx4EC059BzhYTmNgw3sVyJIaW2ctWJMBqGNey4Z+d3CmCVHG1Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzjxnsJbJDnjGik/CxYLa2sqgyThkXSxTjJWJGKdsro=;
 b=NVgS6ISxsXSX+v87J+SfF9KPotarq2icOckIsyABALk7Wy8+QewHEoZtAAoqvpHH3+s68XkUl7LOHbtNueev0cHNtfneMNVJJB4BA90Iib1r716fwuK4Nb8IQMH85ALYcDyzkv0pVMKK59CA4W+r6zobl0YEg+57SzYCduvfsCiYcVRzN8uXNRhcxy8twqxdusEqi/PYLI8Ps8XQyBooOZHH0r61sFkmNAF+pRGVCofq0Q94fFc3YdCsRVscl+aZmlIdj+n5Ixpy+ofPJ8711kU5Iadhl1vNF2yUjZZt9ye33hfqMCl0YwBNAZ3g8EGDrCNtANPABpuSYvV/sfv4Dw==
To: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org,
 konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org,
 damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
Date: Mon, 20 Mar 2023 15:11:40 +0800
Message-id: <20230320071140.44748-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
References: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199018)(921005)(2616005)(186003)(38350700002)(38100700002)(2906002)(26005)(6506007)(1076003)(6512007)(6666004)(5660300002)(7406005)(7416002)(8936002)(36756003)(66946007)(41300700001)(6486002)(86362001)(52116002)(66476007)(8676002)(66556008)(4326008)(558084003)(478600001)(316002); DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 07:11:53.0714 (UTC)
X-Source-IP: 40.107.117.104
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=95
 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=105 adultscore=0 phishscore=0 mlxlogscore=453 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200062 domainage_hfrom=9113
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2,
	RESEND 01/10] kobject: introduce kobject_del_and_put()
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
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|TY0PR06MB5404:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f02840-b284-4bc3-6d9d-08db29126199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 muTGT43VaeByLyLoRi9XhUb95SqH3+kLWxBVtPkJutQTCu+mkxnxvPwmOqwWlwk6+1X/S4GtfvZKc6YTilz/CGe8wkqp76Zect5yfo+VmEw/hUQ7mbZdWFtUmF3eFYD6zNR4DyiKMyhQ5wN4CiaQhtQoEcMK+dsEBYKaIOEsJtHSQzx0o21fTV/rNxZuCuRxr7MgYGH38LqclXy31VjU0PIYeUPD+bfPhpAvIT7mUjTuYhUPZnzcICKlOutlFoOo09yumhEULB+5Gd+IQ1mB7SESlZnZqw30BZ4NvLaBqi4z5kNKCscRkvtNE4PuzbSAbFghtzunHVTAjx4OuuHyt+coAieP9/7luf0kXq/nQCdl977y+S1IFsT4y2Ab7Rho2hI5DSFw3XsAJb9Vg31TC7fcROrMEIPgyDaBdLdsF4BJcGrQCYgb2+IZTFVslQOc0X6hiMZur1mo0PyOFA3t3gnBaV8URIR645vgB1j7xGuZk8W514QMe3r5dlC9h9X9vdssphRMa5xIUU1WHi4JVdpnrfRE2SZRFkS8LiUVWnAI+YtTS3mIXVvoFgjDKb1+5QZYrw/qQ8mxmE9u0gTmN8ofs9cOQTPRZ2yb9t64ZbU/NKHJKU0VfuKAoxes+Upp0tcXHQlCH5DfxJt2ZXqrUurqj2uDs58vbD5WXbRssx8JX7nMNmfD05HR0lg/+GPc5b1jXHBwm5+K9IMfdV6Ljhv/qBk5s/GIXGo/BU+BtT0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?B7n0Da0DhxzRtFoYUJL/KqTvnb5Kl12fMVAwapWeNNKrE/fiE1K5hCTezkcl?=
 =?us-ascii?Q?JX24k8pHJnk/UyBFocGSLkTpQjt0Rt13zqmWTKchDaNBMZ3JPm3BSS+GqCx6?=
 =?us-ascii?Q?bKFmo9gNmfRQ2Qcskja05hLxD9EmNSyYuyO7QO3WHz/+SrRULS8mSEDMGvpH?=
 =?us-ascii?Q?n0SaM03XB/+p6x6u822GSmUgCu2f90jIZGbMiC9mgo3fATiirLJKsI4RjToP?=
 =?us-ascii?Q?YEOw25AeQlMwZIkX3d4cqcP+erFelQWQHSW+dujWaoYXD4WSwTyCLBcihX9L?=
 =?us-ascii?Q?o/4tqu9jppaNodlscJXfRxYtniTFhGL2oCWOIYo3t/aYRyZ+QuoUMiVPZclC?=
 =?us-ascii?Q?oxGbPRdruI8zh62PR4UwLPGyZnF4BQ/GmPBOmqOxx4Cnq0VtLn5QSKNwROaZ?=
 =?us-ascii?Q?ltxV9NOUrCB1i0lc2qymhaUPkLnzBzpiFJyqcr+cA+WxxRocV3fUzJ2Cumra?=
 =?us-ascii?Q?TGkDUKXG9Nwpdoge9dlhhJC3I6IVaVjh0OnXa0Rf8iYLY9XI9dQ8tcLl0OES?=
 =?us-ascii?Q?qRWL8tKY3tqsrfAAqAYPuL5Dq2ssrV7ST8IdyoPKAdBuu+594Ho19G1R+nE8?=
 =?us-ascii?Q?SvObTMOUVDHJokkeuC6ljZvZ5G1P3R7N0KYNTNhoCuYt7WOH4nzk0JruTboT?=
 =?us-ascii?Q?99JSBgwFohch0eDiEnOYptLBTglB9yuDLI9rxGWj80/y5bz3kdxlteYyNkAl?=
 =?us-ascii?Q?MNGnYvlMU2znIe7MrjAnohPT5Mrd17ZjiOPFo7xIXOD1iTN2CBfy3SprW0DG?=
 =?us-ascii?Q?UMTqGGRV2+Gaq2TinYv0Vf4WXfOOpXetDQoHhtJDFVnSEgdG3QzK61xkX2hJ?=
 =?us-ascii?Q?m2J/u3hxsJ/5wF4Lknf7MxtRPWsH+8i+NaE+cnC0zljBSufI+c09qNOU1UlU?=
 =?us-ascii?Q?C9VK8O1clRjzKeH618hpMu8ePTi3RE4rLToCKdnsbJzEzq/yQPhPOMDrz7PF?=
 =?us-ascii?Q?a/g8VddAAPYDmf1GXl1s8feW/al3LGWukRV3GkPOHJzgxGNkF9my9lTemMUO?=
 =?us-ascii?Q?AHij04vSkBqzyat1tERgX+k+KuMNOnRQeovPSf9gnwu6+c3ostCgPvM10NY4?=
 =?us-ascii?Q?K+iVZaiB16uCSUTngTYg3kWP/llKcdO7geoS8A78a9xK+0oZ3fKkCketqtzu?=
 =?us-ascii?Q?PgkUomOwQi4lUlPPAP/R/6Lc9MndjZfBW3Mp6tYmO7YfGlBCWRk9nxztdeIl?=
 =?us-ascii?Q?T6FLgPtTgXjWEjXdK0VdkWsmnTB3eGtPNFV5FJbRJCYfCYgxXw2A5d0idHiF?=
 =?us-ascii?Q?mbp0DvuOKHFcO21PmaE233e+D6Dms/6gt+jIHi+d0UB8XAw7ekbSCG7v3730?=
 =?us-ascii?Q?O/N39KvHhFeXb7ucuV9sYBCQ5c1JnrMU4eG4xyf0zSxbVHKbMvgd49Z91PeO?=
 =?us-ascii?Q?/dA0cJBvo4utUXmPES8kwFJWTert0qkqjMDamMos/XsXcW1slBLgojaMXyN2?=
 =?us-ascii?Q?MDS2xAwE+Yd0Si8/2Rb2fI5nYBxmKNLcTCYB4raQNTXgbSoGFrTDGMiRQi8E?=
 =?us-ascii?Q?Ng4XzZWTiEyWJYDVdE8e7OZ/AYTGntu6+zQpN1OtOwOEu8TIfklbYAqY3ZGN?=
 =?us-ascii?Q?h2ngCvK9l049u3DIAw4tk66KAJeSlOpStjP7sx7I?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e5f02840-b284-4bc3-6d9d-08db29126199
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 VGrfEB+l2SQXH2mcjspX3Dbqw/v/TG9H0vVdwARvjipXXCI6KYTfJ6RZA4qYyXPJjbfGoePhxW77KortzoGmdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5404
X-ServerName: mail-tyzapc01on2104.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 0DrIWfPLbbucVPIB6aBL4X22TMhx8lvd
X-Proofpoint-GUID: 0DrIWfPLbbucVPIB6aBL4X22TMhx8lvd
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAHnER556FMccXiDib5TaEK7ssQ2jUZR/k+RxB362UPKTCReNwhyCIzm1qCmqejz
 dQJUhM6+0LqemDhgqddaO8KxyZ5ideBS8w4QhxD8rqu/SnmK+u3nZ9s7NZCFEAiE
 Lsjv2ZD6lgWcpifJ3y9f+U72Xiy5lslROOWBjgYrkP3upERZFvIXtgUsVRDExhOy
 mG11gAnnAOcoEzpEW/Pi5I1fa7QSFHdMV1oGa3DdXOcwpxYXVDF3S2TBJ1X5dTL3
 wD1b8s7sphA2epu7C3WwPneh1GeFmalgLcAeFEo3mOYB3OSeF5UEFar6sKAtkvbn
 FUvjCyMj5h8c4Ea+K/+z5WhXgEwuadb6L6mY+KTxRRjRvBzzOV+VoDbJuoJ/V4FS
 4BlfNIcBqxrv5GX2YL2ubg4BYdL7pU8H+/tqzZVljAJEaqqibzv0rywGLKfzNnH+
 0HPHKOcgVD1im53agmHgaw+sQmzPbrWOPAdP4fbw7qD9aZLkM6GejKN2BColc3iM
 /F32DaH3H0ghAZVlF24d4rkaCW1IYjosgEPSwz1HE5aUSw==

Hi filesystem maintainers,

> Hard to comment on patches with this. It is only 10 patches. So send everything please.

If you are interested in the entire patchset besides Damien,
please let me know. I'll resend the email later to cc more people.

Thx,
Yangtao

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
