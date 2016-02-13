From: kbuild test robot <lkp@intel.com>
Date: Sun, 14 Feb 2016 06:45:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix build warning
In-Reply-To: <1454395613-3428-1-git-send-email-sudipm.mukherjee@gmail.com>
Message-ID: <201602140629.TOXLsDUG%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sudip,

[auto build test ERROR on v4.5-rc2]
[cannot apply to next-20160212]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Sudip-Mukherjee/ocfs2-fix-build-warning/20160202-144936
config: i386-randconfig-x0-02140608 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   fs/ocfs2/file.c: In function 'ocfs2_file_write_iter':
>> fs/ocfs2/file.c:2369:3: error: label 'relock' used but not defined
      goto relock;
      ^

vim +/relock +2369 fs/ocfs2/file.c

9517bac6 Mark Fasheh 2007-02-09  2363  		rw_level = -1;
9517bac6 Mark Fasheh 2007-02-09  2364  
9517bac6 Mark Fasheh 2007-02-09  2365  		direct_io = 0;
7da839c4 Al Viro     2015-04-09  2366  		iocb->ki_flags &= ~IOCB_DIRECT;
3309dd04 Al Viro     2015-04-09  2367  		iov_iter_reexpand(from, orig_count);
7da839c4 Al Viro     2015-04-09  2368  		dropped_dio = 1;
9517bac6 Mark Fasheh 2007-02-09 @2369  		goto relock;
9517bac6 Mark Fasheh 2007-02-09  2370  	}
9517bac6 Mark Fasheh 2007-02-09  2371  
a11f7e63 Mark Fasheh 2011-06-22  2372  	if (unaligned_dio) {

:::::: The code at line 2369 was first introduced by commit
:::::: 9517bac6cc7a7aa4fee63cb38a32cb6014e264c7 ocfs2: teach ocfs2_file_aio_write() about sparse files

:::::: TO: Mark Fasheh <mark.fasheh@oracle.com>
:::::: CC: Mark Fasheh <mark.fasheh@oracle.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 19962 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160214/f102b040/attachment-0001.obj 
