Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FC3C7618A
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FFNSilXmEqf42ykD2ZaqZSl8dUU3zDl22O1yS/q0hAc=;
 b=jzzgFNiH7DnJu18AM8hLcEw0grpSloW0bbqbYGyYOQO8dwE6TLe4BGnzD0xK1EmT/LOUfIamBqAe
   wkBBsKX1YTpW0PlwfW5CC4f6twonQ65vwVOmI9b6qChxxoArehZZ52reJCoTxjrLSEmLhe3c29D6
   BNbkW7KDEltvXVOdwIYC5eX3sZleAvJvuFA8wylxn9V1WaHuZIcS988G2GTqqVZa7Gqvqwfws3zP
   3uCp5GBKM7lelKd1vB9ZxOE9Z3efEqtoQ1UghwMU4uI8q18HakaFcMCoIrtIP+Ob7/TZPea+QiqW
   kQ/juqjxFWaTqaQEOALWjw9ctSm7f4l4EFPrEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FFNSilXmEqf42ykD2ZaqZSl8dUU3zDl22O1yS/q0hAc=;
 b=okgJH6dUgT5vlGGLv58BO2JohUI+YFQZTibPNNotQ+UCL8T46AFlm/bb7F4EeLTl1xx/tMcvNpGI
   sencd6k4shjEAV4a6q8jhHNlRfZj/mKQvvgpW7jUsHGDm99VqMxIOag8htgo1wJiBounb03Ro0VN
   g0o2V7D2YE/AtAR6td7NppQqWAFBWGeNl0FxI7preR1mAk+iEshYxYSukv3g3px2jx/wh5eOGgR4
   Bv0fQM9wK0nQnnIYTfw9lTb8XP4nUYPRFRGMYYYWD9paU0Jbxn5/SGIpIStM1ZlghTW/iP0WmWs3
   LMgfNxkrsNxeuH3aTO7IX7oR2FlnI6UZPoU9Pw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI00DYK4FDQE20@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:18:49 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:14 +0100
Message-id: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxscore=0 priorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 clxscore=47 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 0/6] evm: Do HMAC of multiple per LSM	xattrs
 for new inodes
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ur48CFyUKrW8Ar1DZr13urg_yoWDuF4xpF
 Wjg3WYkrn8AFW2grWfAa1xua1SgrWrGrW7JrZ3Gryjy3Z8Gr1xtr1Ikry5ua45XrZ5AF9Y
 qw17Awn8uwn8A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
 c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
 026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF
 0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
 vE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
 jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4aJKwADsA
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: wEFWzg5zTDBLcg1s1D1GIuf3FK5DfgjL
X-Proofpoint-ORIG-GUID: wEFWzg5zTDBLcg1s1D1GIuf3FK5DfgjL
Reporting-Meta:
 AAHYIoDKgfErHJyko5i/w0JIDRrqoExVNu2f1DRg/F2xdKt5qwCpGDI36F4nOE+z
 bvxEGlzCAo3oQ7jtegZRDpbA/cXmicuOKGjzcCaXFpSyl5Vfm2fwDUc18jYzZPrw
 aHyv0FVHF10vlqr/fWPmkdZM6Plbw2MBYLkSCFGGPXQ2HZ1sn/mNvfIkcJYC6NTZ
 0SnH19qMzCaEilvvdmd/NkU5PK9NN2Z2kXSmhMiW0DkwIlOyf8/tsZhOstXETVtd
 5HTezUJsdnoSTlhPDnOMzzTvg66KpEJO2SabjfUeZHJHLi80jETRSgBGdc9I9tm6
 JSHrtBDt5zCzHCD2hA1cLRevitiaFd/2tlU3CXJ4pltppF09LngKfvQIXmkfB8Zt
 dVF8qnmDhLn2o8aB3GV6zxKE219nLs2xNr4O+4ioIpfYZoCRjvjyrpdmXgNeQ1Fn
 Qn+N1+Qnc/mHHZU49FYnbEeJYlQpECnYw0hTf/bJxAItyznAvg2gjbIUnSmiQupZ
 fKyvOavovjsocfvAhnZeCimkPrc9LdlVAOvQcTtTF8m6

From: Roberto Sassu <roberto.sassu@huawei.com>

One of the major goals of LSM stacking is to run multiple LSMs side by side
without interfering with each other. The ultimate decision will depend on
individual LSM decision.

Several changes need to be made to the LSM infrastructure to be able to
support that. This patch set tackles one of them: gives to each LSM the
ability to specify one or multiple xattrs to be set at inode creation
time and, at the same time, gives to EVM the ability to access all those
xattrs and calculate the HMAC on them.

The first problem that this patch set addresses is to make the
inode_init_security hook definition suitable to use with EVM which, unlike
other LSMs, needs to have visibility of all xattrs and not only the one
that the LSM infrastructure passes to the LSM to be set.

The solution is to replace in the inode_init_security definition the
name/value/len parameters with the beginning of the array containing all
xattrs set by LSMs. Due to security_old_inode_init_security() API
limitation of setting only one xattr, it has been dropped and the remaining
users, ocfs2 and reiserfs, switch to security_inode_init_security().
However, due to the complexity of the changes required to fully exploit the
ability of security_inode_init_security() to set multiple xattrs, those
users can still set only one xattr (the first set in the xattr array) where
previously they called security_old_inode_init_security().

Furthermore, while EVM is invoked unlike before, its xattr will not be set
as it would not be the first set in the xattr array, or if it is the first,
there would not be protected xattrs to calculate the HMAC on.

The second problem this patch set addresses is the limitation of the
call_int_hook() of stopping the loop when the return value from a hook
implementation is not zero. Unfortunately, for the inode_init_security hook
it is a legitimate case to return -EOPNOTSUPP, but this would not
necessarily mean that there is an error to report to the LSM infrastructure
but just that an LSM does not will to set an xattr. Other LSMs should be
still consulted as well.

The solution for this specific case is to replace the call_int_hook() with
the loop itself, so that -EOPNOTSUPP can be ignored.

Next, this patch set removes the limitation of creating only two xattrs,
one by an active LSM and another by EVM. This patch set extends the
reservation mechanism of the LSM infrastructure, to allow each LSM to
request one or multiple xattrs. While this could potentially lead to
reaching the filesystem limits of number/size of the xattrs, it seems not
an issue that need to be solved by the LSM infrastructure but by the
filesystems themselves. Currently, if the limit is reached, the only
workaround would be to use fewer LSMs.

The reservation mechanism concept makes it very easy for LSMs to position
themselves correctly in the xattr array, as the LSM infrastructure at
initialization time changes the number of xattrs requested by each LSM with
an offset. LSMs can just take that offset as the starting index in the
xattr array and fill the next slots depending on how many xattrs they
requested.

However, while this concept is intuitive, it needs extra care. While for
security blobs (the main reason of the reservation mechanism) it is not
relevant for an LSM if other LSMs filled their portion, it matters for
xattrs, as both EVM and initxattrs() callbacks scan the entire array until
a terminator (xattr with NULL name). If an LSM did not provide an xattr,
which could happen if it is loaded but not initialized, consumers of the
xattr array would stop prematurely.

This patch set avoids this problem by compacting the xattr array each time
after an LSM executed its implementation of the inode_init_security hook.
It needs to be done after each LSM, and not after all, since there might be
LSMs scanning that xattr array too. Compacting the array after all LSMs
would be too late.

Finally, this patch set modifies the evm_inode_init_security() definition
to be compatible with the inode_init_security hook definition and adds
support for scanning the whole xattr array and for calculating the HMAC
on all xattrs provided by LSMs.

This patch set has been tested by introducing several instances of a
TestLSM (some providing an xattr, some not, one with a wrong implementation
to see how the LSM infrastructure handles it, one providing multiple xattrs
and another providing an xattr but in a disabled state). The patch is not
included in this set but it is available here:

https://github.com/robertosassu/linux/commit/311b83a98757915cc3ccb363f545578e7c38df54

The test, added to ima-evm-utils, is available here:

https://github.com/robertosassu/ima-evm-utils/blob/evm-multiple-lsms-v8-devel-v2/tests/evm_multiple_lsms.test

The test takes a UML kernel built by Github Actions and launches it several
times, each time with a different combination of LSMs and filesystems (ext4,
reiserfs, ocfs2). After boot, it first checks that there is an xattr for each
LSM providing it (for reiserfs and ocfs2 just the first LSM), and then (for
ext4) calculates the HMAC in user space and compares it with the HMAC
calculated by EVM in kernel space.

A test report can be obtained here:

https://github.com/robertosassu/ima-evm-utils/actions/runs/4403223954/jobs/7722101662

The patch set has been tested with both the SElinux and Smack test suites.
Below, there is the summary of the test results:

SELinux Test Suite result (without patches):
All tests successful.
Files=76, Tests=1343, 255 wallclock secs ( 0.51 usr  0.19 sys +  6.30 cusr 58.15 csys = 65.15 CPU)
Result: PASS

SELinux Test Suite result (with patches):
All tests successful.
Files=76, Tests=1343, 258 wallclock secs ( 0.49 usr  0.21 sys +  6.46 cusr 59.27 csys = 66.43 CPU)
Result: PASS

Smack Test Suite result (without patches):
95 Passed, 0 Failed, 100% Success rate

Smack Test Suite result (with patches):
95 Passed, 0 Failed, 100% Success rate

Changelog

v7:
- Add a patch dependency comment in patch 1 (suggested by Mimi)
- Restore check of -EOPNOTSUPP status in ocfs2_mknod() and ocfs2_symlink()
  (reported by Mimi)
- Add explanation in evm_inode_init_security() why walking through the
  xattrs array is safe (suggested by Mimi)
- Document the lbs_xattr field of struct lsm_blob_sizes (suggested by
  Casey)
- Move documentation changes of the inode_init_security hook to security.c,
  after LSM documentation reorganization by Paul
- Use attributes in plural form in the description of the xattrs parameter
  of smack_inode_init_security()
- Check xattr name instead of xattr value in evm_inode_init_security(),
  for consistency with evm_init_hmac(); equivalent, since
  security_check_compact_filled_xattrs() rejects xattrs with xattr name
  NULL and value not NULL, and viceversa

v6:
- Add a comment in Smack to introduce its xattrs (suggested by Casey)
- Document the overloaded meaning of -EOPNOTSUPP in
  security_inode_init_security() (suggested by Mimi)

v5:
- Modify the cover letter to explain that the goal of this patch set is
  supporting multiple per LSM xattrs in EVM, and not moving IMA and EVM to
  the LSM infrastructure (suggested by Mimi)
- Remove references in the patches description about moving IMA and EVM
  to the LSM infrastructure (suggested by Mimi)
- Explain that the additional EVM invocation due to the switch to
  security_inode_init_security() will not cause the EVM xattr to be added
  (suggested by Mimi)

v4:
- Remove patch to call reiserfs_security_free(), already queued
- Switch ocfs2 and reiserfs to security_inode_init_security() (suggested by
  Mimi)
- Remove security_old_inode_init_security() (suggested by Paul)
- Rename security_check_compact_xattrs() to
  security_check_compact_filled_xattrs() and add function description
  (suggested by Mimi)
- Rename checked_xattrs parameter of security_check_compact_filled_xattrs()
  to num_filled_xattrs (suggested by Mimi)
- Rename cur_xattrs variable in security_inode_init_security() to
  num_filled_xattrs (suggested by Mimi)

v3:
- Don't free the xattr name in reiserfs_security_free()
- Don't include fs_data parameter in inode_init_security hook
- Don't change evm_inode_init_security(), as it will be removed if EVM is
  stacked
- Fix inode_init_security hook documentation
- Drop lsm_find_xattr_slot(), use simple xattr reservation mechanism and
  introduce security_check_compact_xattrs() to compact the xattr array
- Don't allocate xattr array if LSMs didn't reserve any xattr
- Return zero if initxattrs() is not provided to
  security_inode_init_security(), -EOPNOTSUPP if value is not provided to
  security_old_inode_init_security()
- Request LSMs to fill xattrs if only value (not the triple) is provided to
  security_old_inode_init_security(), to avoid unnecessary memory
  allocation

v2:
- rewrite selinux_old_inode_init_security() to use
  security_inode_init_security()
- add lbs_xattr field to lsm_blob_sizes structure, to give the ability to
  LSMs to reserve slots in the xattr array (suggested by Casey)
- add new parameter base_slot to inode_init_security hook definition

v1:
- add calls to reiserfs_security_free() and initialize sec->value to NULL
  (suggested by Tetsuo and Mimi)
- change definition of inode_init_security hook, replace the name, value
  and len triple with the xattr array (suggested by Casey)
- introduce lsm_find_xattr_slot() helper for LSMs to find an unused slot in
  the passed xattr array

Roberto Sassu (6):
  reiserfs: Switch to security_inode_init_security()
  ocfs2: Switch to security_inode_init_security()
  security: Remove security_old_inode_init_security()
  security: Allow all LSMs to provide xattrs for inode_init_security
    hook
  evm: Align evm_inode_init_security() definition with LSM
    infrastructure
  evm: Support multiple LSMs providing an xattr

 fs/ocfs2/namei.c                    |   2 +
 fs/ocfs2/xattr.c                    |  30 ++++++-
 fs/reiserfs/xattr_security.c        |  23 +++--
 include/linux/evm.h                 |  12 +--
 include/linux/lsm_hook_defs.h       |   3 +-
 include/linux/lsm_hooks.h           |   1 +
 include/linux/security.h            |  12 ---
 security/integrity/evm/evm.h        |   2 +
 security/integrity/evm/evm_crypto.c |   9 +-
 security/integrity/evm/evm_main.c   |  33 +++++--
 security/security.c                 | 131 +++++++++++++++++++++-------
 security/selinux/hooks.c            |  19 ++--
 security/smack/smack_lsm.c          |  33 ++++---
 13 files changed, 224 insertions(+), 86 deletions(-)

-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
