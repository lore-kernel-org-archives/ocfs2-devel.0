From: kbuild test robot <lkp@intel.com>
Date: Mon, 19 Dec 2016 18:56:25 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: add kobject for online file
	check
In-Reply-To: <1482139287-19040-2-git-send-email-ghe@suse.com>
Message-ID: <201612191811.4gtVVyNv%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.9 next-20161219]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Gang-He/ocfs2-add-kobject-for-online-file-check/20161219-181858
config: x86_64-randconfig-x000-201651 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

Note: the linux-review/Gang-He/ocfs2-add-kobject-for-online-file-check/20161219-181858 HEAD 6ef9256cd25ef72a5e69490cc3dacde95b8e2ac4 builds fine.
      It only hurts bisectibility.

All error/warnings (new ones prefixed by >>):

   fs/ocfs2/super.c: In function 'ocfs2_fill_super':
>> fs/ocfs2/super.c:1204:31: error: passing argument 1 of 'ocfs2_filecheck_create_sysfs' from incompatible pointer type [-Werror=incompatible-pointer-types]
     ocfs2_filecheck_create_sysfs(sb);
                                  ^~
   In file included from fs/ocfs2/super.c:77:0:
   fs/ocfs2/filecheck.h:71:5: note: expected 'struct ocfs2_super *' but argument is of type 'struct super_block *'
    int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/super.c: In function 'ocfs2_put_super':
>> fs/ocfs2/super.c:1656:31: error: passing argument 1 of 'ocfs2_filecheck_remove_sysfs' from incompatible pointer type [-Werror=incompatible-pointer-types]
     ocfs2_filecheck_remove_sysfs(sb);
                                  ^~
   In file included from fs/ocfs2/super.c:77:0:
   fs/ocfs2/filecheck.h:72:6: note: expected 'struct ocfs2_super *' but argument is of type 'struct super_block *'
    void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   fs/ocfs2/filecheck.c: In function 'ocfs2_filecheck_create_sysfs':
>> fs/ocfs2/filecheck.c:179:50: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     struct ocfs2_filecheck_sysfs_entry *entry = &osb->osb_fc_ent;
                                                     ^~
>> fs/ocfs2/filecheck.c:191:27: error: 'struct ocfs2_super' has no member named 'osb_dev_kset'; did you mean 'osb_dx_seed'?
     entry->fs_kobj.kset = osb->osb_dev_kset;
                              ^~
   fs/ocfs2/filecheck.c: In function 'ocfs2_filecheck_remove_sysfs':
   fs/ocfs2/filecheck.c:206:10: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     if (!osb->osb_fc_ent.fs_fcheck)
             ^~
   fs/ocfs2/filecheck.c:209:18: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     kobject_del(&osb->osb_fc_ent.fs_kobj);
                     ^~
   fs/ocfs2/filecheck.c:210:18: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     kobject_put(&osb->osb_fc_ent.fs_kobj);
                     ^~
   fs/ocfs2/filecheck.c:211:26: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
                             ^~
   fs/ocfs2/filecheck.c:212:33: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
                                    ^~
   In file included from include/linux/list.h:8:0,
                    from fs/ocfs2/filecheck.c:20:
   fs/ocfs2/filecheck.c: In function 'ocfs2_filecheck_handle_entry':
>> include/linux/kernel.h:850:27: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                              ^
>> fs/ocfs2/filecheck.c:444:28: note: in expansion of macro 'container_of'
     struct ocfs2_super *osb = container_of(ent, struct ocfs2_super,
                               ^~~~~~~~~~~~
   include/linux/kernel.h:850:48: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> fs/ocfs2/filecheck.c:444:28: note: in expansion of macro 'container_of'
     struct ocfs2_super *osb = container_of(ent, struct ocfs2_super,
                               ^~~~~~~~~~~~
   include/linux/kernel.h:850:48: note: (near initialization for 'osb')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> fs/ocfs2/filecheck.c:444:28: note: in expansion of macro 'container_of'
     struct ocfs2_super *osb = container_of(ent, struct ocfs2_super,
                               ^~~~~~~~~~~~
   In file included from include/linux/compiler.h:58:0,
                    from include/uapi/linux/stddef.h:1,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from fs/ocfs2/filecheck.c:20:
>> include/linux/compiler-gcc.h:159:2: error: 'struct ocfs2_super' has no member named 'osb_fc_ent'; did you mean 'osb_ctxt'?
     __builtin_offsetof(a, b)
     ^
   include/linux/stddef.h:16:32: note: in expansion of macro '__compiler_offsetof'
    #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:851:29: note: in expansion of macro 'offsetof'
     (type *)( (char *)__mptr - offsetof(type,member) );})
                                ^~~~~~~~
>> fs/ocfs2/filecheck.c:444:28: note: in expansion of macro 'container_of'
     struct ocfs2_super *osb = container_of(ent, struct ocfs2_super,
                               ^~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/ocfs2_filecheck_create_sysfs +1204 fs/ocfs2/super.c

19ece546 Jan Kara      2008-08-21  1198  	wake_up(&osb->osb_mount_event);
19ece546 Jan Kara      2008-08-21  1199  
df152c24 Sunil Mushran 2009-06-22  1200  	/* Start this when the mount is almost sure of being successful */
8b712cd5 Jeff Mahoney  2009-07-07  1201  	ocfs2_orphan_scan_start(osb);
df152c24 Sunil Mushran 2009-06-22  1202  
a849d468 Gang He       2016-03-22  1203  	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
a849d468 Gang He       2016-03-22 @1204  	ocfs2_filecheck_create_sysfs(sb);
a849d468 Gang He       2016-03-22  1205  
ccd979bd Mark Fasheh   2005-12-15  1206  	return status;
ccd979bd Mark Fasheh   2005-12-15  1207  

:::::: The code at line 1204 was first introduced by commit
:::::: a849d46816fe9e11d59aae78ea95c54f640b1904 ocfs2: create/remove sysfile for online file check

:::::: TO: Gang He <ghe@suse.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 34606 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161219/c3756a16/attachment-0001.bin 
