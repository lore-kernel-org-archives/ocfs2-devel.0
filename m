From: kbuild test robot <lkp@intel.com>
Date: Fri, 6 Jan 2017 22:52:09 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <1483630262-22227-3-git-send-email-zren@suse.com>
Message-ID: <201701062255.2zRvcepc%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.10-rc2 next-20170106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eric-Ren/fix-deadlock-caused-by-recursive-cluster-locking/20170106-200837
config: ia64-allyesconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 6.2.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=ia64 

All errors (new ones prefixed by >>):

   In file included from fs/ocfs2/acl.c:31:0:
   fs/ocfs2/acl.c: In function 'ocfs2_iop_set_acl':
>> fs/ocfs2/dlmglue.h:189:29: error: inlining failed in call to always_inline 'ocfs2_is_locked_by_me': function body not available
    inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
                                ^~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/acl.c:292:16: note: called from here
     has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/acl.c:31:0:
>> fs/ocfs2/dlmglue.h:189:29: error: inlining failed in call to always_inline 'ocfs2_is_locked_by_me': function body not available
    inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
                                ^~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/acl.c:292:16: note: called from here
     has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/acl.c:31:0:
>> fs/ocfs2/dlmglue.h:185:13: error: inlining failed in call to always_inline 'ocfs2_add_holder': function body not available
    inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
                ^~~~~~~~~~~~~~~~
   fs/ocfs2/acl.c:302:3: note: called from here
      ocfs2_add_holder(lockres, &oh);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/acl.c:31:0:
>> fs/ocfs2/dlmglue.h:187:13: error: inlining failed in call to always_inline 'ocfs2_remove_holder': function body not available
    inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
                ^~~~~~~~~~~~~~~~~~~
   fs/ocfs2/acl.c:307:3: note: called from here
      ocfs2_remove_holder(lockres, &oh);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from arch/ia64/include/uapi/asm/intrinsics.h:21:0,
                    from arch/ia64/include/asm/intrinsics.h:10,
                    from arch/ia64/include/asm/bitops.h:18,
                    from include/linux/bitops.h:36,
                    from include/linux/kernel.h:10,
                    from include/linux/list.h:8,
                    from include/linux/wait.h:6,
                    from include/linux/fs.h:5,
                    from fs/ocfs2/file.c:27:
   fs/ocfs2/file.c: In function 'ocfs2_file_write_iter':
   arch/ia64/include/uapi/asm/cmpxchg.h:56:2: warning: value computed is not used [-Wunused-value]
    ((__typeof__(*(ptr))) __xchg((unsigned long) (x), (ptr), sizeof(*(ptr))))
    ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/file.c:2334:3: note: in expansion of macro 'xchg'
      xchg(&iocb->ki_complete, saved_ki_complete);
      ^~~~
   In file included from fs/ocfs2/file.c:49:0:
   fs/ocfs2/file.c: In function 'ocfs2_permission':
>> fs/ocfs2/dlmglue.h:189:29: error: inlining failed in call to always_inline 'ocfs2_is_locked_by_me': function body not available
    inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
                                ^~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/file.c:1345:16: note: called from here
     has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/file.c:49:0:
>> fs/ocfs2/dlmglue.h:189:29: error: inlining failed in call to always_inline 'ocfs2_is_locked_by_me': function body not available
    inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
                                ^~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/file.c:1345:16: note: called from here
     has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/file.c:49:0:
>> fs/ocfs2/dlmglue.h:185:13: error: inlining failed in call to always_inline 'ocfs2_add_holder': function body not available
    inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
                ^~~~~~~~~~~~~~~~
   fs/ocfs2/file.c:1353:3: note: called from here
      ocfs2_add_holder(lockres, &oh);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/ocfs2/file.c:49:0:
>> fs/ocfs2/dlmglue.h:187:13: error: inlining failed in call to always_inline 'ocfs2_remove_holder': function body not available
    inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
                ^~~~~~~~~~~~~~~~~~~
   fs/ocfs2/file.c:1359:3: note: called from here
      ocfs2_remove_holder(lockres, &oh);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim +/ocfs2_is_locked_by_me +189 fs/ocfs2/dlmglue.h

63e0c48a Joel Becker 2008-01-30  179  void ocfs2_set_locking_protocol(void);
9fb5ed3a Eric Ren    2017-01-05  180  
9fb5ed3a Eric Ren    2017-01-05  181  /*
9fb5ed3a Eric Ren    2017-01-05  182   * Keep a list of processes who have interest in a lockres.
9fb5ed3a Eric Ren    2017-01-05  183   * Note: this is now only uesed for check recursive cluster lock.
9fb5ed3a Eric Ren    2017-01-05  184   */
9fb5ed3a Eric Ren    2017-01-05 @185  inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
9fb5ed3a Eric Ren    2017-01-05  186  			     struct ocfs2_holder *oh);
9fb5ed3a Eric Ren    2017-01-05 @187  inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
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
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 48810 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170106/c484897a/attachment-0001.bin 
