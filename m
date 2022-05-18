Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4988DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 May 2022 23:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=npebdeNxRkKzuKis0S48xlpqj1XwLnUd2OuqnH/vWfk=;
 b=UQ0Y6acnfoxBt25QLQlPjrmoNZU637Pp4USZRaffivPMhjbRXWZbSUNxHxr3IJ5/gApMamN2kNQT
   1hFSwVl7xeOmYxZDjLf+L84MeEurtS8Q4LjVTadaO0tp7VmEpgh0EokJC4Tcy5FACm1ZEDhVdrRv
   CzCvthQ+qtEY5q/3MT/IuYLL3vJhx0b21wDkAF/iNC+diKpyLoFZA5o2ZOwOlhc+uIS3fYiqaktt
   NJ2JQLtawNr3E1+KvxXTRIHg5hyMeXu5GMub6Suv+iwLrTwFUrDU4Zw+z531XSaFpIdGyeXPgwPJ
   UMtsvFZ+qeBIMJTYTbpO0DXUs5AW6QRT+Ijk1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=npebdeNxRkKzuKis0S48xlpqj1XwLnUd2OuqnH/vWfk=;
 b=TQTfp5amoHMzdvSrXZbICFg9HZtb6C+0Kij4bpXWsuWeXG7yKMa7EDsM+GIC5ckrfSMPhPL4rpQ2
   xrPCrRw3K9kAbpJHERqtYJ/zMmEiPGLd+ldAQBiPOJw6bFYXpldHRrXQSpRcOfPY06a8MKpBn82r
   rBIdbCKOjzLB5uXxTj98xtGag//W9kMOdFFrIlvBWJzZk8hL6cGJ/OOdZn4Ao2DloR8SyRyn0jsh
   PnA5dWEzU00ekDvSnIYZm+FtXBsGxW5bHGkw4KnDzAm5GtwetbpzE/SzN9+fI5UFrRv74jQd3+pw
   M0ggIUYZmOBQt0ML//IofF3bjhZWR61g1Ibprg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC3008RPRNP2OA0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 May 2022 23:52:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : content-transfer-encoding : content-type
 : mime-version; s=corp-2021-07-09;
 bh=NaJtZanqUdlJ7fa9qOEiJbz+Kjhqv/c7peGg4QvWiCI=;
 b=NFNMpo64WcKKgK1FjTuxQ1iPTwG4RDLwNg4TKzaZGjkz9NdFfS58gxlH8LFkutFpYIXi
 7Blt2oZdEvKfkDR5SP/JT6BR+WvLdy460RxTYRTR99tFAqSbFAJGd9l5xfw1ZvZSWAWJ
 mb5wsyIhCSHgYWQjQC7OdY32GDtIXtFPX/4IcyZUq4lF4p0smR50sn060siT6FKVLohR
 0PDn/HElSwhywN41KJNHplgGXMHxb2wruPmji/ktvuZU5LlVlyAvOv6czy04yfo7VeWX
 aHdfrEZP/6IIEABrFTpUkx8GOHkQaJPKLn7PGOgIa77k/5qjSDdbV3nTk0nNoOBQ5eMC 5g==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giIeiNP4K58nVHWR4mz0k7ecv5kXt6jO3cMLgfc9NPNICy8XL525kzjQ4vt/zKmkRRZF0CcJmSYgKgW1GnmucD5jRvFBP9dHUtKj1k5GLyMn9t9bU7jH2Pwtd/YFvbyIlRGf9SNatu4y5vwLci/6KxSo6hxwCTRgSnEAx8Hir8G8tab7D4jc4EPVSt1g9xbRS7w00IkUUz9IWFX7WNwW+OvW9DvUehVtX/Xj2/1As4iT6GPx4SFu3lF81ktkXvz2XfTdxt7neLjJkRPc5sSHFbtR3UZOMzFAq3OzAZZUpaVUsonzb5Aw+EoNkk0tuoz8DjLm6c15jBRp0/443cOT8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaJtZanqUdlJ7fa9qOEiJbz+Kjhqv/c7peGg4QvWiCI=;
 b=eRF+OL3JV5QMWk0KsetGZG24GhuYktCu90q1Gf+Amh6sHsZbN+hjGDCW4hEGz6KeYJiZ8iLNnq+Eg6paigRwE8NzjSIZWLMgZK7Ndvgm2HAoMP8mBC1wlRUoGxbc5DFputi397Z10XPtbT7ixNqeBhNz4BCGYQr8GPKOgfYkR/5vHiTd6/J2pcBGgGTdn6xX3SV/32R67YFHs29JcnVMYOdpkMd/hnqqH29JaqL5BXTb2ihDrcPqcB00z9TdrRmSxHRwBa3BjTh9L3gwEe69lBbi3893Ev91+YSnx4njJ6doIYRoidFw0x3W+GZ9BnG9B0YVa2SpCrEJ88Tq6Fndog==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaJtZanqUdlJ7fa9qOEiJbz+Kjhqv/c7peGg4QvWiCI=;
 b=e1SMVHbubrdJoB06J+gLOrSgtlCMxgbmhlmAvxnP+A34qEwIBXL6C160vFA95QwLZOIibmTFszfVuTd/cQhCm8nR810h3Vrn3p/scjKxeGC41qgZA4B61RwGHCZFfXEjFJd7SAs932tBwe+PhZ2JB4dIWVoNpK2QBGA8P163q3E=
To: ocfs2-devel@oss.oracle.com
Date: Wed, 18 May 2022 16:52:23 -0700
Message-id: <20220518235224.87100-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:52:26.7515 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.874 definitions=2022-05-18_06:2022-05-17, 2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=931
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180135
Subject: [Ocfs2-devel] [PATCH v2 1/2] ocfs2: dlmfs: not clear
	USER_LOCK_ATTACHED when destroy lock
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ec910a3-8f84-4a6a-8822-08da3929762d
X-MS-TrafficTypeDiagnostic: BN8PR10MB3633:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Yx/Oyx/WFwiFlJYsiNz2sCbcH7Mb9vtQAm6l0NwFrU3nqo9zKgJwZPOH1raXEDFSfZufyyhvqzi5hAnQZkIWLh87/Spjm6ey5UA7jAMCWu/d8u9jtlBd29YNQTBCrfYynhvT8ovUfLRt6sPzEt99U/i0hQt/GpYZPUl2RItoopGHjhLnJAXzE8ZTR3KRnoEnpAmFyhj/ipPQ34LbkW273lcBO3WViVViDgdJ1GRI+adIsfDx3BlRJH2sXPry1tbOmuff7xDVhIHegVAPx06oCkR0m7aYon9QZaQaH0ELms4+iBDGmMSCCFq6/vljtlmW+Rblgt1Iq1GPpLBPboLpSVYy/Nr/S07eGh3UM94Cy+4yRpeVREfrRk7pdgcmHS56/CjllYxPCHfJvI4lnc/3wL0JjvbTAljVmVK2+30Uva313630lPsQvDaq5+LgiWURWUlb5F4h6lOoSr4ktc4MGHI8chYX2xzMU29IpzvsqKYmGlmcTntnpqkxXPrLkMma7UC4PAe08SUd5K/hiCDYlNebC6qiI7YQqcxmKRMImDL6QxXm6IROwTHGN6i1/XqE/v7KD2vCZRiIsmum6dioXcHn1AE6CMiSzaTlibwDBLkeUJwZVZgCrutZTrNLzO/8g55XKAQnZuKajTydipGjkxur9L4CX1EIV8zRlKFEhpdV24eieCiZVnC9/WlK8f2M
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8ec910a3-8f84-4a6a-8822-08da3929762d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 R6qXA/IiR59lwoq9CcXQc61ljSig3R60MHejuHvp+nLw+kiv2PmpQtjQ/4Of9GcDZ2Z55tBFRXGHjMiJ48wJrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3633
X-Proofpoint-ORIG-GUID: 26Yx-63n8pbc8E6NJrqYsCr4cvIwqAK6
X-Proofpoint-GUID: 26Yx-63n8pbc8E6NJrqYsCr4cvIwqAK6
Reporting-Meta:
 AAGI+GtNTLXKVBsQQLl4sRLaMsPiSltYHKnf8XyXNWkYR0iLTXiIFKn8gKGJimmU
 AUIm8eYxMZ4qbJbC7ULc+YzOJMaKBr23DR+1in+p4IDRBIZutLhyqhmGwXppSI5z
 2OtwP+AtfVNP7G6ISh0fI96Z5d6TvP3ELvm/RJjrqQ+tUXvACYCM3U+TvneSY4BK
 ecLiNayUwpl/P4JIQLtPJJzgF/EvuSawt2brQ0n0bZaG7zav7CTnXCiGm2NGw4Ni
 m5AFHoHhiQkotB9ay8bAnTc8la54nMnZFvZAchP6MZEedoIaBwqrQKaJea7WYhUy
 58dfxhehpmMD66tgiY++6Nh6WkP2XVfZSzeTZxFc7+FWbTsV5o8x+fzdEy9pVMZn
 +cE78V4ZMbZoiKmY4uHorcWpzfzVkmYtaJcYFbDVIpZV4dpcEkSh7Zs/9kc/SPQo
 jA3WJHGeVVwRmhG+VO86xpqIDXVapB41/KquPIbzwEDsW/8JHCgOZMlo6mU+oyqL
 X1EHx3dXjSvt8Lpt5EgaUTc0YJ1XKIrpZ9Ow5oJBhS0=

The following function is the only place that check USER_LOCK_ATTACHED,
this flag is set when lock request is granted through user_ast() and
only the following function will clear it.

Checking of this flag here is to make sure ocfs2_dlm_unlock is not
issued if this lock is never granted. For example, lock file is created
and then get removed, open file never happens.

Clearing the flag here is not necessary because this is the only function
that checks it, if another flow is executing user_dlm_destroy_lock(), it
will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
check USER_LOCK_ATTACHED.
Drop the clear, so we don't need take care it for the following
error handling patch.

int user_dlm_destroy_lock(struct user_lock_res *lockres)
{
    ...

    status = 0;
    if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
        spin_unlock(&lockres->l_lock);
        goto bail;
    }

    lockres->l_flags &= ~USER_LOCK_ATTACHED;
    lockres->l_flags |= USER_LOCK_BUSY;
    spin_unlock(&lockres->l_lock);

	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
    if (status) {
        user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
        goto bail;
    }
	...
}

V1 discussion with Joseph:
https://lore.kernel.org/all/7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com/T/

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlmfs/userdlm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 29f183a15798..af0be612589c 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -619,7 +619,6 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 		goto bail;
 	}
 
-	lockres->l_flags &= ~USER_LOCK_ATTACHED;
 	lockres->l_flags |= USER_LOCK_BUSY;
 	spin_unlock(&lockres->l_lock);
 
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
