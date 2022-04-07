Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8B0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gL2kJOOgz2oSW6gaNY3puyvNiJnCTk5MGAkveZy2PIU=;
 b=YK7BqRh0/WXJJ8gcxmfLDNaDTn2XtwThC71sUZhBgtDh9cWemWQgfdAAIMc2z/V7nVwmlGX+L2dS
   y+FzPaflrk8agtzwx+DtdoOjZACKqOQORZXB6BY/EQIiX35+pi5/5AL6qW51WuSW5J0qsJr7tCKR
   XACQnJ2Wo5XaJ8EJYHW9Uqpz1fVAzQpkF3ZLfdeVoFs9Hr4l+Ix00ARDN8uO1bGS3u0wJQlSqhbh
   YrQyCq6ro+/Yi//ckAWhRvhpoXZ4wGysiyxeUtMGo4tVYK8FuhVk1SJr2IeuK86n9/TYxWL0k92K
   FKy4BVk1hWNW1o29+glHo9ViL+5nAmeyD233xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gL2kJOOgz2oSW6gaNY3puyvNiJnCTk5MGAkveZy2PIU=;
 b=sc06oz8TSfZ0p9REO2wbeNv85DbI5XMnV2jOFB/TfhfYa6wY9ujPux1TEYLMn5nhA5vrixMuGsG1
   lvCOp3k4oe/rIoKd8lfkdy3+HNtt19C0fIBm05DyGm8kKPPM8mI0iPe/x+XJ4G4yVo7aGzzhnttm
   jOxBMcnGhjhd83Cb3FJ2pklBpQfWJ3QA3tbJoRws0EYjUkHB5Cdtcna8a1cxPUXGp47k2Nzo+aJq
   8Y526qbIE0xAZOuDEYaUvAMrCQO1s6JNw9LsE9JUoMhgd0YmifJhAtbCExprHyfleYrJcdv8PB5b
   OGMQ0swsdzytklucbIqBaK2KnXAbHjG/Dj7YZA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y009DKA1UG960@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:37:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0fSH05fVrj4EsKu7GruSr6V8eDQcmEnuW15iSPtYu3U=;
 b=iag3pmaogwT0fVNNtSBn/JoHcAOg5JTOiwAr7G+XUgGvcNjxegCBNThSYqe+F4T0NNMS
 B/59HaBNX03xPzKp11moq8ZsFxeak9RIA3RrLouwkC4YK+71tDVE0sdTjSK6BxxCftbo
 0EZ+onJIUBjU/ENdCS5sy3svT9bx0UEJmXm8G3Vy6SHK2y8Xy6l3WbHoInOxD2xK3+eI
 6prGeQ9aYuOEK5xF9lkj3vVuts9fdh0ePfPpNw+bzbLVZ7ePbcRp8+ED14FvB3NB4vug
 6MW3QIbWBa8G316LrQWtBIEFgUnKlZc368HFrB7khC0iArMf4byEey+uTWpLJY8E6DL7 IA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUMmqVvtM3PZrdJYOYr3ZXjGTQquxDDl4iexGUZd2uMPPl0trSRxmu/ytN08hc97JiOKAA6bMJkMkdJfbLU4/cK+p5BErCv+590v3Gl8xm4aGZSBG+jAxAnDD08ccFCYHLK7GHZEaE2obHbYUtaPtb4EOkjHSjXseSRN8ODsar93SN/QnoMPQQglqLo6tkNIgm/TPFw4a6sToW9KNlsu4tW3FWJ4YwGs2fUDwawHqAQZLOfH6jqbw0xXiVsLJ5O5NwV5OuiwQyII6zwDKf/1JhHsDpUVZqGjHhSqryX2lsCo+kPdg6xFSNp/1lsmwK977hT4nAR8yEs5zdCSpXtXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fSH05fVrj4EsKu7GruSr6V8eDQcmEnuW15iSPtYu3U=;
 b=SZ9y5DSwWVwcyxd/Dtpv5YeaKRx2wqNZd1OjsNS6aFp4cim4Pzhv13VR41EmqgeFoL4EPyr5riTFWH6zrhrQYHm4atGuKe21X3ELr8wfV1p+ABjI58pcKfcYYfxofvqNc58NKlk0fs+KboCGuxPpzcT/YCz1R8ul1wvOcHYDo7qKcyh73n2zxuIlZnGNHFKVygg5iNPUxw2lcRbBO61NvLImLAvJcVrIFQRE9J5NfMHAsGcs8Dqt8E/U25szUdU9HmwHU3DopACBCuFCf4tVIaWnevIP88IWdnqe+pw7C/6KggA1r/aj/yMGQN/P2KJ+UvovhRcHRd9lKVAh1+r5rg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fSH05fVrj4EsKu7GruSr6V8eDQcmEnuW15iSPtYu3U=;
 b=dbsa46qgviOfK1Ibs7e9hLs6v8XwRBVJvz76MblDmwJklv8BQu2YOuYadp2erTG5PI4IOrLs19olHKDXV2rV2sVF2sLzoTTEu4/z1JJd3jmVX6p6nVwfYv/eNHFwiuwF0hloYxik2ZUjmiDNrwsGOmOtKthdjzE2BQ+kLQvSgcY=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1r169fttr.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-27-hch@lst.de>
Date: Wed, 06 Apr 2022 23:36:52 -0400
In-reply-to: <20220406060516.409838-27-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:15
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:36:54.7050 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 26/27] block: uncouple	REQ_OP_SECURE_ERASE
	from REQ_OP_DISCARD
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
X-ClientProxiedBy: CH2PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:610:58::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75691adb-1eb9-469a-d0c0-08da1847dc61
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2200:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 yd/1F9lvqz3c8zGFe7RwJeNSWjd2IYgujlTISlMWCQXOVRubaTgyBQfZkOktyIuBGcMy5MUG8hIVUJeS5drUS/gpR9g/sAAPt5XmLAT9GSt/Nvqet+MJUSSFipbaTt4ans5t4xeJNXCij6arGx7LiBiu929FIPl/AbSpRCtlkNLXv1eNaUvdnR3gaX+UXeyU0icih1qsXHJNTyodf/9cY6QCe7djCzBxooi2FxtATRMHs/2myubXhRtEUSxX6B6ceyoKqsndcpckysEOXDsSg9m4qw8bk82pYQ/L1UI08RiOqSFbOIJIiOOPVXxIvHq69Zh61KITPIYWvLjV0VCMmpSGeEtapnqnVz0s1LREYFwI2kW8IVHD+f7Vqu4Ulp+ZlVtZkwP8PyIM/ftjK2G/X+cfHSVgqxgjWBBaLNqieylk6vVXnWuuHE0aE96fa9kEuaoPzn/UHBYHP8iiRyNBtkKWhfNlc1uihvKHUbdGWwa/Scc3dIJMax2DEKzSx8ebdR00G2rXWOngBs+JqJDofxI6SaRW4d+9uGjyKnbxtS/kW61d0W2xpx/08pSx/WqVH7p/XvTtKdM6++QL6ps6onZOZzKnyYDrYA9mpESN5Uk=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 75691adb-1eb9-469a-d0c0-08da1847dc61
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 xxI5XHXU2sbc/fWC9ndbwbsQZvdnJajAa1/8lQ+60/0I67zBHPfFXIKkzPg1a7pl8jTUriXu7jFYTH2C+zxBhKKaELIPNtXE5AOXygQB+ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2200
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
X-OrganizationHeadersPreserved: CY4PR1001MB2200.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: Jwc4vHBq3xWxize-5vQ6TWrSqeB9-34U
X-Proofpoint-GUID: Jwc4vHBq3xWxize-5vQ6TWrSqeB9-34U
Reporting-Meta:
 AAG3TATChFPcwzv/2opt1CAQPxPT90uQCr/jb9op470r3Jouxf9/WL+HlcTf+s1t
 AwY3HahRli5Ra0UvAHDN34B6YwzWfuUN94hQm/oJmXZnwRVbY0JvWezwpucvub+o
 9yIK9E8UbC+h5xZHqDnlhQNSUbfO9KbwxdbLrPLIVfWkx8ZCCBq+cwTiQwDYX6JU
 b1D830dZkPDxUwXB2C0b7gStNtdTkvO6T2LbPUxPHfdWaSB48y2uTwdzwW7d3JRQ
 S4KKK5gpLwRCKpB2VwYqNv0dfbQ9E8wv2XIQyp7H405kNdoYYMWh4oePFJj5KbQo
 2mVW5NYVXJ5bSgN0P0Zj0LnTBs/o58s11NuTNI7B7sT1DUUIi+dFkVNlbbg8WD6Q
 MD8jDdFgAUuRDujuKBsM0ZR6fjeurWerPMLv64he/avzID0lYPUL3hDZMdiB+ioz
 jsjQAk+DfgtjivPb7p3uBblO1V/nmaNAjYXFgG8VL41Ccha57sPi7PzMTXU5iyeJ
 dRlnimZu0CMdqf5qRn49u7oeIgmlFWlpiEsNB9t+r69V


Christoph,

> Secure erase is a very different operation from discard in that it is
> a data integrity operation vs hint.  Fully split the limits and helper
> infrastructure to make the separation more clear.

Great!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
