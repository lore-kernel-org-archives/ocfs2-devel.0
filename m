Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB749C77B60
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 Apr 2023 03:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m42YFXFUU9I2uDDitmWjj2ex8RHPQj3b1TW+DKcZGQg=;
 b=ka1K5x0OSEeQjFwUk0HkcrKUCmor+C0vNh7fXTOe46mxFVxR1Sr8FOTWTT/AHVodxR4oRBxRXDb0
   68nx8i6YpfXhj6xRP4kBEUOMVFXwil19GKC3g3DZ73TY3VMRM4VZQUSnRINh4LQ/HsfNnmZxSMLM
   eKGhYWCQ2iMo1z4qjco5spIt8jNuRzkwGfNScH69hqmX7hyV6gl52Dnhn4Au5sXlzJ1wIz3vf9XK
   ZnAtpZg+9jNxJxy6K/3cJByR7DKdlhV6+TxsmZdy80kQipZK2egXiYXdPFaEWZjFZy+4JV97OKXR
   9lLe8hYN2cgvTBN4jPvsqJ8ABvvVqSIijfh9Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m42YFXFUU9I2uDDitmWjj2ex8RHPQj3b1TW+DKcZGQg=;
 b=mMloy/G29KVqtI5689qMtZoJ6dMl1uQGwTmIBnVJsfaTTyKGCPduX4tFVDk2+qNaiMjHk6Bv6qDR
   i6HI2Si/d1FOE/FPVhTrtT4O4kUQYDl6F0YxtJOGSDWIGg/TH0dmS5uMc9mDLYUiaJONxPP1GiaT
   F8aLgxJhkU371WouXEV+9O/0wFgYANgYyqjf2inDUkqMMvW+pJUHrlX1Q0QMgtH5pnuOZ/tMWp5b
   lxl097tSeu7DO1Zrv6PF/QxnVk2nOO14cyDX+2L+mmnX9LNqB/N1zCPbWlN9gQVfTcelkPU+cJYM
   hXEB4Q1AN7YhJ7N/IIzqQ38RtgrFKV+tzfk3IQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTW00NQUR5VT1C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 30 Apr 2023 03:03:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFLNGKlJVvmirKRydMbM0tKVeRVxrD5wFtYLnJZc2c3AqJe/2mz1TmnkFxl19YdRrxqVJgk0XedreEUHzElRakSrEVHHSa0DlC2wv2uUtZVjvgy/PQ0bP57XF4WDC5OAzEGY+pvWa/AzjTixJ/30bFS9Eqkc1oR21yE3n7ZwB6wRfsr2rgoPZJlKt6pr3Yq4qAG0bATQXTw1pbRaiH2W6M2oTjoVr0Zt6ebAWGZDJ68YcsceRPD49ZYDp0ns1ihlc35k9DKKqJo7jj8asptbG9p3pdKoj/4QGi9CYn9iRB5wB/EmZBWSu+V0mbuekNwXWZ8FFC2gv9NIHuJP2GRLjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+J/GhDYisJ7M6DI8BEWGiftyTllcE9xM9wyXa9OPP4=;
 b=OBwbfaLLrfnNj+sgVq64rkHzRz7w8SMtZ5HAGO6kNAlHYbYrGl9+0mHj2igZoiK16he5CQaWYm9GptxoflwQU/pxaCnZJmSEuosAhJuWq/pHzX24QswG0f42KZ+E5q59WQRRlvhHdLRXu7QBVpd7ENcknA3Cu5ig6++ezDEcXyDKIAosijen+/v0c2nTQif5yQpOi9MW58zhuKLgIGvjJ3kWQ/rYJaunPJDU//O/Dh2YVLDs5xosSIQcIlbbHQCVr6zgLDosaVj8BpPHj1N92WT8IRx0kxMNIbS1dc1jqjUWtesbVsqU5Nz3xIuYjH3jLzVFOEKGXHUnOCtoOCsy1g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+J/GhDYisJ7M6DI8BEWGiftyTllcE9xM9wyXa9OPP4=;
 b=CLqW+PuO+um8HoOPpu3cN376swAcv7ltqjF3oCUVVBfQTsXgWKWobSb+8YyAPS48Lswdavu4IF9Avavy8U1k01k/UBFZmF+J62hoAz0zk6kcZ2DnsQOpEPhggRBTLAqDAlQDhiAnGXchaMCkiv45DdSqYWcBp7iP3ZgG0pvU6Sx7Ol+v2eOGmp9ewqkbEzAAha2dN2KcLv7tA59Nt7IJxwXmPwBpoBcc/kqsFTKulcKHyHA9oe5VUnZMvjHYQ9X2oiB93ltTCUorI0iUSNQqdJIae11cdKaybOciS65/eF3CuPsjhX2cT/c5010/d5wIZsERm3kc5ImJ2JKxmedHLA==
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20230421083653.20380-1-heming.zhao@suse.com>
 <46f6fa85-9001-2cb9-3972-327ad8ba33a0@suse.com>
Message-id: <087e8f12-f03c-d175-4200-962d73641c23@suse.com>
Date: Sun, 30 Apr 2023 11:03:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <46f6fa85-9001-2cb9-3972-327ad8ba33a0@suse.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(39850400004)(396003)(136003)(376002)(366004)(451199021)(316002)(53546011)(6512007)(6506007)(26005)(186003)(2616005)(41300700001)(83380400001)(66476007)(478600001)(66556008)(66946007)(4326008)(6486002)(6666004)(6916009)(966005)(38100700002)(2906002)(36756003)(31696002)(86362001)(5660300002)(8936002)(8676002)(44832011)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 03:03:10.1435 (UTC)
X-Source-IP: 40.107.21.41
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10695
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=108 bulkscore=0 adultscore=0 spamscore=0 clxscore=178
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304300026 domainage_hfrom=9714
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix missing reset j_num_trans for sync
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
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com (2603:1096:4:92::25)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DU0PR04MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1f9a58-44b1-4120-fb43-08db49276dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Ze0rFdrhBq8O5kOHmzJKqTDe8P1FPhxvL6/flJZmEdRlNe/JlKNQoSnH43ZKR/0jCjUtWxROtU9IRqwmMNYG3piHZVZxq1rBuXgaMLsNp7RNRQfSehgwGwt/IpvSrrJ7WGEgB7O1kR7bUgxfyL2Jta8GukP+uvvpusGsO9dIVymq7x/sCSpaSmM7eJdv4b0SZqUp5/oPvOFLem5qR1duz7n/IjoJ+KFPkDTdSGD1Mkvo6tB0G6RUxvqnFm2fMDCxybT6N5za3LDkCsTq/qR08Yc48Uo6t1nBwmAQpUfBlMf3p+l+K5Ze7PWtuaAveDVaI0sx9o6sg7UrIoJrfksJeoKqsVF8Rv5B9AjGsDwZ1WpqiwisYspj5kqO4XXfjV6YtQTxh9lYtUak0nGE2QhC4lgYMx9Qyy7h+GXgE+KfQ+89i+NZJFDa6wzrHXFcwzwA4q5ysj5D8KGLESnbXcMDuOuK/MrKgNmPb8ShyG8h6BUK6kTm0y9YdgDT48QVVMLQxPUp2rFjfFSV75soC/xSfiNa9gk01DwZHVRgFVGjqbha82YvecwuDIH5oNM4/+vwFdxHb9466quPsilLkR3dvt7SXCx9JSrvWjiHJ5L7VdxwAspX6s4kMGqHdcvbIi25t+ck6z5vCxJJnqPL4KUhTw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?V1ZTWmNuN2ZlWUFDdm9ZWTNjZENiVEw1MUwzaURxODVhSWlIV040Q05lVllX?=
 =?utf-8?B?WHdlY09sOWVBeERnV0NtSmlLK01OV1lhZTc2ZjM4dmJmaDBhU0pUK1hheVhn?=
 =?utf-8?B?KzU2SS9TZWJSMmRuT1VJYTNzQ0RRWm8wQkRyRHR4NGZyejZIaEptWVpBd0U4?=
 =?utf-8?B?NUgyNDRjVGlUdW5jUTE0QitlWFRka3lsenl2aGhHcEV1VDgwaGlLd09waVJa?=
 =?utf-8?B?YUsrOGRzcGhSQTRKM08wb0NkVHdmYnJKSWtleEN6T2xmNk0yQlROTUxLYmE5?=
 =?utf-8?B?VllCQlRRMEhkTUQ5UXRCR2VJUHVxNkF4OXFWME1CNm5LRFNiWmprbUtMM0hj?=
 =?utf-8?B?R1JhdURMaFdhVVJTaTNPRytFMEp3TDljY2g3L1Zkd1loRG9PY2lzZGVVSCtz?=
 =?utf-8?B?b1NkS0tad285bHRMS0tMd3k0Uk1qOHNOb1lRd0JtazlXVUc4am41bW1yNUZP?=
 =?utf-8?B?YUI5VXZlNGxxeU1UVWI3VElubGFjZUVFdDk3Ym84cCs3MkcrQkFUZGwwYlRZ?=
 =?utf-8?B?a0Z1bEVyQkVQeXd5NFozNXVqMDU3RXh5UTZkVmZWdW9xb1N1VXlpYk0wT2dn?=
 =?utf-8?B?NXBHeUxmcnNMTHkvc200bjFHdU9BQmhuSG5MOVpkVDA2Um9STTZmL3cxeUdp?=
 =?utf-8?B?czB2bDVScUxyQXhoMU93dE40UEpSUW0rV1JkbWpWTzhubER0dkhrYXhRSXlv?=
 =?utf-8?B?dFhudW4rNEJlNFQ5bkRTakUvTTF0SktYZFVVK1JxNEg1S0dTb3E4REhTYzJL?=
 =?utf-8?B?WG1hSFBMVzNFcnlFbkF6MzZpeXBTS09WRFlKQXBvMlUrckV6QWIyMVdRNlNV?=
 =?utf-8?B?Qm1WckVOS2FDUmNEeEczVUN3cUM1OWN0WU1YWG9mWHp2TXVldUNiOTk0c09H?=
 =?utf-8?B?eEpzVlRiemd3UFp3WHNqOE1sLzBwc2FWVFVMU0s0SjJNV3hCZllyUnZ0NFVu?=
 =?utf-8?B?QnozRjRiNW16L1JYQjVvZFFqa0ppY2tuM2ZlWW53VTM0VnJ0T3hDaHl4bWRQ?=
 =?utf-8?B?SG8yeXMzdmFBcU5iZklJdGxTRWNCamdMWjN3dkFCOTNmNTE5MHptSlpnalc4?=
 =?utf-8?B?d2hwV1krNWp2cU10N0ZPZnlhM0lXTEhLTW1Vd255cCthOHVCaTB6VTdoVVY1?=
 =?utf-8?B?a1NkRkkxZ0tEUkJ0YXlWRFVCOEFvZ1kyZGRLUDNVbEpzUVZGaVpUcHJlRDVX?=
 =?utf-8?B?S21PQnJTbmZBN1ZpN092KzZ1V2dQME5JenFzdDBzYWRHVTBBSG45aXlsb09r?=
 =?utf-8?B?aGtGNThCUVFwZFlhdVRiejhzL1NaOWJ2d3Y3N1czSUpvMS9CbVVDa2M4U09i?=
 =?utf-8?B?N3c2dWVXbmUwNjNyUzd1M1pjeUdtdzBhaG1ieFNzdE42QXVnZGJGL0tHYUYx?=
 =?utf-8?B?UUIvODFvYnRwRW81MGdjQXhLam54dEpnNTYydGU4NjB4VWtFMCtFNmhiaEVT?=
 =?utf-8?B?S21XcmE5dzJKMERRMXIxNVl5NSt3SGNFbmw5ZUVZSzdLaFJJdXA1d1FhMDlV?=
 =?utf-8?B?OHE4NjlVc3NBSVpPeXJPK28xRUc4RExlQ0NLTWRHMDlsRSthTisyYk9TUXB0?=
 =?utf-8?B?WmY0b3FXRHVWbS8wYmdaU0hCVXVxdGMrWXh4eHd1cmZyWnFCNmlKZThIdjhy?=
 =?utf-8?B?Nmc5TVp6RE82NGh2RGRUQmhiWG56enVBU05ORTMwT3JFOWo1UGV5ZU1NRzll?=
 =?utf-8?B?NkFkY2lKdU1EZVBHcW9GMHlxOTA1L09QbnBva01mdUpYU3NrbTlkL3dTdXNP?=
 =?utf-8?B?TThxa1V3UlI3OXB5ODRQc09vQnljSkhnM1E1eUgzck8xeS9LWDNIckdRK2pF?=
 =?utf-8?B?ZVBsSzFZbEdSRGtGcWl0a3VvVU9pOWpZT1NobkU5M2VQdm1scUJGQ3EzUm5G?=
 =?utf-8?B?a3Y0TjV0RFpzTkNQSlVlVno5MjlHY25FUkE1ZjZWMDU4ejRjUWw5Rk11cVl2?=
 =?utf-8?B?VUJsSWZsbDVmU3RmNndocjJicjlaMlJyZlFqaU4xNHQ4UTUyNXlrTnF0WGJY?=
 =?utf-8?B?WHYrY0FwWTg4NUJmSWg1RWRFbW5oclg5cG5mV2x0UCtyeVpSRllKZW1NVHdR?=
 =?utf-8?B?dmZ6ZUx2N0VSNkN5dnV0SXo2S0ZkeVl4VkF0c2lGWVV1ckFkWlhuYVNpNjRB?=
 =?utf-8?Q?gK3xJUnx1607d8jWn8dkjzIv2?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 fc1f9a58-44b1-4120-fb43-08db49276dc4
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 9ruR+BQYjGfd906IrwY9NeYnF1wPxqNK3ILfFrO1l2xgj1KE/lfC9VIxVYzc3Pw5m99aYseEvS5nJ+xJez6q+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9493
X-ServerName: mail-vi1eur05on2041.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: weUfuYyW9jixEk5o50L-OYLq3jmi3sb9
X-Proofpoint-ORIG-GUID: weUfuYyW9jixEk5o50L-OYLq3jmi3sb9
Reporting-Meta:
 AAE+OngCQZoG2KRYn5WkJhlcWoiwAtIqUMKOo6Wnf6L9sEZ8vc5R9QZxzu7W9tjU
 RcNlxhZg2NqqHaSqoKqxV/x/EPylTvYAa1cz84qUkbJ1SDGA4ux/u/Md4W8TjuSQ
 oVOdcZWHDdRc54xespoQvd5QOHJIZKjU5te9mWlKKHoAeKssjE7CjrM5xUy+k8tJ
 tX2GU33CzGv8Cz16yfUsbpM0NBrji8gH3F5GGWTRPlxDPVg1ea65v6qc/Vb7I5k/
 /1X9nFZhCaJlW3CbudJI6UnEnvtrqCJAMdBypjm7CjX8VaHUbk9WeHJjFxss3sTR
 6REzOnXMPMRfsw4TDSShG7gdtVjv40eezPPr1+wg9v4ZIOlzAyT3Smof1v59VJco
 XXY3nU8CkwMFXFLF3jBttNFkUZDfph4ql2hTKVjr1gGYHpvd7a0PXTW/PXr4bW55
 8ImybnGIahZtKnAyHzjBGj0I+gkBeu00QlVOgAOj4GdVQlIkiX4f7O6NMciu87vk
 hIz0m9hWr3N3sQF4fYGj5bkonpQmPX4zubBuxretZZM=

Ck9uIDQvMjIvMjMgNDo1NSBQTSwgSGVtaW5nIFpoYW8gdmlhIE9jZnMyLWRldmVsIHdyb3RlOgo+
IFNvcnJ5LCBwbGVhc2UgcGF1c2UgdGhpcyBwYXRjaCByZXZpZXcuCgpJIHdpbGwgc2VuZCBhIG5l
dyBwYXRjaCB0byBzdXBlcnNlZGUgdGhpcyBvbmUuCgotIEhlbWluZwoKPiBXaGVuIEkgd2FzIGlu
dmVzdGlnYXRpbmcgZnN0ZXN0IGdlbmVyaWMgZmFpbGVkIGNhc2UgMzQ3IDM2MSwgSSBmb3VuZAo+
IHRoZSB3YWtlX3VwKCkgYWN0aW9uIHNob3VsZCBtb3ZlIG91dCB0aGUgJ2lmKCknIGFyZWEuIFRo
ZSBjb3JyZWN0IHdheQo+IGlzIGNhbGxpbmcgd2FrZV91cCgpIHVuY29uZGl0aW9uYWxseS4KPiAK
PiBUaGFua3MsCj4gSGVtaW5nCj4gCj4gT24gNC8yMS8yMyA0OjM2IFBNLCBIZW1pbmcgWmhhbyB3
cm90ZToKPj4gZnN0ZXN0IGdlbmVyaWMgY2FzZSAyNjYgMjcyIDI4MSB0cmlnZ2VyIGhhbmdpbmcg
aXNzdWUgd2hlbiB1bW91bnQuCj4+Cj4+IEkgdXNlIDI2NiB0byBkZXNjcmliZSB0aGUgcm9vdCBj
YXVzZS4KPj4KPj4gYGBgCj4+IMKgIDQ5IF9kbWVycm9yX3VubW91bnQKPj4gwqAgNTAgX2RtZXJy
b3JfbW91bnQKPj4gwqAgNTEKPj4gwqAgNTIgZWNobyAiQ29tcGFyZSBmaWxlcyIKPj4gwqAgNTMg
bWQ1c3VtICR0ZXN0ZGlyL2ZpbGUxIHwgX2ZpbHRlcl9zY3JhdGNoCj4+IMKgIDU0IG1kNXN1bSAk
dGVzdGRpci9maWxlMiB8IF9maWx0ZXJfc2NyYXRjaAo+PiDCoCA1NQo+PiDCoCA1NiBlY2hvICJD
b1cgYW5kIHVubW91bnQiCj4+IMKgIDU3IHN5bmMKPj4gwqAgNTggX2RtZXJyb3JfbG9hZF9lcnJv
cl90YWJsZQo+PiDCoCA1OSB1cms9JCgkWEZTX0lPX1BST0cgLWYgLWMgInB3cml0ZSAtUyAweDYz
IC1iICRidWZzaXplIDAgJGZpbGVzaXplIiBcCj4+IMKgIDYwwqDCoMKgwqAgLWMgImZkYXRhc3lu
YyIgJHRlc3RkaXIvZmlsZTIgMj4mMSkKPj4gwqAgNjEgZWNobyAkdXJrID4+ICRzZXFyZXMuZnVs
bAo+PiDCoCA2MiBlY2hvICIkdXJrIiB8IGdyZXAgLXEgImVycm9yIiB8fCBfZmFpbCAicHdyaXRl
IGRpZCBub3QgZmFpbCIKPj4gwqAgNjMKPj4gwqAgNjQgZWNobyAiQ2xlYW4gdXAgdGhlIG1lc3Mi
Cj4+IMKgIDY1IF9kbWVycm9yX3VubW91bnQKPj4gYGBgCj4+Cj4+IEFmdGVyIGxpbmUgNDkgNTAg
dW1vdW50ICYgbW91bnQgb2NmczIgZGV2LCB0aGlzIGNhc2UgcnVuIG1kNXN1bSB0bwo+PiB2ZXJp
ZnkgdGFyZ2V0IGZpbGUuIGxpbmUgNTcgcnVuICdzeW5jJyBiZWZvcmUgbGluZSA1OCBjaGFuZ2Vz
IHRoZSBkbQo+PiB0YXJnZXQgZnJvbSBkbS1saW5lYXIgdG8gZG0tZXJyb3IuIHRoaXMgY2FzZSBp
cyBoYW5naW5nIGF0IGxpbmUgNjUuCj4+Cj4+IEluIDI2NiwgbWQ1c3VtIGNhbGxzIGpiZDIgdHJh
bnMgcGFpcjogb2NmczJfW3N0YXJ0fGNvbW1pdF1fdHJhbnMgdG8KPj4gZG8gam91cm5hbCBqb2Iu
IGJ1dCB0aGVyZSBpcyBvbmx5IC0+al9udW1fdHJhbnMrMSBpbiBvY2ZzMl9zdGFydF90cmFucywK
Pj4gdGhlIG9jZnMyX2NvbW1pdF90cmFucyBkb2Vzbid0IGRvIHJlZHVjdGlvbiBvcGVyYXRpb24u
Cj4+Cj4+IGNhbGwgZmxvdzoKPj4gYGBgCj4+IFttZDVzdW1dCj4+IMKgIHZmc19yZWFkCj4+IMKg
wqAgb2NmczJfZmlsZV9yZWFkX2l0ZXIKPj4gwqDCoMKgIG9jZnMyX2lub2RlX2xvY2tfYXRpbWUK
Pj4gwqDCoMKgwqAgb2NmczJfdXBkYXRlX2lub2RlX2F0aW1lCj4+IMKgwqDCoMKgwqAgKyBvY2Zz
Ml9zdGFydF90cmFucyAvL2F0b21pY19pbmMgal9udW1fdHJhbnMKPj4gwqDCoMKgwqDCoCArIC4u
Lgo+PiDCoMKgwqDCoMKgICsgb2NmczJfY29tbWl0X3RyYW5zLy9ubyBtb2RpZnkgal9udW1fdHJh
bnMKPj4KPj4gc3luYyAvL25vIG1vZGlmeSBqX251bV90cmFucwo+Pgo+PiBfZG1lcnJvcl9sb2Fk
X2Vycm9yX3RhYmxlIC8vYWxsIHdyaXRlIHdpbGwgcmV0dXJuIGVycm9yIGFmdGVyIHRoaXMgbGlu
ZQo+Pgo+PiBfZG1lcnJvcl91bm1vdW50IC8vZm91bmQgal9udW1fdHJhbnMgaXMgbm90IHplcm8s
IHJ1biBjb21taXQgdGhyZWFkCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvL2J1
dCB0aGUgdW5kZXJseWluZyBkZXYgaXMgZG0tZXJyb3IsIGpvdXJuYWxpbmcgSU8KPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8vZmFpbGVkIGFsbCB0aGUgdGltZSBhbmQga2VlcCBn
b2luZyB0byByZXRyeS4KPj4gYGBgCj4+Cj4+ICoqKiBIb3cgdG8gZml4ICoqKgo+Pgo+PiBraWNr
IGNvbW1pdCB0aHJlYWQgaW4gc3luYyBwYXRoLCB3aGljaCBjYW4gcmVzZXQgal9udW1fdHJhbnMg
dG8gMC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogSGVtaW5nIFpoYW8gPGhlbWluZy56aGFvQHN1c2Uu
Y29tPgo+PiAtLS0KPj4gwqAgZnMvb2NmczIvc3VwZXIuYyB8IDMgKysrCj4+IMKgIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL3N1cGVy
LmMgYi9mcy9vY2ZzMi9zdXBlci5jCj4+IGluZGV4IDBiMGU2YTEzMjEwMS4uOTkyOTMyMGJkOTY3
IDEwMDY0NAo+PiAtLS0gYS9mcy9vY2ZzMi9zdXBlci5jCj4+ICsrKyBiL2ZzL29jZnMyL3N1cGVy
LmMKPj4gQEAgLTQwOCw2ICs0MDgsOSBAQCBzdGF0aWMgaW50IG9jZnMyX3N5bmNfZnMoc3RydWN0
IHN1cGVyX2Jsb2NrICpzYiwgaW50IHdhaXQpCj4+IMKgwqDCoMKgwqAgaWYgKGpiZDJfam91cm5h
bF9zdGFydF9jb21taXQob3NiLT5qb3VybmFsLT5qX2pvdXJuYWwsCj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnRhcmdldCkpIHsKPj4gK8KgwqDCoMKg
wqDCoMKgIC8qIGtpY2sgY29tbWl0IHRocmVhZCB0byByZXNldCBqb3VybmFsLT5qX251bV90cmFu
cyAqLwo+PiArwqDCoMKgwqDCoMKgwqAgd2FrZV91cCgmb3NiLT5jaGVja3BvaW50X2V2ZW50KTsK
Pj4gKwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHdhaXQpCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGpiZDJfbG9nX3dhaXRfY29tbWl0KG9zYi0+am91cm5hbC0+al9qb3VybmFsLAo+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRh
cmdldCk7Cj4+Cj4gCj4gCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KPiBPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKPiBPY2ZzMi1kZXZlbEBvc3Mub3Jh
Y2xlLmNvbQo+IGh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1k
ZXZlbAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9j
ZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczov
L29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
