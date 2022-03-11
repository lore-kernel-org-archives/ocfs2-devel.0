Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9718C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Mar 2022 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yE+i2qCEB78s8zmpIjxqsfJfuhZUiVXMa3BJDq71tpI=;
 b=iarcngfVsK9JtPcfvLid8KS/PKUwHc6zyKMRas3ONLzh7vrjZL4CfpzRNkRl7+XyCL/rqd189l63
   FI7ET4tgeoBP9HrmItfklP2bQOO0R8FDDbqqnTcgWFV12ps50ueXSZ9V5yHmmPiGWqNlhydsvtEh
   F2OhYRFBRoJZgt+j8iairPOwXnqb0HJuXp2O6wypf9V9zN6+aQeAOK9Q4+2IZUq1sgx5wp0hFBLc
   ip1hJQA50ZGWMYulVB9yByGXoz54NJw0gKyyTkRL8XUS5f8u5GhRjscxLEj6YC3AyrqDmM9Uylb4
   BZcFbDMF03miwNtpuCGj1xed13Vx4poogqeopw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yE+i2qCEB78s8zmpIjxqsfJfuhZUiVXMa3BJDq71tpI=;
 b=kvqaEGfhz70pw/D8ewDYjzikBEooW1znBzn60GnSkxDzzInMxhtq1XrndZNVRYudIOeHqMoAB2vi
   5/u/nG1ehUONzsTTB2SbD0OG1ndWQhDBh+5NMZwMTWKMdR9dSFm5a2Xde+8Z4AkkYZlIyPIvvARy
   jzK+PeyjSKA2BWxdYR4F9wZKyt5NVzzGhswWfDNUQX8ZUxK8wYRuLKqE8xRVq2UfvML1oFJKdQu5
   EP5NaH2lqRHuCZ3HUs5FL/toMV2A77xMg2YW958tuZ0aQEdsf5foxK0XO4MkTVbPEaGL465uckUw
   /GpUXkjStdteez6D1RaJBReQZhru4TbgOJHbXg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8K00EPTMQA9X30@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Mar 2022 08:10:58 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1646986242;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2vBChubnCZFamHX7G/Rr11808+pmjSvhVtOgNrV+nfA=;
 b=MCgou9fYuAeSavrjpIYK/EahNB9M3+ORsa39tD+DUobKKcZ4kvLbxjnxE2kF6fYa2KWO8d
 xN6OYiH0Jtl5DDv2ycZmrIrc3NFVRPB/QUCD87EPX9UpZgLWD3xdBd5ciheIo+h7ZvmdL9
 PvuY8Qi125C0eMeTVPYS8L30s8x7m6c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqyeIHeYe5AdUJSlg8cbxZ/BBYgNqa/p9uMgqc5n2BF/uqeGr6kgCy/mEiM7dhYBUzm+77tBgq0dkz0rWkUi/26DIyvv6c15PG72LW3oOJgqazGnWkMzLiTevyOWiUzX6oT+g/ncJ/m/vopm8DXKTMNoLeBT91fpKiwn8o5DhGfzBEB4KerMx6r0Am9Oic7rGKbgRoHTG6lvSasmrlRPmcguVj1AG1JEoVHpfB9WUveoIfcUliWqSE7jYqjJ3R2VSFOqk6UaNuSjejzOKVzz0DiTMIjm2j4d21n3bBsluOMhPeAJOJxSC9K6fS828m5fl2vpZEzjJPDKN3gb1fJI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vBChubnCZFamHX7G/Rr11808+pmjSvhVtOgNrV+nfA=;
 b=MG1VbmRTNuO+Ks6ZhXnVNVOuSesZQNlCkPYi7NXzqX8kg9WSZyxu9Rju33qUst3VbVrH3lGwsX88IJAg4BuhgRq1vt9jA/hbASi+mzRWW57Y+BW8pPh6AWCBNjY2b1agXT1LWeMIYSNe1V0x6RXd0A/myVD02LfgXG4iaYgqTAKNEaJUPrMJmhjEcM6OnWrJL1VM/m/WotnGFfFXa2SywQDHx/nKYmfNtUdJm4VkcxSPlb0LUEmk2R67Duw6gmG+ShfTtfQJm/Bv7LIkRoxLJLSicYampEX7oIXvaCib6VkIeJlTcQ98LPtxoc3lumIQ7l6gTQyZtiqL3ITBhQExcQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <5a0d71ac-3a17-fb0d-7158-84a43ccb5d07@suse.com>
Date: Fri, 11 Mar 2022 16:10:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220310105850.1817-1-heming.zhao@suse.com>
 <e66d10f3-cec7-0564-260a-3c441bebcdd6@linux.alibaba.com>
In-reply-to: <e66d10f3-cec7-0564-260a-3c441bebcdd6@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8676002)(38100700002)(2906002)(6666004)(508600001)(6486002)(8936002)(66556008)(66476007)(66946007)(31696002)(5660300002)(26005)(86362001)(316002)(31686004)(2616005)(36756003)(6512007)(186003)(83380400001)(53546011)(6506007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 08:10:38.5477 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282
 signatures=692556
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 priorityscore=143 clxscore=323 spamscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110037
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix kernel crash after mounting
 when dlm doesn't ready
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
X-MC-Unique: nvgUGlEuPxmINxJEgA6eWQ-1
X-ClientProxiedBy: SGBP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::15)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a797a47a-9fe6-42d2-d6d3-08da0336a07f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3663:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB3663C73A3D42EA1E1DA57DE7970C9@VI1PR0402MB3663.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9Xe+Uo1KTH+Sgv6Kw+XP43bGIyPkz3R4OXvfQrs2zybnJV+iKZ/LDSOnJ4BMshpfmMno1dwq1MT8/Pmf/pKbrZ4G2Jy2T2w/fwDrdjqgojzpDbjz+KOuRWd2zreBOXQz8OlPeMjjt8RlYobZtunEaFZmVYqwSa65r3z4u518ayCwqIBsqR3eY0JcYNlSL85oaRNoRxOyQE5zlq/PnfU3U3rmFoD3mlyFGXJ5cfmDD30+LyXbtG1rBLRGh7GpF59hCNSWoDrj0+R8rLS/RgE0JMkAXpT4ElAQ4Goi3Hmx0pnHkXXd9A8ADutfqLgklPNbFWDf2aozA7Os4vP4cUkXS42FH0EcaPU66U+1xr7M83Xdjwzwrl2mvtYSBiQmxMRI9IhGSh+xcOd8n76i6ipCGN8QE6sXWUJckA4s5OY0K+kv/Um55QCxxgfI8b8VQ4Q+0FlRE22ZosyFzhrTS3W4ikJAw+GHuOL3iV/snT9U56mSAeccM2ms1XYxF4QZO9/ZJCDW27QCZGBzYFDsKumAI2R6UblAKNBz6GUaEs9qWPN/NNACFodT4DwT7uuVG+1rZR70yXwFBIUuXUrd3hqEFAmZAQoZyR6I0A3s228Ocpses/Lx1PRASJLOSXwgdBGYfiufqYn/abnuANq3SsmV4OCETpT7qUCT9Hcrco7glqSJ6AWFBeFVTNE9pLIHK4y0Ut8MDiFyvfoDMxeBQk9lPuumrXF8bAyIf4CpzjT7MjY=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MHh3NlJxS3VlaUFjclkvckJ4NTJoQXRadkF1UW9MdzlVT3dYcnRVNVByYjRW?=
 =?utf-8?B?K285UXZJUDk4dGdnbUcyZ2pob0s4N1AvckxxWnZwMFJ1Mi90OURySUNKekNt?=
 =?utf-8?B?Si9QeGlCN1NlclVEVSt2MTJqVGF2QlR4U0I2MmI0TU1leVFLbUU4eWZBcUJJ?=
 =?utf-8?B?akFzNGlMaGJ1VnU5MTFuaFc1bjhrcEk0L0ljMENmdk56QjhPd0ZHUTVtWTJM?=
 =?utf-8?B?b2M3OERKVlJmcU04eWF4aFNPNEFwNU03UzlMOUV0Tm9mSWR0ek4rRUsremp6?=
 =?utf-8?B?SEdBcE9ISGZFQktVL0RtUkV5UmpIekc1RXhnYUhHVDNKQkR4ejJyaG50bmZs?=
 =?utf-8?B?Sll0OG5jV1NPYnZxVk9mTXU1YXZCRWdYalp5R0dFemVESXR3d0x4dWlOMENH?=
 =?utf-8?B?UDNPSmFvSVEzcVY5V3RmTUR3cE1GYlpkdCtUMFZZdlZRUHhmWmU3anV6MUJJ?=
 =?utf-8?B?UEI5RXZmUm0rRkhpNE9qcEdyMDNlOUNDcGkrZEFpQjc1WkJKcC8wV0VpajZh?=
 =?utf-8?B?QnNMWDZKRXkrZGd2YW5MeUNsOTNTckw2TnRrcWlOblJUVFRVRkVRdXZBTTlX?=
 =?utf-8?B?YS9mNTNiOXd3eXFYQmRFVDlJWHJwVFNpYlp1UWJIbmxwVGNpWG5XTnpyMldp?=
 =?utf-8?B?VVdTWCtuN1ByS0NUUm9tYkRhcGNrRTUvVm1iUUNiV2dJcDRHVG14UVFzZG5y?=
 =?utf-8?B?OGl4c1FXZXYzTlArc28yMjRNUlAyN3VqenVwYmZ6Y2hpaC8wSEhZV0IyNVpr?=
 =?utf-8?B?RHJvaXV0aEswZ3F1bFozUlBtTXVCN05mc1dpTjh2cmpMdmY4NE1UU25hQlh0?=
 =?utf-8?B?QjdOaWV0NzlaOVZseHh2VSszOFhPTldxV3dKMXFVQWlZZFRrVUJEbFBKTDdT?=
 =?utf-8?B?aTRZcGppcHNIcy9neXNlNjNZQXFMQTlqbnp5elU2MjBZRzJDbFlMSFd3R0Yr?=
 =?utf-8?B?cjBCUHFqTmNla2NZUktpNTdkdlVCZEx6b1VuSmNKc0pydmxzS1dmS2pVOWdN?=
 =?utf-8?B?dkVSTkt6QVE4NXBpQ3JONTQ2Uys1NWZwbWZKc0lNSG9oM2hDazVHbGRBMVdq?=
 =?utf-8?B?YzMwWnVVakl1c3F2K2liTzRieFByZnJhT0VDREJMYW9nVWJqOW11NFFTeTFj?=
 =?utf-8?B?RWZCTWdVVDZiTGhyb09CUHpycjZ3SzZ6cjQxN0NPWGxnUm5sNzRWLzcrNU5H?=
 =?utf-8?B?VWxIbkc4aERReGlHNi9NWDV2OGZpUkxHLytqYys3YXpwdXJmSU91TDJ3WFU5?=
 =?utf-8?B?Y3ZGZkI1NXkvOWJsVXhEbnhNODBvckdaL2NHSmc2R3dUZ1FQcTVYNXlXUi9W?=
 =?utf-8?B?VlRidGFTWWpKVmJNdGpCTDdoTWUwM2xRWTNHVVlYTm1SbG5rQ2kzNm1FeWtW?=
 =?utf-8?B?dVNJcStiOU80UEsyN1p6V1lIWE9RbUwrRHNXWHd3Y3NGK0E5UVQ2MjZ2dG9H?=
 =?utf-8?B?RXJHbTl5YlgrZ3ordm5XY3ppRW12YVFQcVJRdUNZSkwxcHl5ZkFDRjRSUUtL?=
 =?utf-8?B?T0VITzNLS2pyVzJGNzU5MGRmWWVYbURzcjFIOU4vUlZFb1dFMFlsWG8wcm5w?=
 =?utf-8?B?RVlBelJRMkhkbXU1WWEyTU4yUW96RDAvMEJ2T1JUMHZGT3N6MDgvalhWMVV4?=
 =?utf-8?B?b29KV0JtM1NnRFJnYlNhRGZNWXRDYnRReEZpaXdxU3FiVldmaTV4cnVRYkdU?=
 =?utf-8?B?U0ZLNkFZWG1OL2F1Rzl3NDg4Y1FPZE40TVJob0NwWVJVMmZJMUVxOFBydHBG?=
 =?utf-8?B?RHRrSWVCOGVTTGxUR0dpUHVRajM3dFJ5OVdhMGtuWi9lSlBOYWZXdUNENVhY?=
 =?utf-8?B?bnNDMFB0RjNWak5lK1ZIOWFTdW5yWjZBcjFSclA0TEQ1bTQ0UytYQjljVWtP?=
 =?utf-8?B?bnF1VU5Od0NQQzByUmV0M3pqdG81YXFwYk9VL3BYdXQwNDA2UWQ3OVJMWnlw?=
 =?utf-8?B?NHVla0JhTVVDUmcrVXhuR3h0VHVzNHdJYnNYZXkvK1E1Y1VpZlBQdmlBekpK?=
 =?utf-8?B?dklpTjgzMlNNRWNjQ0VyVzRURGx0RVdTeWgxN0J0K0x0QkhqejU1MWVIcytC?=
 =?utf-8?B?TUNoVUJVWEVDeWFNKzNqZEI3bEo4YnQ3QTlPNk1HNW02aUJ3MTJjYi9PNVla?=
 =?utf-8?B?RUFyQzBTWnRDSXhmOGVLM0lRdGZHdDFjcUdISjduNHAxOHFtbmg2dzFQeXJs?=
 =?utf-8?Q?0r5SUu15G7g97Y/AnS78Ii4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a797a47a-9fe6-42d2-d6d3-08da0336a07f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ZOFqMzbzlPIpQMhstEeM4sj1Ta0WbHamb6jXF+rUPFp9yoZIQ+I5a/wesoMtP7VU0sRhhGx+NF8m8OuD70MV8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3663
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: t1rBGriRM_7GA2boc4WGfWZ3RhctC89Y
X-Proofpoint-GUID: t1rBGriRM_7GA2boc4WGfWZ3RhctC89Y
Reporting-Meta:
 AAHDy+UN22jpXj4uJmQay1/hnChs6lyg3Ugxp5L+bPJ0+bYd6nOzLA8MoSsw3A8n
 F4h0R02Qs+BAxla3NiV6URsl1dwOFUnrOlC/6l3egpzWxsMfCroUpCave7/CCLcM
 2W208rgjaqW9asOFBjdoCGSe9/wbHzT3r0nPFjFwY4WesbnNHvuSx54IpNNbDLIA
 nsWrOc6OCcoPkACrk9LzBtzogGl8YFTCKW4Alv3VKNA6BRDlUy502OiGRrmr/Y4B
 bjiTG+/Azf/y5sDImCVptWMBAyXC8bXe2UdXguF6vgaydIvn+qDUPetiXM2OtNoc
 NeJOsj2bm8cEu4ggYrSKptdX3GyAw3KadVxDscY1u39afHFWIZDG9RFYbvI3g1yE
 fl5tJC7mbbk1VqOdN9357gdiJFC5d7Loz3Yq1rTFiPhZ63ltcDZW6UGIBdl60KJT
 OcgCHpGmt8AIZ6+VISmEdCoK9oZ+VCnOrC727Xp3do8xwqSday3a6xtHdVtNroAv
 U3D9SSCpnGGteIDWI2Sqt5xifFWaqpM0vM6B92zOh8xR

On 3/11/22 10:33, Joseph Qi wrote:
> Hi,
> To prevent the crash, I think these changes are fine.
> But it looks wried to spread the check of ocfs2 journal.

Yes, I have same feeling when I'm making patch.

> Can we intialize the ocfs2 journal much earlier?
> 

calling it earlier only makes the gap more narrow not disappear.
(another way is to revert the commit da5e7c87827e8, it will make author unhappy)

I'm just learning ocfs2 code, don't have too much knowledge.
please forgive me for below foolish writing.

IMO all dirty data is useless on mounting phase, and can be safely dropped.

(or IOW, all the dirty data before journal init should be dropped directly)
I have tried to mark readonly when error happen, want to use readonly to skip
write operations but still crash.


I checked __ext4_fill_super, who calls ext4_load_journal lately too, but it uses
specific free steps before function return. Maybe we could do the same clean job
in ocfs2_fill_super or ocfs2_mount_volume(I prefer this func). This idea looks
need to write some new functions.

Thanks
> 
> On 3/10/22 6:58 PM, Heming Zhao wrote:
>> Call trace:
>>
>>    ocfs2: Registered cluster interface user
>>    dlm: no local IP address has been set
>>    dlm: cannot start dlm lowcomms -107
>>    (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>>    BUG: kernel NULL pointer dereference, address: 0000000000000030
>>    #PF: supervisor read access in kernel mode
>>    #PF: error_code(0x0000) - not-present page
>>    PGD 0 P4D 0
>>    Oops: 0000 [#1] PREEMPT SMP NOPTI
>>    CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40...e84
>>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
>>    RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>>    ...
>>    Call Trace:
>>     <TASK>
>>     ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>>     evict+0xc0/0x1c0
>>     ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>>     ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>>     ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>>     mount_bdev+0x182/0x1b0
>>     ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>>     legacy_get_tree+0x24/0x40
>>     vfs_get_tree+0x22/0xb0
>>     path_mount+0x465/0xac0
>>     __x64_sys_mount+0x103/0x140
>>     do_syscall_64+0x59/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? exc_page_fault+0x68/0x150
>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> How to trigger:
>>
>>    tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>>    tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb --cluster-name=ocfstst
>>
>>               == there is no dlm running ==
>>    tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>>               == kernel crash ==
>>
>> Analysis:
>>
>> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
>> Journal init later than before, it makes NULL pointer access in free
>> routine.
>>
>> ocfs2_fill_super
>>   + ocfs2_mount_volume
>>   |  ocfs2_dlm_init //failed, osb->journal still NULL.
>>   + ...
>>   + ocfs2_dismount_volume
>>      ocfs2_release_system_inodes
>>        ...
>>         evict
>>          ...
>>           ocfs2_clear_inode
>>            ocfs2_checkpoint_inode
>>             ocfs2_ci_fully_checkpointed
>>              time_after(journal->j_trans_id, ci->ci_last_trans)
>>               + journal is empty, crash!
>>
>> The fix should assess osb->journal before journal operation. And the fix
>> should be only related with abnormal case before ocfs2_journal_init().
>>
>> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> v2: revise commit log
>>      add checking in ocfs2_dismount_volume()
>> ---
>>   fs/ocfs2/inode.c   | 3 ++-
>>   fs/ocfs2/journal.h | 2 +-
>>   fs/ocfs2/super.c   | 7 ++++---
>>   3 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 6c2411c2afcf..3826ab7eab3e 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1205,7 +1205,8 @@ static void ocfs2_clear_inode(struct inode *inode)
>>   	 * the journal is flushed before journal shutdown. Thus it is safe to
>>   	 * have inodes get cleaned up after journal shutdown.
>>   	 */
>> -	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>> +	if (osb->journal)
>> +		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>>   				       &oi->ip_jinode);
>>   }
>>   
>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>> index 8dcb2f2cadbc..1610d49b4112 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -189,7 +189,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
>>   {
>>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>   
>> -	if (ocfs2_mount_local(osb))
>> +	if (!osb->journal || ocfs2_mount_local(osb))
>>   		return;
>>   
>>   	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 2772dec9dcea..01f1ab7c8de8 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1886,9 +1886,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>>   	/* Wait for worker to be done with the work structure in osb */
>>   	cancel_work_sync(&osb->dquot_drop_work);
>>   
>> -	ocfs2_shutdown_local_alloc(osb);
>> -
>> -	ocfs2_truncate_log_shutdown(osb);
>> +	if (osb->journal) {
>> +		ocfs2_shutdown_local_alloc(osb);
>> +		ocfs2_truncate_log_shutdown(osb);
>> +	}
>>   
>>   	/* This will disable recovery and flush any recovery work. */
>>   	ocfs2_recovery_exit(osb);
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
