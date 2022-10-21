Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDB0FA373D
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DeLAEZodX1JEPbhn2rQ3pbXFNzL9c1JpcStWPQbdPD4=;
 b=k9h8M6hgYbbS2U5v+bdP860TUmdZaaYm4R1iIZFPfW0+cKvn+fEDQVaNt0wkgO5eVnNg0KufnNIk
   NWjQhtB7qP6m28/bjTX2efvP9g/bfnI7Jb0HOJLqTmM1L/O43eZQwFVQtfkDsH/e2IcV8QW0vFKe
   2zodOOnGuuWLuV2Z8Q3L9rHeLij/zdNsPRb7DJezsrx5gxW6n6rlA8yrz1RyUJW4zYaRQck0FBCX
   Wi+YxM8t9VQWvb2dfhYJgygQgDoiyVNI4IcfSaI+ctPqvGIvXr8yy2M+GWRvmfAhwgRteuGWfp9t
   AW1sYQsnuWJrMqN+rHCfOqyA4rcCTY+1Ns55dQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DeLAEZodX1JEPbhn2rQ3pbXFNzL9c1JpcStWPQbdPD4=;
 b=TcB07ooqyun6JXryflO3PTS4LtaGH/e1c6YGyLZxNAHQRXI4GP5B1j4ezVg0eyFSHrdlQPr/fGi7
   ++rOoSHCI2aqg/MtbcLIF7xaWiN1nj2CKGdQ++lv+WH+UnKUqLuilojwUghbRFW4aMy/S2znyger
   T3is2How6WSH3sW8w9yWsy8DBo3wJAY4+bT1ztdetrhcp2ChogZY3huaWBXzjW2PIhzJPBpQBD2t
   aI6NJ2ZBm/G5SemDtT8NlY89ic/qPjKOB1frAlvBwFdZsPl1gsAUywfKDn+eD+fP1AOQES5tR40a
   xt8d7WPj5DDYW64+y9lNBvvtw4D0AnWpDBJHrQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK400GDA538BA80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 17:11:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiBPhBQ2nOXbUFCs7D5HGwyluye/fUQqBA5PvYJzQia3laq2GSwSgX9uKFeQmE2Z4eUmTR+WA4i0N/txe5YgN3ABkzYz5gp86j/g1VC4gxLdBePTAVcv6h2eoXwjEk/Z2UwwG9PzgDziyphoQXTibIpcqDdCfUWYUpLur1XLIi3C62H7VC2maEJ2EaAJDCqBR04PR/xzzyQv7PotlEcXukxbUipM9gP4/UK99wm0DTfj4xGuMfCymQPbp9lnmAthbaeLUcr/xCtkc33CLVo6u7iZL+2PjaNJeIzZ8zjDvoBOz1S8Xt1Gx2lPsczbo7VId3dwy7bR5cDKXeZ7hcjJYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kswLU+QXVjGel8efLF/xe4ADNltyaBWMDBUjsYNU08=;
 b=ls2NCoToUapn5syZLlITC1Q92jhiM1KsupxiqT6XAiM7y47WnLbE0CKGDSfmkO0qbBxKmfhpi62BPt0BiEtdv5MJlQNTWQth5eSDb2gAyg8sVAxCEgsMYFG8ZQmye7JuxL3SFQIfwIdcsJ5mnq4MahSkP3YL3JWhnwMcrsdPiWtXy/HNKcqFOL+zn/e0TwfqwcnUN5I1abLk5sqMZZsSM08QCwI2qS40i37LMn9IP/aZCB0i3EeS/g6x/RX/28F8J1XKhmnzKioqik+tg6o75m2OismFj5WF/WFIxQfJvnW8kDyDmcyeYJ+2ump0V5CCGVIj9YtUOjMEToC69+aZCA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kswLU+QXVjGel8efLF/xe4ADNltyaBWMDBUjsYNU08=;
 b=WJ0jQImWSV75QjjuPEDeZOjxLsPxQa6iRjyFqZrAuxt28pedGRaM0T6N++/9K/P2cF3RC7hzbSzx+p7VvtJ/rbaM9g/BVyRFtxRd8BYIzpsZwNAWKKos6nSMpL/BN97cd+3VDpXtgRgbUXqrxFT6oZmBjHNBmYMv2dWtjv/CRgE=
Message-id: <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
Date: Fri, 21 Oct 2022 01:34:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-language: en-CA
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 qemu-devel@nongnu.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com,
 linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <20221021022102.2231464-2-yangyingliang@huawei.com>
In-reply-to: <20221021022102.2231464-2-yangyingliang@huawei.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR12MB3370.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(7416002)(38100700002)(4001150100001)(44832011)(26005)(41300700001)(2906002)(2616005)(186003)(316002)(6512007)(4326008)(6506007)(53546011)(478600001)(6666004)(66556008)(66946007)(66476007)(8936002)(8676002)(6486002)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 05:34:20.4840 (UTC)
X-Source-IP: 40.107.220.42
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=228 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 clxscore=85 mlxlogscore=880 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210032 domainage_hfrom=13122
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, hsiangkao@linux.alibaba.com,
 rafael@kernel.org, jaegeuk@kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 01/11] kset: fix documentation for
	kset_register()
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
From: Luben Tuikov via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Luben Tuikov <luben.tuikov@amd.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: YT4PR01CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::7) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|DM4PR12MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: a9491d3e-ef28-48f9-3113-08dab325e753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 XB5kmHg66LbsiNDVHYvX4BkXOvPZMSQENQW2K0Ywy67IaMYSlA9fdZfyzQiqQ7UvWfVNQprVMrRDBSlE1nrQD+T0HPOwNqlVyQ2eknHecE3s6m5ZpvE9y5gOzc+6ncEOGp0RviEYzkDCvrDnLVSzuhjiSBRr3gFKOQ+ZD4S4UNDDXICZC1jN02ICapAkYGmagRK3qcYt5j+IRMmjpGE7v5Y5gwtwOxkrlD8UYhKpD3Phq1KPzHsbtj/9hZFV7SAEEMu+xXNraJavmY6cQ+Rc12QPY1X388Ohu8C+8IK0y8T9A7JNOZm3q7kZ/uo4P/v6DK0cQBSJ9ga3o3wZLOjfHjkudSK4tu726VjbUJdax992742RCHna5ZqQ+S0DnNxd7REGBQxITGyiwBLttgqRlziPDKsfLBzNPfK07+XMFWiepmJXxfsEU7gFyRkrjkj8LbQ5QNZqYPcCcemjusVgIlvGap0Jqz2QqnT0hIP3hAlV1vUIajOB/p23IqfBE8QrD8chd22+QqCdV3/TfKT6q4Utt90XAlS1/V0Q4orpxZZm8D2DG75dFq8Jc9EQVgXDlzJK3xaCzvh8Vs4HWSTc8MkzlfYIHAy0RW05nOxpfVCHy/Qw0Ky5QCp5dA6aUKynRLizYW56+e100DoI5shkfCQj6uE9yMXoCsXM9CFqghKCpFgNrlrPHVkqkz7M2mGX+b2CCVp0TFSi6eZVT7UkmTQCaNAN+ZzAjZedGcmkGpQj3k/RTrZahFTBmWKEMv/7wJ0FQ+2dYZMmP9bfQ9djEqewnp+SeXFxKKGApaGPyVg=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WU9MZW5zNG0wTEJDR3AwL3Fzd0YvdEs5c1JVUzBsMHlUZFAwL2F0TTQrV291?=
 =?utf-8?B?eXBZb0wyNVVOMmdIazlZMkxtUnhMeW16WjZJaE03RmFtZUhLbUV0UzFqREpO?=
 =?utf-8?B?SktyR2liUDhLTTM1WC9Od0RTQzZwaDAxUzA3VmQyZDRSTmREcmVHSFRHVVhJ?=
 =?utf-8?B?QURCOXJPNnc5bDdmeEtjbnk2QkJqWllLSWhjVCs2SDB2ZERqRGtzeXFhVE50?=
 =?utf-8?B?QWtoS09FejdvZ2kxQ3Q3cDZGRkZLZ3FrR0NKd0NFSkhSczltRVQvb1FkSUp1?=
 =?utf-8?B?YllTV1dnRFpFTldYeElTOTIyTHQrTzBJdjNEU2dHdSt0cHB1S0xzMFJJOWNz?=
 =?utf-8?B?aE5oVHRUODZLUWRWQmtlL2dOS0wzWE8waUljS3dTVVp0Z3ZwMDdBV3daRTA4?=
 =?utf-8?B?MXVQc29DQThiOUZqVnN4bWF1YTloMEY5RExENDF4U1lWbDdXMTd2UTBBU2di?=
 =?utf-8?B?VjlnZS9PMElWNXJVeUd4TEZHUmxUN3FkYXpaRTR1YWVqZ3pQSVcyWElwbFpu?=
 =?utf-8?B?dXVhS2pNYzR3bWdsY0JGckMzdlFSdGpoai92Y1RPZVQ3bUVCZE5HbVlEVkFh?=
 =?utf-8?B?M3YyeWxDemwxamhEdFpXb3J0M3p5b2x0bEdNVXBiL0hIR1ROWm11alFEbUZM?=
 =?utf-8?B?ZVlPTE1xVnBGdmFxdUljZm14MkFLTmpDTGs0ZHlwUUYzZTRTcUR6dzVPMUdj?=
 =?utf-8?B?eVBXcUo5b1JOTXVRNzlqR0hkc1VrdUxxRnQ1SSt6VUVCRXJZTml4eitqU3VF?=
 =?utf-8?B?YjhlMkN5ZWJidVo4Zld2SDExSDFLNzIxVStDeW84NUtycFBrQ1JwTGpsQmUx?=
 =?utf-8?B?VXFpR3pHY08yVXQ5cEhZVWlqV1dZTFdHTm5qOC9sc1VxeVU4QkpZNEpYcS9W?=
 =?utf-8?B?ZWVlUmxKQkdPenhDMVUvL01uaWgzc3EzUHFRUmdkNW1ZSFdWZ2RFMHNKcXZr?=
 =?utf-8?B?UklrOHh0VmEwYkdCM21lemRBVXc1U1FWZFlGVTVud3EzYnJUejRRT0Qwem5y?=
 =?utf-8?B?c09lNHphdEhvdUNUWWlIMytXekROUFBIV0ljM1FRMk1ZbDk0V1NVKzhLR0ZM?=
 =?utf-8?B?SEdSaXNmTSsxTEdIR3NZUURZVnBwSVZpVjd5TUVxUVBoMEM2M3BjekZZMG1F?=
 =?utf-8?B?d1pSS2E1MlZNMXNzbkhlQUFVQVh2Q1VncnNmRHRuNVhzOWtDcEthSjltbGtO?=
 =?utf-8?B?dGdzaFNxWi9ITXZKb3ZSbExLNnlsN280V0NVeFZWNHlGZlpTV251OXRxMEFB?=
 =?utf-8?B?Yi9wZWJIT0k0ekY1dncvYWxPWkUwU3owL0JsRnUwNjZqYmJjY29MZStHVitL?=
 =?utf-8?B?RHlhTmZ5TitTcWdsQkplcGJCZjNTTSt3QW5zcVhpUENKMDNpcG5YOXNUNFFT?=
 =?utf-8?B?N3BJckNGVk05OXhHUzVqVDQ4YnV1Zys4SktvbTBCcFIva2RjeEw2RytkRVdS?=
 =?utf-8?B?NUVrZnlVRmk1MjFpSmtrdHlNNEVuTWRWNDFhQlhBZzN0N1psaVgybDA2RWd2?=
 =?utf-8?B?TkFjcHFxMlp4dyswZEprdUMzRlY1OURLWWNFSTlGemJSWUlEd25ZMFpNSjlY?=
 =?utf-8?B?TjV2UnY3WEhCNks5eFVOZlFqbE1VS0dnK0hqNld6K3ZwT3RSeGkrUE12czdO?=
 =?utf-8?B?RDE4TVk1RVZPYWRXTzUzcVptR2pnamtZb3dndkM3WXc0b280VmwyK2VlWENP?=
 =?utf-8?B?WlZTRFVlVGl2WlcrZDZIcFhiQzNReVd0Rk1jbml1WkdRbGFUTmVOckd5MGxr?=
 =?utf-8?B?QktnQXFIZVdGaGhxVVBrNml6cDhzbEd3dWp2eDljMGhRcFBsbDhXUXYrZEJj?=
 =?utf-8?B?ZzQwL0VpcVVwQUJGU0crN09EdEtYd3FIYXlkZmEzTExXWFpmY2d2Z2RMc3gx?=
 =?utf-8?B?S0Rrc1JteUZKTlVNa2hjRmhQUkw2RW5KWXIrYTBraFVLTE5aWkxYL05tNzg2?=
 =?utf-8?B?SVhubjBCYWNtK1I2aE14blBsc0FkRlBRTHJaUm5jMG9EVXhIcHB5NVlNWERq?=
 =?utf-8?B?VXhibDlPOW1Wby8wajBGSGNxcjBHSEpPRmN3dksxd3FVRU1EV2xFVURLUk5l?=
 =?utf-8?B?aGtybmJjajVmYjdQQTBYLzFXcUtDN3lzcWN3U0VxTVIrQlVxeFE5VWV0SXlM?=
 =?utf-8?Q?ktrLQnaJ7A6j7KaUaHQbK4eVE?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a9491d3e-ef28-48f9-3113-08dab325e753
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 wgM7bHitqJbwFff0I0CDSiuhgmDyEAiTYxABfres5w6+GwGkXJ2liUUMwrvM60Rp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5796
X-ServerName: mail-co1nam11on2042.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:amd.com._nspf.vali.email
 include:%{i}._ip.%{h}._ehlo.%{d}._spf.vali.email include:oktamail.amd.com
 include:_spf.salesforce.com include:mktomail.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: t4MIWmQPJRKwi28PKgL4Xz43hKlQOYt_
X-Proofpoint-GUID: t4MIWmQPJRKwi28PKgL4Xz43hKlQOYt_
X-Mailman-Approved-At: Fri, 21 Oct 2022 17:11:31 +0000
Reporting-Meta:
 AAFvfua5JywrvgZWjYBwrHRikOV3x0Z3DFVt+txWo/Z8A3sL8KFqBezRITlPySvU
 49Q99WFjmkRkfrE/V1stdxkQUV99ZUOW9/NUCgW/WeyQ3fEwTVXK7Ft/RTW7I+E+
 HCfQ7RxNeJc6Vfs9CU3M3V4bUG/NBhQpYKBEsSWDjr3XvLXB+G5UIQUQ/7svjfsW
 lrIibEYlcOzz5oRy7WZdi2fpFDpZfnrxa04GboMmNGmpEBk5AjbSxX5xSrwmzb12
 TK6xV9+J9KPdt5uZ72MrEtGJAY6KqyPAD7Gm9SDhGp+vX5yq52HF1vvzRhDKfDNY
 dWkmL3JukG+sTOwtY5Iqn3nzsvTNrG39fPY6TT+CVPxVbamYLrTwv1jy/ZMA2rhx
 w46LgNSWX3e9bTBLRIrlTaVI7wLsxFfrWiy+G8YPWL6ZHSfTngoxvQ+zQSUBkNHB
 jLvoHZo5PMUCus0HcfXetSja00gODX1zFD4O+4t3/8ZZrtJON73BKVgfX4GH6RqV
 wLioL0PKeqIMwikjQ4G10HmfB0aCcDS2phNijZ9NeA==

On 2022-10-20 22:20, Yang Yingliang wrote:
> kset_register() is currently used in some places without calling
> kset_put() in error path, because the callers think it should be
> kset internal thing to do, but the driver core can not know what
> caller doing with that memory at times. The memory could be freed
> both in kset_put() and error path of caller, if it is called in
> kset_register().
> 
> So make the function documentation more explicit about calling
> kset_put() in the error path of caller.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  lib/kobject.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index a0b2dbfcfa23..6da04353d974 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>  /**
>   * kset_register() - Initialize and add a kset.
>   * @k: kset.
> + *
> + * If this function returns an error, kset_put() must be called to
> + * properly clean up the memory associated with the object.
>   */

And I'd continue the sentence, with " ... with the object,
for instance the memory for the kset.kobj.name when kobj_set_name(&kset.kobj, format, ...)
was called before calling kset_register()."

This makes it clear what we want to make sure is freed, in case of an early error
from kset_register().

Regards,
Luben

>  int kset_register(struct kset *k)
>  {

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
