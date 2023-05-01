Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A331C77B73
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 02:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sNKDMHnvYO2++vsHCS3Q8+9B+SlhszZ+gXnQgBY2EE8=;
 b=ZIF7VG0y/x20OG9W6+zBWAwRN9utTJ/c1p31+MICdgEeJIc5T4vwf625fwAEJllZOtkvpfEdtlI+
   bAgWQ6YGaHHmZiO8xtNZKaiVLVEjSxCcLWkt+FvYWYR5DbNqAS6WW4xhFDIMxSAJcdOoBme+hJ1X
   dUXLkCX1BsWmlj7AZMMJJ2gJHpeUrrtvi/0UeWh+l8qcR2+i2/QnQ096mnLtQ02tr0v2mMz+u039
   qLNTDVUaDwONfYpiesq4HeQvCardGKB8d67Ifcm5n9j14S9xZTTFzAwougO5SN7K6Re0BxI2iq1J
   Id2rI+aAF26VZ5PLF/arj5pnenSfNkkgwIpGVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sNKDMHnvYO2++vsHCS3Q8+9B+SlhszZ+gXnQgBY2EE8=;
 b=gDEzrFT2YeMPVmwuyANOzEQ+9JwK4PGlSeiA87IqVjv+g4XbLqjO80DyjVj+Ph0RPGPwDY0ueNPP
   LMPmZCUpJpzLjAzRw9yHmVRfTWnFpUjv8SUxM1vIgyLPqukSocmEyoERwj5kzBoJHWDuV5cq6u5X
   ExKwpt5q1y68uPZhzyvXTWDdyn+HsmX7lXfaLTtPXBX5b9aeLbH6Bk78BMA3i4FApmOPBsr+XQzE
   /1WdTeKH9AA9odWKyHRKgd+GnBtXUddrpRL0o4Euhbb0gfEUg7bCv7uRFOW+Df6xTI6m8WiR9nLI
   DsrX3z+fEmUKjmPypebi6ZrFNWNTZ48A8i7pwA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY005WHL60EI80@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 02:49:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRMNbIYymrO1gietpXHNOvD6WpOIv7hJspyhRoNlErPd1fuSUN+n50Rwchkex7MMRant9szuQpmxId3Wcm4fnxMOvYJjrtTiyWlnciOtrFQto6aVfacU8uYiDV6FjHyUOmYjWIF4c3rgPClhEMsoV9X5HFziZuCNgfGbmlBa8/WQ1p9yCXUnUdHu38h6CTcowCZzPuEjhANUNFH53/KdKbKupRNh8c7KghXjZiwUgkMyDRt41DAe/2l7DV4m6e7phcTh5KpM3TIH+ONOq6QbYMkDisLENQ7wtpDiVVooISqv/UzNKO7kZ0XT9GnQhPBIWVVMH6Yzw3xGN9EvkGkHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feePQFY1RckRwKevDsjgyoHABH6HDx5nEmk0QARNmtA=;
 b=h/Doq14KBCNh/MzbGFW3FzPZc1wjbnaKokzsWjMjK0Y8w3YeBW7JN0Y6bJXlrVmxLQYQCTsoqRVtT7rAEsTExdDdHBw8hMXCfEfhPrkdm0nspZcxI/Jw4j6wNtXLa6d7f9FiB9RKnsoliG33+R98O4koI/1JF1FhY/oqcCfvCm6/lshw6pi2wN+gpl2jcfQ+uQuEjIi32BsSHF0wr3DO0XAMirgZcEB66tvhfLo2EwGMV1ym4CkrxgrlcgJ31+fKob1b4F+NVFKUyNsFSyCBfa2RjCYsiZyASsVkOy9Yt8CKCVIt3MPRjb5zgBtpDyh0QNF7NbXsWXxTunR1I9V37w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feePQFY1RckRwKevDsjgyoHABH6HDx5nEmk0QARNmtA=;
 b=PX+pRnvtRlLGw0VfDhE5Sx2JlIENcsJiskaLxKACA9Rgb61+RMPBwANYaAohzKPNqy5hfcRA9pTPPg4XHmJyEXqxtuonvagBxyR9sfyIlPHZkEFNQjvCEAPMIEbCBwHXNNrY7DnEyO/TGZtDdbgKF0LJ9AN0kAUEJK9EiNagZovDaf+6V5i6Sxjr6HOOZlRhIwdE0wwpFHn2CST2gKkzAIJ5Ww99VdOPIqP2C0sEqzF8d3xqJWyGIcyvwgpFJ29pXpiBcr8wsdNQuekhpo83qe2umLcmF0PCqT02IKUvhqNwO7VrBT1wZ45mxsPuG/UYNWh7nT2A2q6blAxRC0RbUg==
Date: Mon, 1 May 2023 10:48:49 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501024849.hqfubehatdgomhc7@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(366004)(39850400004)(136003)(346002)(376002)(396003)(451199021)(2906002)(478600001)(41300700001)(316002)(4326008)(6916009)(66946007)(66556008)(66476007)(5660300002)(44832011)(8936002)(8676002)(33716001)(38100700002)(53546011)(9686003)(6512007)(6506007)(83380400001)(86362001)(6486002)(6666004)(1076003)(26005)(186003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 02:48:55.7353 (UTC)
X-Source-IP: 40.107.22.65
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 bulkscore=0 adultscore=0 spamscore=0 clxscore=179 malwarescore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010021 domainage_hfrom=9715
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
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
X-ClientProxiedBy: SG2PR03CA0094.apcprd03.prod.outlook.com (2603:1096:4:7c::22)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DU2PR04MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 662d8f1c-8723-4daa-8d9f-08db49ee9b1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 DvQbdIxLlHMUK8IoBSrT5hx15zA5/NStJc8Yhl55oPNFzBVcJAFpXFHK9QZpVP7+Sm8Rd2zZduhhqWBJMuhE6wX8Ymi9EDcKMNrLM+MX5/Au2IWckOqH7Mzu42zd+DtmQtj2xnpQR/ifnE+Q6iV2JI8nyLuVFaFftJEIPqysF5dCvOt8MugSizD2eY0n5nI+VkHtbnpmTRGVgOsP6ZUMhBHgdgmNU+agIN5iaSYakCTtVgTlbefPFirBhONI4OKfzZHFt7YTc+y02jBEUWG6ECyjvPn3+7NG6D4vF9FT6n+BRZ0HEUoQdrGVEyLVGxcJGu06Uk1wMeYNOglm4EVHFYGl310smQ6utMUwfsFJECb4J/L6gtz2G5LsHvNyg24c/KDhy/gNQXjBmJzKeKEr/B5Y46DITZBIh411up/ORl4eOaweO/vX/5GVapyhrmYoyZ2v5hgJT3umdv77RGSXTma00UZz6UtENvfzUU4l4Soe2+97BGidrrIp/3tWmGI4tXb8YTCJBASf65z+qtk+Aj8rBkmQ8ANNtsw/rdxrHcyiHk0Q3VnwpmF7bH+SbanJ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pB+DQgHVjkZlOT5ZkM9WRmAkmHv2ZRUcPVPBT8CtCWQI1+JBoY5NK03TN0u4?=
 =?us-ascii?Q?zoE/lxYWsH9IoOhXtBGFCbSVNFSvlh1XXxV+L1V3H6DZ5OQrZ67oeutBrINa?=
 =?us-ascii?Q?Dk3Q4gFaGQaiB2bsnk1PsHa9A6xhhAbh3gsNPg01zPBoOHy9+CgGIvosquuZ?=
 =?us-ascii?Q?0gW1pVqgQpYfN7yDdqBWZDezJxMnBybfmkcNq0YFf90I4YtLq51MbbrvHIM3?=
 =?us-ascii?Q?B9sJwVNIrhvnsgYZZqiAgaJ9+JHpp7uGjB3DLmGkivs5bruRhlI+iaehtwmw?=
 =?us-ascii?Q?av1eYlfySW+OQGWgUygcHXiolD6FauMBa2qN5eJoOM6POSN2XkzIQHShD8oW?=
 =?us-ascii?Q?7zhL/LPjlpHYL2gOpYxgvqzRXgEig2jYQjmtvkEm0glBTdEg/+994CCwLJzU?=
 =?us-ascii?Q?Kx6KGuqci/8IagIohFTXnEwSyl2yS1vqP47O5Uh9mEMUjAGaF6skl77xyW48?=
 =?us-ascii?Q?udxmMrS89yi3FqGmGc87c+QYyi1wtJQr/tKxePlyiWMXmoYd49wCMRffnKCY?=
 =?us-ascii?Q?aGdr3v2/qYqXmVkZTwsFX+AVIKZYG0Smt/0x3tJsAK7nIwaJTbZIz8j7R48g?=
 =?us-ascii?Q?/lx9KK1nRR8nXEM4eETtsaIPMAqGEMm+E1Ykg3kjM7mjC2jkWtgBDnWH0bA/?=
 =?us-ascii?Q?EKRZi5WgswijTT0EuUuAJFVzA9xbG1wn4p2QT5h/qg7UNKCwJ4AkNr6l/h23?=
 =?us-ascii?Q?f4vdSZJ9ycWJ+K2B8ZeN8T/dpL+YSVxlR0GWS3rLRh02ltFGbZnfCotvNlm5?=
 =?us-ascii?Q?0jDIMxv8MgULuV/MxNpRforJBgai/fW13gUPyivBT4lyWJlvQF4nY0wA2QLP?=
 =?us-ascii?Q?WZyluh16khTQWMzpsim0T3UBiyLcMYMkT4ChtMA1jIcwoCJkn12RjyqTvv91?=
 =?us-ascii?Q?coUhshpffyW3MwFU+FRYpO99X7AVCfwUYUcAQetv6wo0CVb/nf8x1ljm6lE+?=
 =?us-ascii?Q?/T5bEl+8ARkVAudZ8geFWoBD0iKJkKmTZDj4qE3VesFwYSgVNk+UVylEMEIp?=
 =?us-ascii?Q?xjW/32KZhatpG8l1I4VkAihA6/CAuZ00ognjIHClH4k9LXdJoR7rlX33/UEr?=
 =?us-ascii?Q?e/hSMccmyYeANSny+B98bQmj2hmy1SORJuBRfoEGuL5n0EvegQd48a9e73Fa?=
 =?us-ascii?Q?kAUduf2sm5MCAsZjXZNPOrpXUOhd0Ybmcb5afzB3cRNE5JpZUOSt4kYK4LY7?=
 =?us-ascii?Q?qnZ0zdTgL56R870+l0c91t/ucPFZP+rHIDRcmQ2Bef/TGu5XySNExe+09UWW?=
 =?us-ascii?Q?QksZme/zziBik5hDFFdcEbMMyqMtLr2UISdLf32vIPXvf4yKpKYkYqNIGWRV?=
 =?us-ascii?Q?5v+L3DoRmm25f+frMYxZT+bgy2GUtdCWQFdwS6UBu8dqE0Jq4y00/u/x0+d+?=
 =?us-ascii?Q?BTR+VGu/KCVrtnxb3gxf9l7LyraYPnIPydR/qa01deJZwi3WS95LcWaIUaYj?=
 =?us-ascii?Q?Rd6FomPoBVLi6V7Bg09kFVja1R5blsp7AeE1vYnbi2h0q4DgWUPUMDlwTEVl?=
 =?us-ascii?Q?2L4cAuzeCQ1icU05drD8HnkFmGRqLddz2Wxion1Xm8HhL75azUrshBNKYY3y?=
 =?us-ascii?Q?mvHFk6aLT4luS23zq03wwlj/zkr9M4dw7RlKZxC9?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 662d8f1c-8723-4daa-8d9f-08db49ee9b1c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 BDaUhoV9fnctqMScc1+sufHiotU8EzNb1Slc2qaPUPxXGmEUS2dQF4kSMt4F6yIDk/50C5mWtPVsPkyE5VxaZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9194
X-ServerName: mail-am6eur05on2065.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: t5ne6CXhQKCpom_CGDrwcL66yqIHahKg
X-Proofpoint-ORIG-GUID: t5ne6CXhQKCpom_CGDrwcL66yqIHahKg
Reporting-Meta:
 AAHKkXffIxKEpexYJdFduxkwX+HTVRhBqTLPhZOy0fthHW77wvAFc3PF2qyMzfRt
 tkwDnMT8QKJKzEtxF1FemKdGrAhl/s5UkX9KbcOfmpGGXBXO0rF+2FkYOnxbAjUq
 XbJR/lVb6NT3WbTUTiqDFg2vwBTNEWRw9No93Q80OIJz7J6n5CQCt5+CHAv/wfhR
 VjM9VntW8tqVtrC9aYoQVRhTdNl5Iw2tU9+KbPnHVMMjQ0MnjuIaeSmGw5MphekM
 EJHUCH8kllWH7NiRY+Mlngt4607GlUOs+UThgpyRfLMkMDfnrate2IDb5C3mSKWV
 ERxWjljoEa/hi4Wmaoj0Rex5Q4JprbM1TXoDAr6xnEKDih6glbpLcE73WKgCXWVZ
 f9pQ378ZWTp5Vqv0fdpLqTpbgRiiLZI+Rtuf99No2TsPwHf9YukTbZNDutJv/8KN
 cUEfr+i+46ny72lSrTTERtDI52lZj/YT6gKuTh4+H42/rphP0udSzgK1279plQvR
 wJSN2zi2GUUlVC0dLkEB8XKCvpQsnqQUwM1BuM7XakwdsQ==

On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> Hi,
> 
> What's the journal status in this case?
> I wonder why commit thread is not working, which should flush journal
> and reset j_num_trans during commit cache.

This rootcasue of NO. 266 is that ocfs2_sync_fs bypasses commit thread and
directly calls jbd2 APIs to commit journal. This code design makes 'sync'
doesn't reset ->j_num_trans. So my patch add the kick commit thread action
in sync path.

Thanks,
Heming

> 
> 
> On 4/30/23 11:13 AM, Heming Zhao wrote:
> > fstest generic cases 266 272 281 trigger hanging issue when umount.
> > 
> > I use 266 to describe the root cause.
> > 
> > ```
> >  49 _dmerror_unmount
> >  50 _dmerror_mount
> >  51
> >  52 echo "Compare files"
> >  53 md5sum $testdir/file1 | _filter_scratch
> >  54 md5sum $testdir/file2 | _filter_scratch
> >  55
> >  56 echo "CoW and unmount"
> >  57 sync
> >  58 _dmerror_load_error_table
> >  59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
> >  60     -c "fdatasync" $testdir/file2 2>&1)
> >  61 echo $urk >> $seqres.full
> >  62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
> >  63
> >  64 echo "Clean up the mess"
> >  65 _dmerror_unmount
> > ```
> > 
> > After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
> > verify target file. Line 57 run 'sync' before line 58 changes the dm
> > target from dm-linear to dm-error. This case is hanging at line 65.
> > 
> > The md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
> > do journal job. But there is only ->j_num_trans+1 in ocfs2_start_trans,
> > the ocfs2_commit_trans doesn't do reduction operation, 'sync' neither.
> > finally no function reset ->j_num_trans until umount is triggered.
> > 
> > call flow:
> > ```
> > [md5sum] //line 53 54
> >  vfs_read
> >   ocfs2_file_read_iter
> >    ocfs2_inode_lock_atime
> >     ocfs2_update_inode_atime
> >      + ocfs2_start_trans //atomic_inc j_num_trans
> >      + ...
> >      + ocfs2_commit_trans//no modify j_num_trans
> > 
> > sync //line 57. no modify j_num_trans
> > 
> > _dmerror_load_error_table //all write will return error after this line
> > 
> > _dmerror_unmount //found j_num_trans is not zero, run commit thread
> >                //but the underlying dev is dm-error, journaling IO
> >                //failed all the time and keep going to retry.
> > ```
> > 
> > *** How to fix ***
> > 
> > kick commit thread in sync path, which can reset j_num_trans to 0.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/super.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 0b0e6a132101..bb3fa21e9b47 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -412,6 +412,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
> >  			jbd2_log_wait_commit(osb->journal->j_journal,
> >  					     target);
> >  	}
> > +	/* kick commit thread to reset journal->j_num_trans */
> > +	if (atomic_read(&(osb->journal->j_num_trans)))
> > +		wake_up(&osb->checkpoint_event);
> >  	return 0;
> >  }
> >  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
