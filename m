Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 794A9C05027
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Feb 2023 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4NQ925w9VQIelwEsLzQONh7cZWG9ou5VB4bWDuxIBb0=;
 b=oTiF709uRV8j3fZGkiPydVBY6xKxhHYJ93wPJx1OjUhUPLPsYkfqDG2T3ywf2N4UG8Xh/ednC6PY
   npPOmN97zJyeNSQwgPBiOdudqCfJujheiCzgGSPxwee2J4nidqXgsmngorqsIf1H/qAPVrWizNMF
   VnASQYBE+ZFOFG/E6p9fH5zn/9VAeRlq6biIeR7CiCGgLjl5xVmhEIXlBfBqNjdqLcF/TtfUDewi
   4StDuFp5ldsd3sf75/opX/p33j1m5aAbb49S+Lh+sLofJOFicQQazMGn/QYVjSgU3JFJm6IPWkyC
   CBG7cIV6HpdvrJDTlmzk9N3eRPV+ZZlUy9AgUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4NQ925w9VQIelwEsLzQONh7cZWG9ou5VB4bWDuxIBb0=;
 b=EvXqmG2vDcA66FEWJiudzV0s3lACLu8XL4u3waXSy8/xFChLil3g1Bu/dM53oHkB9nc0ynbYOh6I
   2aFiOhQpzoc/bUS5v7gW4jvX/3RNoD3/MfZNKq0NIptBWO81Dz+G58Ae/9vcUyvxqDWx/Q9HOVcY
   2hvkr8rNjjJ0a+ixICHHiBEoZK/yOv0fsYRERCTKnj/113V5Aa+AZXsD3KPXGLQUJgeamyGqpyDP
   twiLWrp95bfxDl9WynDYXNnLDWfs0ooy4Q3GgqzbrwVkzJOKRmMg2+lpIK4eVKI+Z5fuU01Ox2uC
   howf/SOF4PPI7Jg8sDLaX6FgamvkD1FtJ2KY6Q==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPV009YI010TZ60@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Feb 2023 10:05:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig5AlU1U+h1lqmUITO7vdNsjMndR1LYiJBJyHXGMUKBc8XIEm5slbiqtM2C4qJ5tYfjK05HxV00RO950liW4vie32CKVzCz2UQIbZj60EWTfWmOJh4UbW6HwcuTi1dMpb9Vm7S4hSA9Q4VLtVkm/yiP31lUgygnQXGjYeDpVND79C89s3gVDbvFatmTyjKZHcvULyDTJgLq8wR2UgirTXmuLrwbachLIecaZ+4ZVdDCi0gIQ6izDMLYipoCBuzi1m9dVffgVyCOMcY3HU5UPDoGUPy/271XjrUphlpFkaXX2swd02nL/ivA8XU4Y0YhJiIQWotPOOF9NJglE8iIXBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSxxFt+5Ss+CMSWh8Wh0Vv1qkiOP6aYYoobQLnKsQrY=;
 b=LpYkOylTWn85oIsuJm0OU8RfNU4E3U5erIPUwDtFvUrby0uawPanOpgiENyl/UW4iqUsCm56OVftJupgr3SR+62ExK0O21AUiroCVS/HJ/bzW1xn2l/HRnU//9lRPomXbquG9+KLOOtFAN6cKpnlVLk+q9xE9i1fgVlmhsz5+Y6NJrx2OwWIqvpiFK0FGtX4r9hSZUFOU+SrazTpYy2iS1s6h3KBUeGu1Wh69TtYQy6wAaWXpFRG5MoCSgN1Tun0+KO2zkyN4/xG3NdyC+PN/x/KwqHurZqWp18OvbNSgHyJgIHBuD3pAczhGLY01kme/K3SvbMOiRmFlDUzXOZXcg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSxxFt+5Ss+CMSWh8Wh0Vv1qkiOP6aYYoobQLnKsQrY=;
 b=IERFK86YlS0wciJY/wiERU9fguk+w360L2bJ3IQS/uZ0OBxgPzsDTWuPaIzGMQKHOnl3SKb7mo01kSreY+cCDKO2LwdNAQgA8AXIcb7mZledHJrtvk8cJv+3Blwsqswjhcxn/8KWryyMlIArdeJfxCXQb75wPOw9gRd/6qUr5Hel4RD2hYtnXSJOU72Z+44Zr7FLQpNTeFOWkvUzvNTMT/i6O3983fopcPP8sHPPLjJOup4sHbMToaMMAAjMUTAb5r6Q4tDr0KTCQGexg9btwaHGNohjceymDVZbl8bvWZa7p9nI6GEDslNKxF5Yw/XiPn2HLJTH38dVTYolOS4fZA==
Date: Fri, 10 Feb 2023 18:04:57 +0800
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Message-id: <20230210100457.xv5wchadnd7kkazb@c73>
Content-disposition: inline
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(83380400001)(66476007)(316002)(5660300002)(8936002)(8676002)(41300700001)(4326008)(66556008)(1076003)(66946007)(107886003)(6666004)(6506007)(478600001)(9686003)(6512007)(186003)(26005)(966005)(6486002)(33716001)(86362001)(44832011)(2906002)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 10:05:07.4100 (UTC)
X-Source-IP: 40.107.8.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10616
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=188 suspectscore=0 mlxlogscore=610 spamscore=0 clxscore=213
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302100084
Cc: jack@suse.com
Subject: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
X-ClientProxiedBy: TYCPR01CA0163.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::8) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DU2PR04MB8503:EE_
X-MS-Office365-Filtering-Correlation-Id: 491502ee-e046-457f-a821-08db0b4e4991
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 8gKZ5+g2sZVVPShZWzshJdpRaJhrQmOPV50PZcmTKz08NRLckg5pj6/I38gO/pm0hjR8L5DkhCaPCVAnISr+8ZUZM08fB5ayUN2VM55GEqW7kcYNL+8bEE+K8iocLr6rLu/Y4R0muX9OpahJ01PUxn6IfZ1/NRKYML/hzxEequ6qSLvSEnd4bAPpUWGpCTTxvSJ1QKhF8GImPKq2M8JQoasQyvlfV1AgWpSa0ECUZ4g6TlSI+ePXTlOGSHDCQ6nf8UVDZw5z/70FF9iZstwAdXZ+qVYs/O6QKDcaxWp+HfF18KjUprcNtrcvGjv55FVGFR6fGHk0SnJMdFt00o3KIQcrvjC2XSJ1+gVOU07gbeiT5noIdGlX/n+e17dKbUJ5AOQJRPA0SHFUuv0rrMWIYm7UQjZT2s8n4lh9d6vXWkl5lDJPxbqn+x6oDNLyQ1DFeRHabPJliiXJMR8agwJf3QpU8S1kgM514KxsYbW58qv25LBp7k8pXpvhOW6QBKIYTUeNWu6oDfUyQaReIyTaJK2dsbOxbgGaEawzAtghU9P3oyzYKg40SbgF6xrelmUzBlezmNFCa2sHwYJM/zipMP70SlN07QQVSuopv7uctlDdu9Qxi7k01s3dcP0qot25A2TfPqzOqmmSSSI9Ld1CTYAkKAV31YVYTJTc0On+7X+5fZpHkUpMKlxkPrf4TzTJANTAyzY1Ov3IolxYNCVxMQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?1Jo38jhy/Xnc7i4XdJOqkXnjvgSzb3wi9+Y6biXdd/wSUglxrOHb4Cp+b/uv?=
 =?us-ascii?Q?YeZ8eCYH0w2w5Ecnmv2lsgPJ0/lm2nOMSy0I2lLYIndgf/cBbheqtc0g5ZiC?=
 =?us-ascii?Q?X/hOSVmpW6dXcXjaop1gfyAlDUp59JtVjUVhSKW4F2Wh9EFKXVhMEUjGHvn2?=
 =?us-ascii?Q?YtHMLOuF5J0HG3MD7gNfii0Ts8gVJ5sbo1REBbEKpc/sLiE9+DSn9EummGN1?=
 =?us-ascii?Q?8R4WfvxPGHRPfHnZVHADlu5zZkKBULWVHnzKmySIch9Onou+TQmRXN956cyb?=
 =?us-ascii?Q?vh+nbPyHdWb0Zdd94rpOFV2HbiCUF43Xfm2RUjX4NRhLs8ZDUAgbCzW05VPU?=
 =?us-ascii?Q?zMgMtuJ/t7H60+Teg8C5p1XnGvtjP+V8UnJtKvep5QOhJHG7G+SuhB20khMD?=
 =?us-ascii?Q?2iS9EcvOe4+GE2cO/IhO6Khtjdc8ow4/5dGnVmKs36ZOf6frjxQTUoGFku/4?=
 =?us-ascii?Q?UOMopuFO5WBctimnTZHyFG5OmNG+juWmMcl74ULMf0Os0QPvG88ZyOF7kKeZ?=
 =?us-ascii?Q?uDILmrRGy0jpYJspYBwO+3+fM0m6lMgbWXAqgjYQEQDxXYrcc6DnSKVkLmEe?=
 =?us-ascii?Q?KK0VbFrJFHp124sFxUR9SoEO3LN5VgAYuWWvmpXjZ4e7pS41ZnFdBAZRacJp?=
 =?us-ascii?Q?jUQAYaI1JuxdAbI6s9BaUKhOgk7AowSAUnLRrCVHrig23UOJ/imcMrRRgx5I?=
 =?us-ascii?Q?FXYCz+fEQJMRarxw5Tt8IEi6URkFU6xEeAaB8Dlf9FnpTgmTD+NC3AyWbntB?=
 =?us-ascii?Q?5JDQ2V6z+LVmf0Yz227nriUGL/8RaXQKBkyUI+CjEXwFyxUBMpRVPZVRavZ/?=
 =?us-ascii?Q?F7VWH4at488Bgwv2s8VQq7LhUygNuCsM8T5WtWDeYWwX2IvdTZ+9dC/J/yz8?=
 =?us-ascii?Q?zjWl6kFDvGITlzN1F8jj0IlR2OfccYAQuM81G2qgkiJa1x2PPa1XIjO6BEdo?=
 =?us-ascii?Q?4gCM/n+WSsKI47OEt5Uy0TtCfX6NnRVOmMN04/p25pJ1my6j+9UVQfNKzk+E?=
 =?us-ascii?Q?EjhciZebjxntbOrBcU/LH18+uRfwykTgrKrGatfVD9A60hUfb87yuMjEomYz?=
 =?us-ascii?Q?P2Y7BvurMqAUn95vJEHXf8n23JmzlZ2RBKDu2P77vjP3n0AsBtzUW5NDKslj?=
 =?us-ascii?Q?739llgdAEObyo74ViyLmbSCPtNjYaLcu/eBGC7YsDhCZZaENQdUQmJk5AY5u?=
 =?us-ascii?Q?IZBuXIgaGAf78OpmkCAwcYu6j+l7iSnK+tkumETlabg6F6hBIX22sPBf6v5S?=
 =?us-ascii?Q?QUPB3VqR9uSiK6rAnMNtWVVLP9cs5L0EOU8ZmfhJRsq7s4EvCXDQzfxecKRV?=
 =?us-ascii?Q?Zzc1Hy+LGuqdApZ3/yI5ailMPXn4pXthI2UllPbmClLkbABSSehFZw54AkWy?=
 =?us-ascii?Q?325upPSN+B+N8ojiAI95xQ8lxPkc6u3QfiGeUhLUZz4BYSngsIagrTZaV1va?=
 =?us-ascii?Q?FashXzHsjXY4SeGE0l9D9vzw7WTxY47uaEMwh+ddcQAG08SaMOfHOUQk2ZOn?=
 =?us-ascii?Q?9EpS0/2dBFAG+z/sKv9JAkwwD8b1TiwegKOJyFr/dUOjEIrOeXfawMSr/HNq?=
 =?us-ascii?Q?zdzNY48b684MHF7tfpuY8YmebV+C9fLUQssyvv9xfeUp95BPpfcNE2N1rXEC?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 491502ee-e046-457f-a821-08db0b4e4991
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5+9p8MBfNcrb4Y2Lr8AaGSGkqKaVnwGqpDoOdszAkRZ2Y8JpZaXaY8aJFMRpsH0wd4IeeYzm7M5QEkgssT8gQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8503
X-ServerName: mail-vi1eur04on2051.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4CxAYYDu7Ub6I4YfMOHlKa47ik-hkaoo
X-Proofpoint-ORIG-GUID: 4CxAYYDu7Ub6I4YfMOHlKa47ik-hkaoo
Reporting-Meta:
 AAH0H2W5/I74Vjinm1XRhkhCzAPfgGWSw5u/RCrpLfKo8gLDFQRm2tOLgAfAIF3z
 dSXOcyAlPymldX+CpAWRimz3MiNrE7T0p/fIy9diCA7i7WOsR0/KgChKCCtmyB3r
 +2PRe1ZsRuSx7jrKfarsRbLqocm3KZsARh2seaVnwRuQM45DalkFXbaTQarjTrnX
 /jtmpcmoVvWEMtsep0S/j+seJfNC7mKJa8WgzWFvkUmW1z73B6Y+vi/O/HfbPGJD
 cnXnGDf/CHo6q7GHCLt9YlKeEbdu7X2toVtNWDMke05xBlsR2b3cVvzrDANcZBJF
 sRApy4qTsFx1yVJfjOPGaisA2cXxtlUdT2O0X7nB0thwQXKYvFx8tFp2DVkumMoZ
 Ph1pjvXYNySzl1sEw5iz7OCI+C4c0FpKm8ml3Qja94QR0tlt+8mEQavzKebD162+
 rRSdGF19KxSn4qHLp23VJc4uZ2f4aNHca8iyPwqAb+HIiUbT/kHTD5MSyPY0a3E6
 v5sLyapgcEWqK5LKrjbh04ANsN7ik3ieRVWtetTfx2w=

Hello Joseph,

I am sorry to wake up a long time ago thread.

All mails of this thread (my patch is [1]):
[1] https://oss.oracle.com/pipermail/ocfs2-devel/2022-May/000101.html
[2] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000105.html
[3] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000109.html
[4] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000217.html

I re-checked ocfs2 defragmentation & jbd2 flow recently, I still think my
patch [1] is right. At least, the fixing code is correct, the patch commit
log needs to polish.

This bug has the same root cause of commit 7f27ec978b0e ("ocfs2: call
ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()").
For this bug, jbd2_journal_restart() is called by ocfs2_split_extent() during
defragmenting, and it's not about "not enough credits" issue you ever said in [2].

I explain my thinking again in this mail.

the crash call flow:

ocfs2_defrag_extent //caller call it in while() loop.
 + handle = ocfs2_start_trans(osb, credits)
 + __ocfs2_move_extent
 |  + ocfs2_journal_access_di //[a]
 |  + ocfs2_split_extent      //[b]
 |  |  + if                   //[b.1]
 |  |  |   ocfs2_replace_extent_rec/ocfs2_split_and_insert
 |  |  + else
 |  |     ocfs2_try_to_merge_extent
 |  |
 |  + ocfs2_journal_dirty     //[c]
 |
 + ocfs2_commit_trans(osb, handle) //<== complete this handle

In my viewpoint, ocfs2_split_extent() is journal self-service function. I still
belive the two lines ([a] & [c]) in __ocfs2_move_extent() are totally useless.
In ocfs2_split_extent(), the code from the first code line to "if-else" code
area ([b.1]) doesn't need any journal protection, and we also could see there
are only read operations.

If we worry about data corruption after removing [a] & [c], (e.g: my eyes missed
some journal operations from [a] to [b.1]), we could only delete [c]. So the
fixed code seems (only remove line [c]):

ocfs2_defrag_extent
 + handle = ocfs2_start_trans(osb, credits)
 + __ocfs2_move_extent
 |  + ocfs2_journal_access_di //[a]  <-- keep it, but remove pair dirty action
 |  + ocfs2_split_extent      //[b]
 |     + if                   //[b.1]
 |     |   ocfs2_replace_extent_rec/ocfs2_split_and_insert
 |     + else
 |        ocfs2_try_to_merge_extent
 |
 + ocfs2_commit_trans(osb, handle)

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
