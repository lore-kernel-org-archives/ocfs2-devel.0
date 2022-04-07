Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8B0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=90e5GPwC9SEzFiVgfDmiFH0MMsa4wVAkihmdfkrWYr4=;
 b=15gN/RRIN4ShurUCQX/aC5/xxzu2ShrvcYZCRF2IJBd1ygVTb4Zf/gT/LoQNy0SNx2GsNCz1ywAK
   vnuUxMED3QFxAJHvy4U1aBufBYIgclsx+FhPxla+EicHbFK4tNHVotfKmE+GUSt17rpGTWwkpZ0z
   akxC4zmr51tGc8Hf6yhhyjsbJO/RMToGTltYQfDZ9pNlg3mKra72o/mqQ4BIKf0flObEHJUo8SHq
   hdxsdsWopRcKa865HxcCplxLArCI7+t53vC0omQcsae8hX/XB5iAaVy5r1PfvOtrh29YESTFqVdc
   oTYphH/P+1oXW9ekuh4u3CBZ4CNwZWYF6nL3ZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=90e5GPwC9SEzFiVgfDmiFH0MMsa4wVAkihmdfkrWYr4=;
 b=cY6PluXfp7gFD5i6e5w63r0vwiZEdu2Uml62SdM+tTbPKjZSvQQFw+b4ZLxX3WLjC3OJv2AqaIuR
   C9NJFV6sHHxIQk56hriOfT7lGPnvFifchuKR6eHdhXMHHjTJasVcQvLMqKkizE5CkCvKZBQiQ+vk
   5l2G39/hTY4+XrONeVPAR82Vlo/giaKIOmA+9QmAcDESU6bnyFApZtcXWhgmHKinvBBrHYlxG7f3
   u9sgh/nMm9E3APxMneEIxUpOqrCOx92BsfkxgShFNRt4ZRGNf/mlfYYIQGzsOn+RqXoozVffDf+7
   V0koDUUQtMIj/LvSLk8tWDlAGf8iBcRWAJisjw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00JAY994J370@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:19:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nG3sI1771Qzwkix+7woUumXPeYpDKLLcIMXUM/nZXzc=;
 b=uCX4EVIMxM0btfDpTw5w1ew9bFLCrQilscmuwmVdRolfLJunbh9KT5j69VKpBFtOcJAq
 ObSXwXW1pjDG1XcmTA2ht9GIUnTTPukHcg63rNhtrS2pFvtUQU30jO65uVjIMPB7TAQ6
 M3z4ik2IbLzB7K5bswElc2TQSorNj2XqvboFkJ0QDgkOI0JlZpNXTZl+3TF/DJajXHTk
 8hGfsTiGys+WFrXr7iEbTTgcs7X+hTPGSqmMwHaLtKUw0KaZroaIflimn4O+OXx2aqdt
 +19y5fxddpLswZXH4y4t3+qmqVkl+7EYZAckUFjvjawOty9JLhF6oHbEW/rqImOgBjYX wg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=munt3rJDO8ySa0+WRp0/GkWCzTXCAxslMS32ml+K1DEJ6+Bkwxt+VORx8exc5yBjbij9fKYCuVzI3DoMzt5BmMUK0PrpODB6bHGPQ6hV8kscq2f9Le4Q+M+LpF5wgfTGV/TDIrfTc2WS3IjQ4H++n+kxBUYELzMcIJBaHqHyf8CfPTDFbJVttP0gdbjwyihogV35cUlAmpNgqXYzXkdwcZgqNS7IINeQAs+FuferyL4SkSc+kLxcX3UMWuCpaXcC2/JbMe6yLpF5Q2lt3sU9yaQn5pEIrjqEDb6Nn1EZuOjjysClRLNDSl2lOILZRK0KG7IaesRHejfqJkTWzlRA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nG3sI1771Qzwkix+7woUumXPeYpDKLLcIMXUM/nZXzc=;
 b=I1BG2ztrTjt0C1ggZpmJJSagedVlKI1eq2qXoom5wSuk4D3Z8aszJBDJP7izx1waxjVhs0oYBKK0vq8Y5RIjwYPpF83HtR71RhnZkxvUBVtP2xXqlYdV+URvsXgCEZMs8eQxFkPOvwXoP8yoezrM5R62SiN/78xWn3Gs9JlBxdQHHwUTaOS2/DMKUixgCQpIwREAmSSUino94bkYo1FYa+W3jU7QuN85K7ukkIoZ1vvujhI9qwBETLr7H404g5flOAG0RnJ4CuiFiSpZJbgzmmKnW2RXaznoe3Tqh99X1uKR4RKglskneK+3l5AOwwvVtpo7MugUoPNjL7RKFHmpiA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nG3sI1771Qzwkix+7woUumXPeYpDKLLcIMXUM/nZXzc=;
 b=G72AnkVLyWLchJ0S9psX73eVwQow5N7hp7QCvnBe3cakhNq0Of0dUX+p5cGT1UJVJB4jLefwe06eL+AOxRa6E+LbbaFzBvS2uQZp1ClDqA0xl0cpelYMlxplW++1WaWeh95Ri/tLtro7aHesLJhhH+g6jH76GhNEUY34TrcsEfI=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1h775ins6.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-16-hch@lst.de>
Date: Wed, 06 Apr 2022 23:19:34 -0400
In-reply-to: <20220406060516.409838-16-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:04
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:19:36.9967 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=978 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 15/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
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
From: "Martin K. Petersen via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Martin K. Petersen" <martin.petersen@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bce8477-072f-4601-b4e7-08da184571d9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 DalJnaZA/mALHVaiW8gdylGZH8gSVTvBD2B+VAIE/hzPSBDRTRfc/KxD3KSrgIKbMNpuisTl0DEoo8me+tZqXmQsA6XV7Zr6gYfWhG9xLqnMv+Csrc3gBACQezr+aQwNr93heLsUcTUvVujF1DOjr3gcPbC+GFlV1jT/UbMotxTotMNxpOTkfqJEftBQrfxJDOGm39n+lf53ZXHDZdz0Ijt+KcN11JEhpJenk9aYzbdVK1iwUmndtSvXWrHiglGswXVYYfGhdCp6mjBvCDMYIEPaVuFtdUjCoLLjiFPlz3Ka7/tKii7FTXHiOSCFQqiM7Pdnyp84MDzpWepCN7/Y0YggMNaNu6lF0XRtOmjr5+hlK71om4ogNcslQTsKRrS/60rNxUbOpWFDTRhIHyOUHYepiLECBxlYD2bDHly+J9Es1jBKh3vadVSzwcrXLgLWABZCEM8ZdSdLG9KyxjyXL3skPMDSeOng9cFQwTRprI3S3sA2yXjt1mDbkhN+dLNqpIDoNywjZQ+50c+wQ57911Ge6lZOSW99op9kJ/qvm7/fsGD2pbyVPDBkoVMFsHWnPxEffV/Fy6E+LsoixK5Q5blrmZMAeXKBfL7higOpkBM=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6bce8477-072f-4601-b4e7-08da184571d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 7z4HIuRW5zOTYnm/hMTpO4vuTWv+jkeYUlfnyT66exez8dXOJ7CIITksd8DVeQqY0+uYHTF7JUR/z8AslARHH0hcSzhm6hezqxwsLgDYqbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-MS-Exchange-CrossPremises-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Martin Petersen <martin.petersen@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 138.3.201.44
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: PH0PR10MB4408.namprd10.prod.outlook.com
X-Proofpoint-GUID: EdpQjWY9_-8Lg_XbMScEKCDTVJWLcr2p
X-Proofpoint-ORIG-GUID: EdpQjWY9_-8Lg_XbMScEKCDTVJWLcr2p
Reporting-Meta:
 AAFYHBDeUADOXoTfqjiU5UafeJxN2ws1CoJCuRRs1V0GfxYSfB2dXvca+F3iFnwq
 fhs7ddVY+YcpHaN4miAoWOCONvJL0DHr+NDpyBs9cjwy6ILtaBWf8De3bXmATYhd
 Z0noTv5aTmElAbUi7PLOka4OEdzBTfzrdwUMvDmzrGiQSGM0zOvTiu6AesLz/I2m
 h3yiJ037UhtIHexdEAGe2KtKY05tQaV+LriLuSYrlxOLe8F7yw7jepcSzikVVn8D
 N27UPc0iQhpChkk/6cSpLA4EWpqhFbwaTPytMj0xSvL755pV8v3yruOX55G8hi27
 gJDSXPJ/oFVWUbfs9dNMs/rfltno4HJj0hbfHxnazL2H3fG9AuFwynABMc5Qb2WC
 j/cQUAH1r0QBg7zJoYjq/2yZQ+I/8m2IKURQ9AEY77DVnDMvuIDLGX7m5PGmcCEn
 c1BeAOs68ztlne3NltjhU37jmhehjGDVQhMVfDaZbgKFCi8Q+LDskUrFR5Y44+tZ
 bALCP1RiZNzT/OVFgZf1qfyIFX9hZQLDo9SlhatOb8HWaA==


Christoph,

> Replace the open coded offset calculation with the proper helper.
> This is an ABI change in that the -1 for a misaligned partition is
> properly propagated, which can be considered a bug fix and maches what
> is done on the whole device.

Looks good.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
