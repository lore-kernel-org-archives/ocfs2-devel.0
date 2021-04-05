Return-Path: <SRS0=Nwne=JC=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AC1C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Apr 2021 16:42:38 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9EDD1613A0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Apr 2021 16:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EDD1613A0
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135GObQ7153273;
	Mon, 5 Apr 2021 16:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=TLG6wZfql7A8zp7PgHDpZwi23iHNvK4eiicSQDY4nms=;
 b=NNjb0wtvy+NibdnTLlPZ4UJmMKJ/Xu1g/yq1fEH4ENtzN1+1FhQcdCQRhmtl1c/FAt4a
 pVKEuyfIJv6Obr+/0BIN4vnz8aoNSZ0dLApY+lNT4RsXMwMy0g4cGnzKUOwZyBFjXfBg
 i8CzeRgaZ7Q3Y9cv9GQh1oVjXcg0uhW0G1tXKPREVTZhQmdn2y6bh2rdWCRD3RRugVPk
 LzdaD5YP8Ko33EDuoHowKWutZE45HxeKVe8ey+5zLB0eyIjPeK9hPsfLJZqE9PIBUJ3V
 jnNdB3NtNViNvb3YbzIuAzRh31Z6Dp1ryF6LVbw8y8qZWU6Ig/SOqD8qz9kIdO+IcmF2 cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 37q3bwjn1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Apr 2021 16:42:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135GPtEi159546;
	Mon, 5 Apr 2021 16:42:35 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37qa3hakp8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 05 Apr 2021 16:42:35 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lTSJ8-0004P8-Bd; Mon, 05 Apr 2021 09:42:34 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lTSIi-0004OI-J8
	for ocfs2-devel@oss.oracle.com; Mon, 05 Apr 2021 09:42:08 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	135GP1t9089291
	for <ocfs2-devel@oss.oracle.com>; Mon, 5 Apr 2021 16:42:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
	by userp3020.oracle.com with ESMTP id 37q2pt4rht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 05 Apr 2021 16:42:08 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2576.namprd10.prod.outlook.com (2603:10b6:805:44::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32;
	Mon, 5 Apr 2021 16:42:06 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.3999.032;
	Mon, 5 Apr 2021 16:42:06 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-Topic: [PATCH V2] ocfs2: fix deadlock between setattr and
	dio_end_io_write
Thread-Index: AQHXJ+OUUGxNKz2AoUmZGjy48AVji6qkOpwAgAHq1YA=
Date: Mon, 5 Apr 2021 16:42:06 +0000
Message-ID: <91ECDE2E-8A1B-4A91-B425-E8157081C083@oracle.com>
References: <20210402171344.1605-1-wen.gang.wang@oracle.com>
	<994870d6-5b0e-3a22-6180-9beb501a59b0@linux.alibaba.com>
In-Reply-To: <994870d6-5b0e-3a22-6180-9beb501a59b0@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-originating-ip: [71.198.166.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ffd982d-a7a4-4262-8a43-08d8f851bf91
x-ms-traffictypediagnostic: SN6PR10MB2576:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o1wl648uwSpgIWY3DRzAeGajdgkFrI/+zvFKgULLfAAAQPr4C7C20xtaD/yvaGGwMXjMYeRG58ouFtzk5/k7jiYPE/iTsNd8LQvedmA5DaJc3IDG4a5vZzB1LO8u/fjuIpjTlwk9YFtGHHuDqMCHDfYInquZlEVMa/E4rhY+ow8kMDY7zXkGw6zyzMaaFQ2UALzF7EgnoaAZmsmve2jUcYq1niuoXW297+22VNQVbNKOCdcG06rEsNI1EsaNoxLsO8y6LzK2OLKPSY89aCoOseOVHkgGAOuHiKFKu4TChw50T1YMgBAyfgiT99OZWp0qAQ7Qros6FaTtZvfT/8aFwwQ8AdyP4qpTJ6znWmk6zaTT7Y+xyOlL6dLesfl2yRg+OlmbBn2OETy3wNbpeY+WufXpiPRxzQpLanHVVVTh5FdTa1/KD4t46g88ThERDuihiMnVA39zPAoSVhYeYasz5HH8Tm90S2ObJrQsUQwoVIM/09CbAP4S+LBCNKoQdC+Q9ZdLk0Kf5mHz0Wnhq+2F+ZCgyAFRs/7zcVOSsSNoui7/z4z1zspfTI8WOFDz+RJ3
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9P3C50w+NRaWlpWlcUj4PP2pdZFzK5SF+52v9JguCqBO5hkZXuXuAIASsQzQ?=
	=?us-ascii?Q?2HLbmxQLvis+YLjQNSQxd/al97lAUHBBaI45IfX9yb6/gOg/rMJWHvp9bfd4?=
	=?us-ascii?Q?eyEbayKNX7C1v2bFFWHt3DYpLUyzy1B/FaSj2ZdwiPBh5TULH7q8BbKtZSG4?=
	=?us-ascii?Q?f+cV8/Q0lO4wglRF+tkB2CDgEyvdoaFYHQTbpuXRrLndINnJa4vGErLY1XMF?=
	=?us-ascii?Q?QYDjplOyUK35n3BReucnvGf7oNi0E8c9y35JV7T4ypfEc2V4WcyOqGCaCFoa?=
	=?us-ascii?Q?ftcmxmWPBppn0CiEqlUg795DUsg7RIX8+5VRkDJxcg8PVmd4Cemh4EPpd2aJ?=
	=?us-ascii?Q?rS2xkjpwBlDcVyVeGVAN+kWCw9Jduy0a1ABdL5Er9LxLfXzlRiw5xKlUhUDR?=
	=?us-ascii?Q?ztnQQhOEmJgOLxCkKkGLsQXUe8loXVUJumbD62dm6elvZmPUNbvIjmTJ0dfr?=
	=?us-ascii?Q?xQHKxGJPmJ/rrncLKyF7Zu/4dXmStOmTaTl6u3jpYkqYoOMgrP330xAVp19P?=
	=?us-ascii?Q?48kFsC9XTRj+3yCZJ1+MVy71CUgSao3FH9OP/ltuqVJaVlaNbUAuB6av/my1?=
	=?us-ascii?Q?38930AjQHAQVcbh/tCGdvaAZcbNRxdwc8YgQE7phGUIX4y+s0ZLMnCnHtldG?=
	=?us-ascii?Q?iY8l0/Xt9Ooc13EF/DgWk7+N/qU7bb/xAsoW+v6Ql+EwAvE9Ardlyfya2hhA?=
	=?us-ascii?Q?9KmNnWHWrENUwt4VeWEMDS2b/rDbQSs9sS3dPhqXcAN34cZ9nI8r2P8iwD2a?=
	=?us-ascii?Q?tt5QhDxZQIr70aQuTICbm0J++mXbSTdJQEB0GWTx+vhby3A2T/Vj+32jOrrN?=
	=?us-ascii?Q?ctV+YEALKq1ENZPauWhrNN9BdpLewMEKARRZ+ZzHwrQrElsEQ/S2mS5asgp/?=
	=?us-ascii?Q?nDju7PqO/1ugkTsJ+LeYBe36Gb4GvZPpWqKRMJLu1jPm/nYGGpCErMCA0kCG?=
	=?us-ascii?Q?RtThMJ7PhOilsUBPD2nIMCTaUm6roZBM6s8+I1LDgrjwegYU38z/chkfdZpL?=
	=?us-ascii?Q?wMq1fGU05iLmHH8Yk/e1KdI/RM96ybehYpG/W+sGcYGFKVkNQKaWQ0CubQkO?=
	=?us-ascii?Q?iR863JtlMSMINteUrghkP10gMkGkf11aE8UkVpv6PLFCevGZygQ9blQi1Cem?=
	=?us-ascii?Q?RRJuNW5nV+yE2VAtYw9qBKCRx1D6Wo70iCLEVqQMzFgAZ30a2iEexScPZIli?=
	=?us-ascii?Q?h0NfV5Y2+Oj1Xhzi3xdAWQiPbqSsCksZc2y1v+NtREi6zmqNtkCgHZg+T0LQ?=
	=?us-ascii?Q?4zuhqSWyGgOAIvQolg5CgCkuHi56BUFo5sn0FrXq2PWH/gOJPZyFgithP/Ak?=
	=?us-ascii?Q?yxP0JmpElyEcE68rwNTzPRVd?=
Content-ID: <E36F208C4C55734A99BFD72D5F4E9B08@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffd982d-a7a4-4262-8a43-08d8f851bf91
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 16:42:06.2271 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T4i09QUkMm+BWrRvznItAuXvXw9jRU3Ei5nhdoI1HsWDiDrwYxwYmT5C+4isdEBXKsxLA0mwR/hoaD8n6PbawDIabozGbxBxK649fdgLabU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2576
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 71.198.166.82
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2576.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104030000 definitions=main-2104050109
Cc: ocfs2-devel ML <ocfs2-devel@oss.oracle.com>, "GHe@suse.com" <GHe@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH V2] ocfs2: fix deadlock between setattr
 and dio_end_io_write
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050109
X-Proofpoint-GUID: VKSboSvCzGhr6PBU7J8a3e-_BAFusOSY
X-Proofpoint-ORIG-GUID: VKSboSvCzGhr6PBU7J8a3e-_BAFusOSY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050109



> On Apr 4, 2021, at 4:25 AM, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
> 
> 
> On 4/3/21 1:13 AM, Wengang Wang wrote:
>> The following deadlock is detected:
>> 
>> truncate -> setattr path is waiting for pending direct IO to be done (
>> inode->i_dio_count become zero) with inode->i_rwsem held (down_write).
>> 
>> PID: 14827  TASK: ffff881686a9af80  CPU: 20  COMMAND: "ora_p005_hrltd9"
>> #0 [ffffc9000bcf3c08] __schedule at ffffffff818667cc
>> #1 [ffffc9000bcf3ca0] schedule at ffffffff81866de6
>> #2 [ffffc9000bcf3cb8] inode_dio_wait at ffffffff812a2d04
>> #3 [ffffc9000bcf3d28] ocfs2_setattr at ffffffffc05f322e [ocfs2]
>> #4 [ffffc9000bcf3e18] notify_change at ffffffff812a5a09
>> #5 [ffffc9000bcf3e60] do_truncate at ffffffff812808f5
>> #6 [ffffc9000bcf3ed8] do_sys_ftruncate.constprop.18 at ffffffff81280cf2
>> #7 [ffffc9000bcf3f18] sys_ftruncate at ffffffff81280d8e
>> #8 [ffffc9000bcf3f28] do_syscall_64 at ffffffff81003949
>> #9 [ffffc9000bcf3f50] entry_SYSCALL_64_after_hwframe at ffffffff81a001ad
>> 
>> dio completion path is going to complete one direct IO (decrement
>> inode->i_dio_count), but before that it hang at locking inode->i_rwsem.
>> 
>> #0 [ffffc90009b47b40] __schedule+700 at ffffffff818667cc
>> #1 [ffffc90009b47bd8] schedule+54 at ffffffff81866de6
>> #2 [ffffc90009b47bf0] rwsem_down_write_failed+536 at ffffffff8186aa28
>> #3 [ffffc90009b47c88] call_rwsem_down_write_failed+23 at ffffffff8185a1b7
>> #4 [ffffc90009b47cd0] down_write+45 at ffffffff81869c9d
>> #5 [ffffc90009b47ce8] ocfs2_dio_end_io_write+180 at ffffffffc05d5444 [ocfs2]
>> #6 [ffffc90009b47dd8] ocfs2_dio_end_io+85 at ffffffffc05d5a85 [ocfs2]
>> #7 [ffffc90009b47e18] dio_complete+140 at ffffffff812c873c
>> #8 [ffffc90009b47e50] dio_aio_complete_work+25 at ffffffff812c89f9
>> #9 [ffffc90009b47e60] process_one_work+361 at ffffffff810b1889
>> #10 [ffffc90009b47ea8] worker_thread+77 at ffffffff810b233d
>> #11 [ffffc90009b47f08] kthread+261 at ffffffff810b7fd5
>> #12 [ffffc90009b47f50] ret_from_fork+62 at ffffffff81a0035e
>> 
>> Thus above forms ABBA deadlock. The same deadlock was mentioned in
>> upstream commit 28f5a8a7c033cbf3e32277f4cc9c6afd74f05300. well, it seems
>> that that commit just removed cluster lock (the victim of above dead
>> lock) from the ABBA deadlock party.
>> 
>> End-user visible effects:
>> Process hang in truncate -> ocfs2_setattr path and other processes hang at
>> ocfs2_dio_end_io_write path.
>> 
>> This is to fix the deadlock its self. It removes inode_lock() call from dio
>> completion path to remove the deadlock and add ip_alloc_sem lock in setattr
>> path to synchronize the inode modifications.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> ---
>> v1 -> v2: remove the "had_alloc_lock" as suggested.
>> ---
>> fs/ocfs2/aops.c | 11 +----------
>> fs/ocfs2/file.c |  8 ++++++--
>> 2 files changed, 7 insertions(+), 12 deletions(-)
>> 
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 3bfb4147895a..ad20403b383f 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2295,7 +2295,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>> 	struct ocfs2_alloc_context *meta_ac = NULL;
>> 	handle_t *handle = NULL;
>> 	loff_t end = offset + bytes;
>> -	int ret = 0, credits = 0, locked = 0;
>> +	int ret = 0, credits = 0;
>> 
>> 	ocfs2_init_dealloc_ctxt(&dealloc);
>> 
>> @@ -2306,13 +2306,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>> 	    !dwc->dw_orphaned)
>> 		goto out;
>> 
>> -	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
>> -	 * are in that context. */
>> -	if (dwc->dw_writer_pid != task_pid_nr(current)) {
>> -		inode_lock(inode);
>> -		locked = 1;
>> -	}
>> -
>> 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
>> 	if (ret < 0) {
>> 		mlog_errno(ret);
>> @@ -2393,8 +2386,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>> 	if (meta_ac)
>> 		ocfs2_free_alloc_context(meta_ac);
>> 	ocfs2_run_deallocs(osb, &dealloc);
>> -	if (locked)
>> -		inode_unlock(inode);
>> 	ocfs2_dio_free_write_ctx(inode, dwc);
>> 
>> 	return ret;
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 85979e2214b3..8880071ee4ee 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1244,22 +1244,24 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>> 				goto bail_unlock;
>> 			}
>> 		}
>> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);
>> 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
>> 					   2 * ocfs2_quota_trans_credits(sb));
>> 		if (IS_ERR(handle)) {
>> 			status = PTR_ERR(handle);
>> 			mlog_errno(status);
>> -			goto bail_unlock;
>> +			goto bail_unlock_alloc;
>> 		}
>> 		status = __dquot_transfer(inode, transfer_to);
>> 		if (status < 0)
>> 			goto bail_commit;
>> 	} else {
>> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);
> 
> Why not do down_write() just before if clause?

Yes, down_write() just before if clause works too. I just wanted lock as less/short as possible.

> Anyway, it also looks fine to me. So with or without that change,
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks Joseph for review!

Wengang
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
