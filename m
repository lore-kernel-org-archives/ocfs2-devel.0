Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C64C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VOYgaLKc+4BrOJyTBoCTDXr3crEUJRFvbS0x1dlK/1o=;
 b=QckbJ9OT6OeM8d50ulX/k/MkyhgurUOjkQqdSdRbbS/2EZh+2eUtwTJ+8ABxVCi/zdnrm22qp4Nm
   hLxhovRcCUbE7GjINb7R2eNNbKSgWNCnAft4Bsuc9eVk3N68c1ehZC/7IjfKIqxVa9k11ElrhY4t
   Mgv+GhyoB9ZwL+DN8cC984OUfMcOXRF+v+7S0NMAJVFt89x+l04FVw0l2KnqBtVQA+Ye4OXUzcXT
   d+guYQzHnWRXjWCtjFQ8roGOrmxOnKpuE5J/BmwGAOy2VyzJGfhCUigFexJ0m0zitZLN8XjbnBxf
   /0dOWG5ePdU8q69HL5xJlSm+7h6T9FiSMUQmeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VOYgaLKc+4BrOJyTBoCTDXr3crEUJRFvbS0x1dlK/1o=;
 b=dDigAFycyZ7GgF5xmfTwZnCnv08/r31fEe7R7zoGGM1q0l6gB0cPTCkwHWqMmNtY+4Ylp3ZRl/GW
   bfhlIct8mg7rI7HYLRLanWcZc/BqaNDru1mWBDrgcIWMf/BLH/2HyFy64Pog3/z76cbpotvw/iWa
   4apQo1+A0skIR8q0P2m6IvYrV+bwt9NjQM7Vqlff/UdcYOWjw/yIT7VXpX9Kc9E5Iio22HaBi7Tf
   uSsJAO+Kjco4PPwgvWCCjJQgtWiQc2wVeodE+r4g543tRCqoJfJgyG2rbDxu9Y+8R6ORg7iSQezz
   uL2HysNvFZ93hidRBckOZkpASdPBIE4Fb6ZlmA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y0098094YG960@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:17:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tUJnubd8gZXBDmR5y0HccTdVKl0H84DH174jOcutIYM=;
 b=MpF7s5DZ8ufwzPew/71u+lD2uIs/gd7p212hZkW2MMzH9Z0VU6qO9Yxhu3OWemD0QKv0
 DNm3uvLZOAswhBVHwNIffo5S76DiL2YSWSi69llniRSTVN48ndZYUgtccIGRq0tpCN9D
 YAUuhQw3Zyz7e5dWGbFKKQ2IT2Gi08Fwfu6M2zWCBOcBEwHfAk+9lqS+pi0Q1z5F2lYi
 DsmL3LuIpZTZ6KsFTf2zoW3s3QGDy2wbNZncPR6SR/sPawh4OVJ+EaogbNB0dos6TW/9
 fmnGmjkr8eQPdgXEKjuNCKY2pRLtk0iuwvhrKhC2sgTK8fVzZ6G4l8UcH1Aq3wCl2L1S Xg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFTJqc7y57CiE/uK42/NOopRmYdgF1n3N8rdD2oG2HkEuIcjxKPqekQPzfuizUYYirOSeOTtk6W8kDI+4hsQWw2Ffqc6Jkd+PFBrBb2V9HCqoCuzYAB69PtSLL4pcFPFntwWKialKOmWuPeWkgrCf6WvW4m/3Z1hjtqnpGF/Eb85tCoqfKSJSde0uzrkZFMqz62eJ9KqJojKNOfohnBdgN2Wb7mPRl3/bl/d+wQI6Aqu8QaIoaJKsug/L5H7+2bLvtF4HP8Cgz5yvF99FNXw0YZM/FBIwl+7qDexuPtzPq+I52O5T0tZhBwNZEZJvSCBcfUtJV+BPI7jAWdzkRv3MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUJnubd8gZXBDmR5y0HccTdVKl0H84DH174jOcutIYM=;
 b=obdAjOW2ekIvfRsoxefHjXXc0FNLb23R03a0Hn6xpP3AzAgP3cKFiOjk59rRqBl7yd/S6TqIYEo0PED0++eOhKoVFyMXQR7iL3DhIuGQRbUIZFV2tuDznrpOTGKao3c1F6rwedkyeQMnbqK00mWrP09b221mBP2YbL9Tma0D+ZKH/L4mt+A/t+gD+fukZPhqzi0i2EmG/QdD7KlUwHhfHGEPGL34G6d8q7pABITHpn+CjXwTpvHiQMAYlhvWdZzHtMENwr8VYeV75E2s68thmGeq+DS/swgegd/zG9pWc1TdtGgvlu3VhbOF+FDQubTX6HrqKGJi1QaUPE8tnbBcjA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUJnubd8gZXBDmR5y0HccTdVKl0H84DH174jOcutIYM=;
 b=bIh0kHNLbVOLVfrZOh1LHiu2dADuBWjUuKpPbl0waGWsPH8k3A1VR9Ck2qQeJ4rOcdmeNIsJRpedDKXholmweZuO6m0mAR7L3Csk7gpqzfdxR0CkVF1cdZREyfQJ2BH54cLAqushjE9i4yhFVMPz4NsXWs2ncvFEwRTHyRguHJ8=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1y20hinvl.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-12-hch@lst.de>
Date: Wed, 06 Apr 2022 23:17:07 -0400
In-reply-to: <20220406060516.409838-12-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:00
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:17:09.7050 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=937 adultscore=0 bulkscore=0 suspectscore=0
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
Subject: Re: [Ocfs2-devel] [PATCH 11/27] block: add a bdev_write_cache helper
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
X-ClientProxiedBy: SJ0PR13CA0051.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6756038-ebba-420f-2828-08da18451a11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 l/Q+6i8a2Bi5zZeZEQlD6G9skJ5teYjHqNNUJPNNaoYHzE7gk7unEQUHMPXOiXaM+/kon/EHPF+fZ3ne9ro6a5F76uMKab6MukqeiFh4FAQv+/qv25GcCocja9fDaHu4fjQd40I93XxvXnMXpkZJzidSGU5wLCjQjM+J5xiinwL2j/qAYX8SoSMLrek+q5tSOM4nJrBTWMgyB+ctiM35RViFST0sGrhXSuVRBI5IPMY/fE4YcjSVKGW++lHN/wvaROtz6TMwj1nC7Zmj3y2p45BwowkR52LlipI/AxQQbH81WpK76UHjPZqP8yshCSTfOhPV+U33TjEhdSyeM16m9RSyj1rDMIIi7+JWTaM2mxxx5fnCjVBU16l7itJxSELlBwOTU+sjNpFZTl5Yt9ZxiQnGynbFGcAGJOtnkjcHLEzbSilsfwnNs0uDiOaqSrTZr51xyJW/6kNuPItiBbGuTRJHc+IxN8Xg05jgbBHWaH2qa85ZVVY/rh0urFddrML95xCru7J1BULRvo0CpfvqOPsQgNZboMiS9Aq/JCeygdcdMivRZpU9Lm+03ntqd0yDobU8GJScS3UkFcCiCClligRVwpw4hTmEO8wSt4DSZQQ=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e6756038-ebba-420f-2828-08da18451a11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 vdn52TmNEFKJmHV6h3SFAVHVwIz+ZDkKqUguEUXGoRfnJF6GC3nWc0xMQF1itEcnBnB1dvzxdmeKSxJoWvPlnPk4GBP89IYF14zOzWDQNsw=
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
X-Proofpoint-GUID: GYaARMsj5crS8GTMUNoa1DJSl4geir83
X-Proofpoint-ORIG-GUID: GYaARMsj5crS8GTMUNoa1DJSl4geir83
Reporting-Meta:
 AAEFVgSkvi2PaLiX4cpZyhlT/PEjccl2lcSpRi+r0HGm0NyvZj0qAZadbHJ2cKHN
 AUw3lzqS75S7AvI+eWPHwbHE5C7q2TcW1CfhxaZJUYzJCUXAwmDGhyGr/RK/Gqpd
 4bemH26tPdkFIrwo0OQLTQwuswK0/xOeC+hPLC75guOe8EzNeuEbfPATUjLcRbGp
 de8BKT+87tUVByX9hx0x7IrzND95PWMo7Kzqm1s1MX9wd/0+yGiGf4EGFJcToq3M
 29t41KCmTW9zqJQoo74jGyCRmMacNLAmvcz2yo3wEnCPQJA39dXqqMwv1QVxWQ/M
 BN70hCE4eOd77196+RdwM47MjjGl23ojGkryyeuduEXHEZ8LVztCG8GKuyQm2SMK
 sJ/zE15n0B9iCFbST//Wq04wTpmarQw4tSG34hIXs2YjbMwJm7u/5IAEyF79VLaQ
 N7G6WTV2d13VNhi2eB7vK1idc3dYUTAUFMt3cSbXzotoVmiWgr6W0+wcvbrLTaQF
 vpdGBtyGmqwuOeheITVekqVBf7TJgaqEYIodvAzwt/3A


Christoph,

> Add a helper to check the write cache flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
