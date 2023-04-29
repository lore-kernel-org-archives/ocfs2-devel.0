Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB48C7618E
	for <ocfs2-devel@archiver.kernel.org>; Sat, 29 Apr 2023 06:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XznhmqTurGuvNNIZuvr6DJRGcdmyJrzF+kDJ1C7mTC8=;
 b=X8ugSbxAJJ/2nqVUtPzuLhtwbbcHdoFwUinNgJfz4txrhr2a0nSXABSwZ2jgtsUHnZju1GmdlVAv
   uqU+21/yjUcISzdnXok9q/zCmbS/AdtWLW6PV3+O/N6Au7Z39ZR3Eff7RJW8/hOx8+RwMFklBgXt
   ACnbDax1oioHDzxJVXQndhUVZP50pSD/pjbs9Gt0deb3c3o5BBjY3uQUPSz3Jz2Nnum4Rg13V2E7
   UVp9ezlosHjdvEGQdoQFig50NdJc5ORx0OhCMRepP/SFv9Dz+0AvVbObg13b3UbHgVX+pJ4bU7QF
   PZfndS3ehJChyvONBxpLyJdpFWH5PVBxnbFj4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XznhmqTurGuvNNIZuvr6DJRGcdmyJrzF+kDJ1C7mTC8=;
 b=Gbo/GPpvN9ClysWB+oR6YOYbISeFdMkIGRHw/P0kd6/E/lPzVbGJxV4ZvCBGOX/ncUhLYKj+gOxm
   Z9jL2FI46Kd/FZ90UflL8MRxk/pc6hGuELgwZGDa29dVCqC5l6RIJJ81IvvoLZmbYbcU1AMrXeuX
   Nr4PPPzGfOmGKsVdOlg0uB2KmwFvIGmiZTCbxHn+aZssPaPkIBlCJz6SMQWma28dqnfYCtnIRd3w
   jC0XfCeYd1gYJCRTakzVG7Wwd9HF1Y/TSNrcJOcJBPFZXTmMrNrfQN6CLWTavw4IeHTMzKQuI2sq
   e9Ewh85PyAtFyHCFjjBkQFg119I23o4rPP55gA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTV00JYL6GHEJ00@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 29 Apr 2023 06:38:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyxsSvpdFWEfUxHARqEAJhIPCXM3p1CJR9X2OQinGO0PKqQ8LJtRX1MS49uciXlxUWNLFtlQ6AhoLuIxxG6p6pazvR6qY2ohlxq0Wen+lDA3Wrq0ByNV2xpy6IzxcZmiuw/LDO8059wxQkf6jGICZMbewaVgr4zxiCFf8KFL5w/OB88Rd8+uOMsvD5DOOTev/9u0iSY5kNACf+naK/JnZI11HPy85fUpwJyAXYXmwTQ5Xdx4b1Vcu6J/6+EE2TZwg6U+oxaUHon8yxtARHY4w0edX88UN7UExpDRfjPpvJrElWPVgxFJI+iYx7OaHHIhYylghEMQEUaM0MgtlJOEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGahX+6SD/TFvLsqqNfXzsZt7ZIMWCz6ryL0fjqI8CY=;
 b=hysbYbbOrsy4QBxH+eOLMSAW0buLnaQfoGFWG7cyoD9ClM3rF4X8zTcIQquHPWxdvmcOqkl9Apo3vGGGVE+sNPlzHylLwMBXvKCVvmGcYB4o0bSsc/29EdNEeTP02gUrDS84E7lcl/gZRHUEDBkwgpjvjLeGrbzUGNkyk5L79dLd1mA3hiwXKq/RdWm1T2igXeQNk/79YGuem/OUQJabng+SoPJRW2CzKwKvHgXRB9efBOuArvypb3ryF9J4p1oCMJUulY713PbeAqCaPpWo+kbyQO7Yd1nZZ2MH5mB0JVhaC21btQbD89326Vv1AbeqjrX4KhvvUYsT9YgnkwhNpw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGahX+6SD/TFvLsqqNfXzsZt7ZIMWCz6ryL0fjqI8CY=;
 b=vAp/92pHniINc09/TO7VmgCkJVi+IfPVgp5KTOvTjL9iDzMqzwOUq+pnf1GQ2YDFBF/qAy6pKOo3lwYDcciNlgB9o8vv9SwTKM34DIeqe1FXa1la0ucWagHC1NeKFBPSx5HGqTTIp4mF5zXgrePMOwArqDR9FBSM3tfBi/KgZRdub/KrLhRxKXCuwuGLkL6BS0FsH8dLE1aqT9wlfh6ZtDknxuSRtNXlxu6Vg/dpqNvkJS5CXWZT7mRhavW9n7/UwVvYbvLiM+3vADoRfFgdtZRCK94A6xguStdmQ++Mtce3XT6rkYmuPb83AziP3UP8v/aPSW6LUCBdzeOazaBDng==
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20230406154052.9863-1-heming.zhao@suse.com>
 <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
Message-id: <b8f89579-118b-7697-f77b-dee588c3d3e0@suse.com>
Date: Sat, 29 Apr 2023 14:37:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199021)(66476007)(478600001)(66946007)(66556008)(31696002)(86362001)(6512007)(6506007)(26005)(53546011)(2906002)(38100700002)(966005)(44832011)(6486002)(5660300002)(36756003)(31686004)(6666004)(8676002)(8936002)(83380400001)(316002)(186003)(6916009)(4326008)(41300700001)(2616005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2023 06:38:03.2006 (UTC)
X-Source-IP: 40.107.7.49
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10694
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=185
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=145
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304290062 domainage_hfrom=9713
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
	__ocfs2_resv_find_window
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
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB9992:EE_
X-MS-Office365-Filtering-Correlation-Id: ea84cfed-1647-41e3-5165-08db487c4857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 IyIuGXRW4a9ebiQBF9qaPxjZNGvP89Z+b9TKMwO1+6hbuKTwUt0SSP14J4akrXi84+WZ+/J+j5vBCwlvuGyNii1wQQ5AN5it8FbKvE7W51EHxTAVLPWmsdmmfq5oCaUneHzJmX0wJw4uA/Vk7v7VpO68TPGOl0SbVKNL3R8Hw1uwI46pPWdWYzmZ8urm7TT1tWXR3wGbWGn8LFoYKVOJHSxmwhTDykweYvAJN6SqR6Cn+vzySyuEQmvT+62SkbQF9e9hoqWdxau9XjeR8BfKS4s+rGcyFHBh11VJZ4NXhJ/aiyHzKhq/kK4rJcWIV3qiqzF8yCVFa2WJcKH4/QUw7wa3KCjJi94Vj1Z5yzAd5oFVjQroN6CAUJN5caanhb4lON1CBJ8gaCyTc2xBOOp7LBOwduiXiD2aK7JpAlHA+3H/V2XQBHLcZRZS16jkrYKEBgN8mBNDnEUl+lhHlbLkhXS3T49dhFtzC1xRP64/blly+U7N+zBg8wUJPdJ11mbT/ODaw7zDv2dP8sUZ5YxWcScp58FLHCkFpeudVkIf78pCvnx+Vx1IYl0TN4LrfOhrYslxz63f8YNOFENIkzCce+xNbT3T9HntCObR9TjxnjAsgCUbyiHcSIm4eEpy9bzFBmExIVvFnp3Ng4rxIOUhzg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZVk3VUE0SmRuMS9DRVc1a2FBSHlhMkJaNTQybVBOT2kvSG4wMVY1S3c4d0o1?=
 =?utf-8?B?QzJ1ZWQzaFREVUhTRTVTVXNZZmM0R3ZsVFRacGlCSktnRXZxM1pDZ2hJSlll?=
 =?utf-8?B?OEs1V2M4alNIRmJoYWhZRWNtUXBURXUvL2lnNDFpNVFjenB1cG95SUE3bDNJ?=
 =?utf-8?B?WlcwSVlxTzdLZ1JIbHQyOE9YTzRJajVObW9LS0JRVW4yK216eU9TQTRLQ29y?=
 =?utf-8?B?SCsxeE1EOUVHWjFkaVpHTEMvZ1BFUk5Oa3hicnE4a0tzWk13Z1ZGY1dsNThW?=
 =?utf-8?B?U0l6OUp2VFRucVVMZVgvZHZHZDg2U3hzK1IwSzRiS3YzeThpRG1wOFRlNFk0?=
 =?utf-8?B?dk9xZit0UTEyWFprWnlSTExQNjJiRmVseHc5QXk4VElWRmdTZWxtSkd3R0N6?=
 =?utf-8?B?anp0L3RSTE5UR0JIKy9JaC9KTFM2TCt1N0NWZnJxM3pkc1ZQVGFJUTBQQTVw?=
 =?utf-8?B?a203TWNOd05MbzhnekQ1ZUx1YjdIem1yTkcydHQvaXVkZzBpTlFMZk9KaXdi?=
 =?utf-8?B?QlR0aWdidHVEd3Q4amV6akZTazE3Q0FOdWJQSTltZGVBUjdIOFJRUUh1dTJS?=
 =?utf-8?B?cGprRXdGZjVnaG1VRFRhZVBZOGd2djJyWW1uWGtWNWEzalk1dENYeEJHNFpa?=
 =?utf-8?B?Q0RSWGM5Ry9uV2t2SFJCSUhSNVpzZDJPcWhsZkdmQlJ5cU03Wms0WXlqNHZH?=
 =?utf-8?B?ZjhFNXdlYU5oZHVka0VxelRKNms3YXREVTBzbkhCK1NEbnUrR2wwN0M1Wklj?=
 =?utf-8?B?VDlGMWs1SHJsZ0RFanZtTjRDVzQvTmo5cXBjM3V6bmlEREtmYWhaTGdBVmJK?=
 =?utf-8?B?OHlGYzVMRVRNNHgzSGx0RVNsMldOSjVkZHVXM2JkdHJSVHFBa3ZrTTRRVXVo?=
 =?utf-8?B?ejhRS1JiUm5GNzZ3aTFWQXBGRTBOUytQUmVleis0SG9XS2dPdDVyUVNkTEgr?=
 =?utf-8?B?aS9VVk9FMmNuUDE1bFczWTkyMStLU2NvZnFSUGFwdzZlWDhNMEtDWGZodzRF?=
 =?utf-8?B?RHBSSU1ndDFZaWRVL3NLU3E2bzlzZUZ1YWF2RktYYUdkcUROKzJpTUR6ZVFt?=
 =?utf-8?B?akYvYk11VTRac3crWGpjNnJDc1EvUEJiRjdranFubzBMK0orbVpzcGM5aHRj?=
 =?utf-8?B?V25TTVZjQmtEaFFMUDRRbnVPSXptcEZWWWVKZkFVQnZlN2phZU12ZXE3SUd1?=
 =?utf-8?B?YzJQY25JKzl4Ym1xakVvalFIcm10YVZqaWplaVNiZTRWYjNaV2xnYXFLSW50?=
 =?utf-8?B?Nm5yZ1pIU3F0dUxaZzhGL3BLdU1OOGFORkJQc0kvNldmM0YrbW9XWDl6WGdv?=
 =?utf-8?B?U2FyV29IZjRDZkVwWFlhY3NNbkRyRmZQK2pjQVpBclpLYmtDR0pGd1ZHdUVI?=
 =?utf-8?B?S2l2SEIrcDhINW5SRTF0cDJQVEw0bENUYjVySHhSWU9lVjBPZkN4eXhLYUxx?=
 =?utf-8?B?elRYcWc5ckVJTUd4aGlyWHlIbERPQzhpd0NYcWxKSWoxSW1IclRYWWJwSkN5?=
 =?utf-8?B?MTZQcWJwaFlpNG42dXFWOGhoSWdjSTRIQ3lnSVo2T0NubmNBb2E4RmxncDFD?=
 =?utf-8?B?QmJ1eTVvZ3JaVVlQZ2p6Yjd0ZDg4V1BFTWs3T2NkTEtTVHZXNWREWVBObXJJ?=
 =?utf-8?B?cEVrSVpmNi9VT2RwUEZqbmU3aUpMS1JsL2tyVnZRTDFoVjRmSTB4Nm43Ulpw?=
 =?utf-8?B?Z090bHp5WFVocTJIYzFpa21XSFA0aHZxNTg1RGt6YURNU0xQZnJBNWUzWGZF?=
 =?utf-8?B?cjlkVGplMDVYOGZlNDlnQVN1RDJlS2l1ajhMVUVjWHVmSCtxTWx2OHorbzRH?=
 =?utf-8?B?MWtCaENvaXJadmova2IyeGZMWHljRHJBOHI0eEdZQ3A3dnorcWd0alUzRXNB?=
 =?utf-8?B?OEVIQzRtdlYxdlNMWG4rR2J6N25NUmRwaE90Uk1laURBejdRaXZnSEJ4K2Fu?=
 =?utf-8?B?b0JiLzg2Q2pmUXFNS0o1TmxncGJIa21RbTdmb1psTjQ5WmxJWEVGTnU4NE85?=
 =?utf-8?B?RWRQb2hjcklPcmV4Wnh2YXFUMithWCtONGZzMTdWbi96NHU2N3lnRGFkMDJj?=
 =?utf-8?B?UnoxRGtiOEpKZ1Zub0czcXNJSFBlaTlpTkR6VEtvUW5sSm55SlRwOUFWU0Q4?=
 =?utf-8?Q?mSWutYjRnbAE2ifBLXwYxjIy4?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ea84cfed-1647-41e3-5165-08db487c4857
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 sGR11dHbB6svOYgaU+O+Ygz2O7UfEP5yMqBYZtNZ8S3dXJM14kxiV9hIOZ8wKQ6RpYJdhQqRhIMAugJHviRMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9992
X-ServerName: mail-he1eur04on2049.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: sZZLkdIAIpi2rCK19gT8D-GqYpqZZFxg
X-Proofpoint-ORIG-GUID: sZZLkdIAIpi2rCK19gT8D-GqYpqZZFxg
Reporting-Meta:
 AAFbYXZESRWWhznaiZ9G1+Cl5yq3c0Enmh52fCE2LsFFhdIXJjgrygpzIwNdxYhD
 ktAep6z0AesnlPUkzMV33e9cJvM/DpFiPAwl1xesodiCdg2h2Zm2rnyXW2TCSzwB
 cGbuaKuOwv6X5omFu09scTGZL0XhM2bYcSQSHXwO9ODaf8HXRWajeW8I3lIRtfh6
 VbtlOFnPSeF32ODP/ihiTPCDpEEiqn3NujlAGeVFlKpVxzQAkIExIKsqVt194339
 7JdwCwATRpUKjPL+ytNomAoUL/C+yzfC7Q+gKAHXzA1EcCfbBsh3DqsZXcaPZ/dc
 faL7r9/Hu45k3I04duu17f8HvKg89khr5+rs0ISd6Jzuslr7ckHvOZf0HTgHOQvp
 vGmT9rs2SO4a+68K+fwcfIgGlpqz6yOp3UlkmD9lYqqROYO5r04JzUpjZtjXP8P9
 RIjsOjo4x2y9s3h/S/2yuSIDS6o1m8pKjZQcnZdLtIH3SlHR/h7p1YDMTv4jx/1k
 YrUtMrEmWfRHxVbbCrLANWg2nmIbB86b8N3Ga3MAfgg=

ping...

On 4/21/23 3:35 PM, Joseph Qi wrote:
> Hi,
> Could you please share a reproducer?
> 
> Thanks,
> Joseph
> 
> On 4/6/23 11:40 PM, Heming Zhao wrote:
>> ** problem **
>>
>> Current code triggers a defragfs bug [1]:
>>
>> ```
>> tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
>> defragfs.ocfs2 1.8.7
>> [ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
>> [ERROR]"/mnt/test_from_dd1":No space left on device
>> ```
>>
>> I added some debug messages in relevant functions. When above error
>> messages appeared, the la-window still had enough continuous bitmap
>> to use, the -ENOSPC is wrong.
>>
>> ** analysis **
>>
>> __ocfs2_resv_find_window should use resv node from rb-tree to do linear
>> search. But current code logic uses un-managered area between two resvs.
>> The searching logic deviates from this func job, which should only focus
>> on reservation areas (when rb_root is non NULL). Another issue of
>> __ocfs2_resv_find_window is more inclined to generate inner fragment.
>> It doesn't search & consume existing reservations but be apt to create
>> new reservation item.
>>
>> This patch pulls this func (__ocfs2_resv_find_window) to do what it
>> should do: search & consume resev. if this func fails to get suitable
>> bitmap area, caller ocfs2_resv_find_window fallbacks to use oldest
>> resv from LRU to do the final search.
>>
>> [1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/reservations.c | 48 +++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
>> index a9d1296d736d..eda672622d1d 100644
>> --- a/fs/ocfs2/reservations.c
>> +++ b/fs/ocfs2/reservations.c
>> @@ -458,10 +458,11 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   {
>>   	struct rb_root *root = &resmap->m_reservations;
>>   	unsigned int gap_start, gap_end, gap_len;
>> -	struct ocfs2_alloc_reservation *prev_resv, *next_resv;
>> +	struct ocfs2_alloc_reservation *prev_resv, *next_resv, *best_resv;
>>   	struct rb_node *prev, *next;
>>   	unsigned int cstart, clen;
>>   	unsigned int best_start = 0, best_len = 0;
>> +	int create_new = 0;
>>   
>>   	/*
>>   	 * Nasty cases to consider:
>> @@ -540,8 +541,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   		if (clen) {
>>   			best_len = clen;
>>   			best_start = cstart;
>> +			create_new = 1;
>>   			if (best_len == wanted)
>> -				goto out_insert;
>> +				goto out_create;
>>   		}
>>   
>>   		prev_resv = next_resv;
>> @@ -557,13 +559,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   	while (1) {
>>   		next = rb_next(prev);
>>   		if (next) {
>> -			next_resv = rb_entry(next,
>> -					     struct ocfs2_alloc_reservation,
>> -					     r_node);
>> -
>> -			gap_start = ocfs2_resv_end(prev_resv) + 1;
>> -			gap_end = next_resv->r_start - 1;
>> -			gap_len = gap_end - gap_start + 1;
>> +			gap_start = prev_resv->r_start;
>> +			gap_end = prev_resv->r_start + prev_resv->r_len - 1;
>> +			gap_len = prev_resv->r_len;
>>   		} else {
>>   			/*
>>   			 * We're at the rightmost edge of the
>> @@ -575,8 +573,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   			gap_end = resmap->m_bitmap_len - 1;
>>   		}
>>   
>> -		trace_ocfs2_resv_find_window_next(next ? next_resv->r_start: -1,
>> -					next ? ocfs2_resv_end(next_resv) : -1);
>> +		trace_ocfs2_resv_find_window_next(next ? prev_resv->r_start : -1,
>> +					next ? ocfs2_resv_end(prev_resv) : -1);
>>   		/*
>>   		 * No need to check this gap if we have already found
>>   		 * a larger region of free bits.
>> @@ -589,10 +587,16 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   		if (clen == wanted) {
>>   			best_len = clen;
>>   			best_start = cstart;
>> -			goto out_insert;
>> +			best_resv = prev_resv;
>> +			if (!next)
>> +				goto out_create;
>> +			else
>> +				goto out_insert;
>>   		} else if (clen > best_len) {
>>   			best_len = clen;
>>   			best_start = cstart;
>> +			best_resv = prev_resv;
>> +			create_new = 0;
>>   		}
>>   
>>   next_resv:
>> @@ -604,12 +608,28 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>   				     r_node);
>>   	}
>>   
>> -out_insert:
>> -	if (best_len) {
>> +	if (!best_len)
>> +		return;
>> +
>> +	if (create_new) {
>> +out_create:
>>   		resv->r_start = best_start;
>>   		resv->r_len = best_len;
>>   		ocfs2_resv_insert(resmap, resv);
>> +		return;
>>   	}
>> +
>> +out_insert:
>> +	if (best_resv->r_len <= wanted) {
>> +		resv->r_start = best_start;
>> +		resv->r_len = best_len;
>> +		__ocfs2_resv_discard(resmap, best_resv);
>> +	} else {
>> +		best_resv->r_len -= best_len;
>> +		resv->r_start = ocfs2_resv_end(best_resv) + 1;
>> +		resv->r_len = best_len;
>> +	}
>> +	ocfs2_resv_insert(resmap, resv);
>>   }
>>   
>>   static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
