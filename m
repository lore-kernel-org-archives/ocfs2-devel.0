Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06044C7618B
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=difUbg1PTeEmDfnK/r1sWl3vfnDeU/HkxmN9tEt7Fpg=;
 b=TJNaTSbN0370gO5IluslHw1633A1blpr7rKIjmghqLKTG7FM7YdbC7OGAAJY/FC9rRfI4wa1drhz
   nE5QPiEsSIaI8cRs2gmkJllpl+cDJU2/0HMAPrG7m6+IM5VFEJGlH8JnqoQ76eqjJHgPKgCs2WhC
   fQowwYjSbVzIUW3vAiC5EvOqs8pMuVfEG2OmiXWY7FrAu/tbfsgSDs/G5EcoCTSD67OooI8QSR7l
   KaXeHQFzjMipVJht32sMMQsYPQfXYiORcuUkc94UM/c7noJHyDT5CVMThUBkjjXfQqtP3yTees/q
   U0y4rSHzGc3LInJNU3pSB0nZs0L8OMZHGGUJxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=difUbg1PTeEmDfnK/r1sWl3vfnDeU/HkxmN9tEt7Fpg=;
 b=Vfvj+NzmWKVpHLn/MRNIkuo6u7W5z/I/rr4ivenePpe/+c64CMBEeRTa9tJtRyObF3s0NmRq2Cnn
   QQr4wI8yxN9IpmAvhivvbkrz1i8a5OpguSmG2pd+Bp+/FCyRTSLTenGZIq12q91XcaMWG5+WxTAg
   eRYu6U5GFZ8fT9rgTo8S6a1tcGNT8QrzGEb8EB1zecMGq+dfhPDnYL1c+AawW73b4M5NeNZjPbYp
   4lPMzzcouGDBR9eA5dFrIRX+2dSnwhqZ4n4yQ3tLPSHUGuAXtTxQJWdhnQ2tW/IMLXjnuImSNIl5
   D3nE0E6O0rf6jihQr3NbEDcBDKZ65yYdFXGt6A==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI00JFM4LSZHB0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:22:40 +0000 (GMT)
Message-id: <bae3bf3c768d5ce3e71354a77e814dcb4d67b1c1.camel@huaweicloud.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:21:52 +0100
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 clxscore=100 priorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140071
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 0/6] evm: Do HMAC of multiple per LSM
 xattrs for new inodes
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
X-CM-TRANSID: GxC2BwAX4liiLhBks3eXAQ--.33895S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ur48CF45AFW3Ary7Jw17Awb_yoWkGF4xpF
 WjgF4Ykrn8AFW2grySyF4xua1Sg3yrGrWDJrZ3GryUA3Z8Kr1xtr1Ikry5uas8XrZ5AFn2
 qw17Awn8uwn8A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x
 0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
 F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
 kC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
 c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
 026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF
 0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIx
 AIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
 87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUbG2NtUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4qHcQAAsY
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: rj9UAOnlG4ra-9UmZNI90mX7jtjv0KPT
X-Proofpoint-ORIG-GUID: rj9UAOnlG4ra-9UmZNI90mX7jtjv0KPT
Reporting-Meta:
 AAF8xf7WmebgXFosSAeCMLGztEb239kF9BcIRChIdLPmweJ1rvEN1WvkzEH3LhRI
 +ZWqyL6F8p7mnVTMVBj0sKQacznRuqSfyWHHliByWDuBiJ+WkqYUQO3CX3+cr6SW
 1U9IErrMzAmxJcOlM7VxIQQPYAYr1MQXP8GIJ5damBqAnJTr6i27su2a4eE7q2MC
 8zOFti0YEeUXpqcF/eXtZvWR8vzwB8X0mwxk4G9cPE/7tny5R0oEzFbIUpFdHA1O
 zD3mjYwgD4hFS1OzqBxK01ZTkmZcLVaHwUbxfRSuclCEpwhNeXr8ZhsLm/ejuFWp
 VFF7kf3VQ0lFPmjvD4D9Vm+EDmpjEqzokWWvMavSrOPdHxQNo6abNug+LEebg0Pz
 VvBTyFyXoibSqM42ncovih1Wtf8PWr4cg0JIXw6oXzcWDkB8+nOJuRvrSXa5Hbk1
 yKKPbWOcOp6zJZr7yJlRq+rczTNRh7ctZJC3ynh/PjpR1fDWcLOnANNBRnGWv2ix
 OtQvLI4Nik+FNJDSbEJOgGz2BnZblN2wAPJoqmBEY3MB

On Tue, 2023-03-14 at 09:17 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> One of the major goals of LSM stacking is to run multiple LSMs side by side
> without interfering with each other. The ultimate decision will depend on
> individual LSM decision.
> 
> Several changes need to be made to the LSM infrastructure to be able to
> support that. This patch set tackles one of them: gives to each LSM the
> ability to specify one or multiple xattrs to be set at inode creation
> time and, at the same time, gives to EVM the ability to access all those
> xattrs and calculate the HMAC on them.
> 
> The first problem that this patch set addresses is to make the
> inode_init_security hook definition suitable to use with EVM which, unlike
> other LSMs, needs to have visibility of all xattrs and not only the one
> that the LSM infrastructure passes to the LSM to be set.
> 
> The solution is to replace in the inode_init_security definition the
> name/value/len parameters with the beginning of the array containing all
> xattrs set by LSMs. Due to security_old_inode_init_security() API
> limitation of setting only one xattr, it has been dropped and the remaining
> users, ocfs2 and reiserfs, switch to security_inode_init_security().
> However, due to the complexity of the changes required to fully exploit the
> ability of security_inode_init_security() to set multiple xattrs, those
> users can still set only one xattr (the first set in the xattr array) where
> previously they called security_old_inode_init_security().
> 
> Furthermore, while EVM is invoked unlike before, its xattr will not be set
> as it would not be the first set in the xattr array, or if it is the first,
> there would not be protected xattrs to calculate the HMAC on.
> 
> The second problem this patch set addresses is the limitation of the
> call_int_hook() of stopping the loop when the return value from a hook
> implementation is not zero. Unfortunately, for the inode_init_security hook
> it is a legitimate case to return -EOPNOTSUPP, but this would not
> necessarily mean that there is an error to report to the LSM infrastructure
> but just that an LSM does not will to set an xattr. Other LSMs should be
> still consulted as well.
> 
> The solution for this specific case is to replace the call_int_hook() with
> the loop itself, so that -EOPNOTSUPP can be ignored.
> 
> Next, this patch set removes the limitation of creating only two xattrs,
> one by an active LSM and another by EVM. This patch set extends the
> reservation mechanism of the LSM infrastructure, to allow each LSM to
> request one or multiple xattrs. While this could potentially lead to
> reaching the filesystem limits of number/size of the xattrs, it seems not
> an issue that need to be solved by the LSM infrastructure but by the
> filesystems themselves. Currently, if the limit is reached, the only
> workaround would be to use fewer LSMs.
> 
> The reservation mechanism concept makes it very easy for LSMs to position
> themselves correctly in the xattr array, as the LSM infrastructure at
> initialization time changes the number of xattrs requested by each LSM with
> an offset. LSMs can just take that offset as the starting index in the
> xattr array and fill the next slots depending on how many xattrs they
> requested.
> 
> However, while this concept is intuitive, it needs extra care. While for
> security blobs (the main reason of the reservation mechanism) it is not
> relevant for an LSM if other LSMs filled their portion, it matters for
> xattrs, as both EVM and initxattrs() callbacks scan the entire array until
> a terminator (xattr with NULL name). If an LSM did not provide an xattr,
> which could happen if it is loaded but not initialized, consumers of the
> xattr array would stop prematurely.
> 
> This patch set avoids this problem by compacting the xattr array each time
> after an LSM executed its implementation of the inode_init_security hook.
> It needs to be done after each LSM, and not after all, since there might be
> LSMs scanning that xattr array too. Compacting the array after all LSMs
> would be too late.
> 
> Finally, this patch set modifies the evm_inode_init_security() definition
> to be compatible with the inode_init_security hook definition and adds
> support for scanning the whole xattr array and for calculating the HMAC
> on all xattrs provided by LSMs.
> 
> This patch set has been tested by introducing several instances of a
> TestLSM (some providing an xattr, some not, one with a wrong implementation
> to see how the LSM infrastructure handles it, one providing multiple xattrs
> and another providing an xattr but in a disabled state). The patch is not
> included in this set but it is available here:
> 
> https://github.com/robertosassu/linux/commit/311b83a98757915cc3ccb363f545578e7c38df54
> 
> The test, added to ima-evm-utils, is available here:
> 
> https://github.com/robertosassu/ima-evm-utils/blob/evm-multiple-lsms-v8-devel-v2/tests/evm_multiple_lsms.test
> 
> The test takes a UML kernel built by Github Actions and launches it several
> times, each time with a different combination of LSMs and filesystems (ext4,
> reiserfs, ocfs2). After boot, it first checks that there is an xattr for each
> LSM providing it (for reiserfs and ocfs2 just the first LSM), and then (for
> ext4) calculates the HMAC in user space and compares it with the HMAC
> calculated by EVM in kernel space.
> 
> A test report can be obtained here:
> 
> https://github.com/robertosassu/ima-evm-utils/actions/runs/4403223954/jobs/7722101662
> 
> The patch set has been tested with both the SElinux and Smack test suites.
> Below, there is the summary of the test results:
> 
> SELinux Test Suite result (without patches):
> All tests successful.
> Files=76, Tests=1343, 255 wallclock secs ( 0.51 usr  0.19 sys +  6.30 cusr 58.15 csys = 65.15 CPU)
> Result: PASS
> 
> SELinux Test Suite result (with patches):
> All tests successful.
> Files=76, Tests=1343, 258 wallclock secs ( 0.49 usr  0.21 sys +  6.46 cusr 59.27 csys = 66.43 CPU)
> Result: PASS

Side note:

https://github.com/SELinuxProject/selinux-testsuite/blob/master/tests/mmap/test#L51

This test fails if CONFIG_LSM_MMAP_MIN_ADDR=0

Roberto

> Smack Test Suite result (without patches):
> 95 Passed, 0 Failed, 100% Success rate
> 
> Smack Test Suite result (with patches):
> 95 Passed, 0 Failed, 100% Success rate
> 
> Changelog
> 
> v7:
> - Add a patch dependency comment in patch 1 (suggested by Mimi)
> - Restore check of -EOPNOTSUPP status in ocfs2_mknod() and ocfs2_symlink()
>   (reported by Mimi)
> - Add explanation in evm_inode_init_security() why walking through the
>   xattrs array is safe (suggested by Mimi)
> - Document the lbs_xattr field of struct lsm_blob_sizes (suggested by
>   Casey)
> - Move documentation changes of the inode_init_security hook to security.c,
>   after LSM documentation reorganization by Paul
> - Use attributes in plural form in the description of the xattrs parameter
>   of smack_inode_init_security()
> - Check xattr name instead of xattr value in evm_inode_init_security(),
>   for consistency with evm_init_hmac(); equivalent, since
>   security_check_compact_filled_xattrs() rejects xattrs with xattr name
>   NULL and value not NULL, and viceversa
> 
> v6:
> - Add a comment in Smack to introduce its xattrs (suggested by Casey)
> - Document the overloaded meaning of -EOPNOTSUPP in
>   security_inode_init_security() (suggested by Mimi)
> 
> v5:
> - Modify the cover letter to explain that the goal of this patch set is
>   supporting multiple per LSM xattrs in EVM, and not moving IMA and EVM to
>   the LSM infrastructure (suggested by Mimi)
> - Remove references in the patches description about moving IMA and EVM
>   to the LSM infrastructure (suggested by Mimi)
> - Explain that the additional EVM invocation due to the switch to
>   security_inode_init_security() will not cause the EVM xattr to be added
>   (suggested by Mimi)
> 
> v4:
> - Remove patch to call reiserfs_security_free(), already queued
> - Switch ocfs2 and reiserfs to security_inode_init_security() (suggested by
>   Mimi)
> - Remove security_old_inode_init_security() (suggested by Paul)
> - Rename security_check_compact_xattrs() to
>   security_check_compact_filled_xattrs() and add function description
>   (suggested by Mimi)
> - Rename checked_xattrs parameter of security_check_compact_filled_xattrs()
>   to num_filled_xattrs (suggested by Mimi)
> - Rename cur_xattrs variable in security_inode_init_security() to
>   num_filled_xattrs (suggested by Mimi)
> 
> v3:
> - Don't free the xattr name in reiserfs_security_free()
> - Don't include fs_data parameter in inode_init_security hook
> - Don't change evm_inode_init_security(), as it will be removed if EVM is
>   stacked
> - Fix inode_init_security hook documentation
> - Drop lsm_find_xattr_slot(), use simple xattr reservation mechanism and
>   introduce security_check_compact_xattrs() to compact the xattr array
> - Don't allocate xattr array if LSMs didn't reserve any xattr
> - Return zero if initxattrs() is not provided to
>   security_inode_init_security(), -EOPNOTSUPP if value is not provided to
>   security_old_inode_init_security()
> - Request LSMs to fill xattrs if only value (not the triple) is provided to
>   security_old_inode_init_security(), to avoid unnecessary memory
>   allocation
> 
> v2:
> - rewrite selinux_old_inode_init_security() to use
>   security_inode_init_security()
> - add lbs_xattr field to lsm_blob_sizes structure, to give the ability to
>   LSMs to reserve slots in the xattr array (suggested by Casey)
> - add new parameter base_slot to inode_init_security hook definition
> 
> v1:
> - add calls to reiserfs_security_free() and initialize sec->value to NULL
>   (suggested by Tetsuo and Mimi)
> - change definition of inode_init_security hook, replace the name, value
>   and len triple with the xattr array (suggested by Casey)
> - introduce lsm_find_xattr_slot() helper for LSMs to find an unused slot in
>   the passed xattr array
> 
> Roberto Sassu (6):
>   reiserfs: Switch to security_inode_init_security()
>   ocfs2: Switch to security_inode_init_security()
>   security: Remove security_old_inode_init_security()
>   security: Allow all LSMs to provide xattrs for inode_init_security
>     hook
>   evm: Align evm_inode_init_security() definition with LSM
>     infrastructure
>   evm: Support multiple LSMs providing an xattr
> 
>  fs/ocfs2/namei.c                    |   2 +
>  fs/ocfs2/xattr.c                    |  30 ++++++-
>  fs/reiserfs/xattr_security.c        |  23 +++--
>  include/linux/evm.h                 |  12 +--
>  include/linux/lsm_hook_defs.h       |   3 +-
>  include/linux/lsm_hooks.h           |   1 +
>  include/linux/security.h            |  12 ---
>  security/integrity/evm/evm.h        |   2 +
>  security/integrity/evm/evm_crypto.c |   9 +-
>  security/integrity/evm/evm_main.c   |  33 +++++--
>  security/security.c                 | 131 +++++++++++++++++++++-------
>  security/selinux/hooks.c            |  19 ++--
>  security/smack/smack_lsm.c          |  33 ++++---
>  13 files changed, 224 insertions(+), 86 deletions(-)
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
