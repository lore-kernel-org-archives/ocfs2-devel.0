Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD9FC77B7C
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 06:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U4YDlLEL6rpiHNfou1tZQRgZ1uSqC1LqiN5XcZPyNhE=;
 b=wKNVlEKS7kZGXtdAFKpG5qHFZ+EhasjI9bSo29X2a0giy7uuGOTauBCt0Uk0ip9FEVWs5qy5yMZn
   LLwAwW/AywNV6rqefufBBzwo+nLTh0zmMtvEpdfWoCpetJFIa0bHB36eEd7EyWOJg1lKyrxpJorq
   hz0CmOXgxG14J2NC7rknhnvbsv9rhd/G66or1GgVZvF04ezzo4dBnM/4xOcriazJfg24T2qitrwC
   u+p6hmsDAxbtVzGFe/qA5I37QSw4slfuTCzzn5PTFkQ0lqiEmjgemsGalfeE2BrTYMTMcWflkz5+
   lxMF8kQfSAn35PQXebTt5CIauX5E1691rk+Glw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U4YDlLEL6rpiHNfou1tZQRgZ1uSqC1LqiN5XcZPyNhE=;
 b=E1AfpHYYEWPqbHtw4RoZkRMIqHpnWaw8xIHPLF6NYuw0iSc6VtTZ7Eb7eXRmeXkiWbr5HFUSoJR1
   6bdxoWSC8F0ydukv4R45STDOGSNJpekqUI/oRFHhPWtvzV8Rh3URMJ5y/D9ACB6ghAFx/pEMcfmT
   OzMZU9Z213QGAdRt05D0KB2CFoMOItg0Kdv3uyh+CSTEGuNqkctc2Ybs1ZhQOFPETxY1qglE7kEq
   tsxaw1nP5Ljx4Zws0dXMwIoYlSxQEoYMbtloRoKdGOoEGP85y+/9VWrz1Y+c6jYT8jd5/S6byfFB
   geTLznoZoitfCdrpWSWo/SJL+9OfrjyjOra8UQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU40038TF0QYVE0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 06:22:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E52F9DYKa7cHWqMpDJf6fsyeHntzqoDglrFwuJaSKMPFntbMugj5kD/YD/afXL0QOdBYsloxs1GeZWUJdz4MS9UQpm8NJGCPUpjM1Xa8fUUQpG0BiiEEyeXZjuvZeF6++MyCiK+cBFx1l0ie7KTxkvxwxuVmIZZVXG4/aZeqsvIhsbPndEM0gC96Ek37P/xXC96zU6yg1B6xEMEMqhIx5Bw9iqWVOINfAaUGUIf7t0bjOIoG3dOjcFGoSQzdVaxK1nqdNfIL5J6y4eyYhrS+x7SM27iwdBYTz5C0tRZNFqhhj6uEOVZABeKyULj755EY13UO2NVefQGUEjJaZzAH2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXKUeZZKXvWN8rKWBg8bD559iWW5EH/3TArX+DIbuec=;
 b=MHEtH0v1Sk+FvaDS+e+4e/QxzNK+cPPtGMrJDjG8TBmMUi6OPdZacadwJ674F8M4csQynK7IJibZlKyFolG7euzY9Q3Fw8P+sTyicdaxsBCwRfRrHlQMm6/WPeRIryLNzhV9FE6QDPc51PQT9e2o6f2VG7u7q1E/+4M1MO4Y8/q6JIgGD2n6E1M66GzR54mqUguIrQtsHDD8ztEAiRGb32WhAbSKzyyShiwOetFpLBd0jDccdPLrTN+BES36+7q+gP4gEA/BKxpFjOIOthP58kik9PFIELoNdhRtwBZE+cZfiRS77etYy5tQVGOMDPt6jSlLZ7WcnlcpIHh8eZNxgw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXKUeZZKXvWN8rKWBg8bD559iWW5EH/3TArX+DIbuec=;
 b=uqU1n2xrvkYYeo6ubPfIjOhrOF2TnQBAuyiPf0Mu0cKAUyM+n/1pZnjt8vRwEFJ3WMkWUXmSdBPQGySWUofLtLdqmny9ZLOKViyUVSIOu1I6exyXV4nKKwb+QQ5DCYYzJ91BQJKx2k2fV/YMqmhg6dfje3L/oAcNlP/G3IZbwqL8becekpThOQZiuk7tquY16atcUTviTfUyGbBXnpUb+Y6mnnBCa2VvugjnSgLjydM+zmqG7Ty1WvXx9Xgij9hnDaS5xxOHLngNt39Uwmk4gt46fJWpUZ3UPH1YoZP9mmlu47REMjuXCp0NcMp/UTrY4t+GdXEDlWkmjp8B7ooaZA==
Date: Thu, 4 May 2023 14:21:36 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230504062136.3d5x77fsms5kx6cs@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199021)(44832011)(8676002)(5660300002)(478600001)(38100700002)(8936002)(86362001)(6512007)(6506007)(1076003)(26005)(9686003)(6666004)(6916009)(66476007)(66556008)(66946007)(6486002)(4326008)(83380400001)(316002)(2906002)(186003)(53546011)(41300700001)(33716001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 06:21:43.7621 (UTC)
X-Source-IP: 40.107.8.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10699
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 clxscore=180 suspectscore=0 adultscore=0 priorityscore=162 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040053 domainage_hfrom=9718
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
X-ClientProxiedBy: SG2PR01CA0145.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::25) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM8PR04MB7427:EE_
X-MS-Office365-Filtering-Correlation-Id: 876526f8-9103-48cb-0d34-08db4c67d49d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 x1AHNy7qb0oGdJEJCeAbl07FC4AFZ4iHBZ2Ssx3/UyykaeYOJxCTtMSlT8ZgKR6GjNuFy4wecc3QiSrbtXKVC/+qLbUjUxkDvR3t1C7WMYncRQQMA1RV1dG9iQsEhdj1Yw+7aKu1P4iOqiUH/JHQT7QFjF1u3CIVyf9M2m2j8o3/FpWhD+Rn+HtwF7VEwwA/60MhsaTyglb7BVlLPGXu/6t784VBrIobX8osH2JmkrrFXxBySoYoGvA7cFGGDFeq/pMPeNcWHwOtNSANYAEV3PAoxGa9j8OkhS9C6pqVOzN81kQwR3BDY9N3raUfpsYPCVoXdvIC5c52GhPmo50YUkke0B9tkFe7C2jeO58E2o5vGxKvlv1WwJnMhDYmThbEn/RZnzowa9bytMY0aUd7CEScwhGIzS1xClkFt913r8p02bdPsdKVm9vNmMuWPft+LLtGP7axgWpUEQDgQcS0YtSGWwt+B1C9wAiZ3FPr20CusmBLZitDhgmPnmCrlfyteKocaKToc471y8T8PNcG+s3YJWNJZ3TQLaCWr1wNwSU/zsA+V9cqtaztANuAW9Rz
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?k2Y+vEMtlKkkGb6wV9T1vaycwmva7x+WL+3Bmu9xT9GDBf7pV66EHhFmB0bN?=
 =?us-ascii?Q?O0f6WwfEvcieVBskiIJBFEc8tfIbUue/0pS//E8EMlJV2ZomMBhPyO6qTOvW?=
 =?us-ascii?Q?4Ufo+ldMGMnq/w9ihW8GcYtvfHupfMiNB2TqLJsxomUJtXcQ7kg7zkfOimri?=
 =?us-ascii?Q?GouIrztWqeJhE0jR1oxpuLq/6u+fO9DQGjIeq89kvjYYV1z5n76dBGjB3Ulq?=
 =?us-ascii?Q?dgaEdWgMSQFh8iJTEl5ZmsQyed/QGnxXwYad5TvFbQj3oT+ncFxMJfjCxW0k?=
 =?us-ascii?Q?VpzkkdUkgik85lKD2SoNqlCnbulEvt3UbYs+kGBNfFZVhuj/+9OOrZYhX3mv?=
 =?us-ascii?Q?b4kDEZS5GmU7OrqgYi4Y+pB3hAvs+RmHX3yrF/4d0Y+LB+LOtRRA/M0W5WH/?=
 =?us-ascii?Q?GY/4RD2/tQ7cD6R+0cFQnTz6yIKo0b0yd2i6kFwfHJNMSYnVYQ5bCZq4GST0?=
 =?us-ascii?Q?u4RCOV5Dmnz9kxAYlzg2Txfl8mhTP9C4NM+rK0+B7i3bnKsUGp9FCavaikcN?=
 =?us-ascii?Q?2o6N8QBTq7CBBzgSI7FXGGAUjIj8vFPotLFK43wSeb7ubQ14MHMyzYLkVwGC?=
 =?us-ascii?Q?oIlhJ/BR4j8kmH4hFhT7fh/fTAFsj5P2qVVXs9vM3CTwa6n0+UGUw1mi0MBZ?=
 =?us-ascii?Q?bWyhlqT65e/xshJGWvvvh/javAAWQ3ySd+ftwoq1Xv9ws3fp03cfA2BCx5gl?=
 =?us-ascii?Q?IiAmANA/15TVQJGQswx6Rny52iCXNVNSfZ27NPA/QwSh/FrjIEbVLNzu0X09?=
 =?us-ascii?Q?rHIlehCLKSv27BWcrdAHAXPasbDBEO7fljAq351dPdtACL6IZxCO900KhAaU?=
 =?us-ascii?Q?8oVn7TDT1vQxgR7vFLh+vBffmrAIi+201QDJdU7A0rXEQku3iNxUdroY56qX?=
 =?us-ascii?Q?7sqYsWbSAAIMQ27ON65osewBQVVop5rCDEYu8EfO+K87U+/Wi6pQrTJDS0ZK?=
 =?us-ascii?Q?RG8ctfcI6sCjWVG81v8J4IycH3LwxDvblLky+DtSAxcrDTUm7kUE1HDoIpgf?=
 =?us-ascii?Q?netIcvJ+cDybGzBCgq8zGqy1HV40fdnggGuXuTrVOzUeTpdIOEC8kyxctP0D?=
 =?us-ascii?Q?NjKkOM4BVhiw1wbIOUJcsaFaAszGuwI/cMqGRXkMZNScQOv1fTvGbGp+Dlvz?=
 =?us-ascii?Q?mVff1GEdPb/mOIyZH7XRVQFgYBjv+DceBt6JcvGhGyZvRj3WWUNklZocl18Y?=
 =?us-ascii?Q?EU1CSPycMqw0o9ka4GhQzqeJCrHt9orT2zetNxaYNdfrqazDDp9houO/7FqH?=
 =?us-ascii?Q?GYU1gj9LEsD/qWiUOXCvm5O5QHDQunp5pZnmDMuip6UWbW/XavYVWj0atsh1?=
 =?us-ascii?Q?06LA1WKNBUBzgaTt+sNXBcoSZOHOMAjehoX6SBQwSjSWrYcp/DnTxAwKzs3x?=
 =?us-ascii?Q?gpeEA7Qgz6F7Y4sQIbygnkTZ/WhOZ3olHK28VOrAD5WIDcbTrBUx4ZC5CH87?=
 =?us-ascii?Q?cgXU3kkKwibvrBMCillwRHaQsk8C8S2Fzk2ULtEH8wtW8yK7EfpyO5Mtmf0G?=
 =?us-ascii?Q?RqnY4s9KaTvLGHq+pBZG6Zwim8k+DJi3CDZ76AjleDmq+Fw/Mi1ipgy760u0?=
 =?us-ascii?Q?4qJt2MmOwsbY5iXn73/pM2ZjC+bPqAUx0MWyqE0A?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 876526f8-9103-48cb-0d34-08db4c67d49d
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 PNpSibkEX8bmcvg7I/6J9pDFmtpLHylgXZl9GmWldqzxt36cmk/vJdW3MKZhfzy65ul3bJP2BWqJO8lzS4bE+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7427
X-ServerName: mail-vi1eur04on2043.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: CvuwX3HDpX0Wl7SXnkYRy554_je0WHy5
X-Proofpoint-ORIG-GUID: CvuwX3HDpX0Wl7SXnkYRy554_je0WHy5
Reporting-Meta:
 AAESAMhebo21mHmdWIDiI/k6+KEpnwsbO8BNSRO8D1dCBlpf9AkT8hW9ti8nqsee
 8W/pWgL+39mp17SvmtJjxjmz7jvNYJt4TB1LdBRuGmJjliPvCGWkGinY5RYdjDMd
 qbIjA8FyWll5rnWL5V69ILaU7TlqMa+4ZS24FMrJJ1O3uSeGxTkjNr8cANoGIS5r
 5lumLCkW+4FEr6FrFzUkl96bNsiaV6bcxXK5buYM3vEArn2XnmXvua1czABxF2va
 BHAIkjGxYKpzMCo9OHah+FUMwSqPQKqh2s1uGJLN2AtVVG4A6uyCm7k5zihYS1+4
 4m38ET9oViIkTjZb5DW6OMQS3IECgc6qe36vxYhBtPtAjZdYKVHZ3I/Q/BSmbsrW
 3MwZ9BT03rw/5KPbzTExmSHT/NochG7RQBx1b99W0Ox5mnJq900k7keNFOoXhgaL
 LfUCVA443pUj90QYJrwLBWed7+PGKl5aIm3vM2Dp4iMwBGoMdvBl5ejxR3t1PH2m
 CX/7bDNLCzoJgWsJ10WK433ICw4n1gyb9AeY0ZGtDFk=

On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
> 
> 
> On 4/30/23 11:13 AM, Heming Zhao wrote:
> > fstest generic cases 347 361 628 629 trigger a same issue:
> > When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> > journal.
> 
> What's the end user impact?

There are two impacts:

1. this issue makes unmount command hanging.

No one likes or accepts filesystem unmount failure when underlying devices meets
error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
successfully.

2. for developers to verify their patch doesn't make any regression.

fstest is a famious & important fs testsuite.
(Yes, I know ocfs2 has itself testsuite ocfs2_test.)

Current status, there are many test cases (about 9 in my env) cause fstest
hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
gfs2 only has 1 hanging case.

In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
testsuite. Long-term target is to make ocfs2 to pass all the testsuite.

On kernel 6.2.9-1, the fstest 'quick' test group result:
(the result based on my two patches [1/2] & [2/2])
```
./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648

Failures: generic/003 generic/013 generic/015 generic/040 generic/041
generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
generic/636 generic/702
Failed 49 of 568 tests
```

> 
> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
> filesystem. And we should not commit any further transactions.
> It seems that we may unify the behavior like:
> 
> if (is_journal_aborted(journal))
> 	return -EROFS;
> 
> 
IIUC, do you mean add above code in ocfs2_commit_cache or in
ocfs2_commit_thread?
1>
If in ocfs2_commit_cache, this fix doesn't take any effect for unmount
failure(hanging).
When return -EROFS, the caller ocfs2_commit_thread just print error message and
keep going to retry.
2>
If in ocfs2_commit_thread, it makes commit thread exit/stop without notifying
other ocfs2 paths. Later wake_up(&osb->checkpoint_event) won't take effect,
ocfs2 will enter chaose. 

In my view, there is missing a place to set fs RO. So [2/2] in
ocfs2_commit_cache, uses ocfs2_error to mark RO before returning status (<0
value). The ocfs2_error is the right place to mark RO.

- Heming

> > 
> > This commit gives ocfs2 ability to handle jbd2 ABORT case.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/alloc.c      | 10 ++++++----
> >  fs/ocfs2/journal.c    |  5 +++++
> >  fs/ocfs2/localalloc.c |  3 +++
> >  3 files changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> > index 51c93929a146..d90961a1c433 100644
> > --- a/fs/ocfs2/alloc.c
> > +++ b/fs/ocfs2/alloc.c
> > @@ -6308,11 +6308,13 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
> >  
> >  	if (tl_inode) {
> >  		cancel_delayed_work(&osb->osb_truncate_log_wq);
> > -		flush_workqueue(osb->ocfs2_wq);
> > +		if (!is_journal_aborted(osb->journal->j_journal)) {
> > +			flush_workqueue(osb->ocfs2_wq);
> >  
> > -		status = ocfs2_flush_truncate_log(osb);
> > -		if (status < 0)
> > -			mlog_errno(status);
> > +			status = ocfs2_flush_truncate_log(osb);
> > +			if (status < 0)
> > +				mlog_errno(status);
> > +		}
> >  
> >  		brelse(osb->osb_tl_bh);
> >  		iput(osb->osb_tl_inode);
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 25d8072ccfce..2798067a2f66 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -312,11 +312,16 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
> >  	status = jbd2_journal_flush(journal->j_journal, 0);
> >  	jbd2_journal_unlock_updates(journal->j_journal);
> >  	if (status < 0) {
> > +		if (is_journal_aborted(journal->j_journal)) {
> > +			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
> > +			goto reset;
> > +		}
> >  		up_write(&journal->j_trans_barrier);
> >  		mlog_errno(status);
> >  		goto finally;
> >  	}
> >  
> > +reset:
> >  	ocfs2_inc_trans_id(journal);
> >  
> >  	flushed = atomic_read(&journal->j_num_trans);
> > diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> > index c4426d12a2ad..e2e3400717b0 100644
> > --- a/fs/ocfs2/localalloc.c
> > +++ b/fs/ocfs2/localalloc.c
> > @@ -378,6 +378,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
> >  	if (osb->ocfs2_wq)
> >  		flush_workqueue(osb->ocfs2_wq);
> >  
> > +	if (is_journal_aborted(osb->journal->j_journal))
> > +		goto out;
> > +
> >  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
> >  		goto out;
> >  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
