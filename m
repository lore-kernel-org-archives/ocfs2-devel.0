From: kbuild test robot <lkp@intel.com>
Date: Sat, 7 Jan 2017 01:53:59 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <1483630262-22227-3-git-send-email-zren@suse.com>
Message-ID: <201701070153.BC9be8Un%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.10-rc2 next-20170106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eric-Ren/fix-deadlock-caused-by-recursive-cluster-locking/20170106-200837
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/ocfs2/dlmglue.h:189:50: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:185:29: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:187:32: sparse: marked inline, but without a definition
>> fs/ocfs2/dlmglue.h:189:50: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:185:29: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:187:32: sparse: marked inline, but without a definition
--
   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/ocfs2/dlmglue.h:189:50: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:185:29: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:187:32: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:187:32: sparse: marked inline, but without a definition
>> fs/ocfs2/dlmglue.h:189:50: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:185:29: sparse: marked inline, but without a definition
   fs/ocfs2/dlmglue.h:187:32: sparse: marked inline, but without a definition

vim +189 fs/ocfs2/dlmglue.h

34d024f8 Mark Fasheh 2007-09-24  173  void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
ccd979bd Mark Fasheh 2005-12-15  174  
ccd979bd Mark Fasheh 2005-12-15  175  struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
ccd979bd Mark Fasheh 2005-12-15  176  void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
ccd979bd Mark Fasheh 2005-12-15  177  
63e0c48a Joel Becker 2008-01-30  178  /* To set the locking protocol on module initialization */
63e0c48a Joel Becker 2008-01-30  179  void ocfs2_set_locking_protocol(void);
9fb5ed3a Eric Ren    2017-01-05  180  
9fb5ed3a Eric Ren    2017-01-05  181  /*
9fb5ed3a Eric Ren    2017-01-05  182   * Keep a list of processes who have interest in a lockres.
9fb5ed3a Eric Ren    2017-01-05  183   * Note: this is now only uesed for check recursive cluster lock.
9fb5ed3a Eric Ren    2017-01-05  184   */
9fb5ed3a Eric Ren    2017-01-05  185  inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
9fb5ed3a Eric Ren    2017-01-05  186  			     struct ocfs2_holder *oh);
9fb5ed3a Eric Ren    2017-01-05  187  inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
9fb5ed3a Eric Ren    2017-01-05  188  			     struct ocfs2_holder *oh);
9fb5ed3a Eric Ren    2017-01-05 @189  inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
9fb5ed3a Eric Ren    2017-01-05  190  
ccd979bd Mark Fasheh 2005-12-15  191  #endif	/* DLMGLUE_H */

:::::: The code at line 189 was first introduced by commit
:::::: 9fb5ed3abab2100ae8d99cee9b25fb92e3154224 ocfs2/dlmglue: prepare tracking logic to avoid recursive cluster lock

:::::: TO: Eric Ren <zren@suse.com>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
