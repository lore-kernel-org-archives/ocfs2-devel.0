Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFF6C64EC7
	for <ocfs2-devel@archiver.kernel.org>; Wed,  1 Mar 2023 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=P+wjoD7IkZO7UQ1Fokl1vn8VxrhU2qx2BqYq9Qkjev0=;
 b=AFpy4eYBKevrpzlSKqvSKDqvPRllYt/D+14zpG2llUzN2AdOknMgbfHdv06LZUWeUGPtKz3VK8LN
   lrtukGKtLQ0GaLq8nfeGrLMT8eCKO9SwzV84SCnI13mMP9TpUeATIk+A+CJllgsiK1Fv/22b7OZQ
   NU57DbM/DlxDEJ1ZEkSHyR6QIiRrZAvjBrOOuqR0DZZ048kEL+MhWuLDDu4SVu+1g1Kwf6lSEB+G
   qhzEHkl8CXkcmvb/1LH5XIQWyg5psrSr0PjAZJUAaVZ4obuKUbym/F6O2bL5quTGfmFydUf60VZR
   dD3p711uv9/Is4P8gCzvYfGL8c5DKjE27FtAqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=P+wjoD7IkZO7UQ1Fokl1vn8VxrhU2qx2BqYq9Qkjev0=;
 b=otVHoPLIzT4vlXIxASshLdf8gBtReecEMIWQpql5E3k3f4ohWCQTDBoWVBQg+J9tV+iWVQXMvceR
   COs3UPlFHxMPOd3yyZwWTFMOounz9DSuUEJyK95Ocu1EyGjGncbdksDCmzDJnEvTQW1Y9CqWtwS8
   KLmHHH2xDRrVd1WyU/vFvLky9p9iKIkRn6nF6p6lHijsBt6wJAa5E1UsykbfnzmR/03NDUlseN2b
   ttWJSTxoDs5Tp0mF4U8jREOZOqOyXnkCBaK1wchdCQnLqL4wl1BwmZNsWZmy8ySbbOZhI0m6vUQx
   ZtcpTTPTJx2PY9Vv4Y9DStOFugFC8YDvE0Imqw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQU00OAX5YX2G00@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 01 Mar 2023 09:49:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWXA2gwx56ti98vBJly0Qh2dzjvYXmQTN/GQbPmhYe6amayf2lF/BlQ7NwcqrpTVrMoV69Kk7FMPbPs8q10g/Zhcat0LuZpz8MU15W/RdJjuStb9Sry0S4qc9Ln4CQblIjtF/0YSWTYPixKfxHmsTchJxfEQNff4sLnNFj4bHubGMmdqo7fTA0h8MNsvvFxjVLvJ3n8s3d0faomjX3A5n8Pd17IOi8ULidUReEb2VZmDr1vmY60vI+ToK2B8STyFK8C9kH2VdzXovKJO6Q3EOzdWxDFcVssV7cM9Xc5fdaDpMQaruXgOxUyrxQMI6TBns4PpW1cpzFTk8WccmHlAWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPCQc1E9thrEB8n6bzlNUKbGqOF2R+GsqNy6LOetZVQ=;
 b=F+JhP2D+ycnoH2jdRnsl8FdnKDfK59nNqZnT7a/y8wuzFnk4EeaMHOTXZfRJ25KLgXfSf2nnyLC6CfIHsbekNPgcV3ND3EEpXjr6sV1xejQ+sRVorx/+6UhcKgJRDNnSdyhbzmDwRbmvWw1Ji2ZzeNr5+TzY0c1C4pD2G0bzSCOmmQcI7o6PXCUNSjizC5J7Z8+9L/Uv4IAoxCdsaorZTGeQlVcasElgi39igjEnO9jlTt+vW+Y+p8jQOGe/sjDtE9YJWB66xueHfE+I7wKtRwtcnfGTBhjphQaMiTpsoDt3119R5/sYG++TpbzUnpOTzvZRQOhMOi4PGd1/z/0FOA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPCQc1E9thrEB8n6bzlNUKbGqOF2R+GsqNy6LOetZVQ=;
 b=Y2LjIFRbmw/hRIDq2czd8JWf42mz/l+SstZf4VUnF87BFxictDfZT+ghEe6iKK7Ou860L+nLCSxX1qfZZ2OHZ6VNgpUQ5yfhVs+DB7lZRZufqFx+oHhCyXHhqcNnkYSzM0G4DT+qoZfhWkjdUcgXnw8FLQf8DGKxqliO9f08u1t57zc4hKZF/wpwgJRqMvbR3T3f5ceZVyu+3w9qaRnnNsRe2FOUrbpKTZfYrDNAH40OJpkTuow8ZGzaTr1VZbVJCCBaLFkC8yvaQVj9h5qFoi5HR9axb/Ri0E//8PNy3S/fCkxxKdoqq9eFREP8sw5ewCaEamdlGauNZRsrbTpmjg==
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Joseph Qi <jiangqi903@gmail.com>,
 ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
 <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
 <20230226084544.weep4qypu3mzgjic@c73> <20230226152238.a2wxbriw2sbxmkbk@c73>
 <ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com>
 <50c26dfd-afd4-5dc2-212c-a02e84a75440@linux.alibaba.com>
Message-id: <ce41878f-f56d-b365-9dd9-89c3f8a26cc4@suse.com>
Date: Wed, 1 Mar 2023 17:49:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <50c26dfd-afd4-5dc2-212c-a02e84a75440@linux.alibaba.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(66476007)(8936002)(2906002)(31686004)(5660300002)(44832011)(8676002)(66946007)(66556008)(110136005)(316002)(6486002)(966005)(478600001)(6666004)(26005)(6512007)(186003)(53546011)(6506007)(2616005)(41300700001)(38100700002)(31696002)(36756003)(86362001)(83380400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 09:49:28.8936 (UTC)
X-Source-IP: 40.107.13.78
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10635
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 clxscore=183 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 impostorscore=0
 priorityscore=157 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010081
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: TY2PR0101CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::21) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB9257:EE_
X-MS-Office365-Filtering-Correlation-Id: cc6bb0a0-5ee3-44f2-40a9-08db1a3a4002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 PcyedtuLJ1hb+SXino7sn58IWI6hXXh/WR2/Ty2DQp/Vz27tTmHhpF4Ev3T7J99hO2CeqveFVVw6zEqH6u0LDy+nmh/JyyOHW2gOyawkUC3ZYaRWG8jpX+m25R2vwPrN3XtUPIZo8Ds6ke0RSTnybksUNumwYEP0i9KDzfuXthc8udRBE4xEKp6vKdLSBiN14ZpETuMEl9kJQCMVzpeJV4HLx06XMOHy7jWOjhiTZgdmfNfyAQVBYg+UAmpkMZ3PWH7oFTblN4iOLXzBcazKKONMohUJkbhsMJmkZ3A/Kn87hB1rWm8cFx2GpnnT95g7qtpr6K/gM9AQhQoQm5jcsktfCZX5n10Zgf6ZVNYv12FC6FtVRXgw4IXwJ1wQXKiIf3c6Q08GreDcqquJIZQfW/kCI/2SMQugLjtl3vk+o44TOhC7ZqShVv1fN5XEzV4CwbT6AMeHcf1RqOnHR447ovGN61d8xaU+gur47pnfXF/uGDUY2LLIL+BveQUHBPm3oTzVMoN1Mfbh+iqNj47/DNcf9RAn6UpW2rSYpEVprRMCkawqHS2AETqDpFd7XCKi/U2UFGM5eKWIdhIFKc8N9GCJAgRAdP5Aomo12sgkIMYJu0d+z/lPl7UoZ8whgGfMDHIDGerSHHkUbudttf3y7mETuHbnbZaamby4XVAqG3rWm7l/jIZfc42LSVQJvNUoPUYv+A0Ugh4AMQvw6IeD9w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NmkydUM3ZjcrZWpQNzhnMlhzUEEwbHRvbzlORm9YaTkyRWxrbVBZUmc0emMw?=
 =?utf-8?B?aWlsR3NsVjVjb29CUXh0a1N3d24wRSt0SkZWVGs3bzZnWHE0VzhsaWs4eGVU?=
 =?utf-8?B?T3J0d0lSaG9oNUsyZ3A0NWtYL2RNTmU0K2wzN2NEVUJjUG5kNU5DK01VYm9S?=
 =?utf-8?B?UEhlTnEzaW9BQTFSM0thdkZyb2FET2ZUclVhUkw0eVpLa0tGTXhPdTVOdDZq?=
 =?utf-8?B?bFY3WFgvMlJPcDR3ZkRncFQ2aEtaR1JMZU92cTdkNlZtZEFWNms2WDQwcWNK?=
 =?utf-8?B?V24rb2s0TVBrYkdaOUpUekgyQXVOSzFwa292K3hadjkwVEZhbnExSnVzdG0y?=
 =?utf-8?B?Tks5dE54eHlSVW5lQVJZdXptS1lsNjR3emRvSUpkRzdmZlhKdDU0Wlk4MWM0?=
 =?utf-8?B?R1ZKRjRQNDBOb2Qvd2tGRXI4RVpuSzZUb3EydmNzVWI4ei94REtEVWU1RTJT?=
 =?utf-8?B?ajRZRFdEaVNFMnk5ajF6R0x6MlVVOERMU0NVMThUaTZKL0gzcU5hVzAyMHdj?=
 =?utf-8?B?d0RMRU1BRStCa0pvczVyY1lUZ1lNY3dnRWNSWk1wUWxmeWxtYUt5bWUrTzZC?=
 =?utf-8?B?OUZmU2FJaGxFY1FYVnlsWjdtc0dhWHFJQWFMTkdROW9sSEw5OEJKZ1ZXa044?=
 =?utf-8?B?UzZoYkxrUTRxbHV0OERmNk9MdFp2bkFnOVBUZjJLUE9tVmtHMzVVVFB1UkZa?=
 =?utf-8?B?QUFnWFYwVnVxaGZBZnl1Vi9DQ1kxaXoxZGg2TFJjVHVUc0RQak52bHlUeEZW?=
 =?utf-8?B?UElxcjFURDFscVYvd2x3UlNTYUwyQjE4dzhaNkZXL29xdFNEWDFxRkdWMFFh?=
 =?utf-8?B?bnhNclp2bHEveTlhZk4zTkd6TCs3ME1nMndnQzEvdUFEdThiQVE2dnEvNEZH?=
 =?utf-8?B?WlprK1dZMCtvMWxFVTRQcWlJYXlvbWtNbFhmTm9DL2xoY05kY0RMUWhHT3ZV?=
 =?utf-8?B?RDZYVUxleGpPamlhT1dxK2tGSDNTWmxSeVZqOFZ6MW9PemN3ZGhGYkV2S28v?=
 =?utf-8?B?UUluMi8zamdONFJkWVhza1VWMDFSbHVUM3YwUTRzbHdvTGExdnN1T3c1a1Va?=
 =?utf-8?B?c05jb0lmdXhCVGFmMGhUeHMwS1U1cnRGOW8zQ2xlc3lrMUJCZU9HRnErdWdQ?=
 =?utf-8?B?M24wUyt5SWljQ1JZLzRwTDQ4c3UwYTcvSUFrSUdTZWxUZW1RbzR2bk00WGtK?=
 =?utf-8?B?VzZQVGdMNHBjSzg4SlhscVN0NGttYXAzU0VIZjc0dnlqS2o4VmczaTIyNDlu?=
 =?utf-8?B?TTNXVm9QTjdITnRrTHFQVVpIMndweHJianR4eXpoamVyR2ppenZVVWxxbFhr?=
 =?utf-8?B?a1MvSFZzV1htOXN2V29jRysxUXBiVUNGL2NRV0tHakZPUGFEVjBRM05NQ1Bo?=
 =?utf-8?B?TFdZZXhKTkgvOXJENmgwSzFZM0JhZCs1Z0pFc0ZUckRvdG1scVJtTjFYWnVP?=
 =?utf-8?B?UTZWWm5GWmpOTUFTaGEzdW5HNE5oaGNWbUtoV3RLUExLb01STElRQlYyRVNh?=
 =?utf-8?B?RnhCdEtkSmxjV1dFS2k2QlpWay9tS3g5RDVocnpZQTRtUFhaQ1lMWFhIdkUr?=
 =?utf-8?B?M3RWVWt6Q1MzS1piRFNzOFBmUFFnZE9XcGNiWlA0OUNLOWZmZTJjZitOb0hJ?=
 =?utf-8?B?N0M2em13c05VS1djSTM3NnRmQm91UnRxaDNwa3RzMHc3RFk5NjVOVTdZTWlR?=
 =?utf-8?B?NjNnSnBNUlZrb0hJMVZhQXFoWkNmMmlZN1AxQ0J4dWtvc1NtQWQ4SjI4ZXdN?=
 =?utf-8?B?N1doc1JOU2QzS3FBZUx5UVY0MzJsa29UM2tpN1RCNThxdldXT0dueTFMREN6?=
 =?utf-8?B?WTFQREszR1FwdHcxN092azQ2Z0xhUzdzUnI3WlZnSTU2Y1NQUHNJTEFqRlpF?=
 =?utf-8?B?ekk1Y2lwN0ZWbTBBTVNmRWplcEQzaElXcFJSYm1paWczaFZNLy9mcUZpdnhH?=
 =?utf-8?B?TWV3Vis4eDZqMUhnZkVoWTJLTTdBamQwenJiZVNXSzVNK2EwcWEwcXZOZks4?=
 =?utf-8?B?aVBlQlVhaDJzU2NWUlFmdmRkemNFdEZ4cnhKY2lybXg0ZUVIVlQvNDFLZ3Z5?=
 =?utf-8?B?ZzRQRUVPRk5DcnlsbkJaMU1tZXR0TDhkTzJnbGtVZFFPVUdaWnF0T1BoSmJt?=
 =?utf-8?B?aGdZejRSMmx5cGJSbmNNNUpSRmdZOWlna2R2SWVHOUxZUTAvRUNNRi81aTZD?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 cc6bb0a0-5ee3-44f2-40a9-08db1a3a4002
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 dbQdwyQ9SRADghnvu+ENEN9XH35L5OnWyCQS355LW16mCouUQ27vMRXafyencELD+KKOg7TN8k+FT8ps5quttw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9257
X-ServerName: mail-he1eur01on2078.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ArO8dEEl7m_1gvBmAPaVuM_9IKwyi-nA
X-Proofpoint-GUID: ArO8dEEl7m_1gvBmAPaVuM_9IKwyi-nA
Reporting-Meta:
 AAFaMaltjhKiUB6Jl61AWbcOwNzyTwOR+l/k29Q5JTfeomGlaCOj8UKbnzar4XjS
 +ebU7D/HIJ6NNuLPbF9NfCCx7DSCMSwHVrRGjfUQji/XdYIE4T5ZkvuWI03liUKE
 4FdxHbnv3++qNGT5a4w2zW+10Zgm0g10igjBd3cB2a1rbWWNsi4Fzehya0l0IHDX
 Kaq7cv+tvfkPkWnMZ62VXgjZTpYiysp6CiPHPhU9cXsY8FWYt3mLuNDoKFaOIlMI
 EYUh+qu0wHhLIs/dqroU2Q/+8PEOzKNeOgN5K7ft+9MKwMnu+XLXSEbcml83AQil
 Q7cGfiv8VH5bgP8v1HIcF6Hkc596Hr8v4XVUDxqTLcyYvl+TVqTkHb8XzuQJfsv/
 TwCDWwDlZn4j0fdwj0HpzvacxmPysDZEM90Xsk9jmsuOb9k/XUV3zmxqo1oqmdgk
 Xe0S044oZijFnaCXBH7yGaGaJwvmU7btKsnaALRHbld7aVuV3PIk2j5y00k+8lbj
 +1mVgUKo071InW7wwJF9sKypVO4sPBJmjOTSkKGMYH4=

T24gMy8xLzIzIDEwOjA2IEFNLCBKb3NlcGggUWkgd3JvdGU6Cj4gSGksCj4gCj4gT24gMi8yNy8y
MyAxMDo1OSBBTSwgSm9zZXBoIFFpIHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToKPj4KPj4KPj4gT24g
Mi8yNi8yMyAxMToyMiBQTSwgSGVtaW5nIFpoYW8gd3JvdGU6Cj4+PiBPbiBTdW4sIEZlYiAyNiwg
MjAyMyBhdCAwNDo0NTo0NFBNICswODAwLCBIZW1pbmcgWmhhbyB2aWEgT2NmczItZGV2ZWwgd3Jv
dGU6Cj4+Pj4gT24gRnJpLCBGZWIgMjQsIDIwMjMgYXQgMDY6NTk6NDdQTSArMDgwMCwgSm9zZXBo
IFFpIHdyb3RlOgo+Pj4+Pgo+Pj4+Pgo+Pj4+PiBPbiAyLzI0LzIzIDQ6MDMgUE0sIEhlbWluZyBa
aGFvIHdyb3RlOgo+Pj4+Pj4gT24gMi8yNC8yMyAzOjUyIFBNLCBKb3NlcGggUWkgd3JvdGU6Cj4+
Pj4+Pj4KPj4+Pj4+Pgo+Pj4+Pj4+IE9uIDIvMjQvMjMgMzo0OCBQTSwgSGVtaW5nIFpoYW8gdmlh
IE9jZnMyLWRldmVsIHdyb3RlOgo+Pj4+Pj4+PiBPbiAyLzI0LzIzIDI6NTQgUE0sIEpvc2VwaCBR
aSB3cm90ZToKPj4+Pj4+Pj4+IEkgY2FuIHJlcHJvZHVjZSB0aGlzIGluIG15IGxvY2FsIFZNLgo+
Pj4+Pj4+Pj4gSSd2ZSB0cmFjZWQgb2NmczJfZGlzbW91bnRfdm9sdW1lIGFuZCBmb3VuZCB0aGF0
IGl0IGhhc24ndCBiZWVuIGNhbGxlZC4KPj4+Pj4+Pj4+IFNvIEVCVVNZIGlzIHJldHVybmVkIGlu
IFZGUyBsYXllci4gSSBndWVzcyBzb21ldGhpbmcgd3Jvbmcgd2hlbiBkb2luZwo+Pj4+Pj4+Pj4g
YSBjb3B5IHdpdGggbGlua2VkIFNRRXMgKG5vcm1hbCBjb3B5IHNlZW1zIG5vIHByb2JsZW0pLgo+
Pj4+Pj4+Pj4KPj4+Pj4+Pj4KPj4+Pj4+Pj4gSSBhbSBpbmNsaW5lZCB0byBhZ3JlZSB3aXRoIHlv
dS4gSSBhbHNvIHRlc3QgbGlidXJpbmcgZXhhbXBsZXMgYXBwcwo+Pj4+Pj4+PiBvbiBleHQ0IHBh
cnRpdGlvbiwgZXZlcnl0aGluZyBsb29rcyBmaW5lLgo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBJIHVzZWQg
YmVsb3cgYnBmdHJhY2UgbWV0aG9kLCB0aGUgcmV0dmFsIGlzICczJy4KPj4+Pj4+Pj4gIMKgwqBi
cGZ0cmFjZSAtZSAna3I6bW50X2dldF9jb3VudHtwcmludGYoIiVkXG4iLCByZXR2YWwpO30nCj4+
Pj4+Pj4+Cj4+Pj4+Pj4+IEl0IHJlc3BvbmRzIHRvIGZsb3c6IHBhdGhfdW1vdW50KCkgPT4gZG9f
dW1vdW50ID0+IG1udF9nZXRfY291bnQgKGdldHMgJzMnKQo+Pj4+Pj4+Pgo+Pj4+Pj4+IFllcywg
dGhhdCdzIHRoZSBwbGFjZSByZXR1cm4gRUJVU1kuCj4+Pj4+Pj4gU28gdGhlIHByb2JsZW0gc2Vl
bXMgdG8gYmUgZ2V0bW50L3B1dG1udCBub3QgbWF0Y2ggaW4gdGhpcyBjYXNlLgo+Pj4+Pj4+Cj4+
Pj4+Pgo+Pj4+Pj4gSSBkaWRuJ3QgZmFtaWxpYXIgd2l0aCBzZXR0aW5nIHVwIGtlcm5lbCBiaS1z
ZWFyY2ggZW52LiBJIHVzZWQgb25lIGxhc3QgeWVhcgo+Pj4+Pj4gb3BlblNVU0UgdHVtYmx3ZWVk
ICh3aXRoIGtlcm5lbCA1LjE2LjIpLCB0aGlzIHVtb3VudCBpc3N1ZSBkb2Vzbid0IGV4aXN0Lgo+
Pj4+Pj4gU28gdGhlcmUgaXMgYSBwb3NzaWJpbGl0eSBvbmUgb2NmczIgY29tbWl0IGludHJvZHVj
ZWQgdGhpcyBpc3N1ZS4KPj4+Pj4gWW91IGNhbiBjaGVja291dCBlYWNoIG1haWxpbmUgdmVyc2lv
biBsaWtlIExpbnV4IDYuMCwgNi4xLCAuLi4gYW5kIHRyeQo+Pj4+PiB0byBjaGVjayBpZiBpdCBj
YW4gYmUgcmVwcm9kdWNlZC4KPj4+Pgo+Pj4+IEkgZHJvcCB0aGlzIG1ldGhvZCwgbXkgbWFjaGlu
ZSBjcHUgaXMgb2xkLCBjb21waWxpbmcga2VybmVsIHdpbGwgdGFrZSB0b28gbXVjaAo+Pj4+IHRp
bWUuCj4+Pj4KPj4+Pj4KPj4+Pj4gSSd2ZSB0cmllZCB0cmFjZSBtbnRnZXQvbW50cHV0IHVzaW5n
IHRoZSBmb2xsb3dpbmcgYnBmdHJhY2Ugc2NyaXB0LAo+Pj4+PiBsaW5rLWNwIG91dHB1dCBzaG93
cyBpdCBtaXNzZXMgYSBmcHV0Lgo+Pj4+Pgo+Pj4+PiAjaW5jbHVkZSA8bGludXgvbW91bnQuaD4K
Pj4+Pj4gI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5oPgo+Pj4+Pgo+Pj4+PiBrcHJvYmU6bW50Z2V0
Cj4+Pj4+IHsKPj4+Pj4gCSRuID0gKChzdHJ1Y3QgdmZzbW91bnQgKilhcmcwKS0+bW50X3NiLT5z
X3R5cGUtPm5hbWU7Cj4+Pj4+Cj4+Pj4+IAlpZiAoIXN0cm5jbXAoc3RyKCRuKSwgIm9jZnMyIiwg
NSkpIHsKPj4+Pj4gCQlAW2NvbW1dICs9IDE7Cj4+Pj4+Cj4+Pj4+IAkJcHJpbnRmKCIlcyIsIGtz
dGFjayk7Cj4+Pj4+IAl9Cj4+Pj4+IH0KPj4+Pj4KPj4+Pj4ga3Byb2JlOm1udHB1dAo+Pj4+PiB7
Cj4+Pj4+IAkkbiA9ICgoc3RydWN0IHZmc21vdW50ICopYXJnMCktPm1udF9zYi0+c190eXBlLT5u
YW1lOwo+Pj4+Pgo+Pj4+PiAJaWYgKCFzdHJuY21wKHN0cigkbiksICJvY2ZzMiIsIDUpKSB7Cj4+
Pj4+IAkJQFtjb21tXSArPTE7Cj4+Pj4+Cj4+Pj4+IAkJcHJpbnRmKCIlcyIsIGtzdGFjayk7Cj4+
Pj4+IAl9Cj4+Pj4+IH0KPj4+Pj4KPj4+Pgo+Pj4+IEkgdXNlZCBiZWxvdyBzY3JpcHQgdG8gZmlu
ZCBzb3VyY2UgZmlsZSBob2xkIGZfY291bnQuCj4+Pj4KPj4+PiBlLmc6IC4vbGluay1jcCAvbW50
L2FhLmJpbiAvbW50LzEKPj4+PiBUaGUgc2NyaXB0IHdpbGwgc2hvdyBmX2NvdW50IG9mIGFhLmJp
biBvbmx5IGRvd24gdG8gMy4gV2UgZXhwZWN0IGZfY291bnQgdmFsdWUKPj4+PiBkb3duIHRvIDEg
dGhlbiB0cmlnZ2VyIG1udHB1dC4KPj4+Pgo+Pj4+IGBgYAo+Pj4+ICNpbmNsdWRlIDxsaW51eC9t
b3VudC5oPgo+Pj4+ICNpbmNsdWRlIDxsaW51eC9zdHJpbmcuaD4KPj4+PiAjaW5jbHVkZSA8bGlu
dXgvZGNhY2hlLmg+Cj4+Pj4gI2luY2x1ZGUgPGxpbnV4L3BhdGguaD4KPj4+PiAjaW5jbHVkZSA8
bGludXgvZnNfc3RydWN0Lmg+Cj4+Pj4gI2luY2x1ZGUgPGxpbnV4L2ZzLmg+Cj4+Pj4gI2luY2x1
ZGUgPGxpbnV4L2lvX3VyaW5nX3R5cGVzLmg+Cj4+Pj4KPj4+PiBrOmZwdXQKPj4+PiB7Cj4+Pj4g
CSRmID0gKHN0cnVjdCBmaWxlICopYXJnMDsKPj4+PiAJJGNudCA9ICRmLT5mX2NvdW50Owo+Pj4+
Cj4+Pj4gCWlmICghc3RybmNtcChjb21tLCAibGluay1jcCIsIDcpKSB7Cj4+Pj4gCQlwcmludGYo
IlxuIFtsaW5rLWNwXSBmcHV0KCkgbmFtZTolcyBmX2NvdW50OiVsbGQgPCVwPiBtbnQ6JXBcbiIs
Cj4+Pj4gCQkJICAgCXN0cigkZi0+Zl9wYXRoLmRlbnRyeS0+ZF9uYW1lLm5hbWUpLCAkY250LmNv
dW50ZXIsIGtwdHIoJGYpLCBrcHRyKCRmLT5mX3BhdGgubW50KSk7Cj4+Pj4gCQkvL3ByaW50Zigi
JXNcbiIsIGtzdGFjayk7Cj4+Pj4gCX0KPj4+PiB9Cj4+Pj4gYGBgCj4+Pj4KPj4+Cj4+PiBJIGFt
IG5vdCBmYW1pbGlhciB3aXRoIGlvX3VyaW5nLCBhbmQgY2FuJ3QgbWFrZSBzdXJlIG15IGFuYWx5
c2lzIGlzIGNvcnJlY3QuCj4+PiBCZWNhdXNlIG9jZnMyX2ZpbGVfcmVhZF9pdGVyKCkgcmV0dXJu
cyAtRU9QTk9UU1VQUCwgdGhlbiBmYWlscwo+Pj4gaW9faXRlcl9kb19yZWFkKCksIHRoZSBpb19p
c3N1ZV9zcWUgbWlzc2luZyBmcHV0KCkgd2hpY2ggY2F1c2VzIHVtb3VudCBmYWlsdXJlCj4+PiBp
c3N1ZS4KPj4+Cj4+PiBpb19pc3N1ZV9zcWUKPj4+ICAgKyBpb19hc3NpZ25fZmlsZSAvL2NhbGwg
ZmdldCgpLCBidXQgbWlzc2luZyBmcHV0KCkKPj4+ICAgKyBkZWYtPmlzc3VlKCkKPj4+ICAgfCAg
aW9fcmVhZAo+Pj4gICB8ICAgKyBpb19pdGVyX2RvX3JlYWQKPj4+ICAgfCAgIHwgIG9jZnMyX2Zp
bGVfcmVhZF9pdGVyCj4+PiAgIHwgICB8ICAgcmV0dXJuOiAtRU9QTk9UU1VQUCAvL2lvY2ItPmtp
X2ZsYWdzOjB4OAo+Pj4gICB8ICAgKyBraW9jYl9kb25lCj4+PiAgIHwgICAgICArIGlvX3J3X2Rv
bmUoJnJ3LT5raW9jYiwgcmV0KQo+Pj4gICB8ICAgICAgfCAgIGtpb2NiLT5raV9jb21wbGV0ZShr
aW9jYiwgcmV0KQo+Pj4gICB8ICAgICAgfCAgICBpb19jb21wbGV0ZV9ydwo+Pj4gICB8ICAgICAg
fCAgICAgIF9faW9fY29tcGxldGVfcndfY29tbW9uCj4+PiAgIHwgICAgICB8ICAgICAgICsgcmVx
LT5mbGFncyB8PSBSRVFfRl9SRUlTU1VFIHwgUkVRX0ZfUEFSVElBTF9JTzsKPj4+ICAgfCAgICAg
IHwgICAgICAgKyByZXR1cm4gdHJ1ZQo+Pj4gICB8ICAgICAgKyBpb19yZXFfdGFza19xdWV1ZV9y
ZWlzc3VlL2lvX3JlcV90YXNrX3F1ZXVlX2ZhaWwKPj4+ICAgfCAgICAgICsgcmV0dXJuIElPVV9J
U1NVRV9TS0lQX0NPTVBMRVRFOwo+Pj4gICB8Cj4+PiAgICsgcmV0dXJuIDA7Cj4+Pgo+PiBTZWVt
cyBub3QgdGhlIGNhc2UuCj4+IFJlaXNzdWUgd2lsbCBxdWV1ZSB3b3JrIHRvIGlvd3EsIGFuZCBm
cHV0IHdpbGwgZmluYWxseSBnZXQgY2FsbGVkIGluCj4+IGlvX3dxX2ZyZWVfd29yaygpIG9uY2Ug
d29yayBpcyBoYW5kbGVkLgo+Pgo+IEkndmUgc2VudCBhIGZpeCB0byBpb191cmluZywgcGxlYXNl
IHJlZmVyOgo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2lvLXVyaW5nLzE2Nzc1ODkxNzE3OC4x
MjgyNi4xMzQ4MTkzNDM2MjE2Njc5Mzk1Ny5iNC10eUBrZXJuZWwuZGsvVC8jdAo+IAo+IFRoYW5r
cywKPiBKb3NlcGgKPiAKCkdvdCBpdC4gVGhhbmsgeW91IGZvciB5b3VyIHF1aWNrbHkgZml4LgoK
TGV0J3MgbWFrZSBvY2ZzMiBtb3JlIHBvd2VyZnVsL3N0YWJsZS4KCgoKLSBIZW1pbmcKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1h
aWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUu
Y29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
