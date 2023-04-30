Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E485AC77B7E
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 Apr 2023 03:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=795UQZWpqMs/lmGvala12/KdbZuNJx37Spsl0MqUHHk=;
 b=OC4t/lrxLjgfT9RNDF3ESAXkh+A2az0AVTyIbxIip0zUpLkpXCQoZFB5y1J2F6mU0x6t+/S0Vw4Z
   oHym+qE1dv73la92t7MzMnxPAD2GjFwuRrIm9iRdJZ/haQRMviQH3d4me1f60VNYrH1k21iFsf2Z
   w93g2iIl/ho0OMWqn+xAGdWgVau8dg/aUgF5VxlWvsuzlntKFX9eOUM/GOJ7vh3Kn8d8r83iRvsB
   UkusYfECsI0P668i1dSg4AuARdPxaFNIX/LB9aqf/gIkBHI2Dp78/4kKyvC+vUji86oC5FRb3OJk
   2FMkI1ghLKqK6+m+hDjO8aaXF+6r+9ki99v1Ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=795UQZWpqMs/lmGvala12/KdbZuNJx37Spsl0MqUHHk=;
 b=i5W+G42B5VGGD8rt6UdpzkaV8UwyV23qn++g8yFhATLtWiwi421iLXrhCUMOS7CBEadQxOwBiFAe
   XBE+PaayJx8c3AK3YS7FbaV2JBW+8Ou2353vMsRLNcT95Q6Hww6pW7RZlsFEWIwOiXbvEIV17Dz0
   LuWaO3F0LO0BaEtl5mhf2GqTuTrRe/2SZzjFvkrUOvnWrlaDKl5n8XE0YK+Y75uxsqdgO9ihJYMb
   XKjTOZTEm40LrOlU/7myUQ2y802Ldz2Cyr7RSR1+EKdQPmd7moPWWsM8Ub2/PG3PBz0w/lN42bgg
   t3fdZRPYnpyN6+40iYftnLod/nV9In8sS5ZbLg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTW000GMRT5FXE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 30 Apr 2023 03:17:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO98zZ190e8/Ww/eAuuLn6sywsl1vbarcxVAQE+j2cA0DddmGXukS9v+6ZtCHe0oJ2ePNTAlOnn2dHEzBLaE59MAjBjeeit6rcqkBaQfgtH+mnc68+DibUv9TSlp5PzThUxVHxKCtQn9+Dz9jTbZpkqMmYzR5L+tO6ByWXHTVWh0utLQAAGsUjngVxMw04tvEwfiXDLSWCOjQwoR3VkJOijgRX1sPSKNFSBLRG5qwhwSiUbjFcCGZ1UMDTGIaHahNsApLDEbQvtlPZu+uAIIJ5FJoHkenhJzyACFxew1cC9YiZAQMnsJKPi2RscHU8QiszzhiSJOYhG7HLi8RuYhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vRP5H3PAvQ0aLVSOQYJpoAIuN3kjtOQyMCFgABpOHw=;
 b=gTWQkWeSYi2ULlEw+uM5MyGvyVlCVAiWrai2b32mJCu6cHiRsaggmbe07N9WksowCClHXfPrfLwsMDO++PIrnywFHzKzePNXz/E/g7l5zJZhvWBSKDj1jR00HSxJsq/RGJVDEb6W42pHhPZG8WSbpeuCHHOXNQamJb0b9Win2ufthEA2+oxN+NjMWtEh1rJuGtHNAiMAo8bvxFctNDpAgNgPZ9bHCJZmoudYOUDW2SZnCtNoJDTWiNuJ1Kez6BP1hj5w12nAFtfnY1C1QuFyKzkT2Q0FmozDpBXsPO4AWYNIF/3yHrRiI1MKX88yvZmZC79ABPAbyEYN2KjnQiFGQQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vRP5H3PAvQ0aLVSOQYJpoAIuN3kjtOQyMCFgABpOHw=;
 b=DZukUjxEwIH06QNM4PdEzzx4/9lLlGIYtpfptW/FzNxf3GIdJlw+bxewmtnzcMQrnPWJhEXhX4Hzf/PXm2+Nyac+a7nMXL6FzMcIcb9bkdnMvl5aJvBwE/+712c30tMVSXbWdTn+loshVTeatChfICnjsGTDUXWeP4/Uc1l5ZaKqjJtptgaaCZN0zNLY86A2asRJ6n+fpq8WDfISf9AT6Gd2q07RAslUnZt3Qg7YONvoHZ+Od7/QaNgyT+qkErjBlMDBF/77ZWk6z2MPCLqQNfAlUkDnYBD1RSf5yG8EIAJNMLIg4FH+iJ4NuMZX28wr2B1YO4E3Rs7XpwBnBFPn/Q==
To: joseph.qi@linux.alibaba.com
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
Message-id: <59a9735c-c8df-2e31-f3b3-7044bcdefbd1@suse.com>
Date: Sun, 30 Apr 2023 11:16:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <20230430031302.15597-2-heming.zhao@suse.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39850400004)(396003)(136003)(346002)(376002)(366004)(451199021)(316002)(53546011)(6512007)(6506007)(26005)(186003)(41300700001)(2616005)(83380400001)(66476007)(478600001)(66556008)(66946007)(4326008)(6486002)(6666004)(6916009)(38100700002)(4744005)(2906002)(36756003)(31696002)(86362001)(5660300002)(8676002)(8936002)(44832011)(31686004)(45980500001)(43740500002); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 03:17:12.6228 (UTC)
X-Source-IP: 40.107.7.44
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10695
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=208
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=111
 mlxlogscore=549 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304300029 domainage_hfrom=9714
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: add error handling path when jbd2
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
X-ClientProxiedBy: SG2PR02CA0048.apcprd02.prod.outlook.com (2603:1096:3:18::36)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS5PR04MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: dad23bea-8519-402b-9567-08db49296414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 kYg9YBSBoLr35AnqeIuaubbmQVh1x3Tui/asQm1uVyme+gkllAqC9J5OXTZ3T1okYcs0EcKAuD/uJLwknQj9vnaGI2bOylbBj+1x3Xo+fgq4IJHUfYFLB0qc9OBFyqVRFuLV1bAcdC6jHsDnYfL0w803WQNf19LL47wkWI45dSJ0hYIAr1d0qke2oFJ7LMy3mICIWID483naxpZbIIbNZ5pFlhNvEIBdgP17WdIve5s4yEt2lPV/jxcyAY97lphZ71nZZLbpWuEQv9WJD/KXDkwmvDST6a6SKF5vrwpR4i6Gm9mbkz8yjsqdZsIxe0lAO+3xByCy0kE+N7/2uah0arDrmVcvJfmdjo0QRPcfxrZ6zdW0LL31gd89TBmr2KkxzZk6AK9+8u6I0p91x4AoUrkepfD0lMQOyTEfpGrsUpRDKm9FojnXpWElC5g6PXRwAYahid7YLg4X+n4tijih91ky3Tye/SkZN0PcKp8+m/Ny/GmsSJYHTey/kLh8syCTxTob41jwJqadPlN41E5C8SQsxFilaY6j1W8AA4ouGolIVISm3jWCuF6+rq8YuwW8FR24IEvQ15/FcTKzbBu2KQ2hOB5F7xAsyYh4kf1lzonzBMYVZsXpWp3aMcPtK0ANFeFQDq1C7VhJyNryHmKvyA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eEVLRm02d0E1a01pckV2U1hxZmU0Mi9qWkhLOVgwWURMOFBRcVRRbWMyUE1E?=
 =?utf-8?B?UW1XeGhXK3pWUXJ1encxYnVuUjJLQmpQdlhmNUM5bVdkNW9lWFRQUnd0VlRq?=
 =?utf-8?B?WUtQV0xMOVdKamZqUThYMDFIS2ZpVUVVU0JRWVM1N3c1U29NMm9aY2hDZUdk?=
 =?utf-8?B?VUJYTWR1SXlYR0dmUTAxRExYTDNweGQ4ZGU0STFsampHUUJJdDdpK2FhSGEr?=
 =?utf-8?B?SkdkM2dmY2RUU2FGQXJqd0k4d3lXdFJCWlpIWVZ2QzBGWFNJSDVEcFQ4ODNO?=
 =?utf-8?B?bStUaFJzRmpKcE94WG8zcStMbm9Ca0Z4TjRPVU8wQlV2MWVuUWR1RGIySy9p?=
 =?utf-8?B?NERVOE1ob0lhd2JZQjZManFWcHFrUU9NdWFkeE5Sckp6UWZNZzZITGx3R1VR?=
 =?utf-8?B?NU54V3EzbFhtUGNRTFpYaldYcWxEeE1lb0tmV210eVdhVlN5bnFCcWh1V2hU?=
 =?utf-8?B?dnFOR1BKTHVyYTl3NHMvOFdXRWNXZ0lWMGNZR3gwVDNVQldsbUZpR0xBVVBE?=
 =?utf-8?B?UktrZ1U5cHovUjRxRERCK0lNVUc0N1FQL3Vrbk5LSlNYUVJjNElzZFZ5bTNo?=
 =?utf-8?B?OHQwcENURHhNZTJMc1VWYnVWclNUVDNOTmtjaWpScW8xOHB2TUlUc0NRWGVD?=
 =?utf-8?B?b2ErM3p0UlZEaC91VnpHNklFaThvVlNnTXRidG9sZWlSNS9vdDNjT05udHJM?=
 =?utf-8?B?cWpFUG5leEZqd2ozdXBPNnkzT2NoR3ozdTFodEJRMC9HTXFvcmoreHlGaDJs?=
 =?utf-8?B?dDVOWm1raHJOT3lEd1JzRS9PcUNIYzBHYmdkcFQxNFlJeFBndWFDVmhmL2dR?=
 =?utf-8?B?MTg3YUdtUjJ4SXJhM2o5dlMyY2t6U09rNS9WWWJ4cnNweW5Ick1MQUF1bFdu?=
 =?utf-8?B?ODk5QXlrVVpvUDhzN2JLekN1ekJZeGFiaFZRWEVDaVRZcEFGcnlZQTlYVmlt?=
 =?utf-8?B?Qk0xY1drZXM2QS92N2hhUkFLdHFPUVNHUDFNMk5MVmJxeWc2Q0hscUdMVDJL?=
 =?utf-8?B?WTFBNHRnWkxWN1NSTzVpeWR0WjZrT0ZuZU5OT1lnMGFMMEVkellCclZxQi9y?=
 =?utf-8?B?bzB2YVFMTFcwaUNBMHRXYW5ZU1NrcWtBdm5lVjVDL0JEU1hBTXREVDlxT01D?=
 =?utf-8?B?WEZJdU9RakhOOFVlckNKUlIvcWlLb0pCT1VJNU5KS2NwZGZ5dlNDV2J4QUwr?=
 =?utf-8?B?Um5id2V2UkpmenA3QWxNSWtFMy9wS2pqRU1ZOUpETkZVcFVvSWFuM0lVWEtL?=
 =?utf-8?B?Z0JUV05SZHB5MCs0NW9uV2ZYRGxlN1BXd0VqK3crbTdwdjdVOXM5Zm54a3JI?=
 =?utf-8?B?dy96U29KQzVnTEVoT1hxdkdKYU1kd2syQ3k1TlpVNjBFTHF4ZHZSbzdIRzNJ?=
 =?utf-8?B?NEh0WU96Wkd4T1Q0NzVVbkRTOXdwaURMV3k4LzhkLzNmLzFpMTFpR1E3WTRt?=
 =?utf-8?B?SzBBa2QycDc0VVR6b0plN0hGa2RRU1pCTU5SSXJPbUNtVlppYVJnTDk0SnJs?=
 =?utf-8?B?L1drQmtEY1pvMncwZzJKZmtkL3AzZEJMRXJPOUd4N2htb3ZvMklFZzZsWFNL?=
 =?utf-8?B?NE0vejlGL0FmQWhrNC9JUGt2b0RLWWhGMHl2bnJJS3FsR1FCd09neG02bzl4?=
 =?utf-8?B?T2lIVW93T2tvVGd5c0s3MmVVSUQ4VDBBVjFQTFJaR3E1OWtqdTVnUGRGZ2Zz?=
 =?utf-8?B?RXhoZElja2RKOUdPdXhjSmZ0akdvcklzQzJzRTlMZWpPQU5TbkpRTXEwaUpB?=
 =?utf-8?B?YVpLMHBCOTRmRFNWdDVlcFdsNUZieGpYZTgxSVpZbThjNS82a0NtMXo3Wncx?=
 =?utf-8?B?bnFiWHgzd2RmUmhZbC84WVh0ZW1LeWJuZ1BOZXZiM0NGOStjU3Z6RERvRTJw?=
 =?utf-8?B?RUxXMWRqcmVGRlFOT2U1KzBWaUtrazlpVklPcmN5VmhNL29WSVMyZUZoZ0xE?=
 =?utf-8?B?ZTB0V1ZqZXFBRGxFVmMrVDM5L2M1NUJhOW83NFhnT21hUzh6R2tyMUVPb0Zr?=
 =?utf-8?B?OWZTMW5YWDZMc3dndEk2eWhlZ1FFc2pGM2o3aHFlNU5Tck5NQVZFNXJwRUtD?=
 =?utf-8?B?SXJuSEQ1VEVwK3FBOC9vbTVjZ1FrL0xJOE5LMUtBY3dqQmIwRmhwVGJ3c2dU?=
 =?utf-8?Q?9gYlnskWCbhPDPMcvd0yLj2cn?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 dad23bea-8519-402b-9567-08db49296414
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 XvUgJKMrx0Z0ErBEOACMRm6CVzRn3L/s+qDUwme3DA7SUGu7+mqLfFv1szfk3q5+cGZ8EFXzNHr/yih+qpPULg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9755
X-ServerName: mail-he1eur04on2044.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: feKtwdt4UmUJ_VXf-EwEHvm3PdfiSPes
X-Proofpoint-ORIG-GUID: feKtwdt4UmUJ_VXf-EwEHvm3PdfiSPes
Reporting-Meta:
 AAHPspMkJZicIiZEMoJUu6EG7TesETUNh+MLwq4X5L0fsN9HfVaMC99FvyOKuI1C
 Nbgv2rXb5wB5OZuYMQZDkU04MYCwRH8UsBgHXD/PaxtKEXUb39G2dqqhrG3x1Lha
 T6asdhlcPcwrwFZwWFJO2y5cP6RpyhTGEM0s5CpxRZK6/FDipHYHoK4rAAeI5P1X
 qbMAmF9haM5iN8XCe2OVTt/TBuyRr6xA3ttxhytEdtQwshk7+csNRC9QSAkA9biv
 wCtEVujGcDGWbZ3brjZAoQRvnSeopb8y1d160ToCEewpj+XCxVDe6uCgmBrrOfTN
 98Bq6HrmR6YkKM6nTxauZ3rYt4siu8Jx8CnZQUQc0papudbs6kmySVbPsIYhEU7Z
 wyjekhUMbWOSyob9vXt/T9ETEAaM5/OM2IauO0TshntAkIGWWrHiV6uD9pPRuVEK
 Nni7EZUgX47gKnQI4tGTchP3sowJlb65ohKFTfjVfPc9c8NBuakDwPSEt+dgBjU+
 P+aWf2RF2jcyIGuDQUt/35Za1b5uAGRLF8wWNWoxgnur

More info for this patch, maybe I should write below info in commit log.

 From the comment of __ocfs2_abort(), there is another way to handle

journal ABORT: panic.
And fstest generic test NO. 648 will trigger
  ocfs2_abort then make kernel
panic. I don't like the panic style, ocfs2
  should elegantly handle journal
abnormal case.

Thanks,
Heming

On 4/30/23 11:13 AM, Heming Zhao wrote:
> fstest generic cases 347 361 628 629 trigger a same issue:
> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> journal.
> 
> This commit gives ocfs2 ability to handle jbd2 ABORT case.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/alloc.c      | 10 ++++++----
>   fs/ocfs2/journal.c    |  5 +++++
>   fs/ocfs2/localalloc.c |  3 +++
>   3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
