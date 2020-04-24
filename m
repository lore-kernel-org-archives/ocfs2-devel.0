From: kbuild test robot <lkp@intel.com>
Date: Sat, 25 Apr 2020 02:22:01 +0800
Subject: [Ocfs2-devel] [PATCH] fs:ocfs2:remove unneeded variable
	'o2dlm_flags'
In-Reply-To: <1587539521-461177-1-git-send-email-wubo40@huawei.com>
References: <1587539521-461177-1-git-send-email-wubo40@huawei.com>
Message-ID: <202004250208.3JNgw1aV%lkp@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wu Bo <wubo40@huawei.com>, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, liuzhiqiang26@huawei.com, linfeilong@huawei.com
Cc: kbuild-all@lists.01.org

Hi Wu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.7-rc2 next-20200424]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://urldefense.com/v3/__https://stackoverflow.com/a/37406982__;!!GqivPVa7Brio!IQgjAou8rAf_6WnaH7-3N2gaOpSAHZ_3aNjfAbiBmahAm18U3tpT_KgXqvTg3F5BtDvqsA$ ]

url:    https://urldefense.com/v3/__https://github.com/0day-ci/linux/commits/Wu-Bo/fs-ocfs2-remove-unneeded-variable-o2dlm_flags/20200424-014056__;!!GqivPVa7Brio!IQgjAou8rAf_6WnaH7-3N2gaOpSAHZ_3aNjfAbiBmahAm18U3tpT_KgXqvTg3F6hrSHfIA$ 
base:   https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git__;!!GqivPVa7Brio!IQgjAou8rAf_6WnaH7-3N2gaOpSAHZ_3aNjfAbiBmahAm18U3tpT_KgXqvTg3F4CQ8nWUw$  18bf34080c4c3beb6699181986cc97dd712498fe
config: sh-allmodconfig (attached as .config)
compiler: sh4-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://urldefense.com/v3/__https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross__;!!GqivPVa7Brio!IQgjAou8rAf_6WnaH7-3N2gaOpSAHZ_3aNjfAbiBmahAm18U3tpT_KgXqvTg3F78MlD3IQ$  -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=sh 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   fs/ocfs2/stack_o2cb.c: In function 'flags_to_o2dlm':
>> fs/ocfs2/stack_o2cb.c:65:3: error: 'o2dlm_flags' undeclared (first use in this function)
      65 |   o2dlm_flags |= (_o2dlm); \
         |   ^~~~~~~~~~~
>> fs/ocfs2/stack_o2cb.c:69:2: note: in expansion of macro 'map_flag'
      69 |  map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
         |  ^~~~~~~~
   fs/ocfs2/stack_o2cb.c:65:3: note: each undeclared identifier is reported only once for each function it appears in
      65 |   o2dlm_flags |= (_o2dlm); \
         |   ^~~~~~~~~~~
>> fs/ocfs2/stack_o2cb.c:69:2: note: in expansion of macro 'map_flag'
      69 |  map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
         |  ^~~~~~~~

vim +/o2dlm_flags +65 fs/ocfs2/stack_o2cb.c

e3dad42bf993a0 Joel Becker 2008-02-01  61  
e3dad42bf993a0 Joel Becker 2008-02-01  62  #define map_flag(_generic, _o2dlm)		\
e3dad42bf993a0 Joel Becker 2008-02-01  63  	if (flags & (_generic)) {		\
e3dad42bf993a0 Joel Becker 2008-02-01  64  		flags &= ~(_generic);		\
e3dad42bf993a0 Joel Becker 2008-02-01 @65  		o2dlm_flags |= (_o2dlm);	\
e3dad42bf993a0 Joel Becker 2008-02-01  66  	}
e3dad42bf993a0 Joel Becker 2008-02-01  67  static int flags_to_o2dlm(u32 flags)
e3dad42bf993a0 Joel Becker 2008-02-01  68  {
e3dad42bf993a0 Joel Becker 2008-02-01 @69  	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
e3dad42bf993a0 Joel Becker 2008-02-01  70  	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
e3dad42bf993a0 Joel Becker 2008-02-01  71  	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
e3dad42bf993a0 Joel Becker 2008-02-01  72  	map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
e3dad42bf993a0 Joel Becker 2008-02-01  73  	map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
e3dad42bf993a0 Joel Becker 2008-02-01  74  	map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
e3dad42bf993a0 Joel Becker 2008-02-01  75  	map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
e3dad42bf993a0 Joel Becker 2008-02-01  76  	map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
e3dad42bf993a0 Joel Becker 2008-02-01  77  	map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
e3dad42bf993a0 Joel Becker 2008-02-01  78  
e3dad42bf993a0 Joel Becker 2008-02-01  79  	/* map_flag() should have cleared every flag passed in */
e3dad42bf993a0 Joel Becker 2008-02-01  80  	BUG_ON(flags != 0);
e3dad42bf993a0 Joel Becker 2008-02-01  81  
54d663085a6a0f Wu Bo       2020-04-22  82  	return 0;
e3dad42bf993a0 Joel Becker 2008-02-01  83  }
e3dad42bf993a0 Joel Becker 2008-02-01  84  #undef map_flag
e3dad42bf993a0 Joel Becker 2008-02-01  85  

:::::: The code at line 65 was first introduced by commit
:::::: e3dad42bf993a0f24eb6e46152356c9b119c15e8 ocfs2: Create ocfs2_stack_operations and split out the o2cb stack.

:::::: TO: Joel Becker <joel.becker@oracle.com>
:::::: CC: Mark Fasheh <mfasheh@suse.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://urldefense.com/v3/__https://lists.01.org/hyperkitty/list/kbuild-all at lists.01.org__;!!GqivPVa7Brio!IQgjAou8rAf_6WnaH7-3N2gaOpSAHZ_3aNjfAbiBmahAm18U3tpT_KgXqvTg3F7I1nwT5w$ 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 54644 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200425/5f08ee89/attachment-0001.bin 
