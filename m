Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643A1C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Aug 2022 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PDs12ZfgaIoNTAcXt9evxQy9S8uc0lmgHsyWjUidcuw=;
 b=oscPwQmqXMQxJWN5pz0t5jNHMv0BY3MnKKlV+jSU63/u7xRc6vyfp+Yf4CzSjHNuUf7fUFbiUa3l
   YnxOCLjSHEutnnJ5wM6txh2ei17G2Orq+MB10jJyFVmmnZRAERaAKEvQYPFg+v9xiC80NpN5fiqL
   q/DTLAW706evAdywCN3NqleuSqaU3I/nN3uWtO3VrTB4qzoFTguCGIPd97LPSegkAc4j4Om0W8fI
   Vn2hLUMMpIRiq3hemsY0pZC34fo9ElidlModHuAVq43SeZrgxQGag+HGHasDhFSi4qMYmFsIrDTn
   lgaMdxb5gYYMAMB3QmpRwT8UeR0P0F3w9DlyPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PDs12ZfgaIoNTAcXt9evxQy9S8uc0lmgHsyWjUidcuw=;
 b=Lf7EP8IYURmfsvRKdOusX0ij3TnPUL+YY5GNvChN8bZzaD+CdMJnMVAyQ6AOQYHiDWG4Rqq1Gk8h
   /T66Qa6pxknKEL42t0c8q5QS9b17AkGfE4QxcdJe357+dedgYwZSGp/SkZyeBi5IqVMX2v7o67wM
   7eh5uYI9G39Xjr68OS3iUzq0MUt/ztI5R2mUiqyzrlMv8g4y4C5sH3nmiFHZmmY5LdokvsBDd3F0
   HO2MoSspeeAJzH2qcEjBPMTgn9hQI7weoevq61Dk8/RoSMCA7ORzMH2b8IImljBJ0tyJyBDAVBV+
   6Ctx6bdPhumoUYVfN++mJv6GKqwLxXx7XYguOg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFW00016W7ULG30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 Aug 2022 01:02:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl/lOiiri5wvguwQqQ8ZynK60bhQk2BVZdlVaQUoX5Lu2qRh9fApPMjM4TmGplYkRbscexjhw0DXN66JaP70IrzecwLhjoJoixbCeMCTbuOLgs/riAvKzN0qqoSQPyqSltzC1d2BtZ+AYQUN7RbLtdWaS4AH6GBcX/PAK9fXlxEb2r/JiV6XnDvBM8MS4DO6wizKIxOegP4UAFH5hwSl0Ak1t1qk4ttfSiEChAPxDpJalRR7yEXY+I5YLZVPGqXlny436oczK/BHI4BL7Ge/baC8k2szvgDFQufYbkPk2cmMmDaNSZm3fw+QnM++LUQqD2FGGzSRpC8MFlTumin4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu85zUXU461HsdAPG/E/rJI/NCMNKQuExJoGqpaLpbE=;
 b=jqCdqzQLiVOnoY65+BwSF9lwygrtk8WKdS6m2yZqh0XLcHC70cGPXweuQqwSUrU8A3KETB1DXDYwY5IZwU1d8+CYjrNhb9jP7d/4SqOaVYNyN1Csbeem9PEhiBeF7VJPukxbbAwVo7DU85PMhHz/a3CpzazGGMT90slR8mo+5bICWOXnmfydq478pVebW+Iur9Wmt6zt1J9eIPTMubmssobxnpVUR6afgdI66bnVZyGzZVf3Kc3kfM1xETYEeI6fDG/XhGWQuvyGUnvRpsgy+WU7aowiGwN89Ioe1BC4x258Odhv51oB1LSAJBKJdTlpF5hqVjp2GVKjdgGCjLWyeA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu85zUXU461HsdAPG/E/rJI/NCMNKQuExJoGqpaLpbE=;
 b=emaVtXzxGSWXg8KU1koLmMokMC/Mt/LlvqXvmuwd2oQfbyoHV3vRjp7dqpbLIT+Z7gmV8lrPLtn3Bvm+0V1f96UAMH37/LMzu3x01fip8YzF5QpSuUdo5kf+LIX2Cxug8RvFNTzgHU2y7bxTz6O7INQAVGV7+QIdr1xj0ej0O8BvNWS4i43GV7DFchn4z+XvFUAFmqo2xzgqkTjIZ3gW3oeWFekBkHj8oRe8FUYB5Naj/EUAlxOwDOhYNEmbxciudkR6CuxBUx1VlvhUrTyQ5FUQMhYjcEXJ6vfv1kzTShHD16Q2mSzo2yDHA4OK17MO3NMKfGWV+rTRiWhUXTOVUA==
Message-id: <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
Date: Mon, 1 Aug 2022 09:01:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Mark Fasheh <mark@fasheh.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
In-reply-to:
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(39850400004)(366004)(396003)(136003)(376002)(346002)(83380400001)(6512007)(26005)(6506007)(53546011)(2616005)(186003)(38100700002)(6666004)(8936002)(5660300002)(4326008)(66556008)(66476007)(8676002)(41300700001)(2906002)(6486002)(66946007)(478600001)(86362001)(316002)(6916009)(31686004)(31696002)(36756003)(43740500002)(45980500001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 01:02:00.2390 (UTC)
X-Source-IP: 40.107.22.41
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10425
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=70 impostorscore=0 mlxscore=0 clxscore=212 bulkscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010004
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33)
 To AM6PR04MB4662.eurprd04.prod.outlook.com (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9925fdbf-d940-47b8-c4a7-08da7359704a
X-MS-TrafficTypeDiagnostic: AM0PR04MB5377:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 sQM6BSewcFh2whEUwKA10RBcXQomYc6NbmK3eJsehPbxoCz8Zao6dLAfkoo2u2daMBeUPoCwhNmsC+EQmTytLvNDuPf/Xb5LGx0qiT83lVb9vzoMpbO2gFH8A60ET64xpMc0GuUgireSofxoHW+R9tXfk9lscaX/ezd5yUrAdObmRiQ47UEe6CV7b4NS1Lxk5vuuAOINPrKf29qpC4zyyQT33sE6SM8JcC96YRpDcf6q4OrX/cp1grZD4Fc3Ys3setVqIO+hqy8eY54sgstjehSZK/ssMC0doj+ohxT6GvLGezgMVTpAXPJaM6lFCXqNi0PTV0DIyY0d/JwE6QDlXlQhAdfgHzS9m2/DV6LUasDWA7/wOuVC6dPJ15F5ejf3wzXCcEdPvy9AJSeN2PiXXe495J1W0kRQFvBGA91mntiDNOWZBMR9BF6jFZEykNwxzwqEHqxKO7L8qWgeRCEukJBC8zOUN4qrRiZxe1+DJB5In8UJ+2KK4reHBgmjEDCapd01QENGByuT571Zdq+MClHbvgTyH7yJOB6jflPvyEbOUKy9BN6hixvIdomih1U2Pk+gpnF2zspBAHctqPdxiIs6DJpW9IKBczOwaRd8q1qFxX9ab+t2ynnEgfd/6U6yPSHd1v3jUT2BjTW+gTNQP+S23NQWQlULPeX0VYVnhzUZG8o14KnpnQGhbEd/ONSaW9+T1sBdVNMplH3VqfeLonPAcGjM2raGmL8E1Uf5WnEkXsHiQ+Ul+wMY0pEd48Iq0ulzMW83JPMQgB5DELef9ASBb6hAbBcE8qu7JW/3LMcgQgc5iZb04hOGd8BGXQAc
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?b2p5ZFFBbC9wYk16aTQ2QWtGK05QTVZQM1didWhJY1h0NjV4YnZHalJmV3dM?=
 =?utf-8?B?Rk5TRkE3MWsrRmhWZDNhSS9oc1E1WThHSEF6cmJWZzNnUXE4b0JSMjdjS2hE?=
 =?utf-8?B?blJITUpvSGFLZ21INlBlNTA0emUxbXFpYkZFNXB3cGU4dU1ZdkI0aGo5VHFL?=
 =?utf-8?B?bG51dno5c3ZVVXZWSzZHOXU4UE5GK09qaDhkbWkrS001OWprMDQ2S3ByemNX?=
 =?utf-8?B?eHlpb2NXa2Rwa0ptV0ZZc2xneklWaGxybmZMMG5ReDh4U2xseDRTc0wzbGlz?=
 =?utf-8?B?bTRyN3dzVHFMT2t3Ull2NHRaTkxpSGxGMnFRanpuQ0Q5MG12NnFJY1cwVzA0?=
 =?utf-8?B?QXcwUTI5eGxFYngyTVlDV09lcWszRURnTzF0dk5DUWZ1NDQ2cUpwamJLT0d2?=
 =?utf-8?B?Mk90QmdCVm9aQUhXdnVyMWJyTVQvcjZTTVQ5bUdieTB4V0doSUIxemZYZmE4?=
 =?utf-8?B?eEw0Q2FGc2FqS3MyS0hYNjR4NEFNMi81aU0rNTZVaGxvcVRSMnF6S3FqZldt?=
 =?utf-8?B?R1libEF3Zm5pQ05SV3k4cng0RjJPa09Cblg1N2Nwd0VETDZreVpGZDUrV05R?=
 =?utf-8?B?MG9GZW81VStWTlllSHlQRHhyU2t1SWtCVGJzamVvbUJnamJ5aVJlMUJ2aXBj?=
 =?utf-8?B?YnNPMFVSWE9hOEs2NjRCd01RRzZza0lEbXV3WDFPYzdINWxtbmRNTzBaa2o2?=
 =?utf-8?B?dTNJT2J4ekdETXpSVVVROVRtRWh5N0ZZQXV4SWZYaXNyQVVSWGVrRFJmbTFs?=
 =?utf-8?B?RnI2V0JJK2Y2WWRrNThSS21EMitTOTNlS2FHN3U0WHdZQVZMV05VNkdmNlRp?=
 =?utf-8?B?cTRSMVlrRHkxY0pJSVZYU05SZzZqSjdRU0ZKVGh1QmEwd2lzOVVSbDh1Z2p0?=
 =?utf-8?B?NW5Ia1BlVDY1enRYWGhRVUhvVGc0cmU3OExWVG1HRHNTd0pkaXJ2VmZkTTFH?=
 =?utf-8?B?TG9DNDV5TytwRCt3ZkZab0J4RGtFeG9CZXNrTjU4dzFTRDNmN3Rqa1AzNS9h?=
 =?utf-8?B?SklRcjRadU91V1haYkJNc0dDV28vRmwyWjdVSlNnZ3ZhbmZyS3BZSXNhRlVy?=
 =?utf-8?B?NHBuNjdmTHNTMGdrVkNWTXZ6dlpYbmNYWFIvcThYdWE2RXNTY2U2d05tMXdu?=
 =?utf-8?B?OWlsRjRzTjFFN3V5R2cxWHpXRFpFZUdKSDNwOXpra0wrWTBqdUIzZWtpejFS?=
 =?utf-8?B?Y2pHSDYydTV0TEFXeVFHSDh1K0VwME93eXJTeG9FL0x4UHI5Nk5LL0M1dXIx?=
 =?utf-8?B?dm1jMHkxeGJwc2Nvb0o2M2p5blFNNUgvQmswMDVXWkNHL2M2NTQ2dnkwZzE0?=
 =?utf-8?B?VUp4Z2QwSUVWZGNJTzcwdGI1NkZKMHNYQzNJSElyMTl3RW93c01sQmVjV09I?=
 =?utf-8?B?KzJreWxKWXNwaXhOdmcvNWFRdG1OYU5HbC9xaThqU0NzSTV5OTNrSmJYeDZQ?=
 =?utf-8?B?dW00RGFueU1ReGoyVXdxUFd6TTFqV1BqNUZHSVFMWG54UEt2RXpvKzlDSVNW?=
 =?utf-8?B?dU92SG5FU2JhanljRG9mMjJoQzZnM1VFaVNlb3hwN0R0RDJWSWE2ZW41dW9L?=
 =?utf-8?B?V3J6aDBYMlgyaWNCZ0ZPeWlJQ3F2dFlzcGdEL2Q5S3VlQmpuNlhkamhpZ1hs?=
 =?utf-8?B?L2F4MFlFVTQ3Rk5keXFiMmJUNkVOS3FabGhFR0ZkeEk2eFNTS2hsVVA1OGlN?=
 =?utf-8?B?bGdWRVdTVE51b2RjcHZTM2NQazRvR3hRSUhUZElVUGQwMC9VL2hLRHlFa2pE?=
 =?utf-8?B?dzFZR1ZhMEdObGxoajhQbEo2bUh1OSsrY3BrenFEM0g0RmNhRXpIQlp6MFJ1?=
 =?utf-8?B?QnZDd3hFTkdPQW1nRzJMZkx3RERVWGlpRHVxVlViUmZGK09tcXhRbUxxNXlh?=
 =?utf-8?B?eEpFQ2M1cmY2Rys0bmpVbkJTbG12L2pPcmZKQ2FFRndsMmdTblpUVVlqcUhh?=
 =?utf-8?B?RjJRZmFWQ1pDZW1OSXhpcllZY285b09rUUtTRVlLb0xING5OcXlKR1RoSm53?=
 =?utf-8?B?aFN0M01oL3AwcTZDUG13Rm55MFZ3K09xNndLUS90Y3lNNGpLTERYMk10RW1t?=
 =?utf-8?B?VnloUWd5cVNWYjh0cUZuTElKbEdOazBWb1J5NWJobFB3THNMakR3Vy91aTlv?=
 =?utf-8?Q?YOcmgdVBjVXDy8SnhNI5EEjWI?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9925fdbf-d940-47b8-c4a7-08da7359704a
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 VpAv5p34LwrH+BMnj27wnnCvZOoyGUEggfhEhzZPuE8QyNYDL1/8LqhkdJBrzJ2LJqBvoAa+OMP/aGMdbOCQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5377
X-ServerName: mail-am6eur05on2041.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qo8-qScU4pXScdqU8MQ_hC0b4b8VLxe1
X-Proofpoint-GUID: qo8-qScU4pXScdqU8MQ_hC0b4b8VLxe1
Reporting-Meta:
 AAEN5OaFFL4r344lrrdq3jBJ2VyHDC7OCA0056vcMNfxlLwIKaGQEmgvQcYOKZ9V
 g9pqTDguJXgnL7zDrr64tb+EqNJwcxd3t2VHjNRwt/b4pERT6/0//NImYWOK4lQM
 nVbUsjXfW3IfsT3toHWqjMmo5F8RKaO64NOQ/il80nMsfdIan8045B0RYq4/S4Of
 9F2CBPFbU5HamDC/ZZOZsEmB9QM0oKmwOJf109e4fYdSrl3uDT+CBrUB7AyED9jY
 xsOxNqC2BliwtfoG5XfVVISoF0UdIz1Qw6Cx/1Mv3k1SJV2qHT4tR+GkY9y5cNiJ
 vuhM8tYJDFVHhuWpleVcamUgYzsQOwckjMluaC245VRE80FX6RVuYGdRdTYoOhxX
 yuHXzDdeZelsJzZ7ukUCWQD2HxUMkMDR/MhyjtJSqU29ZSOYCqCx6SxO6btFLfaT
 aOAokcillp8KXEUf94aRogg8POQKTftcmbUxat1RuhTg0WBm9BkABG8sNkH7ix6e
 mhvSiaipS+rQHeZzdDxFdJC8CxXZC46SweDsVOtJL4k=

Hello Mark,

On 8/1/22 01:42, Mark Fasheh wrote:
> Hi Heming,
> 
> On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
> <ocfs2-devel@oss.oracle.com> wrote:
>>
>> the key different between local mount and non-clustered mount:
>> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
>> convert job without ha stack. non-clustered mount feature can run
>> totally without ha stack.
> 
> Can you please elaborate on this? Local mounts can run without a
> cluster stack so I don't see the difference there. We have

I am using pacemaker cluster stack. In my env, the trouble of the converting between
local and clustered mounts are only happening on cluster stack.

the non-clustered mount feature (Gang He commit: 912f655d78c5) gave ocfs2 the ability
to mount volume at any env (with/without cluster stack).
The 912f655d78c5 derived from SUSE customer complain: User wanted to fsck the backup
ocfs2 volume in non-clustered env. They wanted to access the volume quickly and didn't
want to take time/resource to set up HA stack. (by the way, pcmk stack at least needs
two nodes to set up a cluster.)

> tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
> users data - that's a feature, not a bug. So what I'm seeing here is
> just opening us to potential corruptions. Is there a specific use case
> here that you're trying to account for? Are you fixing a particular
> bug?
> 

Tunefs.ocfs2 still needs HA/dlm stack to protect joining action. commit 912f655d78c5
works on non-clustered env, which needs other tech (eg. MMP) to protect corrupting.

 From my viewpoint, the non-clustered mount code is based on local mount code,
which gives more flexible than local mount. non-clustered mount uses unify mount
style align with clustered mount. I think users will like more to use non-clustered
mount than using tunefs.ocfs2 to change mount type.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
