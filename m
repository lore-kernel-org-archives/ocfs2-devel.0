Return-Path: <SRS0=sznG=PI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE12C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 05:20:33 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA19460698
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 05:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EA19460698
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K4r9sj018592;
	Wed, 20 Oct 2021 05:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=Sky61OpbVQiCm1P2Oj2PhQU1PPbDEToniEEphS1Z4pk=;
 b=O8PtGfx9KV7UgPkNMk8SDHTSYjpqvoz+U37Fe0CHep027tPuvEozZ23TrYl5RyZAL76P
 CR/aogIbVpaHMRqASs5G8XuNjFBMkwtyxig6Mn4+g/BrAoT/9YXYuHdgZdMhQdWp0/ad
 UzJi4HbRGAGeipfrCITAggclz6w4DLepYihXqKhRuhx17kqa0mGANpUVwRXafYZ8S317
 R8nl+RZ9IBkiGvv1cfh+neqXxoT69uNwBCiFaUwIjYj0f30ick1kt7A/dPKSC71vTnHR
 DQVmXgGFpcjV1PQhoJRLi2DcAWzy4g+mg4jdaGGotrC+VmOW9ziOexVfNyoH4Rfpr1NV sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsruc6u5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Oct 2021 05:20:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19K5FYDm016873;
	Wed, 20 Oct 2021 05:20:30 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gthv7t-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 20 Oct 2021 05:20:30 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1md3ya-0000Nj-2s; Tue, 19 Oct 2021 22:17:20 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1md3yY-0000NU-6N
	for ocfs2-devel@oss.oracle.com; Tue, 19 Oct 2021 22:17:18 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19K5FXVK096290
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 05:17:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by userp3030.oracle.com with ESMTP id 3bqkuyerw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 05:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=NSS6SpGxYXZlWZLi15kJzX6vbh6FGwEZjbB3FwMuMOUVrcsmSsb9egc+Bp/En0H15uFYl8wn/a1VylFUZV/0Ens5ANoDj33Ll0BHJtEvCQj9GNQz6vA7Jo0AYyWSojY3/kRaZUv4i5kve2gaaAYS+y1AwVxEHX9oRtuhdtF9czArBOlnIHItcfrGmOSBu1iXCx1yH0znpNX1zDCfZacDUPMhliQL3+f1h8PbIZ0SnwqRMZUm4tn1kO0lspDYaMXHGGvLYevkRkKCQLs509wnh6eczK5KOgX9gBmhdnS7sodRaB1IAl5Ebu8MTIi/BlFmNat3BehqRRuQJwf+t4luWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=oNeeJsyvyxmtAC/0wxC9b+QgzAJ62wpHkYn+L5kzbuU=;
	b=VS9icIxy6vUw5aq7z91QRdsIyskv2V4reHRtRkVWd41FoueNVKYp6gMesBfsudd3qg5JRJY5khkt/VPGJgrQLcyIM/Lod8C8DLgDxdi8S4C/ZFhx9G8ComJguey9aoVfbMJA14uH2ra510bt9V8+mja5M1kIv2+g6Ara4kntMNgYg9c5IvLVItVsiZt8axbLg0DDzieuC6HNIETzH+eH5dwTZx4k75PVpTKUuqehtPByr2A0PRGd65kNLM0wElo1JXywIVfmkf0N4QMGleN/1RWyBjoRPxUCSiAkBG5jYMVQfsCJXjJQQDrAaJWQ6YSpIyaCRsfARPckx0NESwfjyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
	dkim=pass header.d=oracle.com; arc=none
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
	DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4608.16; Wed, 20 Oct 2021 05:17:15 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2]) by
	DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2%6]) with mapi id 15.20.4608.018;
	Wed, 20 Oct 2021 05:17:15 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Thread-Topic: [PATCH V1 RFC 1/1] Subject: [[PATCH V1 RFC] 1/1] ocfs2: race
	between searching chunks and release  journal_head from buffer_head
Thread-Index: AQHXxXGFurbtKvlJ6UepY6KAlnJ6VqvbWJPw
Date: Wed, 20 Oct 2021 05:17:15 +0000
Message-ID: <DS7PR10MB487887FD77515DB7ECFFEC16F7BE9@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <1634706926-16201-1-git-send-email-gautham.ananthakrishna@oracle.com>
In-Reply-To: <1634706926-16201-1-git-send-email-gautham.ananthakrishna@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
	header.d=none; oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88c1d2b0-8cef-4d8d-073b-08d99388e14b
x-ms-traffictypediagnostic: DM6PR10MB4266:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KP5pfbzLzW36NGNK5FTHjPiWpLUkunlqkfq28mR+CjwUEOO+Gulm6a8c9/qCHOZt1Dat6Jv2UVi99F21+3jj6DzJU0H0HPZHFGIDMjW1g/haRu/uMwio+e+Oo0KeMPZyl13tzsyI+ypfBlhFPZvy7Ck4iGGdYQHz1AA3pcdZFhe1QiZxUs9IlFCHBnL6nPaJw8HQH7VstOGYsKbvS6KpARrdeiJPH/S4MU3kt13CAQLmuFBSyJcr1MZG3gP4CwKi/d+t+k0y1+tyW4OIaaNz6gtD4afSmv6RBk78KZN5qEcFJu4lGv/bntou5E2FH/S9dIKWe1tB9Y9xaoh9nA/lIiFJ0pQa03kCdkIj6y69hdv2VJF3BO+pocq8gSB/HwWUDOS0R0+zMzNeTdHgUmMvhULbvY3ivb7elAaMDiphC8/W0lAwa39w6hlFD2/rC8hVKD5bMaDDTgaV4DF5ZI6aIHX6+j/YeIYWCALDS+/El5dH2U+uNODofQRCEEjjPY06nzxwEqe+IBDSmiG5xW5EZoXl/RotMfnWULzK49xqAH1YOKs4NHYrjIYgkNSHdSuwkPJUxu7HyMsaGszmfDb1cgl/jN62xLNx4h2UF8VlZRs=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c1d2b0-8cef-4d8d-073b-08d99388e14b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 05:17:15.3365 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gautham.ananthakrishna@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 157.45.120.128
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM6PR10MB4266.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110200027
Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH V1 RFC 1/1] Subject: [[PATCH V1 RFC] 1/1]
 ocfs2: race between searching chunks and release journal_head from
 buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200027
X-Proofpoint-ORIG-GUID: i5DbSX3u3SCGJTTssYpY6C9JRkQUecIu
X-Proofpoint-GUID: i5DbSX3u3SCGJTTssYpY6C9JRkQUecIu

Please ignore this patch I will be  resending it
Thanks,
Gautham.

-----Original Message-----
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com> 
Sent: Wednesday, October 20, 2021 10:45 AM
To: ocfs2-devel@oss.oracle.com
Cc: joseph.qi@linux.alibaba.com; Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: [PATCH V1 RFC 1/1] Subject: [[PATCH V1 RFC] 1/1] ocfs2: race between searching chunks and release journal_head from buffer_head

Encountered a race between ocfs2_test_bg_bit_allocatable() and
jbd2_journal_put_journal_head() resulting in the below vmcore.

PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
 0 [ffff8802435ff1c0] panic at ffffffff816ed175
 1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
 2 [ffff8802435ff270] no_context at ffffffff8106eccf
 3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
 4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
 5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
 6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
 7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
    [exception RIP: ocfs2_block_group_find_clear_bits+316]
    RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
    RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
    RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
    RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
    R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
    R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
    ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
 8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at ffffffffc11ef680 [ocfs2]
 9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 [ocfs2]
10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b [ocfs2]
12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb [ocfs2]
13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf [ocfs2]
14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at ffffffffc11cc0db [ocfs2]
15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at ffffffffc11ce53f [ocfs2]
16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at ffffffffc11f59b5 [ocfs2]
17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 [ocfs2]
18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at ffffffffc11dc169 [ocfs2]
19 [ffff8802435ff960] ocfs2_make_clusters_writable at ffffffffc11e4274 [ocfs2]
20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 [ocfs2]
23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
26 [ffff8802435ffec0] kthread at ffffffff810a7afb
27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1

When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the bg_bh->b_private NULL as jbd2_journal_put_journal_head() raced and released the jounal head from the buffer head. Needed to take bit lock for the bit 'BH_JournalHead'
to fix this race.

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
---
 fs/ocfs2/suballoc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 8521942..86f33f2 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1256,9 +1256,17 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
+	/* Fast path */
 	if (!buffer_jbd(bg_bh))
 		return 1;
 
+	/* Slow path */
+	jbd_lock_bh_journal_head(bg_bh);
+	if (!buffer_jbd(bg_bh)){
+		jbd_unlock_bh_journal_head(bg_bh);
+		return 1;
+	}
+
 	jh = bh2jh(bg_bh);
 	spin_lock(&jh->b_state_lock);
 	bg = (struct ocfs2_group_desc *) jh->b_committed_data; @@ -1267,6 +1275,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	else
 		ret = 1;
 	spin_unlock(&jh->b_state_lock);
+	jbd_unlock_bh_journal_head(bg_bh);
 
 	return ret;
 }
--
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
