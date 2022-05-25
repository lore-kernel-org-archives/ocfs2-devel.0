Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BB3C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 25 May 2022 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w7lcdpBeSQyRsFDiubd7OCDjuHKvCPmCdaC/fDemGs0=;
 b=nlqGtJbxmkBmS4gW8wShEk7U4/tGYkjXxudu/6JTJu9M4h49yqVuTjtsNJbs/goCEDZPc79rHA1v
   AEzZh9vwLXRyv8kPZE9jSN1ZLt2ts6F+VOdZUoitlIAT/0lP3V3ur/ZSllWVCruDvaQ5w1J7Bvsn
   qfWyj0tpzh9hT9OcddXd6AwwUWnktwMMpX2gI8CNvMdeR16bV3ll+VQWsfXh1KH7S9eix5QmXb/X
   HdMSBrKBKM/TEeABOyACyUlD8dFCkc35XHgCxhRFt1obMOzGJNFfo21bWuuwAU3VdJwcSfSmG2Py
   1vTxiQZSXpOJ5DKnSx3jqpAMIRtYLbso10uwxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w7lcdpBeSQyRsFDiubd7OCDjuHKvCPmCdaC/fDemGs0=;
 b=Rocp+FG/FEO8eOshMTEg/GaewoPG8+/tNW7tkxuqMF/qmhQkgL5kXL06hTIXRf2w5hUuLm7o/Jku
   4x1BTUXoRGEep4fnyQkRN4J0cW19OIveYlK7a54SHKGV3sQ4gt1j4YfD9zVDVmcSWNNV94J1JbkV
   gL6VNcSIlfGnQA8/acQ98o5PJv8nTR52atPewOpPnTEHI45qOCq+/zVa5ir/e+HCJx28RR++KSTE
   4RRMMOxsoQNVy9GjakBonORv/egJAaA3GuVrBFTJMO5cEsRHOn6VCa34zCnJiiqpEfEkD278qhdQ
   X9xpK0Gk+jdFyqgpvpbFWhoA4P82QS8VQJhZ3g==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RCG000O1FW2FS60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 25 May 2022 20:07:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1653509216; bh=ztjgle/K2/xhmqi/bvfch9LMKnwhiff0BhsWg4UUmZ8=;
 h=Date:To:From:Subject:From;
 b=bWTZB3ugNZ54IhmjsW7IArYwLga4YR7eahuxFk06fM9H60Jzj20MKZzSN3bItmTzE
 R98JhvXJzs94egAZzBK/L1t7ihtw9Llo/EYWCzra48VJ+iRbzuskzP1zBDKXc7AMTX
 5jqZfsAV2MNzBZGzewfUScNn2iFR2c2qS0g7UPHU=
Date: Wed, 25 May 2022 13:06:55 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
 akpm@linux-foundation.org
Message-id: <20220525200656.96B36C385B8@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10358
 signatures=594197
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=142
 adultscore=0 priorityscore=70 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250095
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch	removed from
 -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: t3P657vpQZvF5Fk3AHSiA_I7tFb9MaG-
X-Proofpoint-ORIG-GUID: t3P657vpQZvF5Fk3AHSiA_I7tFb9MaG-
Reporting-Meta:
 AAHslhfAvPmZNMmFCNarvD+Ouzkf6cbd4UmtNaAcYNpH+i4paVY/0oik8oRE7g/u
 HDneQzPBHCrtelGa0zqVy/gfLhcLrzK+KZKbinqnAti9Vj6zhsB2wx/rASjjm36z
 slSFY+BUA/3c9Hi0JJXzIqNALbS4XH5FiEJLPmIs+FPzFNQBBjCrzPpaWwttIlmy
 Ha+wQybRpQIJu3iTgir1UG3aDT/UwAw6De8oMWO9YBXOwxM0zeeCKoN+WE/J6O8G
 8THtoR9OpUECj9MX5IXTg/VM1H//V8wYBEBAoDniHcUjqXMlCQ8RVmivYj9b4rlK
 RlYuFTY6mNQgGIdb5bxQDGSJz55whJk09FYNZTSw5P2fYy8u28WjIdZ5Yucu0rtB
 sFsHsrpfQuRXpJIGot52J7S49CDxD/sy8tfOpN7PWR5oQlQofrR1sKhOI5cvxku+
 qhPjcoNuqqqKqBIiRbZWhxJWRdjwL28R86JyfXUxxjF1jwCW9OuQ5yx1W0aM3JUP
 Uksp35i76zpyvraiFrEBNqJzjBgq9Kq0xO3Vp305+PF5


The quilt patch titled
     Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
has been removed from the -mm tree.  Its filename was
     ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Junxiao Bi <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
Date: Wed, 18 May 2022 16:52:23 -0700

The following function is the only place that checks USER_LOCK_ATTACHED. 
This flag is set when lock request is granted through user_ast() and only
the following function will clear it.

Checking of this flag here is to make sure ocfs2_dlm_unlock is not issued
if this lock is never granted.  For example, lock file is created and then
get removed, open file never happens.

Clearing the flag here is not necessary because this is the only function
that checks it, if another flow is executing user_dlm_destroy_lock(), it
will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
check USER_LOCK_ATTACHED.  Drop the clear, so we don't need take care of
it for the following error handling patch.

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

Link: https://lkml.kernel.org/r/20220518235224.87100-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/userdlm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlmfs/userdlm.c~ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock
+++ a/fs/ocfs2/dlmfs/userdlm.c
@@ -619,7 +619,6 @@ int user_dlm_destroy_lock(struct user_lo
 		goto bail;
 	}
 
-	lockres->l_flags &= ~USER_LOCK_ATTACHED;
 	lockres->l_flags |= USER_LOCK_BUSY;
 	spin_unlock(&lockres->l_lock);
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
