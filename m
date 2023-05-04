Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743B3C7EE21
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rBN4/8e4mHbpevX26ngEEMtCPxUBAbzchzRWrhD7a0I=;
 b=WLtTTZEyjYv0R+Y4IsYkkAM1RPSVxTyKCNk7A6zmbUVonxWCFZYA9L5KWT+rYYgr7oHwF1xvdVT+
   vjKeyGbZw9jku37c2fvbxWdg3hIOYPa2Sr1PD89mg2aNEpXOR1k7PgFNavef7U4obDbD6Zj6f0Vh
   POCl/4WXxcqMBiRPYFUkyMtLUAIn9FJ8w+0uPEyUQoLreo61Ycy1Zdqzx2no2HXuKQQBoNQVPlBO
   i0+8W9rxrE5NNumFdECZcRpFNrRhvj7/S3E4HLs7gS+6bBK5cnomsnxzgbPD4k3dws85D0BHw/bl
   bMK1Rj/dCp8BFqmjkC9mhHvBfleljsA3IbnI3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rBN4/8e4mHbpevX26ngEEMtCPxUBAbzchzRWrhD7a0I=;
 b=mD7Be6hcA5zFauU53D+jIGgSQTkz+f2jBGUjbVd8OdJZRj4AUjeQlgdCxXMNL4J70PkI9pi+WxkJ
   2PhHi2nWDP4shQ7RqCgeY9OOGNeLhDpbuUortxD5y+Ke7xZWTla6Dio75ETJWsUMZ4hg1L7dLZ3X
   LQNvCcpc/COOXTN+ZAJvDlLoxbJ6BRwYi7MltC5JhBNxlXuIrjOGb8YJ0sha4aMpxnwWl349XfVf
   FabcLwPN9JmOiWj9DGIaDQCJ8N/y7AneP+5jypmu3NKk0dA4NDJeSrNsLFCUS2/yFm0c7l3TlFE3
   Z9vdz64WdT7RVH7Qdl5+9qWOl0PQ7mclsqsUEg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU50096K6QMQY60@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 16:20:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJxhS+vzs52/CuiNh5IpjCzoZ3+zSw0in/iEqmNRdPvX52obGeEABsCVh0JtEYYScKQdvOskHdOV/SwaQ4yFHFmgXkeb0Y3CcooxZcqFFEHWiYFhLt7oBDbEXctGA8fVM9fgAXDeKamICUd9T8JOIDkmiL2/9jhdemnQCYWiHTh36UidBqwnKIJQGiterJcuapm3CCuzmtTNSyWZV79V2WLEz/BSmWMVIKx/EKd64BEJJFm+NjLVFvaLxMafGutZCOKDGaMOGqxte+Qrsim8zi7Fcg6W9H+OSo2Rw+DYemnOYvlGBQwA8pcWbpYFoZXW7v5fQ+5Abarw0PnohBds1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J86tjF3aRAvLJvVWv4ZVUGUPEU/pLMaAHS1J/jTaQ+Y=;
 b=I6nfKtCLUs5ekCqMVPN+1uSkRyRTcQpY6XwNScoSnLDxtdUj/CvUdR8/iEFR90hff2cZYEzt0VQpimB2o5UNyv5J9fxrzaE0tMmyJ+tVOIvl1JxRf6AI1UD70n5prxsxh9MlzsZ3kJRWbpck0YS3mqR98T2h/ab9Lx3IfO9gkxBVwMqNWimw2WmyHbxYHYEA9YKItG5T9n94uw3hzIbL6Jz35Eu+cpVh9Os1MidtBM2LNQpBlMiEAUOpJwW5QkNgPyNHUE7Y7nC38Ywr0QKoXIwMeQqLzscRxTA/1bQiOQKi9z1L3lExuyv9H+suh4MieD5UAaCg8rpGH4S4aQWI4A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J86tjF3aRAvLJvVWv4ZVUGUPEU/pLMaAHS1J/jTaQ+Y=;
 b=HT+7GsNhTVyxBg+oKRCPaI1f7tWbIqZ5etkkgl57XFBxPMUz5UqOBgLv0oWy1uMDOq1iNmK6ublUXebojHD4JwDkbsB/doawU78DvhqnygjZpAx5Y6fpvBq7VRz1xJzVyZPYWjQBULhrDMqvGMQXWYPDAcMUY7fXU0im+jqXknGQt1jy0i1afmqhKcI+UTU5Y+tfbHBhY8XgdSMSQeQrKDPwfakJrSpdW8EjJ/lJ76b8D09EuNBFUfiMvoSAXobnQjIG1sofyhwAJ/Ologijt4Fl6fmMydyjNFM8TLZ024TORjJ3Z0dJ8v+fYfHDU3QsTnYZ3RNlboKHCtctwFXFqw==
Date: Fri, 5 May 2023 00:20:22 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230504162022.jajkdgj2rgus2w3x@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
 <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
 <20230504080232.5a6suqn2hvtfz52b@c73>
 <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(38100700002)(4001150100001)(316002)(41300700001)(6506007)(2906002)(53546011)(186003)(1076003)(26005)(9686003)(6916009)(6666004)(86362001)(6486002)(4326008)(6512007)(83380400001)(66476007)(66556008)(66946007)(33716001)(44832011)(8936002)(5660300002)(8676002)(478600001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 16:20:29.4934 (UTC)
X-Source-IP: 40.107.104.59
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10700
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=181 impostorscore=0 bulkscore=0 priorityscore=148
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040132 domainage_hfrom=9718
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:4:188::18) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DBBPR04MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: fd78d94a-7b27-4b07-a5b5-08db4cbb7a14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 t4M2cbTaSNql+pZyk5Oy/ZJCrlq0inz6U3u0qkVl5OHCdiQczB+692gu4XXkL/M+i0eV4OHEEbTpF7XKcPSuWsi7ook9eynylnV9qSPPsDCFN8zqv1ek7QPhZX+tWsOHR5rCNN2x8A4TsbNQ1kCBQ3TBFt5mheD+ffj3epvBqOU3IJbiAvlO4RA2NvVkvYzhVzkdHR/sLk8xua32KDD61BhGLwtgfu4bdRt6CyRjvTBl3vflrp30k003TYoi+QWRUuAxE7tWRex2oADj0OeGVAhbR7u32wNTA5UR2u4n+cCR/jlHeDDiQC18iqGz0UEMNu/zTVHWWZKyXyDCvFt9gkOiUbCUBYYAq/SiysrF8LTLJ7g/8rVsPdV9/3GAKq8Ic+6yFWdh0V+8aJTMTr2EP4T429J3KogUxYW2k26IYsz2WFyfYWqGmfUQrjWU6CYVU8v754dol715AAfMlEBjD/tgDUUI9B/Ssfe+V7Gu9APWiueymGbx4Dd7XQFvNTpsviXpothwwTtscjynI5TGb1ALxVK5Ee+PeNi/sFdAMG6yu0R4X6JKZkxj/yGtsAHz
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?1M1TFZaPUS/dOR+i2Q431tUZTUkOeQdPI5/RCdqyWPTpbhNHofIOoD6yrMMi?=
 =?us-ascii?Q?msc202BrIshZVEBVl11BSvla9sAT+7jf5J/jaTkktk5QjuIPmUQ/Z6xnL93x?=
 =?us-ascii?Q?nvtA1fyAr6unYomz+XR+0DtTZnmnaJNnvOlZi+aGh8IXKwlhfDqA33BrJDgo?=
 =?us-ascii?Q?yEcibn5TwetI2loYQBFi/xQ9staL8nVx5eyDLxbS/9rN8YZ27TcUF7lefHFL?=
 =?us-ascii?Q?ONRPixxM59v6M6kwzBiSuq1CyvqRLPnSly2/vK5xT5yBLhizwdLb1vTXYBAP?=
 =?us-ascii?Q?lXSjAfqd7h4ODob6GsK877HPhVy3KQWVJ4u8/mZOUtDkaWuPMDgkm7nZPDVu?=
 =?us-ascii?Q?x1/dQhGZdqBF+bvXD0K+9f562gwjsNj+ZmYWf6Nq2zxOFP8bPqBkEIovIiMI?=
 =?us-ascii?Q?OBWYXrRQoCKbmSg+pJywurMGLoQyW5sYjcLCVi1UgyGLNl64AwM+Ud5ZDir8?=
 =?us-ascii?Q?qNZ9R1vJKdLW/gCuDAn4E9E6uZtTceKfpRnqIS8/MUjGw2ZavD458qS4oXGu?=
 =?us-ascii?Q?iAXtbA1118G8w+uw+Z/wBMw0tsNCWTIw43XjJebBp6unKvkOyeWINtsuWYG0?=
 =?us-ascii?Q?cqiNgJuh8Xzh74MfjD8MopuRLOIWT39w3kmR6um40fy6097bWN/pow+PD6vT?=
 =?us-ascii?Q?T+xs1Y/CbzrUjeU3AWhiyMfUKoRvdG5jPp/hZlTERQXFlvZBf0Ih9kUE6bFr?=
 =?us-ascii?Q?ek3Gf0xNDKy+RpxNdwJ6OZ4gwOVoH272j2MPPiS1ph2BeXz2mTbyRrHs05ui?=
 =?us-ascii?Q?d5jximTx/yADqYpzaca5ddC5kdp7nScXQm7cNS7pgN6wvrr7TnVvWINbrJ6d?=
 =?us-ascii?Q?jNeZiGM9Dt4S5XhVb+9V5PaAKMYljqLs7H/Slg7MsirfydFrJpGHGEhW79Hj?=
 =?us-ascii?Q?H0BmX2bDsfTf0RVHkpoOZz1r4n0jVJ17lovIdvfMlLHvRxx5XsyECPyPZeGV?=
 =?us-ascii?Q?VPnWqa477eBbc1E+JF+m1WF/blF8aHupOU6hB1s1ozmHYlCNxwry6RhK1ddr?=
 =?us-ascii?Q?iOEmYDdj9BMDlK+aaWX5WTcRISIu3PSKcZOMTA9mMzGudm6JAufsh8ZE0ros?=
 =?us-ascii?Q?VHFODFUnP1tN5RhSc3Z/KUA7Oke66uJo1Pm+7Yg8ynVoCflHE66CVUaMeft5?=
 =?us-ascii?Q?15Ql6STRSot/NFKW+KzmF2bjwNKHxZaoSz7JAoblGKbOWN45s7Y6bqUTCVtq?=
 =?us-ascii?Q?bITO0BomaVlr/Jglgd4k0r8gPtwOPsILDS+BVdZHm2IYdzfYCR9xe7OY4e13?=
 =?us-ascii?Q?h3X31ASJl+xhs/Km1UX2FPj8lKlTuUcbxpgRzzZiS9J1TdCl0H8cg+9XiGyt?=
 =?us-ascii?Q?gTZ/2uqCpzZhvcXDQ5jXe/Ggi9V/J6Z0iJmKQxAOW/Z7c57wwUHbUhX2Yw/k?=
 =?us-ascii?Q?/hI1y2GX/yQPlysvixrNC8QXGD2ZMW7MynO63n2tiaDEjXaVhqczVoS0j+6W?=
 =?us-ascii?Q?l2Y4WguTt0KKATWOcSKWvKdGTDJxdQPHRXoPa2juCQkBiPjYvK8JAKrzJEaP?=
 =?us-ascii?Q?/mTOABET7Z6mtq/uaYL0wTJ7EjkZqGCveizYzmuNUfFdcU+7z/LwEFdAa/Y8?=
 =?us-ascii?Q?fZt1yWf7uOex7+ewUvsahK0nmt25/GGbnaiqFXdQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 fd78d94a-7b27-4b07-a5b5-08db4cbb7a14
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 9yoUN2Yvtth3ISLNQjHSTovWvMy71H8GrxwRmF8xcsrRFgP3TZfyXRLkjTc0w9XZHJMV2RQGNIy9ugDpcyz9tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7980
X-ServerName: mail-dbaeur03on2059.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: RPdtY7uHq514_EzdxxVzJGqFkeYXNd9V
X-Proofpoint-ORIG-GUID: RPdtY7uHq514_EzdxxVzJGqFkeYXNd9V
Reporting-Meta:
 AAFSq6kwvwDeaGZRR4+RJq90YXvtHRa31TE1H9A7t8hUZRxBvFBmVPaYxcnmtubV
 woEKukA1hDxr6JlOgSAJ+HMJM8aeSYYhdkcAu8HqiTM3L26gaDMfFo2Wqa4Tfz9m
 bMRuCGVsgiX9MwLX63J89o79fRl+qb7wq6U726B/AmfT7dEngMh5UAjFU0Bjsy45
 1NAdKLNNsvrW/01GPbB/xLD0jU6dz+CG1WW2vCN/j7H7O/wDiAXVkBHlFjm68WOa
 gJByGMBjTHib4pbZQtV8DedI4FXVjZY0oHnkaoO+T8jA/AViqImGUjbxCHVd78iu
 dOwjkL8F9B+GPm8IjBdmDN1ILrJEReSO0y3y/5MfBpO9W+IjZkh5mwA/KtqS1fP6
 EZGE5e4g2DMQe8ycYEw1hLj09nCVU9oKHBib4NZwkge15XRTc1KztKB2GuJWhKEN
 CtF+M7H1c/UBhP0SqMq0f3DilNX4STqxUydFTTHFRNJUN4bt1eY4q1QSKqgbHVPf
 gfSWjcs0SWIRKJUXNl5ahCsl9q9NvqlSxL5py0oEV0A=

On Thu, May 04, 2023 at 05:41:29PM +0800, Joseph Qi wrote:
> 
> 
> On 5/4/23 4:02 PM, Heming Zhao wrote:
> > On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/4/23 2:21 PM, Heming Zhao wrote:
> >>> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 4/30/23 11:13 AM, Heming Zhao wrote:
> >>>>> fstest generic cases 347 361 628 629 trigger a same issue:
> >>>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> >>>>> journal.
> >>>>
> >>>> What's the end user impact?
> >>>
> >>> There are two impacts:
> >>>
> >>> 1. this issue makes unmount command hanging.
> >>>
> >>> No one likes or accepts filesystem unmount failure when underlying devices meets
> >>> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
> >>> successfully.
> >>>
> >>
> >> So umount hang should be in the patch description, right?
> > 
> > OK.
> > 
> >>
> >>> 2. for developers to verify their patch doesn't make any regression.
> >>>
> >>> fstest is a famious & important fs testsuite.
> >>> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
> >>>
> >>> Current status, there are many test cases (about 9 in my env) cause fstest
> >>> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
> >>> gfs2 only has 1 hanging case.
> >>>
> >>> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
> >>> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
> >>>
> >>> On kernel 6.2.9-1, the fstest 'quick' test group result:
> >>> (the result based on my two patches [1/2] & [2/2])
> >>> ```
> >>> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
> >>>
> >>> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
> >>> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
> >>> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
> >>> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
> >>> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
> >>> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
> >>> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
> >>> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
> >>> generic/636 generic/702
> >>> Failed 49 of 568 tests
> >>> ```
> >>>
> >>>>
> >>>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
> >>>> filesystem. And we should not commit any further transactions.
> >>>> It seems that we may unify the behavior like:
> >>>>
> >>>> if (is_journal_aborted(journal))
> >>>> 	return -EROFS;
> >>>>
> >>>>
> >>> IIUC, do you mean add above code in ocfs2_commit_cache or in
> >>> ocfs2_commit_thread?
> >>
> >> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
> >> Actually we've handled this case before, but just limit the print. But
> >> it seems not enough now.
> > 
> > I wrote in my previous mail. Follow your idea, The code should be:
> > 
> > if (is_journal_aborted(journal)) {
> > 	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
> > 	return -EROFS;
> > }
> > 
> > Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
> > Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
> > IOs will trigger IO error then trigger RO status. This flow is wrong, we should
> > mark RO as early as possible when JBD ABORT happens. In my view, the best place
> > is my [2/2] patch code which in ocfs2_commit_cache().
> > 
> 
> Agree, but ocfs2_abort() is more appropriate here, see
> ocfs2_start_trans(). But ocfs2_abort() may panic system, I'm afraid it
> has to change to read-only accordingly.

You are right. I ever used ocfs2_abort() then got panic. :)
So I changed to ocfs2_error(). I also sent two mails in 2023-4-30 (the first
mail has mess format by thunderbird). I copy the mail content here:
```
More info for this patch, maybe I should write below info in commit log.

From the comment of __ocfs2_abort(), there is another way to handle
journal ABORT: panic.
And fstest generic test NO. 648 will trigger ocfs2_abort then make
kernel panic. I don't like the panic style, ocfs2 should elegantly
handle journal abnormal case.
```

fstest NO. 648 could trigger ocfs2_abort from ocfs2_start_trans(). So you could
find my previous mail, I ran the fstest with parameter '-e generic/648', which
means fstest excludes NO. 648.

The only different between ocfs2_abort and ocfs2_error is set
OCFS2_MOUNT_ERRORS_PANIC, which could trigger panic. If you think panic is
brute, I suggest to use ocfs2_error.

> 
> >> BTW, the basic rule here is, we don't want to change journal to prevent
> >> other nodes corrupting the filesystem.
> > 
> > If my memory is correct, every node has itself special journal partition.
> > If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
> > No other node could corrupting the fs.
> > 
> I don't think it's a good idea to modify journal even flush fails. Why
> not catch EROFS in commit thread and break? Now we can only expect
> umount continues with error, right?
> 

With your idea, I spent more than two hours for coding & testing. The result is
my patch [2/2] is correct. Please believe my patch [2/2].

In patch [2/2], there is 'goto reset' which will resolve below three issues:

ocfs2_commit_cache
 + ... ...
reset:  //goto label
 + ocfs2_inc_trans_id(journal); //<1.1>
 + atomic_set(&journal->j_num_trans, 0); //<2>
 + ocfs2_wake_downconvert_thread(osb); //<3>
 + wake_up(&journal->j_checkpointed); //<1.2>
 
1> trigger hanging

umount
 ... ...
  ocfs2_clear_inode
   ocfs2_checkpoint_inode(inode)
    + ocfs2_ci_fully_checkpointed() //1.1: check '->j_trans_id'
    + wait_event(osb->journal->j_checkpointed, ...)
       + 1.2: will wait forever, if commit thread exits.

2> trigger BUG_ON()

ocfs2_journal_shutdown
 + BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);

3> trigger dlm lock convert blocking

if there is pending downconvert lock, no one kick it.

At last, you could set up a fstest env and verify my writing.

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
