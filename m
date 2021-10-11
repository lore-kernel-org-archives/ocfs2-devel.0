Return-Path: <SRS0=Exlr=O7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA381C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 09:50:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D10360D07
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 09:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D10360D07
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B8v42H010260;
	Mon, 11 Oct 2021 09:50:49 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bkw3j34ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 09:50:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19B9f17G168354;
	Mon, 11 Oct 2021 09:50:47 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bkyv6rwmm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 11 Oct 2021 09:50:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mZruD-00051r-C6; Mon, 11 Oct 2021 02:47:37 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mZrtl-00050w-3H
	for ocfs2-devel@oss.oracle.com; Mon, 11 Oct 2021 02:47:09 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19B9edHE015770
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 09:47:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bmadw0sgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 09:47:08 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19B9SZf6008067
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 09:47:07 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bkyh9jt4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 09:47:07 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-10-rmFfj1DgNum017d0-2uTPg-1; Mon, 11 Oct 2021 11:47:03 +0200
X-MC-Unique: rmFfj1DgNum017d0-2uTPg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=hgbh9hltpNfzYuIVyOxHjGM/8uJBsfrW2I0dwTBOF+Utq6zTiamFKFDpnubFCndKfQV4akmV4bwbkKHoJRWmYWptESGjfUAGTYjqX7UNGYNwmLdquZwH+jM6bHJ9fKPr8W9PiAcGiHVpHH9XCFLwM93E6eoj3fk+A2TJfeUNjoPEZ8qKlSOBSf4rMylLM+clZM4iMJ5+O7EALFyc43JCo2EXcXozwIKJWZQb4geKeQLEJ23MQo4l/r4gnAjVsi7k3fIeraIFHKoMbqr4VtndcJJGSb7eV/m0SBv65286b88rwwNu29d2InLXTATxiaH4ZFmxpY0PEgJLa/JGdt+F7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=nPwDteGPdQemoHbWTTvd2DIq3aNxgZ3gQ/WwM5Y6Vo4=;
	b=CU7NvC0JvF8JTRkujcCqnaduTVcD19DJdxYdMLqI1GC2zlzz3xmCgkAuUbejymHYCKNUz01HPFzokUsOu34svNt1TEmPgxV35ZbmB/SeCRqfwYebYt+S2109wBeYCRNh7zr6UzSjmQXk7lCf9iUbo6/SBAdMcyEGcWWcEt+NVNrNAmMalwzUqqQgosLCFZcHYfCiE14wCvNxO3PD8W+guGhGM8KHNXYdfwdUs81B6TsJZ/sWFDEN5+EE8mYqqVdvRVIiqBZDyqDmYbm5Zo6e8ikwrZHvPrEvFaEPF9XGtC7GyfI+DNweQRjKH8ilNdIyt+Q8oJlOOBl7KBgmLVk4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
	header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR0402MB3495.eurprd04.prod.outlook.com (2603:10a6:209:8::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25;
	Mon, 11 Oct 2021 09:47:02 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::e989:6ee5:2367:49e0]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::e989:6ee5:2367:49e0%6]) with mapi id 15.20.4587.026;
	Mon, 11 Oct 2021 09:47:02 +0000
Message-ID: <a0becc5f-5400-e589-44d3-9873ae43e146@suse.com>
Date: Mon, 11 Oct 2021 17:46:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
Content-Language: en-US
To: Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
References: <20210930095405.21433-1-jack@suse.cz>
	<b2f712c2-c46d-4bf6-7867-88d81f49087f@gmail.com>
From: Gang He <ghe@suse.com>
In-Reply-To: <b2f712c2-c46d-4bf6-7867-88d81f49087f@gmail.com>
X-ClientProxiedBy: AM6P192CA0078.EURP192.PROD.OUTLOOK.COM
	(2603:10a6:209:8d::19) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
Received: from [10.67.20.87] (60.251.47.115) by
	AM6P192CA0078.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.21
	via Frontend Transport; Mon, 11 Oct 2021 09:46:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5925678f-78f1-4785-11ee-08d98c9c13a7
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3495:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB34954ECF3825D9E88300CFBFCFB59@AM6PR0402MB3495.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:57;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6ew06DcH/vnd9hKlsJ4/cw8vQaTInFi8pXRIJsmBB4DnjQP49hngXp+Sp7QSWC0LWqzi9eUAZxNz0iPh3dD9x0dFwfYsG4tkkynV+s8FTKQD1GBjiuSj/tZB+soE2PBLqDWFccabPFqVTWp+00XerLzDMxGUAjCGiDNnMxRKbP87z8xvRIj9iLz0RsaUvylI5WYbqNh/7RgFsL5xIaIuhfrLljMp82FXY/NdT34HAOCIW8WrhTvEsPVUJe9CVMIPt/cFTmu+co1IR9N37HrwKNUTuVFbJXw8/eME4jHI6MphiIfo06to/w7oh7FbbC58qMYrFZXfopeS8HLAHo7hc6RrG+5qltprxx/6T5cjb1DjQid1ns7PyMwtI/DQbm57hKspS63txTVcxCYlKL8PrxXGu+kPyeCBC/RaLlsB1i+Khc1mZph9VjJtIrkEBNSgsypVos+lIw+6j/fEN6nTZS4HY6a+dyLzAjJ51iEf3vkXREXU2OhyaaiHxrX91UYicceHEF3iJUoQaswGOK72oS5+lq3rPTzac8EdGcO5pMMmKxDIC9BcyHKoB4du2CSHF9WdEO89iZvigwW5OKo1K4x9qfa8/hQ+QgfL62KNeOOwwhD9uALiW0M0NFY5JwwjxB2S3HCG0dJNG5wPF/9y7cAQ7EEmS8CDN2B5iYJcgaOV3Hcu+NfsBwnXoD7wts8JaEiY/Xvf7J2QhZkQZaZgAD22voteslM9+ryKlCIKCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(38100700002)(66476007)(5660300002)(956004)(36756003)(2906002)(2616005)(66946007)(4326008)(186003)(8936002)(31686004)(316002)(16576012)(83380400001)(26005)(86362001)(6666004)(110136005)(8676002)(66556008)(508600001)(31696002)(54906003)(55236004)(53546011)(6486002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEwyQUs2K01hcVZ3bDg0TVB5eGxySHcwdUpKc25WOWdzUVExdkJqUC9wam4v?=
	=?utf-8?B?Yi9GdFIwR25zM09MWnNWTHB6ZUwrSGM1eTBOaGRuc1lCblV1SCtQczcxcFRY?=
	=?utf-8?B?ZHpzL3p2MTZNQ0o5aGpvdFFNUDFUMlpsYmlPRmhySXZBWG12MHpRSFhmTkth?=
	=?utf-8?B?NWpvUEVqcUkydWsrYjdoTU8wdCtIVlM1R28vYVNrYlcxYTBkZmx0ZmUzZVk4?=
	=?utf-8?B?ZVdrSEw4M2M3ZXdSano4bTNhaittZmgyNGtyZHA1NUxRTk91WjNMQkNhblZD?=
	=?utf-8?B?K05FV0pPYVBxbFI0a0ZBNWNvQ0VCQ3IrRzNZNGQyaG0rNVZOVThOMCtkZ3l6?=
	=?utf-8?B?MzQ0YkdEYzNheEVjOVRCZFg0UWhPRjd1SWZab1RoMUo3NW1jOUQ4WUkxQmF2?=
	=?utf-8?B?RE5VL20xL0hONjk3V3JHSXEyQ05GYnJsVVZPd3VXSVRDeEk4WWY2WXFuaEx1?=
	=?utf-8?B?YnY1YmZGZE9yMnhjdVdKcGU3YjZhbmdmWFBSVDJwMDFadzlQelJ2Y01GQVJC?=
	=?utf-8?B?N2d6ekJocDhhdGRrTk9PVG84T3R4WTExNGZDdlZyQXdmV0p3WWZJUUdEem9x?=
	=?utf-8?B?UytENVhhc2FPZ2d3cDFhVkZCbGRlZ3lmWVZPVktTWC92bEpiZC9JUk1SZGRw?=
	=?utf-8?B?eHM4djh5WWNSeXFKSjdPMUhOUlNaeGoxL1VranNBL2hkS25jdzJ6T3ozdkJ4?=
	=?utf-8?B?Qk1aekVMK2hUS3FpQjdQVC9SME5YaVpzbmVmTENybXF0ZUFRNWlmUnpnSkp3?=
	=?utf-8?B?OHZNT2llN0t1WGorV0cxZk9salpGak1JRVBVR3VjcUNmS0crSjFBZE1DeXUz?=
	=?utf-8?B?Z29YUjVVNkZHZHF5VDhlUWVzNFQvWTBOSi8vNFlZeURBMXJiK09zZCs4UDFP?=
	=?utf-8?B?NE5RZVoxdzgraUlqU29RT3NMQUJ5K0l4SlpodFMvMG1HMCtmeE41UElXckxa?=
	=?utf-8?B?TVk2eHlBalp0UmRnTEpscUh4aWhSQThxR05OaFdPNXRybVBGVVdpNjZHdThB?=
	=?utf-8?B?M3EwYnY3VUhGbFNSN1BUeUpQTGVQZ21aRXQ0NWFVelE4NitaUGhmZjkxbWpk?=
	=?utf-8?B?N3lvZHBQTDNNWWUvZ0ZzVUZodnJjVTFqK2xUKzRWNEpFTmtMMWozNVdRREQx?=
	=?utf-8?B?alBQSkpNcTFrcVVnckNBWXk0dStRNTNOQ1JpNWV5ZDQzRlZNRXBkZjd5bnZW?=
	=?utf-8?B?OXA4Q2V2Q0hsSWR6WEp0djYzTXBrQlZGUXdxaUxCL1dIY0Eza2Fxa0xvb2hG?=
	=?utf-8?B?WDY2NGFBTEgzVSs0bytsbnZtWnRBdTdPdm1UR09tY0tYdFV0Mk9EZ3NyYXFM?=
	=?utf-8?B?YTI4WXR2SXZSczRaRzk0SUlDRlpTWExTeldmZElaM1l2ZFlWSnJGdTFZUitx?=
	=?utf-8?B?cTlHRzIwL3hacVZ6RTNaYmkxK0h1eGh2U1dDWCs4T2EzeDJwd2NQQzZpMnIw?=
	=?utf-8?B?bU5jbDViME1mZnVUbEp1T1lpdUE2NEJWOEFDcmxMU1Yyd05tbUlxYW93SGhj?=
	=?utf-8?B?MHN4WUlJbVdnNDZYcWdhNmVKWXpMYzh6eVFKU3FmTHNRUmFPRmYvSVlNM3o4?=
	=?utf-8?B?dnJ2anZCTTd4NHlQMEt1Wk1qVlpqbFQrMit5N3F3ZWorMEdRL0JXUGo3NjB4?=
	=?utf-8?B?VmFNMkh3THZwZ2xkV1lwak1JS0FwOUkzR1Rmai9RalJSR3BNSXdWUmxROGJj?=
	=?utf-8?B?K09zamVBcjl6YkNFMk16SlZGZ3Y0aVJsUDloejdnQnl2RERNK2h3MmZtWjkw?=
	=?utf-8?Q?fn3qjrZTyyRmnLZkqo0bL3zbXGJ5C7TMftp4BIZ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5925678f-78f1-4785-11ee-08d98c9c13a7
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 09:47:02.3907 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb/WVqK5HM5Cn9noCa3LRWTZQ8z2yX61adu4Z+sGh6vCysw/+O/SCAORfhf1oUXV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3495
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	bulkscore=0 spamscore=0
	lowpriorityscore=0 priorityscore=159 phishscore=0 adultscore=0
	mlxscore=0
	mlxlogscore=999 suspectscore=0 clxscore=210 malwarescore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
	definitions=main-2110110055
X-Spam: Clean
Cc: "Markov, Andrey" <Markov.Andrey@Dell.com>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix data corruption after
 conversion from inline format
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110054
X-Proofpoint-GUID: vQDPNsA13QC7RdQ3aXIu1Z8BrDz1QYRp
X-Proofpoint-ORIG-GUID: vQDPNsA13QC7RdQ3aXIu1Z8BrDz1QYRp

Hi Jan/Joseph,

The code change looks OK for me,
The testing result for ocfs2-test test suits is OK.

Thanks
Gang

On 2021/10/9 11:46, Joseph Qi wrote:
> 
> 
> On 9/30/21 5:54 PM, Jan Kara wrote:
>> Commit 6dbf7bb55598 ("fs: Don't invalidate page buffers in
>> block_write_full_page()") uncovered a latent bug in ocfs2 conversion
>> from inline inode format to a normal inode format. The code in
>> ocfs2_convert_inline_data_to_extents() attempts to zero out the whole
>> cluster allocated for file data by grabbing, zeroing, and dirtying all
>> pages covering this cluster. However these pages are beyond i_size, thus
>> writeback code generally ignores these dirty pages and no blocks were
>> ever actually zeroed on the disk. This oversight was fixed by commit
>> 693c241a5f6a ("ocfs2: No need to zero pages past i_size.") for standard
>> ocfs2 write path, inline conversion path was apparently forgotten; the
>> commit log also has a reasoning why the zeroing actually is not needed.
>> After commit 6dbf7bb55598, things became worse as writeback code stopped
>> invalidating buffers on pages beyond i_size and thus these pages end up
>> with clean PageDirty bit but with buffers attached to these pages being
>> still dirty. So when a file is converted from inline format, then
>> writeback triggers, and then the file is grown so that these pages
>> become valid, the invalid dirtiness state is preserved,
>> mark_buffer_dirty() does nothing on these pages (buffers are already
>> dirty) but page is never written back because it is clean. So data
>> written to these pages is lost once pages are reclaimed.
>>
>> Simple reproducer for the problem is:
>>
>> xfs_io -f -c "pwrite 0 2000" -c "pwrite 2000 2000" -c "fsync" \
>>    -c "pwrite 4000 2000" ocfs2_file
>>
>> After unmounting and mounting the fs again, you can observe that end of
>> 'ocfs2_file' has lost its contents.
>>
>> Fix the problem by not doing the pointless zeroing during conversion
>> from inline format similarly as in the standard write path.
>>
>> CC: stable@vger.kernel.org
>> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>   fs/ocfs2/alloc.c | 46 ++++++++++++----------------------------------
>>   1 file changed, 12 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index f1cc8258d34a..12aead0dabe2 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -7045,7 +7045,7 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
>>   int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   					 struct buffer_head *di_bh)
>>   {
>> -	int ret, i, has_data, num_pages = 0;
>> +	int ret,has_data, num_pages = 0;
> 
> Should leave a space between 'ret' and 'has_data'.
> 
> Other looks good to me.
> Reviewed-and-Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Cc Gang and Andrey Markov who have encountered the same issue before.
> 
>>   	int need_free = 0;
>>   	u32 bit_off, num;
>>   	handle_t *handle;
>> @@ -7054,26 +7054,17 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>   	struct ocfs2_alloc_context *data_ac = NULL;
>> -	struct page **pages = NULL;
>> -	loff_t end = osb->s_clustersize;
>> +	struct page *page = NULL;
>>   	struct ocfs2_extent_tree et;
>>   	int did_quota = 0;
>>   
>>   	has_data = i_size_read(inode) ? 1 : 0;
>>   
>>   	if (has_data) {
>> -		pages = kcalloc(ocfs2_pages_per_cluster(osb->sb),
>> -				sizeof(struct page *), GFP_NOFS);
>> -		if (pages == NULL) {
>> -			ret = -ENOMEM;
>> -			mlog_errno(ret);
>> -			return ret;
>> -		}
>> -
>>   		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
>>   		if (ret) {
>>   			mlog_errno(ret);
>> -			goto free_pages;
>> +			goto out;
>>   		}
>>   	}
>>   
>> @@ -7093,7 +7084,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   	}
>>   
>>   	if (has_data) {
>> -		unsigned int page_end;
>> +		unsigned int page_end = min_t(unsigned, PAGE_SIZE,
>> +							osb->s_clustersize);
>>   		u64 phys;
>>   
>>   		ret = dquot_alloc_space_nodirty(inode,
>> @@ -7117,15 +7109,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   		 */
>>   		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
>>   
>> -		/*
>> -		 * Non sparse file systems zero on extend, so no need
>> -		 * to do that now.
>> -		 */
>> -		if (!ocfs2_sparse_alloc(osb) &&
>> -		    PAGE_SIZE < osb->s_clustersize)
>> -			end = PAGE_SIZE;
>> -
>> -		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
>> +		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
>> +					   &num_pages);
>>   		if (ret) {
>>   			mlog_errno(ret);
>>   			need_free = 1;
>> @@ -7136,20 +7121,15 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   		 * This should populate the 1st page for us and mark
>>   		 * it up to date.
>>   		 */
>> -		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
>> +		ret = ocfs2_read_inline_data(inode, page, di_bh);
>>   		if (ret) {
>>   			mlog_errno(ret);
>>   			need_free = 1;
>>   			goto out_unlock;
>>   		}
>>   
>> -		page_end = PAGE_SIZE;
>> -		if (PAGE_SIZE > osb->s_clustersize)
>> -			page_end = osb->s_clustersize;
>> -
>> -		for (i = 0; i < num_pages; i++)
>> -			ocfs2_map_and_dirty_page(inode, handle, 0, page_end,
>> -						 pages[i], i > 0, &phys);
>> +		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
>> +					 &phys);
>>   	}
>>   
>>   	spin_lock(&oi->ip_lock);
>> @@ -7180,8 +7160,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   	}
>>   
>>   out_unlock:
>> -	if (pages)
>> -		ocfs2_unlock_and_free_pages(pages, num_pages);
>> +	if (page)
>> +		ocfs2_unlock_and_free_pages(&page, num_pages);
>>   
>>   out_commit:
>>   	if (ret < 0 && did_quota)
>> @@ -7205,8 +7185,6 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>>   out:
>>   	if (data_ac)
>>   		ocfs2_free_alloc_context(data_ac);
>> -free_pages:
>> -	kfree(pages);
>>   	return ret;
>>   }
>>   
>>
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
