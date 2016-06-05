From: kbuild test robot <lkp@intel.com>
Date: Mon, 6 Jun 2016 05:43:50 +0800
Subject: [Ocfs2-devel] [PATCH 42/45] block, fs,
 drivers: remove REQ_OP compat defs and related code
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
Message-ID: <201606060540.nWhFU0Cr%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

[auto build test ERROR on v4.7-rc1]
[cannot apply to dm/for-next md/for-next next-20160603]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/v8-separate-operations-from-flags-in-the-bio-request-structs/20160606-040240
config: m32r-opsput_defconfig (attached as .config)
compiler: m32r-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=m32r 

All errors (new ones prefixed by >>):

>> ERROR: "__ucmpdi2" [drivers/scsi/sd_mod.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 8852 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160606/2183654d/attachment.obj 
