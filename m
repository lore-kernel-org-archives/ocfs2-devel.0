Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3F6C43334
	for <ocfs2-devel@archiver.kernel.org>; Sun, 12 Jun 2022 07:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pSh5ORs5hXHyhOw8JGvghnS3JYgqbOB5HEHsUC6+54Q=;
 b=PphDhxBu+rP5kpskMhVZsprSFLVY/I1asqOThXN8zEzKzB9GEcBrzPx6voSm4ZR+Xs52MOAJ1V4P
   3vxCEltPdKYisYXjvPbGKKTSSSIlRl9OYLIsyaqJP6uSrOo28QFZvw+W/X0E7mKYgwWbU19XF5ZP
   Ip6+oFq4aKZZ/xDXg3W73JeGgapeVVb9bzK6ffAIWrTUexsRj9MexjKfRD+ChcxlXTF963th/tLx
   Buz6fNkDHtZmlz71jmbmPbdgKJyngbXHUMwt2na0Wx1D4yojC+JIPRgKTJZJTWfw+N0waGZoYAxg
   S1Ll/0Ndnzj/urAcKz7wfd5/VJ8rYZpDtqbgPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pSh5ORs5hXHyhOw8JGvghnS3JYgqbOB5HEHsUC6+54Q=;
 b=MN4C43ksEQA+pVagmk5WD6NPiyOX00CqKNBVtLfxCM4ISx3MN2maCXnRBD7o8dq5LGMZaoNV9N4+
   BGTwgBd8jduP+Eo+a0TUBpNvoRyitaByGVfQo+fMeHNn1bJhxy8av9247jvyAooYhmYOx63qPBzs
   UE82+TLBzlm2AksHv5V1u1ANFWdhZFC0T4HNihIinFJxXaIIMoqOgN4UTHlqm/OjuVv1tfiQyiZh
   dcSjDWSBnbkrz3FHftTVu9Z8kNRZaeZugoBMKgwjSszaeTqNRMv89LwRNGLi2GPpabqHeLUxzbLR
   oxn7rndIhDj5NldJljjHzdHlI6eugTO8DtpabQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDC00MD8TKSG360@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 12 Jun 2022 07:46:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=We8AyDiO6DGZPFKCSPHmVRBJX44nDbLw1bqskrfpIbdhMwGziKWE1rlpnVlQB871jyVFrCTOHP7hFp/YWZfhcavLQnr7DMvTzRSQ7EmrOcK3chcAmT5VRHUx5ohNCcTFLrxd1cw3MPBWoJ6JvdyTfO9Lk0ipyvlfGXCoqKFuNOHmAde4t8bQ5KVpozqXwy+gBZ4ppNkTg55/j5knSlzYhucvrXXMCX+i129rbIud0hEEJlefJzykyvLivIHdYBoctq3fJ3eBVFnsvtmui79GUiAa7kgyjwrszq+zK7Rg72RVlYioEdmFYBegfW3epqbzkaBUExJ6cjhVwR0CN3dBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhxxubijzQlAFBXQvekbRQonTwWvbNxt81M3ca86HGI=;
 b=PKGNsZ34XrpDIdzRrmkRrx8V+CRKz910WqHdVp7iP4Da2AuhPIvgUDFU2Fw2I9sHwW4/eZMBO2SEreZwMLs2GM/GMjUcjweEcRdxdFShC1Hq6Vax78YHCaQMxI/44b1vz/sMUz2/SY12l8eJI5hGn4lOIvQ3tRil+UV3bzgNyo/VTuxJiUKtye5kOgO18l3dwUA7nPMKH8bF+zq4mJpxQn4Jnrp2nMMNpVQj0n9gsv756+8FXOk/QII7EBi74ksaLhZMCIp3v58NMfWAWFo1UKpvFIziEB4PjFZuFkrEvulds0npbY3mcli5/vYqLqonR9G7ae44ktavO+3Roq6jZw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhxxubijzQlAFBXQvekbRQonTwWvbNxt81M3ca86HGI=;
 b=OgpxLDP3y/K1H8rhoPzZSI9DfUPz5vcssMRdUZFGNHMDS5qA5gcOyumnyNP8nvoiBAZiCvJGjRZvDPOs5BC+lxwaVP19a09HSWvEi0ujCIcTxhnkq18vaWi2mfz4vNrqTZXelgIXTFl7XJaoHu7aOoygnoOmad0+k/tJx9IksKDPM8jaG/B08f3tDEMDgB0H5EMuRBa6gDCZzj8XdWRIMGlSaSUMV8OOS33z/yhCrAbetLWlyMhTy5eEeQzuDGXjF1XXkwNAfTX37aGmf3j1/6J8BLWXyq9vBJ7T+6vh17NQX9xh2n5Z8hkJVHRc+ct7VhAZyUl2NToeChhSFHodmw==
Message-id: <82e1181a-b432-fd37-8451-1b35068b912b@suse.com>
Date: Sun, 12 Jun 2022 15:45:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220521101416.29793-1-heming.zhao@suse.com>
 <20220521101416.29793-2-heming.zhao@suse.com>
 <b7970a54-2c81-780d-966f-05995acdd813@linux.alibaba.com>
In-reply-to: <b7970a54-2c81-780d-966f-05995acdd813@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(8936002)(38100700002)(5660300002)(2906002)(316002)(86362001)(66946007)(66556008)(66476007)(36756003)(31696002)(8676002)(508600001)(6486002)(6666004)(26005)(31686004)(2616005)(83380400001)(6512007)(6506007)(186003)(53546011)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2022 07:45:41.7308 (UTC)
X-Source-IP: 40.107.21.79
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10375
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=839 mlxscore=0 clxscore=204
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=118
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206120037
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix for local alloc window
 restore unconditionally
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
X-ClientProxiedBy: SG2PR02CA0032.apcprd02.prod.outlook.com (2603:1096:3:18::20)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d3ba153-faa9-46b1-fcab-08da4c478cc7
X-MS-TrafficTypeDiagnostic: AM6PR04MB5477:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR04MB54774896749D1CC5F6CAF6D797A89@AM6PR04MB5477.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 htwYlT153EiTQQ21VKLFW2am4yF/4u96aAJUHsaR5MdkS4K2ogReHoSePwmP+bRrtzL7QKr2UFy4V/XMiQsmAUU1fKCRjKVFmKPi+HLjuFc0H8YF7ElJ1T3SAxPyBwTvilsd9LQ/CffYmlTqeUops9ipwS0fFDfofDFXpwvAN0hpSE7P4e7xcFiLOkkM+yUXulUnO0Pg01sFGvz7b3nXZf8K5argNeRask+Jm/goIpsMO/YtxW1Z3VoYS7V+jAIFU/TrwjLBpEVdNtNeHQ8er8AFjQjr1ND5tlmKntMOMg8VZEMm+msCDX/gXVRrUmSht62I+S3zsQa5z9N0Kud6mBEsVH+l/zrxD00lKV/az1VMSBm/4N+1J9IMerUeW8QTam/f1vU1DX2uGw4nRcvtBWblmKmtebepBY7QG8ydHU8iOLR2DUcQB2eT6iMXz/jrFebipmxu9S0CrENu8I4AStBizmAHNooKYwJ0RUrVPO/+/jzKNtqIN5B255XPCO4Pp3hOCVmZ4hQegE4jb5zVY+ExpJCLJlhhIVTLA6fHdj70SNmQW9DHPdgsKXffqqbnYS2dn82bY2TyV38mV4QjyqpZdT08OPZT/f56tyxjd76Wjce8elnoQ6vEzxCwDfJ7JGep4R5fjgsjVHAZqTbFhO/hHXeXE6IFuv8Tyf6heJI1w9MOjAcdKWqok2reZvClxT8wjZVybjaIpqpNUtMXAnHcSLwJixuxJNK8XbPVOWU=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NTJ5aU5LMzA4VHowZGxoMXlPdnFUelZlZkxoSGJ6UThvVk1oSnJuR0ptRnVR?=
 =?utf-8?B?U1d2UW1HYU9YY2hEd3ZXODdWbG1nZWlLSkVlWFNlMnhnYnpIamFZd1JOOVRJ?=
 =?utf-8?B?U1VLak9tUVJoQmFwRTJxb2RsR0duaHJhY1NhcmhoUE9JZG9RSFdjeGo2Tmlj?=
 =?utf-8?B?L00rd2wrV2VldnlmY3dRN2tNTkFkNEJEcVJkejU3Y0JoMnAwWTJQUUExaVlZ?=
 =?utf-8?B?ZEhwdnRVSzVZR01vSmp3bXlnMFl4WC9GZHdlUk13aUpNblptcFNMZmF2U1RL?=
 =?utf-8?B?RFI5TGQwRFpHakM0T0V6cm1vbHpYMktTbDNFWWp6WXI5NTlHVEVnZmJlUDZP?=
 =?utf-8?B?Q0c4V244NFZ6MFlFTTRTVEhLd1MvQ0s0TUVZZnJpYlluUXpkT1dEYVdJakhw?=
 =?utf-8?B?U1IxOVlPQThNMjB4ZUI0QWpEbDFqZzBTQnJWVGRsOWRhaTEyeE93c1dKaEs2?=
 =?utf-8?B?NzdUNHY3SDlCcG5xdHhTa1ZKMnFSclFiOG5QWFFHeGJFaGp6djRpYmlHOTJC?=
 =?utf-8?B?SUxGVjFreXpKRlJlT243dDF5NWEwdExBYVJ5YnpzdHVweVVzRlk3bzM3dmVx?=
 =?utf-8?B?NnpyRFVhKy9rMlpQL0RhbzkrYnBBQTRHc2RzU1R0N0dPN3didXZEQUo1akdC?=
 =?utf-8?B?ZEpXbmZXZm9wSC9jWlVDem1SMDY1NlpiUVdrZjdLYjlwRFcvUTFxQ0FFQjJT?=
 =?utf-8?B?S0ZDOER4ejJqNmdDU1Qzakpld0VUOUNNTERaT3grMEZmR0VLMGh2Mk9peGRo?=
 =?utf-8?B?Q2syNFVFTmZyVVljMllNdHVlcUNzNS85ZWdDWWhsVXBnTFFTMFRIMjZwWm9r?=
 =?utf-8?B?cDIvOEN6YUkySkdpMXJZemFNd0g1czR4TWxPa1BSNHA2RHphRUdrN21mU09s?=
 =?utf-8?B?TXZBQVFUUW0vK1RPSWZoc3lSUWptNWlFYUhEandKZzhGRmpNb2kxM0JONU0z?=
 =?utf-8?B?SlU0emYvM0VmZ0c3UElCeUJ6SU1JSDBudjlEUXdKSGhFdzRZK2gvWGsxVFhy?=
 =?utf-8?B?Qk1tcFZFekNBK1V3eDFZY0cyZlpMeW1QNDNCclFPRHlhOWVzNjc0eHJSaEVw?=
 =?utf-8?B?cU04eVl6RXQrRVl2QVVKZmxaMUUzK2JMODdEZGVnVXVBbm1wSHd4Z045SG1k?=
 =?utf-8?B?V09scHZYbTRlVk1teU8vQWkwOVJWbGNWRVpLeEdRS2VCYWt3UXlFelFrOHNE?=
 =?utf-8?B?UFEvOEZNbU04cjNPWHVXc01jajFaT1NkRFFpZEs1UlhPaGRFdTJ6bndhUlUw?=
 =?utf-8?B?OU1vTy9Pai9Wb1BaTk5RZDhML3J1N1NJUFlROGd6M3RCNi9ZL2NqZlZKcktI?=
 =?utf-8?B?dTcrUmRrR1ZGbVgwM2s1OUFQLzdxK0ZZQWVFVDZFQW1pTGMxdWtSR0xEZUF3?=
 =?utf-8?B?RUR2NjJpR1RzZ1lSSGhFcEVySnFMTXFmSVg4b3g4TnhwOE0yZjZwM2hwalVG?=
 =?utf-8?B?dDlTOGxRa21QY0JUemN0Wmg2UTdJRTZzdE81bTlKS0dXV3l0dDdrWjJKSnd1?=
 =?utf-8?B?RGREeitvU3VxRGxwMzdmTGJGZGdZSWsxMFpaV0ZMMDdNSDlZQStUY1NTVXJ4?=
 =?utf-8?B?S2FLU0pZS0xnMFpBT2dYVXp3YkRSRk5NSmpRRmlyTkRId0krQTQ2MWtESC9h?=
 =?utf-8?B?UzQycnk0WUNqMUpHVURrdUZFdGlCN2I3eG5rcEdkZXBEQ0w3dFpsaHNvUU1t?=
 =?utf-8?B?bngvakFMKzlTYThXSkVjR2UrVGVFOGxCcng3VEJCWmJScGZEdTBwZ3N1dVRx?=
 =?utf-8?B?dFdHOFQzcnd4VTZEL3E4VDNSTDFEc2Z4M2o2MFFkNmp5YlJ0Um1nVVhIVHFC?=
 =?utf-8?B?YnE3VkJvazJWK2FDSExTQnVwSEt6by80Nmh3cGt4MDJqOVAycmtjMGNmcTVP?=
 =?utf-8?B?bC9SRUY2YWVOaTlVWWxqd05TQTNvczhtWE5qSktkeUtoZlFXMUUrdlphVUVD?=
 =?utf-8?B?QTJsRzZaeStIQ1ZqYU5XcUwxNmdKeFBWQmxSK0drOTg2UVhBdjBhRGcwczdz?=
 =?utf-8?B?b3NSbHpxZTVWMDVnV29WRW1pOWNuWlhuclBrd1lWRFRIcmtqbHZUSlVqelpn?=
 =?utf-8?B?UTE4dGlGcVRHU0RRcnNtK2NLaWtCWWVlakU0c1lHMmVyejV4ZEYxdTVKdUdl?=
 =?utf-8?B?d2ZaelBuVXI1UkJuakFlRjF4NkhWazJHS3JxKzVOMUd6eHZZQjNhd01EeUFt?=
 =?utf-8?B?S0xFbTEwN25YQXJ1akRTYTRUL0dDZWtvQjNCRW1xTitPUGZ0S25kUXR6aHh4?=
 =?utf-8?B?d05TTWhGRDFsdE9zY245YTZ4SnFIUWdQVXI5L2JxazMrd2ExendvTFRmRkhH?=
 =?utf-8?B?UEZIRXZRdTNVaDlnNFFoTDVObUdYaHhuODlNRUtUbzhhN0Z3ZHFhUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1d3ba153-faa9-46b1-fcab-08da4c478cc7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 nzRy3MEy9atKgQdycRIIyY0c8Vs6ole37JgH+3O2KVpSjqdZWQpTgZ8kkRA7ECzpMyetZDVkAHHlQ1eF26iAXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5477
X-ServerName: mail-vi1eur05on2079.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: jcHdlNfFwqHyHpYlxOLpfFymlwyhWm0W
X-Proofpoint-ORIG-GUID: jcHdlNfFwqHyHpYlxOLpfFymlwyhWm0W
Reporting-Meta:
 AAE477RIuiM0ZsBPta0OSEaeilzVW1lg3IXeAN7I8Olmj/wrUEcf4OUgvbo6tFkR
 tW0P3HuWunzTuVxgaLvspyBZHEeGkhyhRBVgnTOLIhqpwBjJHxCoO0Gg8GJ9+CE7
 h9C8tfeRL8xAWHzoNcwOuk6YCvAIO9766afCKSJP/vVuEiiv6kj5d6U0qObmJV8C
 AljuUzIYd/MXCoa564eoX65C1Y12TvJ2LLhFiWNApVt/NEJ5UqR/QSMt7vss3p+W
 yeITrfKtNOMvwv52U5AKEQEn9fPmZOb5ACAGEir0T+Ms3JUszlY0CdYYRnW/u3yp
 pXkQxmcvhXlx3RGnt3t5k4xLcNxflymREQJXmHsnHirwjMcfr9lYyV/V5z9i5ObQ
 Laillk+cQ2H/Kwii0yJvEWbsmLOrgILO/tNYRq/ArivG+jJhsGQWvWNsF2bBUwTu
 TspjCZXewhaLpp7YtuIFycjiGoaEelw/ryVBnpEQOyUz+boWq7iVE7vPYPEEziWD
 6SPe6ov4haB07AzTTrsPO3/ETe2EvvCZfDwL3obXj2++

On 6/12/22 10:57, Joseph Qi wrote:
> 
> 
> On 5/21/22 6:14 PM, Heming Zhao wrote:
>> When la state is ENABLE, ocfs2_recalc_la_window restores la window
>> unconditionally. The logic is wrong.
>>
>> Let's image below path.
>>
>> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
>>
>> 2. About 30s (OCFS2_LA_ENABLE_INTERVAL), delayed work is triggered,
>>     ocfs2_la_enable_worker set la state to ENABLED directly.
>>
>> 3. a write IOs thread run:
>>
>>     ```
>>     ocfs2_write_begin
>>      ...
>>       ocfs2_lock_allocators
>>        ocfs2_reserve_clusters
>>         ocfs2_reserve_clusters_with_limit
>>          ocfs2_reserve_local_alloc_bits
>>           ocfs2_local_alloc_slide_window // [1]
>>            + ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_SLIDE) // [2]
>>            + ...
>>            + ocfs2_local_alloc_new_window
>>               ocfs2_claim_clusters // [3]
>>     ```
>>
>> [1]: will be called when la window bits used up.
>> [2]: under la state is ENABLED (eg OCFS2_LA_ENABLE_INTERVAL delayed work
>>       happened), it unconditionally restores la window to default value.
>> [3]: will use default la window size to search clusters. IMO the timing
>>       is O(n^4). The timing O(n^4) will cost huge time to scan global
>>       bitmap. It makes write IOs (eg user space 'dd') become dramatically
>>       slow.
>>
>> i.e.
>> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
>> la window default size: 106MB.
>> The partition is fragmentation by creating & deleting huge mount of
>> small file.
>>
>> the timing should be (the number got from real world):
>> - la window size change order (size: MB):
>>    106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>>    only 0.8MB succeed, 0.8MB also triggers la window to disable.
>>    ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>>    runs in worst case.
>> - group chain number: 242
>>    ocfs2_claim_suballoc_bits calls for-loop 242 times
>> - each chain has 49 block group
>>    ocfs2_search_chain calls while-loop 49 times
>> - each bg has 32256 blocks
>>    ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>>    for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>>    (32256/64) for timing calucation.
>>
>> So the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
>>
>> In the worst case, user space writes 100MB data will trigger 42M scanning
>> times, and if the write can't finish within 30s (OCFS2_LA_ENABLE_INTERVAL),
>> the write IO will suffer another 42M scanning times. It makes the ocfs2
>> partition keep pool performance all the time.
>>
>> The fix method:
>>
>> 1.  la restores double la size once.
>>
>> current code logic decrease la window with half size once, but directly
>> restores default_bits one time. It bounces the la window between '<1M'
>> and default_bits. This patch makes restoring process more smoothly.
>> eg.
>> la default window is 106MB, current la window is 13MB.
>> when there is a free action to release one block group space, la should
>> roll back la size to 26MB (by 13*2).
>> if there are many free actions to release many block group space, la
>> will smoothly roll back to default window (106MB).
>>
>> 2. introduced a new state: OCFS2_LA_RESTORE.
>>
>> Current code uses OCFS2_LA_ENABLED to mark a new big space available.
>> the state overwrite OCFS2_LA_THROTTLED, it makes la window forget
>> it's already in throttled status.
>> '->local_alloc_state' should keep OCFS2_LA_THROTTLED until la window
>> restore to default_bits.
> 
> Since now we have enough free space, why not restore to default la
> window?

The key is: the decrease speed is not same with increase speed.
The decrease la window happens on the current la window size is not available any more.
But current restore action happens on there appears any one of default_bits space.
e.g:
the default la window is 100MB, current system only has some 20MB contiguous space.
la window change to half size (10MB) when there is no 20MB space any more.
but current code restore logic will restore to 100MB. and allocation path will
suffer the O(n^4) timing.

 From my understanding, most of the ocfs2 users use ocfs2 to manage big & not huge
number of files. But my patch response scenario: ocfs2 volume contains huge number
of small files. user case is creating/deleting/moving the small files all the time.
It makes the fs fragmentation totally.

> 
> This is an issue happened in a corner case, which blames current restore
> window is too large. I agree with your method that restoring double la
> size once instead of default directly. So why not just change the logic
> of ocfs2_recalc_la_window() to do this?

This path is related with two issues:
- restore speed more quick than decrease speed.
- unconditionally restore la window

only change ocfs2_recalc_la_window() can't avoid unconditionally restore la window.
so I introduced new state OCFS2_LA_RESTORE, which will help ocfs2 to keep throttled
state.

btw, during I investigating this bug, I found other two issues/works need to do:
- current allocation algorithm is very easy to generate fragment.
- there is O(n^4) timing. even after with this patch, the timing only becomes O(n^3):
   <group chain number> * <block group per chain> * <bg bitmap size>
we needs to improve the allocation algorithm to make ocfs2 more power.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
