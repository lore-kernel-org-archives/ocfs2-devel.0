Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B15C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BBnHuyIpurWcDtUjHp3fD3bX3hq17emdsElnlbFGxN8=;
 b=TpOkrF0G3GPF+i57xJ1R77hg51NcPdEGAyC5HPMf9R35NMMcYo/l8sFGyuoZ0jcZMqEiflw+AklN
   erqU3wwdb6dwQTQg6xrvjBDWlaPp+KZd4C+sH0T/9oEPtFjFTzVNhDDvPc6kU2kzyiklQeHGLfjC
   2Ir5dnfTe8SgEKhn60J7qqgaC4BlJ81S2rDweg9h5pr4ZfNTO2Cj32W6wLWNMFTDJqaJmr2C7TjA
   R959xMgY/FP/5Nga3y0GROUvdv07B43ZOtCehAmAcaSk67Pisfza+AehFDXHWvwtvWJAR3t0UnVj
   0GQclfl8YmrxHah5849u3UYtKBX0FvV349IEPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BBnHuyIpurWcDtUjHp3fD3bX3hq17emdsElnlbFGxN8=;
 b=KSnb43LFKvaOurrd1Ao1aZN6WkuppCkTh8gY56DufAGNcEayJCpaNPNHQ4JesNaTYh06tJ6Xn+qG
   hIOYXx4+TBqbe4ASNu40My0Ugg5daNEcLcLcR++rbf8QgSHeX8oM1b8Bj85R5DOiKkVlMd/IzemL
   /Kkx+kmG3PEhrM7uWjjDU/5wqcVdfj7OMMUd7rfwF9RvAtpHqaSDTXLi17uG/ElazYTuiu3DGo/g
   kSAMnIzEmEkgGVXq465doBJma8XrGCWbpWQmOrJwbwHUQAwRWE9HlavjQRBHylW+jQVw75v41GTs
   S05t73zqCgiiWvLYWXF4EJgytg8sCxl6bS0OaA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00EGK8NOCGB0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:07:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GpTq+EYaOf33mkP0QbI4hVWDfTMc3+BcRAeyKVHiQdA=;
 b=0NtihXCzQ1+FQ1tCY3eP6NaSpVt4C62wBMyONHaQNDXk+Df7NABfYZ8ObxD6z0o7h0Uc
 4hadU2EUf9PJcm+SUs3zQ9fmikp6iPVKfKznotYPBhCxFizO3X7756CP4yBhNN4ETH+d
 zRknrleWVirHM8J6jWMYloqaVcNB8LeCiln5KswXELm519im3zOt+dJH4qPAGniklmBH
 bESiGf/Di83wWhWNbSjeJTOjlax0eu+rRflOqChjuyVyITKb/Ywanr4aHYF0/eba8zNN
 7gHxkMSTCK0+dV6aKHHStj60hOdZtNU2yzeS/UQagbF8ZY+LhFGqdP/KG8ZK+UbN7UwB hQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPk9xHKl8Cb8HiXFTCBgkHKbJW+N5/TSyeU03s0yyeGJrO/jucM+MyyRqlAPlfy8GLnK2BkiEC1eyggwr4yK8yFTEVpcfHa05D5HtL26wRp5suz2y33fIMkAfZaQaR3c970YD+B7UeXPX6s71iVTLvFUrBHKD7PYZjxlLAzuODvpMU+YtyYWDvlL7qO0o3xapmp1NTTOGyxQTiQk8W+hxZrC7erK4jkdsYxizNsIEKlGJZB6DvUoVBJweXR6h/zRgOgYh+bllpP/7Gtjwyv5fUVTy8IH6TFyx71bsPdbgnRvXSs5ZDBdK+u/OlBrb/ThQdl3zsfWhCXkeojc6nYeNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpTq+EYaOf33mkP0QbI4hVWDfTMc3+BcRAeyKVHiQdA=;
 b=G1GsxXpYbWRE2pg4HYHq0iN45t5yns7zqgoHWe4m+i6RTHK1gBavfo03WfoEHRVuaIAJjT2i4k67P5+YRlnZgKuDFaxJJ12N0Fkay6CjKZNYnl+Hu/fSYnf12DDsIdP0Z9HcKG/gSeX5Jw6LCcS97rgjnaTgoyMJiTt8UQ1R5vD4VhHDzC6kZHPBW3MqhddFP1jIktH9wgNhtDbOZ2IB7WDRbPIPPGvqpxhF2Ye23gd6hKzTMwPCbV0qYbzdHKOoBKcawUisvjhtY3bDjm4uBs+zbxQOx0ejGflpFtk6olmpGOty7gVHhTlKedje3XGcvc7R0TF1KJ6+J/eOyzx9xg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpTq+EYaOf33mkP0QbI4hVWDfTMc3+BcRAeyKVHiQdA=;
 b=wWWm3sxo5O/Q64rFlV603btAI6HGqPomYXUb9x2D73SYxTGY8QkJmR80/I1yeK2chEDMUicEmQqQiVMSO67kPlxS4gv1EwB6FtqJOjOiK+ePlQ3nNiW/mXc6ZTfKA62R9Yh0v5bfuQtY7bctWOMctjXUr2W1g6TeSbdfQ2DWWmw=
To: Christoph Hellwig <hch@lst.de>
Organization: Oracle Corporation
Message-id: <yq1r169k2xu.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-2-hch@lst.de>
Date: Wed, 06 Apr 2022 23:06:16 -0400
In-reply-to: <20220406060516.409838-2-hch@lst.de>
 (Christoph Hellwig's message of "Wed, 6 Apr 2022 08:04:50 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:06:19.3144 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
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
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [dm-devel] [PATCH 01/27] target: remove an incorrect
 unmap zeroes data deduction
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
X-ClientProxiedBy: SJ0PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a45fa5a3-2b8c-4663-be6d-08da18439656
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2152:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9uKvwYL+mL6RSW8I76ZWVTyJ+hCPN43UAwfOpukdKF9+hDWXPc7LozlakW13sa7bJuzDhykrDaMdt5WQ2Ggro5/HhDJfto/YU8x5cpCzwIIQmd7RVJEyth+tOveTrV+0C5Jt3R/2URTP2b1uZuwAtns0rkdChRn7LgRzFQOScMyNXy6YJd6WLVmJIsD7X9YNjmoY/QurzdsjZzUmfYPC6Nndd+zKRaznUJdSBhNhiwg9dpcXgqZD+Fp5Bty+EzA5uP9rn/Bo1584n+idRU9AQv/IjdP8zfSZYRsf1kF2wm0xa+sGzEPZTvQoHOK42mn6CGLDzMVtRsH2hy6Ks0+DpKYrHxtZjaLdNdwlJiYCuVtfzcB4k7UAiUePtW4IAfOfoWsoM13kGcBk/slPqiKekZ4jEjQoZWiF4/jZQH9DKd3aQJpWZn56EZehu2zzMa5vpLF2vOg0SUgi8v9jRNoPr2eg2WAkJI+wkJPZf8LumJAhIcx6SnuEZk72qSQXwYajqtBCitaOenCTLlnynuNm/3Nty4s4Fqiej1ZVClUjJQY0hWG/KM3kM6SGxffXgbRchbiWnTo40o+g19qi6+TZuXAca4NC2mr+BGCU92CsQrs=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a45fa5a3-2b8c-4663-be6d-08da18439656
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5tkEIoZ4H14YUgKrlQd1Y9moaGyVjpl1sLoZnstWUDniQCbedG8LT5Gd1DY+Ny8/39s7sr5pKhBb9B5hbVtDgDdzDmpGJ/9F7To1TqLdYLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2152
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
X-OrganizationHeadersPreserved: CY4PR1001MB2152.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: bOFW42heAb6N092mKvd6jcY2jzkNmFKi
X-Proofpoint-GUID: bOFW42heAb6N092mKvd6jcY2jzkNmFKi
Reporting-Meta:
 AAFYHBDeUADOXoTfqjiU5UafeJxN2ws1CoJCuRRs1V0GfxYSfB2dXvca+F3iFnwq
 fhs7ddVY+YcpHaN4miDoVuCONvJL0DHr+ND4v013G1zKnHgqh1+M90WPrHddQ+ym
 cDe888O+CIi6/tVLt6iGy2G2EU+Is/K6FJIpGK49TuetuuGtAi/G6S3Ny6HRj+xt
 93s0Z5fb7VgwudOZEwV/K4YB4gsWajmePSVwHBs1rg26dtzEhvYYGGqirvzVuBqg
 x2LhELibzZ4+0zCnJwxuwiImff/qj78HkXfRVpU2iDaiWCX8YDlqjIcH/p7Lb03x
 0E0WbY/nxO6EFppSfwYvS2lFezZxux5JcI1sgS8EKge3qtqQLpAGj3nyedfmS0W/
 s1sfpCrkiAMYOpklwjAss3tNvPUujT8VWkKlzrP1nKlAOJ6/bc8FgReVx7fw8fP+
 e3VBqn+jhcpb1XGtoJiO3u2HwBtqLGkJ7aGkW1jvA0bIyWjQRcktu1h/8znu9wEz
 lJRLC5mmLglWfCFaO3ybwWPPm7Z2gLCOYhh8TTv122CH


Christoph,

> For block devices the target code implements UNMAP as calls to
> blkdev_issue_discard, which does not guarantee zeroing just because
> Write Zeroes is supported.
>
> Note that this does not affect the file backed path which uses
> fallocate to punch holes.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
