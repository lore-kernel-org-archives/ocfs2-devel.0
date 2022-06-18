Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF133C43334
	for <ocfs2-devel@archiver.kernel.org>; Sat, 18 Jun 2022 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PDW8aYTFE9mO2qVPgO5wE6B0TB10n1G/SHSp1GS7/hU=;
 b=JDf5iA+HXmG8kRMnrYJo8wwha+vtbirVwBomQXTk4qnI3E4EnJxAXxPbFuc8L8zndPfiNimda4Nh
   yZJC1OC9UpA50E2mPuB+BO+kicq1hjMKmDT5ZTeC2kUedcw93u2zuGkmxoT7HULURN5AwmMxYDq5
   QsvofCtgYUWVEbnQ4sxb7c+OgyZ/uUPE2vEZ+jEL0U6oJpR325Io7D+nn3fzt7k4n2+5unfKjZ+r
   r2v3FMlH5rrnIo3/oZCXv1JIHbRwIYHe9QEq/ns2//rGRwCVtblLLpH70iNXxzObVsEGkXX/n5Cn
   h77XtiLUZn/eFiu8oXPA3osocmhEZHypYdWOrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PDW8aYTFE9mO2qVPgO5wE6B0TB10n1G/SHSp1GS7/hU=;
 b=C2M0SDdpVKBEDvmsbpSGL15UsK/0kLgh4sL2Rz2pne4f6a7gy3YULzCVvfIvDoels3/F268M2jgR
   zKohSagudp8k2rGo51wQ7XXJuoc593o+Yk9I9tvtHG49AC8g0fid1H+3xtmfHzljEmwzeZRi0+e4
   3zmilEkPCRDdkMtL4B4oUPu340u+m2KdCBQ2BAS5+1EgJzsbD28tmZGZ0WFMkCBaSrw0sOk5OuLr
   VB8RRfDzaLn4I/itPm97pUZ2hbb+9ahaJj5HNVnm2leg6l0Bh+RmPtjubwgiRBop8EyLKjs2meQN
   TlBS3mNASEVJ+2AsRmPRnf2qzrGHiB72K9cfwQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDO00G724NSIN20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 18 Jun 2022 10:19:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ik19SUKYVArKaZ8LLt3TBiahhdWH329npxaLsGmbj3tr22fb+hTGYTIJR4bWFqma4+x94RJD+UEBvjAI2OPt74fs75NYSmMfJJMvLn8VZnXbCPNzUFMSK4uG9lmUwty9LlChKyHJqM+GaJG0kWMq6OlR8rZltuyIMpW1c/5JsFZ888VIRMDala4LF9+0nxTeD9CDz1UFUcOS8H5rbIHDjD5hgf2POzQ4SHPjzcy8gaxmY11/N/8aZ30i+xkTGBjy462bjFSU2lk8CC5XWCiOUHc6vfy0Q4j1VZsqtNN2SQeWSHj54ONlud/QllK0/eoQog3m5Gxdo8OkEEZQ1DYzYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgCecVGCVoqcbHlBDWU4lMPrLBd148FjdnHvp6xhA74=;
 b=cHbyf+djyCYZVC/aKR/txJ0YaSM3YGBYDoAVh/0uv2ZwrjjzEW2aGykum5ka0RAy6R/zaQhtF6HWfsLhS8DXEUiAC1abZqiRwXD16gycAZl+wnRlU71MSFbHgFuK7C5buugsVhaSSzwiY4/hk2BFYxRWYt7P8UFpFqcIF87DGLpNmGL0oJ8Ob+xZ0VmF2vpfzp0DZX24+pWrCzsU4RU6v8SXwg8yWPXeGTWJGA0GdKH/vQersDFq/f2r0hFZvmderj1flNsC6/q9oJ2Mu1fwTC2iuGoy+AmR/8rlJUS/J9srq557h6Npfxi3TqnNz8HJ3y6Dh6ji6g8ZcvYfsY/AbA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgCecVGCVoqcbHlBDWU4lMPrLBd148FjdnHvp6xhA74=;
 b=z1N3DTZCclvMkNuU/rL8kLSEBlHZL3aJMXSTqlVioYjTbBO/uNXQIyzVFSpFfXJZ79u4tf5Z5K159Tex/iPGTG7WnqaqbYrJEAucMFCO1VT39fnHY5gpOU3vMEkX4A4NOf6v5rq2+bhgUsF4F6j5qKG5kO/KdehLKDRpBCpwM67cqo7BpByrSp3AI8bLd5i/nT36cEJw8ojUZAClz5TRqf2KE3cKNHGlY/Xou+T52yHgOP50/FqzcFm/OnTxT97q5jmtlWHY91RYOrIIVtBlgPEkXfucJLb5sUKZmD+b1XiNlPvKaZOO79M7fyKc8AhoU5H0JYmJ+rFUXn/1r9ZkqQ==
Message-id: <f0d9f738-a9ed-0b78-f989-a5b228d0233e@suse.com>
Date: Sat, 18 Jun 2022 18:18:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <3144cb10-4359-bb1e-1875-f9803fc9f4a9@linux.alibaba.com>
In-reply-to: <3144cb10-4359-bb1e-1875-f9803fc9f4a9@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(36756003)(6666004)(38100700002)(2616005)(53546011)(31686004)(26005)(8936002)(6506007)(5660300002)(6512007)(8676002)(6486002)(66476007)(66946007)(4326008)(31696002)(2906002)(83380400001)(498600001)(66556008)(86362001)(186003)(316002)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 10:18:41.0846 (UTC)
X-Source-IP: 40.107.22.76
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10381
 signatures=594854
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxscore=0 phishscore=0 priorityscore=176 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 clxscore=218
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206180050
Subject: Re: [Ocfs2-devel] [PATCH 0/1] test case for patch 1/1
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
X-ClientProxiedBy: SG2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096::24) To
 DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55afc31b-b2a7-4a87-92a3-08da5113ea8d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5551:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB5551FB19F23D1F8B5158F4AC97AE9@VI1PR04MB5551.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 xyqEaVIp7/55sBj8l6hhVOgjpdweZms7FB3qzQD9xKI2UMPv96rkWZbNLlLBEp0nWSmJLJnua/dY1RJRmy2/68tOLbM2vYk/A224a7ZBLiPgcb6A9PQuxYYyzCp6R5ixsauABUPam9+eSaf1M8WR30nzrvfxR/KWJhLV2I4u5qMnbqheMrPiTcA+Dnf2FxDfDmFd/SOQD8UC5IiDgXCQvo/OlX4KHN24QPWSgHnTsCcEFkN/ePgVYq5K2Bvkev9a9BYrdYEkLmzNtuK0SuffBdOErBPZrayYVv7ZV/ZHO+s+5A8WrAEtnfrQh+Kw3gRcYbymLbxbyzFf4XgVp9aDsCwOGpDlWCunpxVCJ2XW1BiH+MMZMmBvP3M66Rknpl3ol1uC6fgY5TC11lhQlWqlMmW5y12e0EpYFYH4Pm1ozJUlM3tMFjYzmxLTqfHO4s/wATrsZDaimiiXlHy9zczyp6vTvwKXObCMbDlG1UwnrGXoVFhqPQDRbR9Gbtxz98ecYSN1qLE/fVnzNdW4Uyiye5wkm77qX0qLFxSeNIIxpOMbBMrhc3dSGl/X9VdW6/P6qCvDm9cjBX+DZ4/7egvfnlJVbKp/+yCzlK+Kiuy39L45hcp5TUgA+QDVdWfefoV5V/+pG8m0BiUw0uXYFYjdyaFPxTny8ljbHc9MWFBS3+x2E+l0raFeOduEd2i4wd7nrg3p4BkyTTKnI6aRrueyZOMX7bGwfPN60AFLeZAQo/I=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VytCN25BSjBPWGFFMkRGcTJIb0FSWVlVcTgzZVlpb3MxckR4aGFxNU9SOXRK?=
 =?utf-8?B?dytkV3ArcERVRkh0M0tRUVNzSlRGdlFUdFhSU21HaW1uOFM5U3lSNnVORW9J?=
 =?utf-8?B?R1NKYzVpd21maUhFZ0d0Tm1zaDhITUd1TzRiYm5EWVo0RWIyajQ1Vi9MTEFn?=
 =?utf-8?B?WGozZ0Ztekgvc0UybzRPRzM1eVRIRDBxM096d09BSGtiMUc4MlVGOHlqNTdx?=
 =?utf-8?B?SlBsOGNQMWgxNS8rTUxNSFJpeFpkVThxL1RqcE45NUFyRUZzL1R1eU5WNmVU?=
 =?utf-8?B?K2tObjBMeU1QNGY3Zmk0VzM4NytxM2tQVVdpMm9PZHFQMUUyMEZNaFdCTG1i?=
 =?utf-8?B?N3VsdUhDL3phZjllTU51Rktjd09LQUJmSVdnZWtiZlQ1SFlVMWJsRkdrMW9z?=
 =?utf-8?B?Vnk1M1NWdzJOdWF3YVArbHkwU3NWWVZKMGErc0lIKytiNlJZRWpQeTE3czdp?=
 =?utf-8?B?aGxZMEVPc08vVFlBNEgxNTFVem1xODlmSWhwdGFjUzJGci9VT0ZVcCtUeC9h?=
 =?utf-8?B?cHJjMzBoc2RJOUoxRFYxenN0Rm16ZnBTbGJsd0dZZTBuajY3ZXBhWkJ2Q05a?=
 =?utf-8?B?MXVzZXVLd1V4SlBjWk0xa0VRby9jWk5Fb3dXU0ZNLzA0YkNTREdYMEtVYnc1?=
 =?utf-8?B?VHAzWDBhaEJueGFiMVFjT3FpZ05KWS9sdzZVSS8wNDFUczFHNmJ3bndlOFR6?=
 =?utf-8?B?aUVnWGVXVTBlVXJpOWw5M1ZEeENXT1N5VFdsZFFyTEovbjI5UFpkOFNERlFU?=
 =?utf-8?B?SW55WldlTk0zWDFyK0g0Mk5UWFZkbGp4N09lTVVIYm5KNlhydVBDNVdWV2J4?=
 =?utf-8?B?c2tmOVdvSkVNeHNwNFhPeEpocjFYRUtiTHZ1dGMzWXhmdXlobWxBR1hhWitB?=
 =?utf-8?B?aFM4UFNCejRGV2RacVlveUI4dm1wM25oOUNaT05rYktEZWlaTkNtVnhyREpi?=
 =?utf-8?B?SVJtQmRQZE91d05lVFc2Z2pJRUhmaC80M3JJNnNtNmEvenh3RHBCWHA0NjQ1?=
 =?utf-8?B?U2pvL0lqWUJOeWhRdnJOTHRxcDM3YzFIZnBadHhrNTNxb0tMMHJQN1hCQ21u?=
 =?utf-8?B?VHY4bXhxMzdMSUsxckluZ1BORlBzQ2NjeWM1bGk5UHB6Y1pIYnBVdzFHV1pG?=
 =?utf-8?B?TElRaS9uNnpUVy8rVEczbjcxMkUvOU1UWmduZ1dSQjVOYlZscjQzN3FpS013?=
 =?utf-8?B?dkZ6bk5UUUtHSVMxTWRTdlJwS1lod3g0amxUZjZ0MUZjcFoxRUFtRjRXUTlr?=
 =?utf-8?B?ampMNTVtZ1dPck1mdUNFbFBwSFJWNDYwcWF4VENEbTl6US9jUHRDVmpXTjM0?=
 =?utf-8?B?VUUyVTB3RCtPaUtWNjRDNjZDNmNneGdoRVdZWUwwVzJJTmNhWHlJa1M0eVNH?=
 =?utf-8?B?QzhaYjNERmx6SzFCSURQU092QzNPNGpwaVUzem5CZ3NTRFN5dE1pc3VubGJw?=
 =?utf-8?B?K1R6NXROSUREdmVUd2QvZHl4THowbUVVbjJpZFNrcWorOGFZNlpqdWFmSjVE?=
 =?utf-8?B?YmJxQlZQTzIxL2hqZ1ZxU05aUHlXVURPazdWS2hJdEtzb2FDRjJiOC96UmZI?=
 =?utf-8?B?dzBXeVU2YTI4TW5IcEhBSUxvOFQ4KzU2Z0ZERHpTRWNwM3U0aHh1MGY1TE84?=
 =?utf-8?B?Wm5oSGtmV0hUOXlXc011SWluQkg0UlFIYTRPSTk4RktKcnJxYThWQTBQM0hU?=
 =?utf-8?B?dXkzRjgxa2RWMjZVcHhmRjNzb2dqbVJvQ3VVKytnOXNzWW91eHBCVHdnRnY1?=
 =?utf-8?B?NVdmdFRYNStyeFBvNFNRNVo2ZERBd3BDaTlLZlhFbHBIelN6TEpySDVhZjVr?=
 =?utf-8?B?T0xGY2lyZ2dDbFpFMDl4TkU0Q2VDUHR6QWFZRE5EdnhWcjVTbWQ1VkZid0t2?=
 =?utf-8?B?d2thaElZaXVUY1VMWWk0VTJ4b0tsYlhzaWp2cGZDNUc5OXZDaVQxamk0L1JF?=
 =?utf-8?B?Mm1oWFRHMVQ4L0ZlNERvTTB6a0cxd3B3Z2NDNGNQMEhhQXBTay9YRCtPeFV1?=
 =?utf-8?B?cWE2VWdvR05UOFBLZkl6cXVndlBLM2RPTlVKcE54V3ZMMmRIdXBrdXJib0hU?=
 =?utf-8?B?UnM4M09Dd2lEdG1aUGFKQmh5bUVoWTlZVi84a2xBUUZETjlGaTF0bGJkeUFE?=
 =?utf-8?B?WWlwSTdLU0U0cks1aHYzd1o2bW5FN3Vqd0Y2UWJYakU2ZzVuWFFFVmFYeFBp?=
 =?utf-8?B?VGRGVklncDVyMm9YTjUyVUlCUzk5TTUxekdFaHhoUDc4TjFGOU1Cc0M0cXor?=
 =?utf-8?B?VU1PR1Z2bGtGNWFONHJvVE5JZXBNL3dSU0tDb2lLaXFveG9mQXNOSzBhNzJS?=
 =?utf-8?B?YldCcEtVVDM2NGQ3R0xUUk1vME5tTUZ4RXd1Q1h0dWE4L2Eydzd6UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 55afc31b-b2a7-4a87-92a3-08da5113ea8d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 R3Pe2Zn5PtTx4pjdCaGB7sylTW2a25i9ZROzjbvZCNubxoHBfhB4xp5/2On67G3cTYHwNa2X2YbMkkjLsJXr6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5551
X-ServerName: mail-am6eur05on2076.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: cjuxTbDLq0RVejqC1EJECQo0FR8Do30p
X-Proofpoint-ORIG-GUID: cjuxTbDLq0RVejqC1EJECQo0FR8Do30p
Reporting-Meta:
 AAGNPEmogTMMmViRpw1FieOa/fsDdm+BZSVISJPqQHSL2i5wE4Rgnh/5yFQCfDzs
 +meHsqj2gb2+NzBZlSCCo0DEkhwlEOEVfPKetQeUaj83cJNrtyJsu29G7glxMF8K
 3w9CimPuTHmTpN53V/blsGzL8JYQWre3z5k30QGiiiMcOu6I2BqamLAAME94L3N5
 4hfFvu0DTMDurqynpHigT3AWONZRdZ3N+m6f5xDUvb4wWg3oP1AC0HWMh+4Wn4dj
 p7IAfqpQXiJy2zP5sjMdDd5XT6Iuoe2Dx2bF1LxSIzJKkweP3H4c4gizLg7ACiZk
 IYEm3rbw7ZnthkzadJfzm2Tmz31f0jFRBp2neYGI3b+RvOQm9gaZ1PyiNzYEnm7E
 7pSJ8iKRLBwKmEWBWsjKbEVde+HDike+OP5/59c8MqzWZoNMLurOvOm97cPvlkBm
 M4m3LnXmcZa/G93XHvDNrT2l2TBsj9GXS5slBKmojHwuxjUB+KUPKeQn58QCzUHy
 /4G3us9k9XSjd0gJnlrpmnqdrruv8YmigyI9c94tjA==

On 6/18/22 10:35, Joseph Qi wrote:
> 
> 
> On 6/8/22 6:48 PM, Heming Zhao wrote:
>> === test cases ====
>>
>> <1> remount on local node for cluster env
>>
>> mount -t ocfs2 /dev/vdb /mnt
>> mount -t ocfs2 /dev/vdb /mnt              <=== failure
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure
>>
> 
> This is mount multiple times, not remount.
> Don't get it has any relations with your changes.

Yes. not related with my patch.
I include this test only for watching remount result.

> 
>> <2> remount on local node for nocluster env
>>
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt
>> mount -t ocfs2 /dev/vdb /mnt              <=== failure
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure
>>
>> <3> remount on another node for cluster env
>>
>> node2:
>> mount -t ocfs2 /dev/vdb /mnt
>>
>> node1:
>> mount -t ocfs2 /dev/vdb /mnt  <== success
>> umount
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt <== failure
>>
>> <4> remount on another node for nocluster env
>>
>> node2:
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt
>>
>> node1:
>> mount -t ocfs2 /dev/vdb /mnt              <== failure
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt <== success, see below comment
>>
> Why allow two nodes mount nocluster sucessfully?
> Since there is no cluster lock enabled, it will corrupt data.

I didn't know about ext4 mmp feature at that time. If ext4 allows mount on
different machine (can corrupt data), ocfs2 also allow this case to happen.
But following ext4 mmp, we could better to add some similar code for blocking
multi mount.
> 
>> <5> simulate after crash status for cluster env
>>
>> (below all steps did on node1. node2 is unmount status)
>> mount -t ocfs2 /dev/vdb /mnt
>> dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.cluster.mnted
>> umount /mnt
>> dd if=/root/slotmap.cluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== failure
>> mount -t ocfs2 /dev/vdb /mnt && umount /mnt <== clean slot 0
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== success
>>
>> <6> simulate after crash status for nocluster env
>>
>> (below all steps did on node1. node2 is unmount status)
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt
>> dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.nocluster.mnted
>> umount /mnt
>> dd if=/root/slotmap.nocluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
>> mount -t ocfs2 /dev/vdb /mnt   <== failure
>> mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt <== clean slot 0
>> mount -t ocfs2 /dev/vdb /mnt   <== success
>>
> 'bs=1 count=8 skip=76058624', is this for slotmap backup?

sorry, I forgot to explain this secret number meaning. Your guess is right.

how to calculate:
```
my test disk is 500M raw file, attached to kvm-qemu with shared mode.
(my env) block size: 1K cluster size: 4K '//slot_map' inode number: 0xD.
debugfs: stat //slot_map
         Inode: 13   Mode: 0644   Generation: 4183895025 (0xf9612bf1)
         FS Generation: 4183895025 (0xf9612bf1)
         CRC32: 00000000   ECC: 0000
         Type: Regular   Attr: 0x0   Flags: Valid System
         Dynamic Features: (0x0)
         User: 0 (root)   Group: 0 (root)   Size: 4096
         Links: 1   Clusters: 1
         ctime: 0x62286e49 0x0 -- Wed Mar  9 17:07:21.0 2022
         atime: 0x62286e49 0x0 -- Wed Mar  9 17:07:21.0 2022
         mtime: 0x62286e4a 0x0 -- Wed Mar  9 17:07:22.0 2022
         dtime: 0x0 -- Thu Jan  1 08:00:00 1970
         Refcount Block: 0
         Last Extblk: 0   Orphan Slot: 0
         Sub Alloc Slot: Global   Sub Alloc Bit: 5
         Tree Depth: 0   Count: 51   Next Free Rec: 1
         ## Offset        Clusters       Block#          Flags
         0  0             1              74276           0x0

74276 * 1024 => 76058624 (0x4889000)
```

At last, do you think I could send v2 patch which includes part of ext4 mmp feature.
I plan to copy ext4_multi_mount_protect(), and won't include generating kmmpd kthread
code.
btw, to be honest, I can't totally got the idea of kmmpd. kmmpd does periodically
update/detect mmp area. And ext4_multi_mount_protect() already blocks new mounting
action. So in my view, kmmpd update/detect actions only work for user/something
directly modifies disk mmp area case. if my guess is right, the kmmpd is not necessary.

Thanks,
Heming
> 
> Thanks,
> Joseph
> 
>>
>> -----
>> For test case <4>, the kernel job is done, but there still left
>> userspace work todo.
>> In my view, mount.ocfs2 needs add double confirm for this scenario.
>>
>> current style:
>> ```
>> # mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
>> Warning: to mount a clustered volume without the cluster stack.
>> Please make sure you only mount the file system from one node.
>> Otherwise, the file system may be damaged.
>> Proceed (y/N): y
>> ```
>>
>> I plan to change as:
>> ```
>> # mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
>> Warning: to mount a clustered volume without the cluster stack.
>> Please make sure you only mount the file system from one node.
>> Otherwise, the file system may be damaged.
>> Proceed (y/N): y
>> Warning: detect volume already mounted as nocluster mode.
>> Do you mount this volume on another node?
>> Please confirm you want to mount this volume on this node.
>> Proceed (y/N): y
>> ```
>>
>> Heming Zhao (1):
>>    ocfs2: fix ocfs2_find_slot repeats alloc same slot issue
>>
>>   fs/ocfs2/dlmglue.c  |  3 ++
>>   fs/ocfs2/ocfs2_fs.h |  3 ++
>>   fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
>>   3 files changed, 62 insertions(+), 14 deletions(-)
>>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
