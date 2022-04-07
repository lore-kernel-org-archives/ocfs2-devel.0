Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA37C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b3EwIIDmEjkTGyQY5hLnzs2p4DuAhrpipEOmD7QZa2Y=;
 b=TBg8sePx+765qtaHmISX7pHY5k5UMvhtVBT/xSrtGiyRssQEqPcr8Zur+Dv6f6NWTfAR4GWkokkf
   P6sKQYAAjoNvLp8OFtciLTPVMGX52zEvxEpHu5mcSCBAKhUYEMdHJUDBIAz+m7uPKlsJ/YKsfyzq
   WuRUxoPFeODHNUmZiN/v+U3WAhB3nU1QCwXLUscPZH8YgEeuwK626bkmW/cnDMZaXyp45mdVVfRs
   Tmmz/vuCYIUvRzQXWghKQhWmxZ0USNPm9OJ0Oaif1WfT3DKSa4/uAiwRbnJLyLz3Ko9AfUgIFTsu
   f+5aIczLn7Sk36Bo3GxdUMBB3hF8CR1jNj8gCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b3EwIIDmEjkTGyQY5hLnzs2p4DuAhrpipEOmD7QZa2Y=;
 b=BOyfULLO28CEAXhwEIZs2iTPOLpgpcQJzMopnWaIiDcp6sh+7w9nFbWkUps/sqdK/G4O72xHaL2z
   GAcW+Swvdsx7tR1fR3FlMoWrQZx4TJYvxJgqKSiz0WCajTfykGstehUBkrv2WexpZjuFV0ENoRz8
   srFTib+c7s4joTXHcpi9+mgli44/u01sSroRc7UYaB35K4jYpCJcH/HBn+HBjCPBhChFsu0IlCkA
   i4wckwSgTIy3ppp8oQmYCAxWmvvpMpfJTEGaEw1JoF1oQOh9zPF6ldc3iCvl+vKkfzxLz6erZzZQ
   VTSxMmiIbqX3XFjMTQOOUrzWEHsBTBKGry7J8w==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00MIN8OABGB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:07:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F3x6P1kenH1Hm7uyRz1muMBaUZJEydwA1QWe1BNT6dc=;
 b=cfJmdlT0b28dv1IZ57X77wNW/0fqQIlICfwO+w21wI/1c0lHpUBi2zuV+EXoHxuLCx9+
 gzqua7rNKLsJh19hOfS/0zBGvCfkCYy2lrweCkMd8JtuJNhLctuWbAoww6EZ2zply3JC
 ZIqbDi1nv88R8J2m5pMK46KWih6U/y6utEmvmiAxqETsgHdTNSMNSF/VAFFXPW5xmymY
 5RqSgSb60kNgdK+p1lDvCcexMmB0yW/JWqgG+vd6dul2009SoBlCouO+lunuW/I1DRXe
 dOiSjL78iwHW23gE+ZvYCuXRRyi57NDTPg+ynkS2WqJlrCVV/u5tO5CQddADUltB1K3M dg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GewOAaqVdb8sF7qOPfRztnexa/gKzdHvM5bGIOvC8+50r8mBlAR1DcdUCJdGTVss5+g4XrngpvPHkJ7Sdl+iXWV5rOZM0f+XcLR3ujIAPjtosR0qsSZNo6DSNv5YYB54DEBG7sClyTU5n1IvhQAZ2cK6jHzE9nYUVDb3bvFzjGBV8i+V4joQdHH/fZfKta7q1/QyvRZx9hkjoOOxA+ubePwDwMBUvjQAua3dsz8Ga9FYkHGgeOAMUYRKnYGm3IVyJPYTlOrup7wLAh+gJ5QW2chJsfKLwH89B8flg5GkkQcFPC1G0Y1hnE3loU5bZ74vhiBKY13Sae0AIllOvotoSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3x6P1kenH1Hm7uyRz1muMBaUZJEydwA1QWe1BNT6dc=;
 b=B/TMMHDuC9RLsPZ6wT1k8MhN3Ted5alB6R0T+S2slytP0e73cxclcRi8vYsTKsA1n6oVXFJ+t1ScbD7rB9/RxQwO1eizdZaOSP5T8BaSGSC1L9ce1H+6xJ72iOATxCHw4K6bblsP56HSydF0MxlI5QVYjy4pZSZIE68HNNsQBopDN7AD5JjJesyROJgLvjQmXNs8oNLi25TXQlU9jrIVMmXCmiXtdC3x/9k5tubrguzJ8nALqlJSBKiWo+5348BmSZAmyIW32xcdzx7lhOxgTNCgPA1yP0u9sPBYSVlpKduzzoILx618fYvcqEI4uZA/k/BCwYFQ6t3SrsN0IW9xNw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3x6P1kenH1Hm7uyRz1muMBaUZJEydwA1QWe1BNT6dc=;
 b=xMyp97S/eW5+v7qnSCKECte9omIy93r0mV226XgowLHQAo3qrH6fPVkR9mrWstVURHGCzAAZ4pqlZV/KjB23iuBJTYIsKMoQ7HcwpnjKX6bXLxFNMN56O/EtcWArQj3lC9MFukt5jFka08k3ZjgHiuXBEVHrqFZr66+/oZ4WlSQ=
To: Christoph Hellwig <hch@lst.de>
Organization: Oracle Corporation
Message-id: <yq1lewhk2wm.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-3-hch@lst.de>
Date: Wed, 06 Apr 2022 23:07:07 -0400
In-reply-to: <20220406060516.409838-3-hch@lst.de>
 (Christoph Hellwig's message of "Wed, 6 Apr 2022 08:04:51 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:07:09.9126 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=807 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070016
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 02/27] target: pass a block_device to
 target_configure_unmap_from_queue
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
X-ClientProxiedBy: SN4PR0501CA0036.namprd05.prod.outlook.com
 (2603:10b6:803:40::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0159823a-59ea-43a5-79e8-08da1843b492
X-MS-TrafficTypeDiagnostic: CY4PR10MB1590:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 /YqNy8cXnh3Z0ganuYGTF5bS0RU8+Ime3ZT17Ti5NT02mJWC9mRLqdOAY66jI0ikS9zpI5S/262geoCzOOBOs8P+mDDXZN8L68rIA6uA+PkeVLquA28LydAwd74Y1TVTUP5KQ20ft/9eblrIhHaRqqlnwiSueTkhg5OGRF3d2iTdjpyP8oKe5T6V+0UcaDiCxR/AqJcT9kvlwyA3XLYkmWOi1ODHV8kDIPIIZGJKiS1MPaPxalu/BvjlVz75Xe9BBjM9wanI9TP/FtHGqGDrHOK5BQG4VTAWDGRNpiwWa7sO8mfNRODK8aX/pZbSA9cKA/yhNYXAAsdj2d+Ojyeg3EeXvZAI6ndu9a1MlIf6Oq7mQO0ArrwJRh1LwcDpzBIvXGms2/Uf7jvs4FGxvSq13WqykadqeTV5XWKINiTwunhoKdVOPA4OmrTIaikAMqDaIsbtCC1lkGY7MpHilAkJyeXF10z+7HWRB4IyjXvNqLnWhqLGjXXTqjtqSWhkYRX3oKMv2lauXWBJ3LQLgXvKjUqsBIQggpxyOXLmdI03N06KHw5LcIWA6Tsvc/gwkssdfW/004UeYJpNhB13lSIhRgEWSNe78NgP+aMrdyM+/fs=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 0159823a-59ea-43a5-79e8-08da1843b492
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 kG9UjttGiRw3JVf+jwyI08QGAOc5aSrKx67j79jMLLO3Ff/ZV9VhprSYJVdNJOr8vqf7ZUAqbYsGc8mjgfl0GBN0niA5yaYJtcy5AtXhsag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1590
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
X-OrganizationHeadersPreserved: CY4PR10MB1590.namprd10.prod.outlook.com
X-Proofpoint-GUID: H4aCZ2vP2x1tF1xyMa9Apj5vsH88HK6M
X-Proofpoint-ORIG-GUID: H4aCZ2vP2x1tF1xyMa9Apj5vsH88HK6M
Reporting-Meta:
 AAE/tqmns6iTdshwpDy28AL+d7OCGrOgPiwbhLhGv91UIbl4tnIBCUnpXPHqsZpj
 bNeXvvKnKQcZ5VI8MaZY1tsoNLYaU/AXNkjMuIdy74aB6kLsg5a5x14rTW0lO9An
 mhRFFbxA22a1kZTK4pwCesKuDp+ogq9N74WqdzhKVqjM6D9RGsNdrBFJdPrjJLQr
 fWKvmogP4gsKVCLrAUDSLvm+kenFgcVjHR+lAUtfA/dMjmz15bhsLJqBIPf/jduC
 KhMdYMzuTUUxqHA3ttHb5FCL4NeYL5yn2CTKNCnujClvJkgoWazA0bcBnv2lVu9q
 dxSwPMp69lsFw5qccmrw5xE7NTFuF/LGwhGqGx3WBQXsyRfv2+XQ5re2wv0VfWgc
 IFMKUN88FETC2n9aRuFpBa2ExX673iu/xEx2U5PCA/A344r/QjtB3ahce1E6xBcn
 HPEeUzSua6Jycc6gAAyXzyTvfAThFWxF1xr+teQKUEGo+j5uJup57uDia3ZI+k1p
 1XQlgBhi+exu+Q1Z19e7IPoBabCUxfdC+V0lOKg9V6gv


Christoph,

> The target code is a consumer of the block layer and should generally
> work on struct block_device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
