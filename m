Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C803C43216
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:57:21 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 474DF61131
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 474DF61131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KDmLnS026944;
	Fri, 20 Aug 2021 13:57:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahs40jhgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 13:57:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KDlCVO068106;
	Fri, 20 Aug 2021 13:57:17 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm1ry5d-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 13:57:17 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH51I-0003sv-F0; Fri, 20 Aug 2021 06:57:16 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jlayton@kernel.org>) id 1mH51F-0003sC-Kz
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 06:57:13 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KDlAO0073706
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:57:13 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vnk8bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:57:13 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KDm2i5016213
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:57:12 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahvfvc173-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:57:12 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8368610E6;
	Fri, 20 Aug 2021 13:57:08 +0000 (UTC)
From: Jeff Layton <jlayton@kernel.org>
To: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Aug 2021 09:57:05 -0400
Message-Id: <20210820135707.171001-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=733 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200078
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, linux-doc@vger.kernel.org,
        david@redhat.com, w@1wt.eu, cluster-devel@redhat.com,
        linux-mm@kvack.org, rostedt@goodmis.org, viro@zeniv.linux.org.uk,
        luto@kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com,
        ebiederm@xmission.com
Subject: [Ocfs2-devel] [PATCH v2 0/2] fs: remove support for mandatory
	locking
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200078
X-Proofpoint-GUID: xbJek94VInwg1Z4n3tT39FSmnwirGDzh
X-Proofpoint-ORIG-GUID: xbJek94VInwg1Z4n3tT39FSmnwirGDzh

The first patch in this series adds a new warning that should pop on
kernels have mandatory locking enabled when someone mounts a filesystem
with -o mand. The second patch removes support for mandatory locking
altogether.

What I think we probably want to do is apply the first to v5.14 before
it ships and allow the new warning to trickle out into stable kernels.
Then we can merge the second patch in v5.15 to go ahead and remove it.

Sound like a plan?

Jeff Layton (2):
  fs: warn about impending deprecation of mandatory locks
  fs: remove mandatory file locking support

 .../filesystems/mandatory-locking.rst         | 188 ------------------
 fs/9p/vfs_file.c                              |  12 --
 fs/Kconfig                                    |  10 -
 fs/afs/flock.c                                |   4 -
 fs/ceph/locks.c                               |   3 -
 fs/gfs2/file.c                                |   3 -
 fs/locks.c                                    | 116 +----------
 fs/namei.c                                    |   4 +-
 fs/namespace.c                                |  31 +--
 fs/nfs/file.c                                 |   4 -
 fs/nfsd/nfs4state.c                           |  13 --
 fs/nfsd/vfs.c                                 |  15 --
 fs/ocfs2/locks.c                              |   4 -
 fs/open.c                                     |   8 +-
 fs/read_write.c                               |   7 -
 fs/remap_range.c                              |  10 -
 include/linux/fs.h                            |  84 --------
 mm/mmap.c                                     |   6 -
 mm/nommu.c                                    |   3 -
 19 files changed, 20 insertions(+), 505 deletions(-)
 delete mode 100644 Documentation/filesystems/mandatory-locking.rst

-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
