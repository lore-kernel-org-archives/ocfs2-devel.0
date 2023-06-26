Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6721EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i3+IauIuPZoQVpT/3yrdxvkaTWTKMUx3BjvXw5lIfwc=;
 b=lV02UQaHEcy1C/qqfcWeE8X2qIJMrdswCFeQF5aQeR6AXcOBs1mjVG0wHphaEPonutPgm2vv0LWG
   JTC/nQADSaIud4x5T5P0nKqs0WXWFAXu7HzClQXmTEiJ6kLHoSw1izbAkFm9JSFk55N+cPSDI15O
   YW6jw0SKu7UQbELW5k0Psfvdq+9z4K8CbsJ+vQrgALxkbQ3q+jcp6u6UCdPk97JZCp25dxzzFHuM
   iMyYbj6ERucE/2FnpqZpsyYFm6tVP4/Fh/QPLO1YA+t2SxaoxYAVzRtmAyOdP5FsF3KkTtzJLFAx
   Cw/L7eHVoCuqTu77vexzjQP+cD/qxEQF/dslyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i3+IauIuPZoQVpT/3yrdxvkaTWTKMUx3BjvXw5lIfwc=;
 b=CTfPcTApW/a8+wp9yjg9R/V/9pR035f4xRjfO48o0l7k638sXw703eO+/ygCxlA+D5+0IGAbj8Np
   Gv/L8QC71piO0ehm0KQlaGvVAPatTbbiBFhLaKyczu9mVx+zpmJsKJ+ctzj15D7SL9ivUilJDKWZ
   kQSl96WDOl0N226YSmuORXbrFj0YsuAFt7dkZfvnmT4b21unYC/ZsUOQwb/uwv5YeOW5/cZRzFiX
   LUgzDJtItwdE6zixsQGagx8sBbqijHiCw3D33xmoRW2xlxm/yfvPNLVsC7KYzVcThjvgDZL3dx6p
   O9CZTOBf1qhqGRsI+a8OyS9J6IqckvmyMouVCQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV00I3G86IR680@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 14:56:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjJ/T8K7ptkv2ikVpjOV6syiiYbXI4Rn1v2H5najbRDD8igkaefAqkpobcwiksL77d17cgvAZzk21c94kXaOC9nZXt5pO0dq9EeBTEJLorSpZ2io0QvqHzuKraWGbqAXk060JbvWRPFzE5n/UGKP/S+tdLbTFIVNjIqbeD5UnfiGT+xjAaXvk/2MzOjC4v9F4WULuMMIRIY2OqX1qpsQYBeKOKnqEuzgZGafpbhv47jjo3hnE6RU+Fy0LDCXurrNtJrQyvAC1vVjZ1lPzQhLZ0tVAbfvSCgtohsahI27EG3YYfrcdok40s/RgPEj7Z9/s3/NSzRKjZSynze+qmaCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rZ/NsBv9B6g4vtSKmrWgHl5ky3s3LAJrOv55ZyTsVs=;
 b=c3Pbr9UOA9vkujVILjUUAMx/mSCoY5/8jpxt+oqziPyYd0y0o2fliM8YDMlFrdzRJXuptIhyKzDF5PbQhj7UU9oQaOW75QFF87JTdklY0kfSYWsoeOhwOSVWsM9QMemBgVZJTdXZhhjImL86MKEcRE2i8wUgB2f9fQ+9psYmfwg4SaSANq5baoXIW0C4Dac2fjV8K33jT25uik+i5U5cY1yvPxCLC21InbJamWHuCu2VTchazgYw84vXqpT0secaZJb06GOkFcWZ3GrhNfOnVy+4JgFI7x3H6ML0KSXHsoGj6BHHPb+4xayuCgsANfY038Z4YtER1XvV+1x/RuefTA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rZ/NsBv9B6g4vtSKmrWgHl5ky3s3LAJrOv55ZyTsVs=;
 b=LgqXNj1cF6ewsEF8pxSBQEu49ti3fD9EjJSB4Ft+hntvPeaxw0v2HI1vV2VtJsRJSJedO+GXU8Dvcibgzbse/qD4ow6VYY+XUp1mMbQflVRuORNqPqx1alxBr5OBI07ugAJPs8m3OudcQJMBJ8YJAoej65J2NS5vKBOgHAZ7YpxBzc6aoubmlaeLUW6vtKSM64bzVMh4ybg4ehCMNvQvAKPZDYmEFFEoF/YWz+DnzF4EXHD2lTOSnbDlQMMPU1qBVu6U2YPKpMdn14zd7fHRT/33qMJKgK6CR+ngTv3Kv8FWp/pLC6YFtz6RvyQlwEeCEmEzdNfIU5U9vtQF/ls1lw==
To: joseph.qi@linux.alibaba.com
References: <20230626112453.22571-1-heming.zhao@suse.com>
Message-id: <f9dd70d9-b63f-b528-1a4f-fa33b28c013a@suse.com>
Date: Mon, 26 Jun 2023 22:56:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <20230626112453.22571-1-heming.zhao@suse.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(966005)(478600001)(6666004)(6486002)(2616005)(83380400001)(26005)(186003)(6506007)(53546011)(2906002)(5660300002)(44832011)(36756003)(38100700002)(4326008)(66946007)(31696002)(316002)(86362001)(8936002)(8676002)(41300700001)(6916009)(66556008)(66476007)(31686004)(6512007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 14:56:21.9979 (UTC)
X-Source-IP: 40.107.7.59
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10753
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 priorityscore=149 adultscore=0 clxscore=161
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260117 domainage_hfrom=9771
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: add error handling path when jbd2
 enter ABORT status
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
X-ClientProxiedBy: SI2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:195::14) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS8PR04MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: af932210-d859-4e4e-6fc4-08db76558168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 baE9spY269vKgZhoED73JnO1XEMpowdaX/JjDCVgYXXFPm7HQOcaMIAygbBzLllvxPRP+Rt0NNn7SseemH5Z6RX0ctufCndTf8Eg4i9dZ7M0A6xpP0Jykc4+EQfbNklJ6q61us1nFRXUmM+zw8eWtfJoOfwGrAi9tLIfmFEGBIsZCH035Xd/vzw9lOP49mgfpvhXpjzu+luVmRWIwHZxBLp96N89ppP2A9Q6H6hp7UgbLu6JzBBhRG3PdX73NiBDBqM8i8RQZU6vPOMr0RakLsBkHKiqLAS/SG5mw6wJWzaQ/zN49FKq+/u6izN5haogM8m5oueBfAkGkEBP1hMPwknedticGHsu1XamAfBRLAGSGs9sKiBVoGXb/1YpoghoG2A/NdctfZp7wDpKZmUX2d+VDVVAmIU1JNonIdrrGPO6DJKv4jvazuv51kZwrFPTlPiOPpf/e84hvigVqhZCCs2qd5idLzOwNBAKurK4PNwc2+jI+S4Q+r+6QBjI4gCDPIzuPgkAlj5PAmUBOs3yfGPorTrZMPDa4q9yIvXehQZ56gqp3VCnLB34vGmib8JXi4K4qklXDPh6xUJ8kzND2HKxaanEtQ58apqum2WYzlNTA1TV4Th8PyUy1i97F7XfmTOC0E8q9bHoYZcU6q4sEA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c1NYRm5YWndPNDEvQ3Z1VFZSOHhZOEtMN1R1eTE1MWp1ZlkzT1J4TWc3VjE0?=
 =?utf-8?B?NUQ2eXJvZmI3WEVaaDIxL29tSC9ObTF4cmkxRCtGMzh3a0k1MmliaFN4Mlhx?=
 =?utf-8?B?dHE1VE1aMkVoTmhRTlhXTjg2NVRKeGJoMnVjNUFCcGh3MTZQZVAxdlY0K0lh?=
 =?utf-8?B?TUlHcXV1b01BTFBjVW5LanJsdC8wbnlpRWV1c0tETVpMek9RbFI3UFk3WGpS?=
 =?utf-8?B?V0pXdnk5UjA3ZDlkcEZSQmxqTHJLZjFPdlRVTEowS3lzbjZKMW5GU2Z4M2RS?=
 =?utf-8?B?cnI4Mm45cGFIeCt6Y2EzUTJVWHU0M29JRUpCQW1UNGh3ZHNucDBqTDY4SEhD?=
 =?utf-8?B?S2doMCtZZndKYWRqSXI2RTg2MEN4WjFjbWZhUkFXYWlFTFhHUnNCLyttNWU5?=
 =?utf-8?B?TVMxbUJjODJDdzdPZUE0dVhRVnVNWVF2RVF4TW9Bdko1cDZmaStnalNGRWJU?=
 =?utf-8?B?UlV2TkNadC9nSEw2bk51bnhnRGpza1ZmYWdXeFVvSlMrWlJpbkNSYndvdEpL?=
 =?utf-8?B?U2ZnUkd2T2NQNG4yNFJoK0QvSjhzREFxbXlJZjFkYzEzeUFNZjh6WEtobDdN?=
 =?utf-8?B?MXFPbFlyNGNBZGJ6UTlmS1JCMUwrS0MwNU5RR2cxVkwrcU9sVU9FZ0hIUjFU?=
 =?utf-8?B?d2trY1hOVHVQQ3h0RFMxRGY3bG1ueWw1OURCYmRUQVI1TER3ZEdXNWVleVVD?=
 =?utf-8?B?aFRnQmtCY291ZWp0MEhjb0ZhRmZtZXNxK2pRUkdIQTdCWnd2L2o0UGhKcmJR?=
 =?utf-8?B?YUlOWXo2U0gzR3RMOHVneGg4WE1rcTFYZTFCS09EdTZ2RGZHenZ2ZXRhaE9K?=
 =?utf-8?B?ZmZoK1B0cUlzZWpBSnB4Nkp1b1Rtc2JqVlo0ZlJaSGZQd2xWOWg5c1dPZUdD?=
 =?utf-8?B?MmtYSHhpSjloYjR3MTFqU1J5VWo3UXBTOTJyMi9yQWFYa1A1V1BsWDdNMWx1?=
 =?utf-8?B?dmM4dW9mYWduNmpwK3FiR0hFMVNZRkplTlVuSlIwZ2xISEM0UzJSb0pETEMr?=
 =?utf-8?B?eUl3clYwOFNjUmJZY2ZaVFI1aHVBZitYRzJkRWlyYW1VdTVWc2ZiNEEzNjk4?=
 =?utf-8?B?RVpaV2xFbm9ZNjdLVUxTbE9lVUVvaFZjWFc4VThkcTJoeEYyMTI5NWNiekxP?=
 =?utf-8?B?L2xaMStjVXZ2ZEFzajlDckc3VzM5bUdLbzN4V3VLYjE5MU04V3dYSnZ3MER4?=
 =?utf-8?B?aExiOGlibFZ4MkFlUWNoU01kMGVDeldjQ1Bvbkx2bEM0Nzh2VHlxNjlmd0Rs?=
 =?utf-8?B?TVBiS1ZTeXZXQkZIMW5vMWlRd00rVm1iby9JUGtiRm00NnFGZm1WWStVaGsy?=
 =?utf-8?B?amNtdkJuYy9hOHNrelBTeEpFUU9nNEROc1d0VXJtdGpyYmp5MWwyOFV3R0t2?=
 =?utf-8?B?bDVZR2d2TVh2bzNaK0NCTVJJd2hhZDVVUWpQcVpEbC90bnVoWlFUbGFyZXVF?=
 =?utf-8?B?bmRPWXd6eFY3Z2tCTjM5emRJdnJ0US9CZXRqbkk1dW16R0FvOEhqOU1zTmUr?=
 =?utf-8?B?ZENLWHFNSngrYmdUT1ZsUFAraldTUHNESXNCZXlnQkpJKzhoZ2N2YWc3UUdt?=
 =?utf-8?B?SGp0TlBVUHYzaDBnREY2YWlVakdNK3NYd2xUWExWVlVYWkVRZzVRTjNhUHJw?=
 =?utf-8?B?TzZHTTRWdzBsSzZCdWdNS1FUcjBoQU5DNUp4L3UxaURKTUpmL0YvUEgyS1JW?=
 =?utf-8?B?eWpJelMwd09pWkpWbVNnbFV3NDljN2k3ZjRZMDE0aUlEMGhXUUtPSURST2xM?=
 =?utf-8?B?WmRZK2JOR3RJc1VRSExPcGxUQXBaNmxFemZscnMrb3FSaS8yb2hhTEJGVExR?=
 =?utf-8?B?SytFeFdHWlkyVWVPeG9qMUJkaDFZMUsyU0JPS211eDBYSWQ4eWx5SzdicDBI?=
 =?utf-8?B?K3V3UXRrOXV5aUt2ZHhEWEVaKzVITVNMS0tsdnZ1bDVCRWRGRkpEMzJaeUQ3?=
 =?utf-8?B?Ym9YVG9pM0xGbDJHUjBIRUlUa2xLOGIwS2ZWMlB0K2REZUxiemwwSmtTYTBJ?=
 =?utf-8?B?MUJLRElGajNkeFgwRjBqenlPNGI4VW5kY3VGNG9LNGNWVjZBYXhWbHlkWTFz?=
 =?utf-8?B?Ty92aHBGTk9lK0N3dHJ4c2oxdFhvUVVaRGNxN0k5eUxPeW4yM1NUYzRTYVFL?=
 =?utf-8?Q?erWaq04LTTAP/Oq3C4OpnprHm?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 af932210-d859-4e4e-6fc4-08db76558168
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 eocEKITk5RoW8h0uO0hO+0C2UcYb0RaRoCIhskSwvEJ97sjAK9JpcgqIkquKVGRtgySRhM407bH5pFgfQ+c3fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7640
X-ServerName: mail-he1eur04on2059.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 1W4UJRUSwvQujODsWfIIyUMYEEvMCR48
X-Proofpoint-ORIG-GUID: 1W4UJRUSwvQujODsWfIIyUMYEEvMCR48
Reporting-Meta:
 AAGQf5J7Aq3I+hMRtpxyMS7cUsdOwsInyRVbCP0kL14FntxZU0USWSn6OHOtFtjf
 f00TrnnvIV1EP0pZwKpxScmXu+VTeoirnJ/fL6Waznl3i6AiP495KRKtypJYw7P6
 dR2Z0Bxdbr6lp1anUYOqFqDIxwIi1Uia09cTa91aBEJo2uSiNG75v6Aehji21kt6
 s1lv0E7ngPdiDv+NykTu7Dpz2cnYywC7QoPkaGW51lT2FqyKRRA/S+mDZw1x+RUI
 fqsZFPMNF395MbOe0FLFTEmj36khdQubpXklG+ED35efrfLIb8w9jCvJpIVwUJwP
 5ecPaCIraGJj6ZmJdVgGnESTrZWfH1wwzpeAlOMtLn1wicFZu+cvFJ9HTMQjbR8E
 8/FoLvL4B757e01aDB2BeIw1f8z262jluHV9Rl6tx2x6FC+8mmgmkbI4qaBpiHFb
 Iqt4qgcg8RsopF2xLCnEoPrTOqkLWnx5wwv29Nyiu1vjYN7oFesDGMb0Q5jvRphy
 k00O2dEC58QOLtcmkpZTR3s7SAHNkdbkY8bqxiIZfG/+

On 6/26/23 7:24 PM, Heming Zhao wrote:
> fstest generic cases 347 361 628 629 trigger a same issue:
> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> journal. This issue causes umount failure (hanging).
> 
> This commit gives ocfs2 ability to handle jbd2 ABORT case. After
> patching, umount successfully and leave journal dirty status.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2:
>     (this v2 only for patch [2/2], see below URL)
>     add description in commit log.
>     don't reset ->j_num_trans and leave journal dirty status on disk.
> 
> v1: https://oss.oracle.com/pipermail/ocfs2-devel/2023-April/000896.html
> ---
>   fs/ocfs2/alloc.c      | 10 ++++++----
>   fs/ocfs2/journal.c    | 17 +++++++++++++++--
>   fs/ocfs2/journal.h    |  5 +++--
>   fs/ocfs2/localalloc.c |  3 +++
>   4 files changed, 27 insertions(+), 8 deletions(-)
> 

It looks I found 2 bugs when testing this patch.
1> fsck.ocfs2 doesn't succeed to repair unclean jbd2 data but output successfully.
2> fsck.ocfs2 doesn't remove dlm lockspace when exit.

** how to trigger **

first do below steps:
(/dev/vdg size should bigger than 1GB)

(these steps derived from fstest generic 361)
```

mkfs -t ocfs2 -F -N 4 --cluster-stack pcmk --cluster-name tst -b 4096 /dev/vdg 131072

mount -t ocfs2 /dev/vdg /fstest/scratch

/sbin/xfs_io -i -fc 'truncate 1g' /fstest/scratch/fs.img

mkdir /fstest/scratch/mnt

losetup -f --show /fstest/scratch/fs.img

losetup --direct-io=on /dev/loop0

mkfs -t ocfs2 -N 4 /dev/loop0

mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt



/sbin/xfs_io -i -fc 'pwrite 0 520m' /fstest/scratch/mnt/testfile

/usr/bin/mount -o remount,ro /fstest/scratch/mnt



umount /fstest/scratch/mnt  (<-- trigger jbd2 abort)

```



the last 'umount' will trigger jbd2 enter abort status, then leave unclean
journal data on disk.

then using fsck.ocfs2 repair this loop0 device, this software output 'successfully',
but the real status is this partition still fails to mount.


```

tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt

mount.ocfs2: Internal logic failure while mounting /dev/loop0 on /fstest/scratch/mnt. Check 'dmesg' for more information on this error 5.



tb-fstest1:~ # fsck.ocfs2 /dev/loop0

fsck.ocfs2 1.8.7

Checking OCFS2 filesystem in /dev/loop0:

   Label:              <NONE>

   UUID:               4990448088164475A620ACD486ACFC8E

   Number of blocks:   262144

   Block size:         4096

   Number of clusters: 262144

   Cluster size:       4096

   Number of slots:    4



/dev/loop0 wasn't cleanly unmounted by all nodes.  Attempting to replay the journals for nodes that didn't unmount cleanly

Checking each slot's journal.

Replaying slot 0's journal.

*** There were problems replaying journals.  Be careful in telling fsck to make repairs to this filesystem.

Slot 0's local alloc replayed successfully

/dev/loop0 is clean.  It will be checked after 20 additional mounts.

Slot 0's journal dirty flag removed



tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt

mount.ocfs2: Internal logic failure while mounting /dev/loop0 on /fstest/scratch/mnt. Check 'dmesg' for more information on this error 17.


tb-fstest1:~ # ls /sys/kernel/dlm/

0B90A8FBD12C4ED3BB947682045C8B51  4990448088164475A620ACD486ACFC8E


tb-fstest1:~ # ps axj |grep ocfs2

     2  1232     0     0 ?           -1 I<       0   0:00 [ocfs2_wq]

     2  1233     0     0 ?           -1 S        0   0:00 [ocfs2dc-0B90A8FBD12C4ED3BB947682045C8B51]

     2  1240     0     0 ?           -1 S        0   0:00 [ocfs2cmt-0B90A8FBD12C4ED3BB947682045C8B51]


tb-fstest1:~ # dlm_tool leave 4990448088164475A620ACD486ACFC8E

Leaving lockspace "4990448088164475A620ACD486ACFC8E"

done


tb-fstest1:~ # mount -t ocfs2 /dev/loop0 /fstest/scratch/mnt

mount.ocfs2: Internal logic failure while mounting /dev/loop0 on /fstest/scratch/mnt. Check 'dmesg' for more information on this error 5.
```




Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
