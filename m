Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5700C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 08:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3lWoz3MXn5vvoF7B00NQUnKj3SRdrBtM3CwVbzif1+I=;
 b=tHvGBmUJWLW5gBhjfSF98ZFlQZZ9IMJORT2N9Bo+ov1VIJf6sNXBa5s2+T2DEyj2MKGmj5Exo+J7
   Cigmkl/dCYtzUc+PR0giVqgJ7nr1bEyrlLywbkAbjTgT9E96ijaypvorVbDot3a5lj1QJ6+kK/Nk
   XBByvWXZKge8V+7ARV9E/EjK0Pbon7K3FtpRlGoOQA3Oc82slGSyvKuMaMmEZlG2L7ovKUQp5fkt
   /v6BgvAh40NYSNfR1issqkRTx2PM9vP8K863LNnTavLxzKj2/WXMypjdx0XLaPxcTCvjXvp4Ag+R
   qdCvG6ZSWt7/j2LMz3CYY8WiWuiGQNKWhZbo2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3lWoz3MXn5vvoF7B00NQUnKj3SRdrBtM3CwVbzif1+I=;
 b=GMH+x7TJn8nXjPa9rcABwtQCoerp/6HUSuOuLLlVURibJMoiYzEeCJ9lS4snKO3piZpx74W0Fclr
   0ixgk8gwg87Kus8vf9mTjsrlXrD2zVnPXqKD453hb9twmPOOeTD3DXWlkrfHOfK/Z9oiI7v9S0tW
   oIjV/KiGEr6jvXnb2uRbXmOD6cLglS/vYz1SfrFTjMCzEYzneJgp1p7sZUdkwhXmJYwWDAwhpRdA
   BQiYY1jY8S0Rf2Cddf5IXngLEebOCSNnNDxMCWdgLPJ3Lr6tNQBmMzWwnnJDAYV5w5xgdHts2eze
   vkxnHlx3vbJKUcwfb762TgcHh9iujvTkOCo45Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8I00EIUSCAI290@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 08:16:58 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1646900202;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eEBq5BMovTqvlAl43Fturdd55y3VW3Ib1tORnNaQ6Uc=;
 b=Ub694U3oFTH0dYCXXbcNqOkqMPPQlfVgb2phgjSwVapoGUO1/TGDUTGB58ihu2VxVVTctY
 l+8IvENwAmAFCziCISwY/k+CiuslpWtkwubvT3yUIrtCadrCr8cPrEb4v27X8jDFDiG9zS
 ETRf66moMhrKOFxteZklF7HdLcrs6yU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIZXVhVtbQenN155S24/Pk0d0CShQjJFHdZnVY3nqgqfdzEhKlx8Lsg1j9Tvn29Cbc/Z9Q6J8RUc3PWRb830y48CtjdDFALbGREEYFZbZlCHtJHOCVr/6EDlaEVYsUrFhRS1+lOJQYZeAACt9K95oRydzF/deQJowsYBZqf3qKcQG795y2N7JCJt64J4AkpV4PhUi2C9+ggMgnls6AC0okQNBjYBiD7U0UKC76qe6hVmO7FL2B8eRm49FduOJOT/EvnhluzkDMIA5TDwGyKxwMK/DldfLi33RteQLKfM+S3MWN4Y+tD1gg+G5cED6HviveRgl46qOGqQ4mAnQ0Rt1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEBq5BMovTqvlAl43Fturdd55y3VW3Ib1tORnNaQ6Uc=;
 b=BoyiVXZrLQP4ktYzDEdbjuedu38HHUCdWNoxODr5dp6Y7GVqvy5KORv9d1xqesYKi9/UynfzLfx6hQo8C9hN99+RLfMOhNlQDca6WFdPMK1tSN36iP6zIv8Jq4Y0PzQNz9SAEPJZER3PJOolZQKFL4OuKYNh4+xcO344RnQ8hB+gLRBClusGv43XnHyU9B44mfhC+zRHydzzZOPsCFk4PYzY9f08AVYY0qA7F3R4NtMQnzY1+5rhho6vJnyHr+AL81BazPESWZwKz25SIcvGpPmpWcXnsV0UtxryRKVH64YD4OT03K4AQZBWvRlrEoHAX1+uFZ7F9/D97YtziniidA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <78cb02b7-2383-e3bf-a1f4-2358284d337c@suse.com>
Date: Thu, 10 Mar 2022 16:16:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220309133020.1869-1-heming.zhao@suse.com>
 <9db2a983-361d-8e14-277c-e0c34740004e@linux.alibaba.com>
In-reply-to: <9db2a983-361d-8e14-277c-e0c34740004e@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(8936002)(6666004)(38100700002)(6486002)(36756003)(86362001)(2906002)(31686004)(5660300002)(316002)(2616005)(31696002)(6506007)(53546011)(8676002)(66946007)(66556008)(66476007)(83380400001)(6512007)(186003)(26005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 08:16:40.2394 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=228 priorityscore=108 malwarescore=0 suspectscore=0 impostorscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100043
Subject: Re: [Ocfs2-devel] [PATCH] fix kernel crash after mounting when dlm
	doesn't ready
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
X-MC-Unique: 0zoj0iRAOfeIGXdu-2YkTA-1
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b9f73b5-4b97-4ab0-f27f-08da026e4d9f
X-MS-TrafficTypeDiagnostic: AM6PR04MB6150:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR04MB6150F8E2F8434ED58C9EF1CA970B9@AM6PR04MB6150.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 kXp+O2c5NnBOtuYid7H952nouLmGuEH8iK2Pk0xMuoEu4xuFU+lID5qGDkpj471uDVokeMXrBchNmSPYD3/hHQd+FiPVHu+n9UHU8guInusEGE14toOxbyu3T/KHUYluf3TGquFO4gSehSUiAnul9RA62IjennsojjZIpEnyvkeYB+zo1s5xRjBgTwb+vEgKg82+OdbxiRDGmG7yEX5GcD9pHzWt6MLuGesCQBsoyNEaxq8HU98pKa9slC2sDDzCrtUBnI0Lw1m3MGu5iFJK1J5801SIRdWiFkIteQGJ+o93QVdaBLhyUjaq7GCx1GMmONaBFoPZT5tPYm/lpCrR1u+ie36dx9aSpEdpdKcnL3hfB1ZOctG68FF1f4G0zs+Wqsk+Sahf5/SPpimx90iksBdxO8Xwk8EjzavZDHWG88xdyskn0v6zIPeo/ntl8trAuX7sEYY77QK9IMbPvRezaR9NBPp1HhxbT5zvyPpznN/Beu//agkTlRvQ+rRxKt1pTFFbWChp22VvDsiLdFnnksg2pB8XQOE0eYDh3UOVMGyiyPrzXryvv1fujDIDrT2mWdq7Tgxhvw1BK4YhWKxhEtyO3lVMZ4Lz6Fvjh/hZP634ZCtQKThveJDT/1XLJaNtOjEshU6+0OS6xeSJ8jLUkI96rOuo0Y8MKtIeAeoaIGng2iE8tBu7h5e2BstlxELLf7l3MoF5krgwCNTmNi81uO69dYCoB0XcvR7Y0Aiwyr0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eFdlZlg5MmFhZ3MxRHF1N05XWFBuNWpiLzZYMGpSZlhCajVYZTM1Njh5QjVw?=
 =?utf-8?B?WDZ2MG8rK1ZpYlYxSmU5dG40aXdIODVWamZ0eVdQU0lqdmpmMnk3NlNwR2s5?=
 =?utf-8?B?MGdvWEFyaUI2UGU5dFZCYnliN0ZiRTNDS1N6SlVBRXBzeHpKRTYxWjdvazl5?=
 =?utf-8?B?Ujkxcmg1RFNvdzFqZ3dRYXRuYi96Ym4xQ1o5cVFCQWlxYS8zQ1pWZlZnUHZz?=
 =?utf-8?B?OU1jbWFRd3dFMEhGc0ZvQW1PRVBJQmsxTE45Y0lqYkc5bm15SzNMa1ZIM1lK?=
 =?utf-8?B?c0x4ekkvRWlRcjZuQ1ljU20zb0NCb0tiR2owV1dSMDhZSmczb1ZxUm1Wc3V0?=
 =?utf-8?B?L1l6TEJ1TVhwZVhBYWVvOXpLbTFBQVBtRERTU0RJb2I0cDNYZzdDS3F2SHpt?=
 =?utf-8?B?dkVBUys0bEZhTTQ4QTF0NS9mS2wvYUVVTnRLODVBZTE4YmVvdm9IYWUyY3pO?=
 =?utf-8?B?K3h0K3JiaU9pLzRTdzd2cDNyZ1dQMFAvNGpFQzJXaU9XbmtuamlaaTgxNjJB?=
 =?utf-8?B?T0puZ3UvOXhJNGo4NG1nQUNMNHMrT3Zmb2JpWUxDWkFCakFLRVQwZnVkTEgv?=
 =?utf-8?B?K2UxQlVCSE9XaGlaWkdZU0NvWHZrVldTYTkxeGsrTXRVYTQvcVh3ZkpMeGNT?=
 =?utf-8?B?VGtITmpsZDB1azJxeTkzVUlFNjZqM0dxMEtpaHhkY0JwNWJvaloyZHdFbldZ?=
 =?utf-8?B?eHE1VmhTQ1UyZDlVMjg4Y2tMejd6cEV0ZVlQYnBsWDlyS0dEWkZoS3orVFN2?=
 =?utf-8?B?dUhVbU5zQ25IMjN2a0puNURtOWw5NHZJdlBkTVhMQ1Z2R1pPVlZKbWRNYktS?=
 =?utf-8?B?T0oyUFJWdTUxZWNRMnZEOWZqZ1lxenQ5Tk5VT0dqMisxNksvWWJPUDdTc1U0?=
 =?utf-8?B?OUp1NGp3Wk10K3VKeDM1SzZwY1JFYk9IUEVHUHBUMVJ6WG5Gem9SUmNBb00y?=
 =?utf-8?B?NjhaWWVUYUZmcm1WdG1sZnJWaWE2aUhYdVVKa0tPa2hWOTlIaXVwNFJqTUNl?=
 =?utf-8?B?U0hOWTA4R0w3amJyYTRXQ2h0d1MzaTJEMGNxZnFZNTVOWWxwdGxxTXBiQVhZ?=
 =?utf-8?B?UU9wdFRaeSt1MnVvSXhjbG56RUdBcnBBY3RScCtVZGpPcmFRN3VDYUl3cE95?=
 =?utf-8?B?YitTNUtVc1gxTzlJNDRORGZ1WWpvVXBXLzZ6ZTcvcVVLVXpJS0ZLY2NoWVEz?=
 =?utf-8?B?c3gyZmNSQUNNcWVtSmtjajJKdlpwblZLNXVMdkkxdzcxbk1lTEZFVWo3Y0hv?=
 =?utf-8?B?T2dhTTVoaEJoTTl0WSsrNmxDM2doQ0ZtSjBMZE81dDJ4V3I5dzlST09ZeGMv?=
 =?utf-8?B?cm1MLzJxN0llMzI2SGRUek0zL3ZQYXI1Y0xrYmRUa05iT1Y2L1VZN01vMnZ6?=
 =?utf-8?B?UTBFbzNwL0hWSkhTQ0FoUlhMLzFheWx3WktjbVFpc3N2eDB2Z0Fsc0ZsR0tQ?=
 =?utf-8?B?aXJNMnRUb2NMcUd1M1h2OWlxQ1BlMkQyMlR6bzJGalc2Ym9iUGpFb2Vvd2R6?=
 =?utf-8?B?WWF2NVRlL3NBU2trV0RsV24ySWo4NExrR1IxbjBBRS93VFZNTmFEV2E3RzEx?=
 =?utf-8?B?d1pocWFMT0pBcmZHOVk0SmVzQ0U0R0hibjc2Wm5ydjZyTzNEaE9GUjM3d1Z6?=
 =?utf-8?B?V3NOeTV5eEpDZ2s1MWJmc0dKTGxVYUhQelE2NG1OSyt0bC84NXZ6MUR6TmFS?=
 =?utf-8?B?Q2d6dmNuV2pTUzB3VkFHTUZlREh5YTRNeFhwaEtQTXVWSjR6ZnhzMXN5cW5Y?=
 =?utf-8?B?YkdiTEd6Ym0rRUJZZm5xbjN5VE5WNEY2Sm5salhUQVZXOEd3NWE2R3Q3STlu?=
 =?utf-8?B?RXBQN2V5TGZJamloRFpxWW5LeFBSTVBITUZhb1ltUHI5eXVIRTVIOFNQQjNW?=
 =?utf-8?B?eWdEK2d3V0FJREdXNU9ybUlsVUVuRE5LbFJpVUExYmRjdjR2SWlTcWZyOFhV?=
 =?utf-8?Q?3tn+PGr7ADzlqmQdyNtwgi+wC6Ztw6RV?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9b9f73b5-4b97-4ab0-f27f-08da026e4d9f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 TDK3/t083nzNKqdLfX2N9K6U8eXkJg5czNZ2w56hSXx9UoJA+NRd/dTB32NFp3++Hug6zhHjErmZIUqA4p87lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6150
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 6YLnMTt4zAR4HMNBYJbiZAMeTjDc5Lcy
X-Proofpoint-GUID: 6YLnMTt4zAR4HMNBYJbiZAMeTjDc5Lcy
Reporting-Meta:
 AAEMvFzsLPBkPgNudAqrwHhKzthQhPfAoqV7LOkp/jBowGRfN760D9sEuQQyTJ3c
 t4AYYRR6bMkEx9qYLdxa4kFdWoEeoR1TzM//BTR0F4MzrIUjaoSOwwTsDmhDr60A
 CNThj7WDOiAtOWbR9IZnDPy6FCzLeKwsbCnZ10I6gFP4b4SksSAR/4JH8VYH+qEt
 9Q3fpMekoMf5/FJ2SIr8E9Tic4mYtuQhJl4RmMFtqCKqovqMyT65X0fdpRGVDctx
 caYT+gnwmWl/rScsWRqI5f/CjLd8zz47W7h+yhPEUWN+Oe85JXSiqctbKZ8+qmM4
 nBtT6pSUXPYgGfeEkkCZ4R0Cb4IYNniXJbdzSJ81jCfc7MvRZMBCZa01ayLooSuZ
 fwfWVuXcPl7/0kt2Pe/dkshhGPL4Ma9XVGccGUjX2pUwZDokRji8sxPUsZeQM+J7
 +h+evx5STXwJCLP7PGEqAxxWGZD8W40gxNceWwl30EoS+QP2CC2ecLN8Didl02lq
 rkSb/W9Y6BUSrCDNz4UpP32cgxXkUonCHVSEQ4ixiHM8Tg==

Hello Joseph,

Thank you for your review.

On 3/10/22 11:59, Joseph Qi wrote:
> It looks this issue is introduced by the following commit:
> da5e7c87827e ocfs2: cleanup journal init and shutdown
> 
> Before that, journal was initialized in ocfs2_initialize_super().

I agree, and will add Fixes in V2.

> 
> On 3/9/22 9:30 PM, Heming Zhao wrote:
>> How to trigger:
>>
>>   tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>>   tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>>              --cluster-name=ocfstst
>>              == there is no dlm running ==
>>   tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>>              == kernel crash ==
>>
>> Crash log
>>
>> ```
>> kernel: DLM installed
>> kernel: ocfs2: Registered cluster interface user
>> kernel: dlm: no local IP address has been set
>> kernel: dlm: cannot start dlm lowcomms -107
>> kernel: (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>> kernel: (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>> kernel: (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>> kernel: BUG: kernel NULL pointer dereference, address: 0000000000000030
>> kernel: #PF: supervisor read access in kernel mode
>> kernel: #PF: error_code(0x0000) - not-present page
>> kernel: PGD 0 P4D 0
>> kernel: Oops: 0000 [#1] PREEMPT SMP NOPTI
>> kernel: CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40a195b7ff0f3399a616c3290f963c4ad189e84
>> kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
>> kernel: RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>> kernel: Code: 24 e8 9b 68 04 00 48 c7 c7 70 88 db c0 48 8b 80 98 03 00
>> 00 48 8b 80 70 01 00 00 48 89 44 24 08 e8 3c 50 d8 d8 48 8b 44 24 08
>> <48> 8b 48 30 49 39 4f c8 0f 88 ff 00 00 00 48 c>
>> kernel: RSP: 0018:ffffbbf000847bf0 EFLAGS: 00010246
>> kernel: RAX: 0000000000000000 RBX: ffff95f6834b8000 RCX: 0000000000000000
>> kernel: RDX: 0000000000000001 RSI: ffff95f6a1fbcbe0 RDI: ffffffffc0db8870
>> kernel: RBP: ffff95f6a1fbc6b8 R08: 00000ab5a9371b7a R09: 0000000000000230
>> kernel: R10: ffffbbf000847bc0 R11: ffffffffc0d53ea0 R12: ffff95f6a1fbc560
>> kernel: R13: ffff95f6a1fbc408 R14: ffff95f6834b8000 R15: ffff95f6a1fbc908
>> kernel: FS:  00007f366f151740(0000) GS:ffff95f6fdc00000(0000) knlGS:0000000000000000
>> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> kernel: CR2: 0000000000000030 CR3: 0000000003fcc004 CR4: 0000000000370ef0
>> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> kernel: Call Trace:
>> kernel:  <TASK>
>> kernel:  ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>> kernel:  evict+0xc0/0x1c0
>> kernel:  ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>> kernel:  ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>> kernel:  ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>> kernel:  mount_bdev+0x182/0x1b0
>> kernel:  ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>> kernel:  legacy_get_tree+0x24/0x40
>> kernel:  vfs_get_tree+0x22/0xb0
>> kernel:  path_mount+0x465/0xac0
>> kernel:  __x64_sys_mount+0x103/0x140
>> kernel:  do_syscall_64+0x59/0x80
>> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
>> kernel:  ? do_syscall_64+0x69/0x80
>> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
>> kernel:  ? do_syscall_64+0x69/0x80
>> kernel:  ? exc_page_fault+0x68/0x150
>> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> ```
>>
>> Analysis:
>>
>> ocfs2_fill_super
>>   ocfs2_mount_volume
>>    ocfs2_dlm_init //failed, journal still doesn't be initized.
>>     goto read_super_error
> This is not a part of call trace, I don't think it is needed here.

OK, will drop in v2.

> 
>>      ocfs2_dismount_volume
>>       ocfs2_release_system_inodes
>>        ...
>>         evict
>>          ...
>>           ocfs2_clear_inode
>>            ocfs2_checkpoint_inode
>>             ocfs2_ci_fully_checkpointed
>>              time_after(journal->j_trans_id, ci->ci_last_trans)
>>               + journal is empty, crash!
>>
> 
> Suggest we use the following way to description this commit:
> <call trace>
> <reproducer>
> <your analysis and how to fix>

OK, will follow this style.

> 
> BTW, as I mentioned at the first, a fixes tag should be mentioned here.
> Could you also please check all possible use of journal during
> ocfs2_dismount_volume()?

I verified my patch before file V1, there was no crash anymore with no dlm case.

Under your comment, there may have other places need to fix in ocfs2_dismount_volume().
The reverse operations in ocfs2_dismount_volume() for range [ocfs2_initialize_super, \
ocfs2_journal_init) should be checked.

> 
> Thanks,
> Joseph
> 

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
