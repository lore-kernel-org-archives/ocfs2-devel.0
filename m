Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B630C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zqfGkRuwUyLR8FSS/Zci+whjEnn3UhMGcUtqy9qF80g=;
 b=GPj4RncsLGrrIORlpxH6l4VZuMLxBCJOE1bkaHGhcCGZKX4Y2HOaqGW9Gx51RRcWhpLzCFHo3i2g
   hN40+M+XH9PM6Jo/KKd0Kc4cV0er8FrMq0hqbFgoP+rKFQ0LZuwVBJ8/5BLJUhR1AquqcX9gQ09n
   Rs4QovicmOomiDd9kMceYLFsmPWytPYPIJJ1Z6ZXFVVJWa3cJK9LisDliuAOeQpxBZU3xnGc+Dxe
   WF/oy788ejhgpbgnbrXVmvreoT2BCnL/bWgwdIjrRfO8o6jcCejkYMpiVzlVC8YlZ2kMVTg6hkqK
   lwNEYcAOi5/ikcafi0nFtDY2PL5GB0LQWt9a7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zqfGkRuwUyLR8FSS/Zci+whjEnn3UhMGcUtqy9qF80g=;
 b=OaAXEjXE1FIggoFktW0CCkKNvjFH0+l3rG/4Z/CspF1fpEiUZm+dA6QT7WfTLKd2jolaWX8UDcDx
   QBUeO19znRf/7ss3mlJiWskSUps1CtMKgfAxL0zxyyNLMO/uJ0iZmBd9G2HrMitBv9YOCxRHUYkk
   /BBwMZPPxns79ykOrsxuMB4CpvRqYveOkVxJmzFAgZQKfvefioN+VUuBCbPL7piydTbBr1LuIqwF
   6xOI0nTTXqH16en3EAqrwPQGnLuDYo8hrLkegVMRL3Xr1jQOLrWRD84Li2Gx4bxyRW36M0VCYf7W
   fHG5yOAptFfMFviQmUWLBNTkaPrg8VKeoxOeOQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBO00AIPWXW0M20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 23:22:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : content-transfer-encoding : content-type
 : mime-version; s=corp-2021-07-09;
 bh=yLE0iWnV2dSqoxGRHWmOv0GJjp1wJW/abUBWB3RT6YY=;
 b=psxEeUhKoKIYKUM0tk5jrHSvEs3yV4UPhh3BzBCHGxN45OD5mLp5ofk4SVkWX7tNUQ7A
 6d2HynZg8zPbMfbr6SBg/6sapFaw7mY6FeQSECuoJWEn5QDleqdI8czCBaVpKXiMjTQL
 pyZ8yvdjBP+OFl7gYfBwnf9lDcahSVx6oO0me1Jb05uNopLQj1Rvu5MH9Ipw9HIIU1KV
 8fPU0qaIqF0rS+oAyEKBowHin/9A37BqDA7ReorI+yXJmJymxuGtnzlDx2u8UXVB8Zzs
 EWNhfCPb3CXM1RadEfbw8Kkv9tgqjbY7+lWjaG94irgwe913PyY9njDkVh2Gei+Hs7ns 7Q==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbMuV72fALu9V6kS2TNPXzfl/NEn5pteCpfT7yoefFcR3lw2ViloBEdcPr29Moi7/dRz7djkd/FaW5TjzG8kklsz1fEMrz0F4uI/rDbfzOxo6em/1wVfVcrd3QaTTfFS0xvnvR9WFugBfpYrz+IWxu9PWNR4kiwrVKMr2C1tLSYNppLrHo9P9gg9HPaXaA7iL1fLsHwExH2ZmxOkDk2Lv7RX3XTGySHgSLGaJe+WvtG2gmlE70zFkjBf+Nbt57ijD32H6k6+vbygJp3sgT/sdS40A/igOOMCZN54P2j1hQATmChXProJ5/vmCBDrxJFcq74A9FlCjAlZQjcvurpFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLE0iWnV2dSqoxGRHWmOv0GJjp1wJW/abUBWB3RT6YY=;
 b=cIKUYjR9h0Gy79sCTa7milWU6CbVZ2Ogd6ZkwVTJpUD2YNqwBHSQCMwp4RjoUGZChthivpulmjCqk6Ku2qy9dnbi5vO04m7eSbUqdGUsQsVoYkRk5YwLuB/fj/FEN8C7IEMAgrtSBe2b++aE1RGtNSvXP7RU8DCfQdNYjDszyw+5vCZ+i4bngT8zwzg3hYhuF/kWD1+oA+CQCaCPybkIprslWYSKPiZms9/NmMjyn6MIVU1Nizzd1AGHl0axwMWmQBV99Y7ukPgyIf4z3IYMrhAuk9/PGYo6AJcpaUUpYzKIq7ANsEMqVGjHrdyGfOxb+FIvtgFXfu6Ew2aUCsg3ig==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLE0iWnV2dSqoxGRHWmOv0GJjp1wJW/abUBWB3RT6YY=;
 b=dTCz1jZYq8pPwBdZ0O8g9FA7cjcBSdCSsrAiJtnBMBdL16OpMSIBhI6Y5eyv7PCGpheNeDAJSUntzof9CcvUjfmHjDfKK+DYfeREOnkO5+9wjM7J0I3ls57eRDQbTkSgIuiI5v5Tk0hkx/MDXOXRUe+lMz8RM8/PcC63frsMeOo=
To: ocfs2-devel@oss.oracle.com
Date: Tue, 10 May 2022 16:22:11 -0700
Message-id: <20220510232213.23435-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 23:22:32.7373 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.858 definitions=2022-05-10_07:2022-05-09, 2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=823 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100097
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: dlmfs: not clear	USER_LOCK_ATTACHED
 when destroy lock
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
X-ClientProxiedBy: BYAPR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:a03:60::30) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70510b69-3009-4147-b068-08da32dbf58e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1840:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 SqlgC9x8WJaUAZK3WczxiNLTw9ZInILt4gryHekpSuHSxPsccw0/ycwtFne8dFTmnc6j2Vfw118g3CGrkuDatnQjG6AFyBh+qcU9Tes00P/lbBNVnDy1eVyztjz1hEvY4NYKcr3659FCZe95yYdvFUQCAe28wCCGmpFq+CMU8qb0wOYu3j8hFZmJWlUod4L509WP/bEsYKynMGueV6l8hF30kAunnQ0yFE0iT+/8bPCdw2E9bh1r40V8z0kzqQqtQJ6YaQgghdl13iloWrnlZm2YcUBdeOBWqLUKLKMXH65+SJGsjrrdPGFUwOP7alspauP8fzCq/0xqqRhWB3y52bVx8wSyfhT7RXmHADQhA8wV80u3eceZJqm1B6LgVgeFCtFzb2kXGjIjfcoq0h7lT2MWcJJm9gKqqdX2Qw5HtpWIDqXFVrn3ARXadrtmHpR2BmolxRai/xO4mSh2EhJUJAdkxmukYm2n+6Uia9hsALwyGaxKIqvQZG54JjlfkZ5PuuY3Vv1lRboL0l+ylS86GVmgj+EVBpHWdOFZ5GKYZ9DC6vqawkj7puQkXXbaTpQjgu7VH0TOA11EOZqp8oUlc4VJDjRzZCVqmi2h7V/T4Zo=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 70510b69-3009-4147-b068-08da32dbf58e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5Mzxb/Diy8AM+5P0wh+4v+QXREyOWMevbUR2nUh21GFZM2/Lexk+ff3qiYQ7uiLMuqZivxbO+/VIX542M3l3AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1840
X-Proofpoint-ORIG-GUID: uXyik4YNR2sisZx3OGJQ61KVqhxhuAQ5
X-Proofpoint-GUID: uXyik4YNR2sisZx3OGJQ61KVqhxhuAQ5
Reporting-Meta:
 AAEPkBbytQwJiqEYAGrkTVot6srFCa+Zio1XfvuhnckJSQZKoNTys/5tiKPvzjQm
 mtRMcPqQktLai4rWhZGdx27HvSM29YUO4Q/TB/fxMjqN9mstXwrEZ0oXQBbf6606
 V5W2rFYWkZdTYbYhXNvJSKpKcSbi4QLjaanG5CuUg8BfIRxLddaVwJsjQLmmoLXx
 WnjYns3mJjR6RtEyBWS2Ypptp1JVvC3XN7eU89Sq1GBNbK1QfTxG6Y6diTSbxINx
 1cA91JR5tvS5F8hUeabbVXeXTaHm95L72Rd2bbByrtt88eB/Gq3bsAF/M3OKhxTB
 b62zgaOT5xoiNCg3zMIvjixehWGPaghR8aphjnpDM19bQ9MAtTWdwgy6zpJGhKqy
 nsLx+UwnpuVV88c8On3MFr8I+3aqeTsZnvUbdSeFjs/QiQamlI2KzWgUccvsK1kv
 p5sgNgBWOB98ih0hTYK4uhmxtQqOujf/rnUVvl7it3R0IlW4zMX2Tk06iDX+Ucmt
 6btQauQ/Qqo6AkAR+AAWhPDUGKgkNhjDjNWpz33buLg=

The following function is the only place that check USER_LOCK_ATTACHED,
this flag is set when lock request is granted through user_bast() and
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

Cc: <stable@vger.kernel.org>
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
