Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D8FC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Jun 2022 07:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EtBi5LLRd5TJidffnncvgmorehIiR8LNRxvUQVW8MWs=;
 b=Qo5HaL910MbXc/GD6RAnAlfccXzgNYP6cgAq2khDoStWqUdsFGzF37QbFzKw7ja8N/d4OzxLxfuk
   W/BMZIgMWEkNK+ETFjBhT+3JL2g91p5Rb2v5ilNMWc6Ku/XUN3WfZLx09EMAY+6wKSs8x05FmTr9
   Q0VXvKI6RoTvsTRrNggl4U9GcGFma5vUiJxIXyYfULl2WG30ArOwGfk2OapU0rVTCk1i3Pw2p4Hb
   vYQ+3MyojabPHaXiDe+61GNn48Qx7ZiuBDqWNv60Nayf/KJwyj0llcHRJXimO6Oam9Mlx6vOOZ1v
   B/koMwYfXiBn7D9kSbyBsEokXQ8z7Khjj6vbRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EtBi5LLRd5TJidffnncvgmorehIiR8LNRxvUQVW8MWs=;
 b=bYkTVrC1QmevCgKRwv+EoPVBTkOFXIU77UbuK7B0oM0Kg9uBDt2Txyo+33KzLjWZpXDVX16C5tB2
   7U/5pBqfNnFzKmfXWhVAfAmfjzNRnBYWAw6WbDYXvHDFLUqR9a1fhKzSBC7DUznKCvEv894iueP1
   +y/qNIg6yV4AML0NlqlKRmNvULP4dAEFipSkBxrWtUgSg4k2n457bD8npFzFcA2r1RaXW3/X0mAZ
   lMcjoH/qP9yBTi6qoYnGP0lNs5JL4MVodeI8z8x/BF3QwH0+Rt7GMPs+tL/tpBluck2ZqN+aMZAZ
   WQgJfQJuBeFA5J0Ingo0LhhfPIi+pK93GCtIwA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDE000L8OVQEV70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 13 Jun 2022 07:59:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZR2aZbnGNWoflpLHl1PmGSIuIBHIZ+pmdMddPTfkJUw0Qa/fyAJx5r6IC5NY+aP7N0C1uQFiBQST/cvIjC5HqjRQoPMTCijoGlUoMhg2gQCXYMmC5c9aDtlY1QC+ljomnuvamzNst5GHJrWzjEQR1QO6XUXsMLfDy/2DY8d4SmgBiIshYtbWkLpbvN0fhUqSInouWFPOIsXQaQ0saLhpA7pZMBjLSHWPNW7kALNlnmFvS24AgZKF04yH45FQRShLFVM9MhNWepB0EJ3fUPJXQYp8/3yc0kkBoS0QAg3d/tcb6gcMVJql5q71gRI5v+85HV/4FqwPnI6Jqt5mSW7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYX6LNQPPFq3iP/STjb5vixOui4/LXuFaoTQg60t7MY=;
 b=RAvhNSyqJ+zZdbpxxuHGL+42oaI92yLbka1O9BlwoRk9jnh8KZMBPWQoQsmxh7otYkwsjkdZ5d+zT652TDxA26IJSNPxAzNw2e1iczyo3YRodwVBWz2BF1YpTLPgnCmyyrbDdUrvXDUK/fKav4TXVx9E3KmiKcXrLwa2OzqwVA2ZpvOxILTQ073A6Flek5ooMYCIN2rVMKLg+pyOD0PNhgt/CfHJbrNcY2pc6naDjHMMfouf2T4TVmgcuAnBqeq5HfKrUl3LkEo3wAfW5fgR45GoCMSWvdowex0WxxEapYCBf3UDirBNDECjEEuynBEUQyKkFZqelyT17ETbF06e8w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYX6LNQPPFq3iP/STjb5vixOui4/LXuFaoTQg60t7MY=;
 b=dWqsieNrcnEjrHxsJZ32PMz8QZulQkFVkgGmFlSnwVpJkPgopDqGy3xHMVkISP9V/XltHYbg0UheUwaNt7848nSW+WDACJRpXgZ2qShHBM7ihXyCTcHKHzZhgJ0lKnO2ekGLphR2GFAaKI5gozALndyWC8gXfHTNPWiNGLtdebTH4HcrFTRkknhQn8JVnE/TOhd2DqAoGjPGMgB1th9PST0//V/+mU2FVNWEaaNZNSMTYmdEsXPmgzFf8idUPDtfwhstOOyi5PzSKxuoYo+h44btCIYW2PZxWjVxrFQaYxaAAhjPGDpW5KvOtUVZAi3oxxPDRgWnDIlQ66OTcrriWg==
Message-id: <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
Date: Mon, 13 Jun 2022 15:59:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
In-reply-to: <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(6512007)(36756003)(26005)(38100700002)(316002)(31686004)(53546011)(966005)(186003)(83380400001)(6506007)(2906002)(6666004)(30864003)(66946007)(31696002)(8676002)(66556008)(4326008)(8936002)(2616005)(5660300002)(86362001)(66476007)(508600001)(6486002)(43740500002)(45980500001); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 07:59:32.0165 (UTC)
X-Source-IP: 40.107.21.42
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10376
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=78 clxscore=176 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130036
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0d4d1c5-2e03-49a4-5c4f-08da4d12a609
X-MS-TrafficTypeDiagnostic: AM0PR04MB4532:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB453283FEBA653A68011052D997AB9@AM0PR04MB4532.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 WECkR4XcbJcBQlI8wR44hRWRxu6u4M2/vZ8LJkBzEERzOi06xG1Jb32bwl0wMGA0tMoZwyqbYby1W7H3T3v5E+b/8hmsIN1J2ocrlJQ7SzmHbNoNUBGw383PQtmVHq9jRaVK1kgqfma78e8piJRTsLTWHns10LmyW9Ya053kovapakhM7mteuWPU83wO2EM9VLBLaokWAbkR3XLTltCjW9AhIMpZrcrvJkf+LWtIxRxxIEWt0M5vVZCcE9VIn8CK73b3g/nYI9BaBDrQPYFiauy5y34lmuSoOiaVnWDaNk6ne5gwyFtzIUUGUgqWH3vw/GsViSv/7FMhYkiA1Sj0w7ImTsUwwIoLAVQDuHZtLwidKOCqo5rYQkjNISgrS9KMBoOMtc0lsDF5+UDZM3TdCbegGC/6qYIfXfLFPDOTavRc47rPF0dWDtJeFlirYXkWYYu5suWaMOEX83GZx/rn5Nk0Zu+4ahUcVGTgIdndZitdMBzf7jUNfcNRFuONAfi1soFKzDSqUOZzCXHsSNuHdQ7JQ8w25hWXa+crSK1M2xUAc4ZZTKX8eWjXG0NrBCy48puxOUtWqoLkNzNsO2eRVq5j7M+8gZYfaheBIXwfkwPzxkC7PXe+CRe994J/VLepAveb2s4XjJWe9BF31ph0AQF3gIGG377PB/Jrxrxo4Iw9JUuq6CNN2QshyxdsgdcNGRmkGGver88SR7pmC/d5oTbcc7s3rEJlWylYdC6/cdbiu5DxmHMGfYcbGPfrs1/OLurszFWdOIFY2goF4GZjsmy8O9QheUL5NqDr+JBk2rZZiIkF2+lW8QlopPrwReeh
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?R0gxZURBWTgxcUdiMmNaRmkvd2J0TVE1ZEQxUkdqVE1KTVRVUVZwU2kvYWFy?=
 =?utf-8?B?U0RqMEN1dUVpNHFvVUlpMkpWWGNvWUh6UXJycCtHVmpHelFaYTBxbHlQNGJD?=
 =?utf-8?B?dHpMbGc3OTBiZXlwaldMNGF1SDhWUk5SeHN0RklOcFd0QVNCVEZNMitwNVBG?=
 =?utf-8?B?dDNTR0pJRk9TeEQvSmFQZGd1OE51UUw4eE9KYjZucnMzYWlFdzUxQTg1Y2pM?=
 =?utf-8?B?Y3pFS0FsZFNTdFQzbjB3SURnK3oyQWtRMVFYUlJmQ3JyQzZ4SzU0ZUVPWWtH?=
 =?utf-8?B?d1RMU1RKZkxZL05XN1VTK2d3T1I4VEtsVElrUUNQdTNMSzFRcEVPU2h4ODhz?=
 =?utf-8?B?aGJBQmR5cDRJdGJKb2Q2ZlBLOVhRUHFPR1FrTDlCTDNFUWQwQjkzK2lqTWJT?=
 =?utf-8?B?c3NXZWdIQ0R5RytzU3MyRVZmMEcvS1VTSVpOSmZCNTVlbXhySUZJWEZXRW80?=
 =?utf-8?B?RXUxRUI3MHNhRGNEZHgzYmNEdUpvWTNIcU1vQ2lydVg2K2NHcDVvUk9pVmg4?=
 =?utf-8?B?akM0WFNkRkFucHFKNnBaazBERlFCZzM2RHV4aUE0MDhGaHZrZGwrVytNazBK?=
 =?utf-8?B?NXZ6MVVtdE5BbE4wYW1mZDV6MkVoMll2b2s3d1YrVmkzQXVVS1lBUDJYZ09x?=
 =?utf-8?B?V0pocG1PRWtCdm5VVG80YkQxVTdsK3BLQkw5dWhteUpxbXVzWG1JYWNIazUv?=
 =?utf-8?B?ZTdLeTI4RklQMEdxcFVLYWltcW0xRm1hSS9oWlhtbmpnQmQ2OEZiNTUrVysr?=
 =?utf-8?B?ZGZtRFRDU2hPQUptN0JkNXhuRTVaTE5vZjhDQmE3aVlUV1EydlR5OTBtMkFJ?=
 =?utf-8?B?MUdnTktYTG4yK09lVU9xVktOZld3NVhqL3Axck9Vb0NYeXJCbmNzWU5ZMEg1?=
 =?utf-8?B?djJYbUV1OENGbnZhSHlaZUQ5WVJpb093c0loc3JoVGpzM3ArdjltMEE0NC84?=
 =?utf-8?B?UHA0ajVQRVVxOUpLOGdLWHc5NkV5Vm1jWW9JK21GWlI3UVV1U1doS2k3czhm?=
 =?utf-8?B?bkZyZmZsUUpmMFBnMTJ2dUlkWDV6SG5PV28yb2hiWjNtenZZMFJxa2oxWHpY?=
 =?utf-8?B?dG9YU0JWQ3IzbEQ3clJ0TFRwQXZmZytUbFJCYVBSWThHTnE3ejU0Z0pCcUx3?=
 =?utf-8?B?RmN2UzdsVVhwVERrTjg0b3Y2SitzaFpoM0NpTHk0endab0lCcGR6eWVNNzlG?=
 =?utf-8?B?czF4anF1UFNaSnRBNkszeXlBTW8rT1hNWHJUaW0vTDQvQitySTdiY3djaGIr?=
 =?utf-8?B?MURSd0d4aWJNVEQxTTN0K1ZINC8yM0xBUjV6K3h1N2ZCWm9jS0NYOExOL1FJ?=
 =?utf-8?B?NHZObXlEQ0ZrYnphQ0FLNE5nK2g2aFhLZjYxcjJoNm5mbkw2Wk9Ieno4TVdl?=
 =?utf-8?B?NFNBVVdqUHE3K3o0V2YvVDVhU0FDWmtwRzc3K3ZWUWM4MFdUbEkvMHcyK2Vq?=
 =?utf-8?B?YlhtaVhMTUErSTBjQTZnWFZpRlBieEpuNGhKeCtwN2luZUdrbWhFNFJNZHZw?=
 =?utf-8?B?L0NQZlBjUXNoNERJeWxIUWNUZFF0aFh6K2p3NWlNZXM0eEdZUXZNVU1EWmYx?=
 =?utf-8?B?aE9VZDFPck9SZGtvbUExYk55NlgvTmxjVFIySmx1eW51Y2tyRWtVTURER1dC?=
 =?utf-8?B?QnF1dm53VlV3WDM3T1RlMVVkUUtlaExDQWdhaHZKcHZENjhEQTdseHZsR2pm?=
 =?utf-8?B?YzN3SWM4UGk2c251dWNUVHlSeTdXa0VXdVdaNkFxdms4dTAvUTQ5bGFZcnd2?=
 =?utf-8?B?UmpEQlFxOFNzekw2MXI5b2F0bFY1WHFZSkYrVzdBNzYyb3VqVmZrM3FJZk5z?=
 =?utf-8?B?NXIrdk02SFFIUXc0Tkl1MjA1WGlpc0k2YWZPM3QxaFpiaUI2L25EbzB2d2M3?=
 =?utf-8?B?c3lYM3JvM0t6cTgvQVU4UVZSK3hsaWZKci9ab2ErZTIwYTc3OE5PZGFiQXhO?=
 =?utf-8?B?Rk43N0YxUWJnS1V2TjNFTzRWUG9QclFxRFFlVldJSTJONlFxQ1I5d002QnBi?=
 =?utf-8?B?TzZ2MlBVNlpxNTFRQncyaHBVdVRaQzJRK2ZBVisxM3o2YWN5VUdvWWxNZWNZ?=
 =?utf-8?B?Q2NaMVQrb1phUDRwNlF5Z1QwMFNTM2g5L1lEQjRGMkt4RW1hT0lPN3NNM21H?=
 =?utf-8?B?SG9rWXJoMlcvN3BSclBXRFE3dksvMkxGYWpOc1JsMzFDTG5qT0hjMmtHQ25r?=
 =?utf-8?B?T0hlNlY1ZVpPY3pNcThQSmhzcUpGRUlMNW5RUTBabmlkVGlDTko2dU1GSjBB?=
 =?utf-8?B?MGZGd3JRTzJPVUttaGxjTmN0SlZINjNQa25ua3NRajdjYlBxdUpEVXpGNFdJ?=
 =?utf-8?B?YjJxOUJGLy9rMVk3NVdqY3huNWpkL2ZyWXNPOXBRZXcyUm1TVnVLQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b0d4d1c5-2e03-49a4-5c4f-08da4d12a609
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Fw1ZUSv29YQ+SkIRXNS94AReBnyu+/xHrD+zjtMINWidwxF7My0WDtgL0YhCfyT2mKoCRy9gvau+IT+9bIrzag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4532
X-ServerName: mail-vi1eur05on2042.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: O14i0kX1D2BKxGH8K7fqZENm08g7NTfP
X-Proofpoint-GUID: O14i0kX1D2BKxGH8K7fqZENm08g7NTfP
Reporting-Meta:
 AAEd8A1aNB+HS9NElhVzAQQv7ZTrZqfldv7O56jFG7VjvqpZJlgPoRupwpBrMh0L
 2fBct8vcb6It26fROUi3fFtXYcffDLXjq1IDJclCicI8SAYUn/j4FcteLOO79Jdl
 qbzH6u2KfhoVKtu8oX1ZpfcnzoLKkBDDx1dm/TBG2ReuHDhxUqVKR15MX+SUtp24
 /aHYpkKJBrAXk0mZ0ACZBab9PdtBROHXU71i1OSFDnYynMeb6Cl7LavxB6BqLt6u
 No8cH3LJEplBCCC4Ptzkc9Ef+0snYUyUV0RVjcgzknI486Z+J4uDsaqs7E5ZFEvw
 Nd2iaTJG66YK05ucJyi7Pzcw8M/hkOwb9hl7K82g7Pdz4mNyVCijwsBMy6LRuaTf
 Wz5JuDzwYxK+WIRleLmwBS1CorklCTn+PfdgwA9HUuUKlsus2UP57Huumsidonx6
 Wy51WLZHgl/X+I34LhycT0Pu3jz47Ue0OCj/D46cECVp8G+L9yIYneoArVEqtybu
 bpEaz5TJ9n8uk/jqBti8Ioi9A73hO3m6At/xwOInCYwz

On 6/12/22 22:16, Joseph Qi wrote:
> Hi,
> 
> Why can't use local mount? I don't remember if we discuss about this.
> 
Sorry, I can't follow your question.
Do you mean why revert commit 912f655d78c5?

or you are interest with the feature local mount?
the local mount is created by mkfs.ocfs2, which can't be converted to clustered.
see mkfs.ocfs2(8) '-M' option.

/Heming

> 
> On 6/8/22 6:48 PM, Heming Zhao wrote:
>> Below commit log copied from Junxiao's patch:
>> https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000107.html
>>
>> Junxiao planed to revert commit 912f655d78c5("ocfs2: mount shared volume
>> without ha stack"), but maintainer & I preferred to keep and fix this bug.
>>
>> -------------------------- snip  --------------------------
>> This commit introduced a regression that can cause mount hung.
>> The changes in __ocfs2_find_empty_slot causes that any node with
>> none-zero node number can grab the slot that was already taken by
>> node 0, so node 1 will access the same journal with node 0, when it
>> try to grab journal cluster lock, it will hung because it was already
>> acquired by node 0.
>> It's very easy to reproduce this, in one cluster, mount node 0 first,
>> then node 1, you will see the following call trace from node 1.
>>
>> [13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
>> [13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
>> [13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
>> [13148.749354] Call Trace:
>> [13148.750718]  <TASK>
>> [13148.752019]  ? usleep_range+0x90/0x89
>> [13148.753882]  __schedule+0x210/0x567
>> [13148.755684]  schedule+0x44/0xa8
>> [13148.757270]  schedule_timeout+0x106/0x13c
>> [13148.759273]  ? __prepare_to_swait+0x53/0x78
>> [13148.761218]  __wait_for_common+0xae/0x163
>> [13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
>> [13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
>> [13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
>> [13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
>> [13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
>> [13148.775401]  ? iput+0x69/0xba
>> [13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
>> [13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
>> [13148.781756]  mount_bdev+0x190/0x1b7
>> [13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
>> [13148.785634]  legacy_get_tree+0x27/0x48
>> [13148.787466]  vfs_get_tree+0x25/0xd0
>> [13148.789270]  do_new_mount+0x18c/0x2d9
>> [13148.791046]  __x64_sys_mount+0x10e/0x142
>> [13148.792911]  do_syscall_64+0x3b/0x89
>> [13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
>> [13148.797051] RIP: 0033:0x7f2309f6e26e
>> [13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>> [13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
>> [13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
>> [13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
>> [13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
>> [13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
>> [13148.816564]  </TASK>
>>
>> To fix it, we can just fix __ocfs2_find_empty_slot. But original commit
>> introduced the feature to mount ocfs2 locally even it is cluster based,
>> that is a very dangerous, it can easily cause serious data corruption,
>> there is no way to stop other nodes mounting the fs and corrupting it.
>> Setup ha or other cluster-aware stack is just the cost that we have to
>> take for avoiding corruption, otherwise we have to do it in kernel.
>> -------------------------- snip  --------------------------
>>
>> ** analysis **
>>
>> Under Junxiao's call trace, in __ocfs2_find_empty_slot(), the 'if'
>> accessment is wrong. sl_node_num could be 0 at o2cb env.
>>
>> with current information, the trigger flow (may):
>> 1>
>> node1 with 'node_num = 0' for mounting. it will succeed.
>> at this time, slotmap extent block will contains es_valid:1 &
>> es_node_num:0 for node1
>> then ocfs2_update_disk_slot() will write back slotmap info to disk.
>>
>> 2>
>> then, node2 with 'node_num = 1' for mounting
>>
>> ocfs2_find_slot
>>   + ocfs2_update_slot_info //read slotmap info from disk
>>   |  + set si->si_slots[0].es_valid = 1 & si->si_slots[0].sl_node_num = 0
>>   |
>>   + __ocfs2_node_num_to_slot //will return -ENOENT.
>>      __ocfs2_find_empty_slot
>>       + search preferred (node_num:1) failed
>>       + 'si->si_slots[0].sl_node_num' is false. trigger 'break' condition.
>>       + return slot 0 will cause node2 grab node1 journal dlm lock, then trigger hung.
>>
>> ** how to fix **
>>
>> For simplifing code logic design, We make a rule:
>> If last mount didn't do umount, (eg: crash happened), the next mount MUST
>> be same mount type.
>>
>> All possible cases, when enter ocfs2_find_slot():
>>
>> 1. all slots are empty, [cluster|nocluster] mode mount will succeed.
>>     this is clean ocfs2 volume case.
>>
>> 2. for nocluster mount action
>>     - slot 0 is empty, but another slot is not empty:
>>       - mount failure. (there should be in clustered env, deny mixed mount case)
>>     - slot 0 is not empty, all other slots are empty:
>>       - slot 0 is nocluster type: mount success  (may crash last time)
>>       - slot 0 is cluster type: mount failure (deny mixed mount case)
>>
>> 3. for cluster mount action
>>     - slot 0 is empty, but another slot is not empty:
>>       - mount success
>>     - slot 0 is not empty, all other slots are empty:
>>       - slot 0 is nocluster type: mount failure (deny mixed mount case)
>>       - slot 0 is cluster type: mount success (may crash last time)
>>
>> above with simplified form:
>> 1.
>> clean parition => nocluster/cluster@any_node    - success
>>
>> 2.
>> cluster@any_node => nocluster@any_node          - failure
>> nocluster@node1 => crash => nocluster@node1     - success
>> nocluster@node2 => nocluster@node1              - success [*]
>> cluster@any_node => crash => nocluster@any_node - failure
>>
>> 3.
>> cluster@any_node => cluster@any_node            - success
>> cluster@any_node => crash => cluster@any_node   - success
>> nocluster@any_node => crash => cluster@any_node - failure
>>
>> [*]: this is the only risk to corrupt data. we allow this case happen:
>> - node2 may crash or borken, and fails to bootup anymore.
>> - node2 fails to access ocfs2 volume, needs to manage from another node.
>> - mount.ocfs2 will give special warning for this case.
>>
>> Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
>> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/dlmglue.c  |  3 ++
>>   fs/ocfs2/ocfs2_fs.h |  3 ++
>>   fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
>>   3 files changed, 62 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 801e60bab955..6b017ae46145 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -3403,6 +3403,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>   	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>>   	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>>   
>> +	if (ocfs2_mount_local(osb))
>> +		return;
>> +
>>   	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
>>   	osb->cconn = NULL;
>>   
>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>> index 638d875eccc7..4fe42e638309 100644
>> --- a/fs/ocfs2/ocfs2_fs.h
>> +++ b/fs/ocfs2/ocfs2_fs.h
>> @@ -534,6 +534,9 @@ struct ocfs2_slot_map {
>>    */
>>   };
>>   
>> +#define OCFS2_SLOTMAP_CLUSTER   1
>> +#define OCFS2_SLOTMAP_NOCLUSTER 2
>> +
>>   struct ocfs2_extended_slot {
>>   /*00*/	__u8	es_valid;
>>   	__u8	es_reserved1[3];
>> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
>> index 0b0ae3ebb0cf..a5c06d3ecb27 100644
>> --- a/fs/ocfs2/slot_map.c
>> +++ b/fs/ocfs2/slot_map.c
>> @@ -26,7 +26,7 @@
>>   
>>   
>>   struct ocfs2_slot {
>> -	int sl_valid;
>> +	u8 sl_valid;
>>   	unsigned int sl_node_num;
>>   };
>>   
>> @@ -52,11 +52,11 @@ static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
>>   }
>>   
>>   static void ocfs2_set_slot(struct ocfs2_slot_info *si,
>> -			   int slot_num, unsigned int node_num)
>> +			   int slot_num, unsigned int node_num, u8 valid)
>>   {
>>   	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
>>   
>> -	si->si_slots[slot_num].sl_valid = 1;
>> +	si->si_slots[slot_num].sl_valid = valid;
>>   	si->si_slots[slot_num].sl_node_num = node_num;
>>   }
>>   
>> @@ -75,7 +75,8 @@ static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info *si)
>>   		     i++, slotno++) {
>>   			if (se->se_slots[i].es_valid)
>>   				ocfs2_set_slot(si, slotno,
>> -					       le32_to_cpu(se->se_slots[i].es_node_num));
>> +					       le32_to_cpu(se->se_slots[i].es_node_num),
>> +						   le32_to_cpu(se->se_slots[i].es_valid));
>>   			else
>>   				ocfs2_invalidate_slot(si, slotno);
>>   		}
>> @@ -97,7 +98,7 @@ static void ocfs2_update_slot_info_old(struct ocfs2_slot_info *si)
>>   		if (le16_to_cpu(sm->sm_slots[i]) == (u16)OCFS2_INVALID_SLOT)
>>   			ocfs2_invalidate_slot(si, i);
>>   		else
>> -			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
>> +			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]), OCFS2_SLOTMAP_CLUSTER);
>>   	}
>>   }
>>   
>> @@ -252,16 +253,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
>>   	int i, ret = -ENOSPC;
>>   
>>   	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
>> -		if (!si->si_slots[preferred].sl_valid ||
>> -		    !si->si_slots[preferred].sl_node_num) {
>> +		if (!si->si_slots[preferred].sl_valid) {
>>   			ret = preferred;
>>   			goto out;
>>   		}
>>   	}
>>   
>>   	for(i = 0; i < si->si_num_slots; i++) {
>> -		if (!si->si_slots[i].sl_valid ||
>> -		    !si->si_slots[i].sl_node_num) {
>> +		if (!si->si_slots[i].sl_valid) {
>>   			ret = i;
>>   			break;
>>   		}
>> @@ -270,6 +269,20 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
>>   	return ret;
>>   }
>>   
>> +static int __ocfs2_find_used_slot(struct ocfs2_slot_info *si)
>> +{
>> +	int i, ret = -ENOENT;
>> +
>> +	for (i = 0; i < si->si_num_slots; i++) {
>> +		if (si->si_slots[i].sl_valid) {
>> +			ret = i;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
>>   {
>>   	int slot;
>> @@ -449,17 +462,45 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
>>   {
>>   	int status;
>>   	int slot;
>> +	int nocluster_mnt = 0;
>>   	struct ocfs2_slot_info *si;
>>   
>>   	si = osb->slot_info;
>>   
>>   	spin_lock(&osb->osb_lock);
>>   	ocfs2_update_slot_info(si);
>> +	slot = __ocfs2_find_used_slot(si);
>> +	if (slot == 0 && (si->si_slots[0].sl_valid == OCFS2_SLOTMAP_NOCLUSTER))
>> +		nocluster_mnt = 1;
>>   
>> -	if (ocfs2_mount_local(osb))
>> -		/* use slot 0 directly in local mode */
>> -		slot = 0;
>> -	else {
>> +	/*
>> +	 * We set a rule:
>> +	 * if last mount didn't do unmount, (eg: crash happened), the next mount
>> +	 * MUST be same mount type.
>> +	 */
>> +	if (ocfs2_mount_local(osb)) {
>> +		/* empty slotmap, or partition didn't unmount last time */
>> +		if ((slot == -ENOENT) || nocluster_mnt) {
>> +			/* use slot 0 directly in local mode */
>> +			slot = 0;
>> +			nocluster_mnt = 1;
>> +		} else {
>> +			spin_unlock(&osb->osb_lock);
>> +			mlog(ML_ERROR, "found clustered mount slot in noclustered env!\n");
>> +			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
>> +			mlog(ML_ERROR, "eg. remount then unmount with clustered mode\n");
>> +			status = -EINVAL;
>> +			goto bail;
>> +		}
>> +	} else {
>> +		if (nocluster_mnt) {
>> +			spin_unlock(&osb->osb_lock);
>> +			mlog(ML_ERROR, "found noclustered mount slot in clustered env!\n");
>> +			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
>> +			mlog(ML_ERROR, "eg. remount then unmount with noclustered mode\n");
>> +			status = -EINVAL;
>> +			goto bail;
>> +		}
>>   		/* search for ourselves first and take the slot if it already
>>   		 * exists. Perhaps we need to mark this in a variable for our
>>   		 * own journal recovery? Possibly not, though we certainly
>> @@ -481,7 +522,8 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
>>   			       slot, osb->dev_str);
>>   	}
>>   
>> -	ocfs2_set_slot(si, slot, osb->node_num);
>> +	ocfs2_set_slot(si, slot, osb->node_num, nocluster_mnt ?
>> +					OCFS2_SLOTMAP_NOCLUSTER : OCFS2_SLOTMAP_CLUSTER);
>>   	osb->slot_num = slot;
>>   	spin_unlock(&osb->osb_lock);
>>   


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
