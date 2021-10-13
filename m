Return-Path: <SRS0=9kC7=PB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58DDC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Oct 2021 04:09:07 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 31B6D60E09
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Oct 2021 04:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 31B6D60E09
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D2vDoR004221;
	Wed, 13 Oct 2021 04:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=2SmH8GCXKUcL1CwygH8x3VhcHKRuLkS1p4kBOjBy0S4=;
 b=GlSzpvZ0gjnVX4d6ndZr4ydrYpVDTTXJl+ZHiJSjLHdepfUnKUiA8XCwiCnXLMfJSP8R
 sWgZTHMH1Y50oql2T8peMfuxwRhvBxKapJcolghCmtObrNtSnN9/PGaTDraOF3yZ4IAS
 yNo7KPaPyf2kfuaVfnLatN0h5C1WurnxSZONgvgfmZ2ScYvxCfdeFPwHYYN3h7BE/stF
 2c1DHLMRtldhT/teS5OiYiN+apGVuFQZkfzrdL5g1llPsyTVoOEY/73zkQNmn8D1g7lz
 uNFy9XckgvQvW3jl+qUA0zW3qCMHmip+wSKgKwJgdt7LcmYkqkyZtunSZBYloHlHJOeY Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbu95c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 04:09:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D457c8048908;
	Wed, 13 Oct 2021 04:09:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bkyva32p1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 13 Oct 2021 04:09:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1maVZf-0003fQ-Rn; Tue, 12 Oct 2021 21:09:03 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1maVZc-0003f0-61
	for ocfs2-devel@oss.oracle.com; Tue, 12 Oct 2021 21:09:00 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D459pS059876
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Oct 2021 04:08:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by userp3020.oracle.com with ESMTP id 3bkyvbb6hm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 13 Oct 2021 04:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=G/9qiizycersqhMRU8Axd0MMq4m6PnmneAfc/fWR/G/IQSOTBScgc3D3q+3EcgNF4/XG68r7iXkY0o5qqwDpN8t19alQjGI1277abzuTUOsLZSlYimP6PkEFJugJJxcJzTvrB8m1LO1y/PHG6Ff0VH0+hLwcCJS/OZJSrLQH/9HW1SKrnuwoUbbPA/GWuFDjnR6r91sHV0QblVyxFo5X9GN2XVXpLf2a42hTJEQaLluIHCIzVBvMjB6SVdyLKcjCWHVkA2iMR81dBc2ITgMyYFQJpO4bJPzY7KSsXh63xSlgX+QO2dEDk7/rto3gVTPSmPXpN4S9ZqBcoeODr3+ihg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=AhHeqgDgsbEkwDuM8va3VOFZ+p6gA5xy2KP1lmD36b4=;
	b=ODBBaTbwfp4sIrkvxKyJnR43BPVQ+PUs4PLgnqswbimNC/bqe3XyHfg9yrS8a7QsqJMs0JPVxHsP4NlSZUgOERoaYBgWm8OoLxlGr67jpNd/lswm5CMLEEItxl6Ky2cfZvmCpQYjJ/ekoChOspjC1SN18qWg6zov0z2VqChyVPNqpKtePAh/YW+1cFIwdkK9aiuMVimr6UhE+naX92TG7J5uW5IqBVp494aRR2gaVkPZ1k/DeV0SCZuS7GINUjkyeqnina7+Sid+u4CNotcJ/gcH+Xu55/HD01kso1q9DAf42Rk34RQQ+Snp1AN7qioeZUxm+oH5hCJjFlhF6Jlgrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
	dkim=pass header.d=oracle.com; arc=none
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
	DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4587.20; Wed, 13 Oct 2021 04:08:57 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2]) by
	DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2%5]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 04:08:57 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>
Thread-Topic: [PATCH RFC 1/1] ocfs2: race between searching chunks and release
	journal_head from buffer_head
Thread-Index: AQHXud+74b/hZFJ4XkKJzZqeCw4chqvIqtQAgAexW2A=
Date: Wed, 13 Oct 2021 04:08:56 +0000
Message-ID: <DS7PR10MB4878CEFE0D1FEE9BE668A025F7B79@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <1633434852-26662-1-git-send-email-gautham.ananthakrishna@oracle.com>
	<af8792a6-cb2a-b529-1262-b0254b407018@linux.alibaba.com>
In-Reply-To: <af8792a6-cb2a-b529-1262-b0254b407018@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb5760d7-9f30-4759-733c-08d98dff2dd8
x-ms-traffictypediagnostic: DS7PR10MB5374:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p8surAzfSDeXhGDt9fdhObI50yziS8fHc2pbIKR652pT4a3j5jGTkBOT5x1fEoHfrCrZy46MYHFzXGHSoUyTwbCIdpGFL/JDFP145K+WXlmPLdX6AMc+W8dpxkt88KF+DUe5G1tzNat8jU63XvoyYj2vUFHBTqtoy92GiV81c4ws5ZPrDvkmTSOvvVe5i0p5Ye0xXRz9d3otZisvXWM6eHqLttTbg0wUx+RGdfXHWX8DwSyNJFIsZ8J2HZxa5PZTuBDeN8HvZ0vwc1R6wq3KeD9+VOWGYQylGmTcyG08Y/9n6sBNKEuxBidvZYAphxwkWmk+yptFTnciWnVmEUUFRE0GU0Xo1wT60yoIrsM/aqgU2vnqhn/erMZL2UEHGcILhDISuFD39I2Hv3uAQd0EFZ8pIimg+psQJWUx8ezc5LE3F85iWVvFpfqVn8N52JHDsBdT9cIFI+dt74+1U9UvMblSzM3FQuLfrhx7/Gian2650HWxQKHk/UrpdxIiJfbbInnVnyP24qtXMpD++Agli18FbgYcY5QPjpYkj9aEDF5eK1RTwJj0eqPt4iYzRTeP3NLXl9cU7QzNd+Yex6L/wsBhx5r/3bcf9NxQMwKjbOM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5760d7-9f30-4759-733c-08d98dff2dd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 04:08:57.3628 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3aCRr92KLNAtpssrXCoq3P5ZUiptcimxXMFgoArMvcVoMqzlB9JiUDfCa9gCKlA+z4yv9yVwvJI6MgEpOmTKTGSUnMBMpVn0tQf1we3s12MEd5865p+L1DsjqN5OZ+R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 138.3.205.4
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DS7PR10MB5374.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	malwarescore=0
	adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110130026
Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH RFC 1/1] ocfs2: race between searching
 chunks and release journal_head from buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130026
X-Proofpoint-ORIG-GUID: Gdbqz94xfqzw-OL_XTcFziISW0vNsL5D
X-Proofpoint-GUID: Gdbqz94xfqzw-OL_XTcFziISW0vNsL5D

Hi Joseph.

In jbd2_journal_put_journal_head(), we decrement jh->b_jcount before calling __journal_remove_journal_head().

However in any of the calling functions of ocfs2_test_bg_bit_allocatable(), we dont increment jh->b_jcount.
Because of this, __journal_remove_journal_head() raced and set bh->b_private to NULL in ocfs2_test_bg_bit_allocatable().
This race happened after we checked "if (!buffer_jbd(bg_bh))" but before we referenced b_privatelater. This is how we go the
stack described in this patch. Hence we need to lock bit BH_JournalHead while checking ""if (!buffer_jbd(bg_bh))" as well as referencing b_private.

Thanks,
Gautham.

-----Original Message-----
From: Joseph Qi <joseph.qi@linux.alibaba.com> 
Sent: Friday, October 8, 2021 12:10 PM
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; ocfs2-devel@oss.oracle.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC 1/1] ocfs2: race between searching chunks and release journal_head from buffer_head

Hi Gautham,

On 10/5/21 7:54 PM, Gautham Ananthakrishna wrote:
> Encountered a race between ocfs2_test_bg_bit_allocatable() and
> jbd2_journal_put_journal_head() resulting in the below vmcore.
> 
> PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
>  0 [ffff8802435ff1c0] panic at ffffffff816ed175
>  1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
>  2 [ffff8802435ff270] no_context at ffffffff8106eccf
>  3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
>  4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
>  5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
>  6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
>  7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
>     [exception RIP: ocfs2_block_group_find_clear_bits+316]
>     RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
>     RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
>     RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
>     RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
>     R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
>     R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
>     ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
>  8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at 
> ffffffffc11ef680 [ocfs2]
>  9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 
> [ocfs2]
> 10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
> 11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b 
> [ocfs2]
> 12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb 
> [ocfs2]
> 13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf [ocfs2]
> 14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at 
> ffffffffc11cc0db [ocfs2]
> 15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at 
> ffffffffc11ce53f [ocfs2]
> 16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at 
> ffffffffc11f59b5 [ocfs2]
> 17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 
> [ocfs2]
> 18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at 
> ffffffffc11dc169 [ocfs2]
> 19 [ffff8802435ff960] ocfs2_make_clusters_writable at ffffffffc11e4274 
> [ocfs2]
> 20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
> 21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
> 22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 
> [ocfs2]
> 23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
> 24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
> 25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
> 26 [ffff8802435ffec0] kthread at ffffffff810a7afb
> 27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1
> 
> When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the 
> bg_bh->b_private NULL as jbd2_journal_put_journal_head() raced and 
> released the jounal head from the buffer head. Needed to take bit lock for the bit 'BH_JournalHead'
> to fix this race.
> 
> Signed-off-by: Gautham Ananthakrishna 
> <gautham.ananthakrishna@oracle.com>
> ---
>  fs/ocfs2/suballoc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 
> 8521942..0e4e11b 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1256,8 +1256,11 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>  	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
>  		return 0;
>  
> -	if (!buffer_jbd(bg_bh))
> +	jbd_lock_bh_journal_head(bg_bh);
> +	if (!buffer_jbd(bg_bh)){
> +		jbd_unlock_bh_journal_head(bg_bh);
>  		return 1;
> +	}

Seems !buffer_jbd() case we don't have to lock bit BH_JournalHead.

Thanks,
Joseph

>  
>  	jh = bh2jh(bg_bh);
>  	spin_lock(&jh->b_state_lock);
> @@ -1267,6 +1270,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>  	else
>  		ret = 1;
>  	spin_unlock(&jh->b_state_lock);
> +	jbd_unlock_bh_journal_head(bg_bh);
>  
>  	return ret;
>  }
> 
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
