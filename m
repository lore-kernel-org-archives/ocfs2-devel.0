Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA31C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 May 2022 18:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FHDwTkjP7coLxfqquAfQpyUGXVtFUNHs8tgZQjvwDzs=;
 b=s3pIMmYBCeYk1uP9f5ZFzf8YMLkX0TUE7zh7ZKfz1PzINjCgxlVXwydBw+nRzmbJTkG4WoN5JjHx
   j/v5cF6d2D8RbBpFzLuFuMY6St2UQn2pK57f+TRtQAZJtpz1DAeXvwN3L1KbX4bG9t+bsWwLy6mE
   G7+fMMLm/HW2asKxkSpghPqGJ2pmyCfLIAAMq5Fwgf5wh3DhwvceXu1lHuwRBnfESo5lBL3W+MGn
   0S5uL0zTmghdBTSisdzvcC33JS5qQ1GHa/Aq71B8gDS+n5tI00PTqPQeylEL/jlabvI8KV8ZCSmB
   vDhzWcy7I7E33bS7zXlSg7SYsh9HelzxRiRZ3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FHDwTkjP7coLxfqquAfQpyUGXVtFUNHs8tgZQjvwDzs=;
 b=HBjA8kxezU5xJEn/VPlXGA2H5amjSwSEbXfX/HAD5w7wQeEr20krvtDJhOyEfHVXaM/hzdVSL0P8
   Kimv21QiSGcNjMHtijvI1mKdl8xZwJ7tR3KXj+yCCkX2KzcfBEe2SWRCWiBefOa4VCHqsYx2DamV
   Vfd76No++pgcf/k9HraPoayKfJQ9XK1X5ZPvRUeIDEU4UAgZOrR8lDYLUxBzImqLf34IWafWkl7X
   V7a1slCpIS/EE1qIZ9kvbkmzLj6ww2q3WlWbp8d/3gfrQNdcxUpFsCvxIgRtddylPfi/WsRyqNev
   U5wrNW/aCNlnEpQDXqtcrNfNYSJKfJytM79Ixg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC500I9X8MRXOE0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 19 May 2022 18:56:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652986588; bh=q58ebU4DqQJqrIfKSe6LdHqQemMFaajbYh7hT/Jp7/A=;
 h=Date:To:From:Subject:From;
 b=eZpKfXOg2ed1DniiDrBjrfM0MiqgZhwV5HLNUFkU3W9S5rASHhKheyTfo8Fo02JJu
 A8Rt47rsRNCHmhLimJcQhR65UnWOCBfKLFsK/yY6mJKGcn2gryb30zRzeyPE02a43t
 ByT9Kuu+2KloLufUG1ohcnYwYyIXz7GwQMf1A9hg=
Date: Thu, 19 May 2022 11:56:27 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
 akpm@linux-foundation.org
Message-id: <20220519185628.BF06BC385AA@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10352
 signatures=594197
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=145 lowpriorityscore=0 spamscore=0
 impostorscore=0 adultscore=0 clxscore=185 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190106
Subject: [Ocfs2-devel] +
	ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch	added to
 mm-nonmm-unstable branch
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
X-Proofpoint-GUID: cIka-yCn6KxHm7MIhvRqvaKK94DXvYba
X-Proofpoint-ORIG-GUID: cIka-yCn6KxHm7MIhvRqvaKK94DXvYba
Reporting-Meta:
 AAEphJ9xWQjwrSbuSYevs4tnDFfmo3QjvCk2/3uO0CIRatkaGO2ahfd/quxppWPl
 sr2ZSlVzUxnCN4SVeGXjguoWkUdD1SYW5KfH6E7uM2JfiZsVZkc5xN75jIwmDt02
 c5jDMVVB/GiustFxnKkRduUxn1mPZTOTyLZTpyZRNAcENdE1dr4rFgh73V3EiZR+
 Z+zMYoJR8dqD+hM9FDIJtiijL+UUf5v/JBTul5pXCtYzrNrViS4Uf+5N+3KrNra8
 xYoV7buEm2+FKETgx53j/WVQPE601hmcZtq9tHgGDr7WpBxNocRn5JrUfMvyyFW8
 TqlgPRCgnCfwUmOvo5/WDTVxkZno1vDSUzx/U0LZ/VvynOAym0VcXOHaiD12FNty
 EAR+oaKCsG8VNzJMQZUjwFc56xs5lHmnHQOrD81S5TVbTmxw5TjGJObh++jFexPl
 5aaWBm+FnqJNwJhfnRgX25LhtZSuKgKmxYQo9CspbKmxPZ2Bp6jb3czQIQ1nX69Y
 RIuKr4VHRl+tFJxwz4d+Atx6t/2uC9s0+OeOfSV7GJ/z


The patch titled
     Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch
ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
