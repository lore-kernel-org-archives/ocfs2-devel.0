From: kbuild test robot <lkp@intel.com>
Date: Mon, 6 Jun 2016 05:49:37 +0800
Subject: [Ocfs2-devel] [PATCH 42/45] block, fs,
 drivers: remove REQ_OP compat defs and related code
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
Message-ID: <201606060525.7bWU0DWo%fengguang.wu@intel.com>
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
config: blackfin-BF526-EZBRD_defconfig (attached as .config)
compiler: bfin-uclinux-gcc (GCC) 4.6.3
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=blackfin 

All errors (new ones prefixed by >>):

   drivers/built-in.o: In function `sd_init_command':
>> drivers/scsi/sd.c:1141: undefined reference to `__ucmpdi2'

vim +1141 drivers/scsi/sd.c

^1da177e Linus Torvalds    2005-04-16  1135  }
^1da177e Linus Torvalds    2005-04-16  1136  
87949eee Christoph Hellwig 2014-06-28  1137  static int sd_init_command(struct scsi_cmnd *cmd)
87949eee Christoph Hellwig 2014-06-28  1138  {
87949eee Christoph Hellwig 2014-06-28  1139  	struct request *rq = cmd->request;
87949eee Christoph Hellwig 2014-06-28  1140  
b826ba83 Mike Christie     2016-06-05 @1141  	switch (req_op(rq)) {
b826ba83 Mike Christie     2016-06-05  1142  	case REQ_OP_DISCARD:
87949eee Christoph Hellwig 2014-06-28  1143  		return sd_setup_discard_cmnd(cmd);
b826ba83 Mike Christie     2016-06-05  1144  	case REQ_OP_WRITE_SAME:

:::::: The code at line 1141 was first introduced by commit
:::::: b826ba83985b86029288d8cc24fb93ce96947b18 drivers: use req op accessor

:::::: TO: Mike Christie <mchristi@redhat.com>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 14347 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160606/171e74d3/attachment.obj 
